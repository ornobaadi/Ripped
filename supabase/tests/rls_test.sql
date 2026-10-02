-- RLS suite (phases.md Phase 3 exit criterion): user A must never see or
-- change user B's rows. Run with a local stack: `supabase test db`.
begin;
create extension if not exists pgtap with schema extensions;
select plan(12);

-- Two users.
insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-00000000000a', 'a@test.local'),
  ('00000000-0000-0000-0000-00000000000b', 'b@test.local');

create or replace function pg_temp.as_user(uid uuid) returns void
language sql as $$
  select set_config('role', 'authenticated', true),
         set_config('request.jwt.claims',
           json_build_object('sub', uid, 'role', 'authenticated')::text, true);
$$;

-- A writes a workout (user_id is ignored and forced from the JWT).
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
insert into public.workouts (id, user_id, created_at, updated_at, name, started_at, status)
values ('11111111-1111-1111-1111-111111111111',
        '00000000-0000-0000-0000-00000000000b', -- spoof attempt
        now(), now(), 'Full Body A', now(), 'completed');

select is(
  (select user_id from public.workouts where id = '11111111-1111-1111-1111-111111111111'),
  '00000000-0000-0000-0000-00000000000a'::uuid,
  'user_id is taken from the JWT, not the client');
select is((select count(*)::int from public.workouts), 1, 'A sees own row');

-- B sees nothing of A's.
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select is((select count(*)::int from public.workouts), 0, 'B cannot read A''s rows');

update public.workouts set name = 'hacked'
where id = '11111111-1111-1111-1111-111111111111';
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
select is(
  (select name from public.workouts where id = '11111111-1111-1111-1111-111111111111'),
  'Full Body A', 'B cannot update A''s rows');

-- B can't take over A's id via upsert either.
select pg_temp.as_user('00000000-0000-0000-0000-00000000000b');
select throws_ok(
  $$insert into public.workouts (id, user_id, created_at, updated_at, name, started_at, status)
    values ('11111111-1111-1111-1111-111111111111', null, now(), now() + interval '1 day',
            'mine now', now(), 'completed')
    on conflict (id) do update set name = excluded.name, updated_at = excluded.updated_at$$,
  '42501', null, 'B cannot overwrite A''s row by id');

select is(
  (select count(*)::int from public.workouts where name = 'mine now'),
  0, 'takeover left nothing behind');

-- Deletes are not allowed at all (soft delete only).
select pg_temp.as_user('00000000-0000-0000-0000-00000000000a');
delete from public.workouts;
select is((select count(*)::int from public.workouts), 1, 'hard delete is a no-op');

-- Last write wins: an older update is ignored.
update public.workouts set name = 'stale', updated_at = now() - interval '1 day'
where id = '11111111-1111-1111-1111-111111111111';
select is(
  (select name from public.workouts where id = '11111111-1111-1111-1111-111111111111'),
  'Full Body A', 'stale write ignored');

update public.workouts set name = 'Full Body B', updated_at = now() + interval '1 minute'
where id = '11111111-1111-1111-1111-111111111111';
select is(
  (select name from public.workouts where id = '11111111-1111-1111-1111-111111111111'),
  'Full Body B', 'newer write applied');

select isnt(
  (select synced_at from public.workouts where id = '11111111-1111-1111-1111-111111111111'),
  null, 'server stamps synced_at');

-- Signed out: nothing.
set local role anon;
select throws_ok('select count(*) from public.workouts', '42501', null,
  'anon has no access');

-- Every public table has RLS forced on.
reset role;
select is(
  (select count(*)::int from pg_class c join pg_namespace n on n.oid = c.relnamespace
   where n.nspname = 'public' and c.relkind = 'r'
     and not (c.relrowsecurity and c.relforcerowsecurity)),
  0, 'RLS enabled + forced on every public table');

select * from finish();
rollback;
