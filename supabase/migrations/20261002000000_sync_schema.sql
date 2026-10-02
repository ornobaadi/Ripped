-- Ripped: server mirror of the on-device Drift tables (schema v2), for
-- backup and multi-device sync. The phone is the source of truth; the
-- server stores each user's rows and nothing else.
--
-- Rules (CLAUDE.md 5-6):
--   * RLS on every table, deny by default, own rows only.
--   * user_id always comes from the JWT (auth.uid()), never from the client.
--   * Last write wins per row, by the client's updated_at.
--   * synced_at is assigned by the server; clients pull by it, so device
--     clock skew can't hide changes.
--   * No foreign keys between synced tables: rows arrive in any order.
--     Deleting the auth user cascades to everything.

-- ---------------------------------------------------------------- helpers

create schema if not exists private;

-- Stamps owner + server sync time; ignores stale writes (last write wins).
create or replace function private.sync_row()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.user_id := (select auth.uid());
  if new.user_id is null then
    raise exception 'not authenticated' using errcode = '42501';
  end if;
  if tg_op = 'UPDATE' then
    if new.updated_at < old.updated_at then
      return null; -- older than what we have: keep the newer row
    end if;
    new.created_at := old.created_at;
  end if;
  new.synced_at := clock_timestamp();
  return new;
end;
$$;

-- Applies the standard columns, trigger, indexes and own-rows policies.
create or replace function private.make_synced(tbl regclass)
returns void
language plpgsql
set search_path = ''
as $$
declare
  t text := tbl::text;
begin
  execute format('alter table %s enable row level security', t);
  execute format('alter table %s force row level security', t);

  execute format(
    'create trigger sync_row before insert or update on %s
       for each row execute function private.sync_row()', t);

  execute format(
    'create index on %s (user_id, synced_at)', t);

  execute format(
    'create policy "own rows: select" on %s for select to authenticated
       using ((select auth.uid()) = user_id)', t);
  execute format(
    'create policy "own rows: insert" on %s for insert to authenticated
       with check ((select auth.uid()) = user_id)', t);
  execute format(
    'create policy "own rows: update" on %s for update to authenticated
       using ((select auth.uid()) = user_id)
       with check ((select auth.uid()) = user_id)', t);
  -- No delete policy: deletes are soft (deleted_at), so sync can carry them.
end;
$$;

revoke all on schema private from public, anon, authenticated;

-- ---------------------------------------------------------------- tables
-- Common columns on every table:
--   id uuid pk (client UUIDv7), user_id, created_at, updated_at,
--   deleted_at, synced_at.

create table public.profiles (
  id uuid primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  synced_at timestamptz not null default now(),
  goal text not null,
  experience text not null,
  equipment text not null,
  days_per_week int not null check (days_per_week between 2 and 6),
  preferred_days text not null,
  session_minutes int not null check (session_minutes between 10 and 180),
  avoid text not null,
  units text not null check (units in ('kg', 'lb')),
  onboarding_done_at timestamptz,
  disclaimer_accepted_at timestamptz
);

create table public.programs (
  id uuid primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  synced_at timestamptz not null default now(),
  name text not null,
  split_type text not null,
  generated_by_version int not null,
  active boolean not null default true,
  started_at timestamptz not null
);

create table public.program_days (
  id uuid primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  synced_at timestamptz not null default now(),
  program_id uuid not null,
  day_index int not null,
  name text not null
);

create table public.program_exercises (
  id uuid primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  synced_at timestamptz not null default now(),
  program_day_id uuid not null,
  exercise_id text not null,
  sort_order int not null,
  sets int not null,
  rep_min int not null,
  rep_max int not null,
  rest_seconds int not null,
  reason text not null
);

create table public.workouts (
  id uuid primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  synced_at timestamptz not null default now(),
  program_day_id uuid,
  day_index int,
  name text not null,
  started_at timestamptz not null,
  finished_at timestamptz,
  duration_s int,
  feeling text,
  notes text,
  status text not null check (status in ('inProgress', 'completed', 'abandoned'))
);

create table public.workout_exercises (
  id uuid primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  synced_at timestamptz not null default now(),
  workout_id uuid not null,
  exercise_id text not null,
  sort_order int not null,
  rep_min int not null,
  rep_max int not null,
  rest_seconds int not null,
  skipped boolean not null default false
);

create table public.workout_sets (
  id uuid primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  synced_at timestamptz not null default now(),
  workout_exercise_id uuid not null,
  set_index int not null,
  weight_kg double precision,
  reps int not null,
  target_reps int not null,
  rpe int,
  is_warmup boolean not null default false,
  completed_at timestamptz
);

create table public.exercise_states (
  id uuid primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  synced_at timestamptz not null default now(),
  exercise_id text not null,
  current_weight_kg double precision,
  current_rep_target int not null,
  stall_count int not null default 0,
  last_total_reps int not null default 0,
  last_decision text,
  last_progressed_at timestamptz
);

create table public.xp_events (
  id uuid primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  synced_at timestamptz not null default now(),
  source text not null,
  source_id uuid,
  amount int not null check (amount between 0 and 1000),
  occurred_at timestamptz not null
);

create table public.personal_records (
  id uuid primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  deleted_at timestamptz,
  synced_at timestamptz not null default now(),
  exercise_id text not null,
  type text not null check (type in ('e1rm', 'reps', 'volume')),
  value double precision not null,
  previous double precision not null,
  weight_kg double precision not null,
  reps int not null,
  workout_id uuid not null,
  achieved_at timestamptz not null
);

-- ---------------------------------------------------------------- wire up

select private.make_synced('public.profiles');
select private.make_synced('public.programs');
select private.make_synced('public.program_days');
select private.make_synced('public.program_exercises');
select private.make_synced('public.workouts');
select private.make_synced('public.workout_exercises');
select private.make_synced('public.workout_sets');
select private.make_synced('public.exercise_states');
select private.make_synced('public.xp_events');
select private.make_synced('public.personal_records');

-- Signed-out (anon) clients get nothing; signed-in users only what RLS allows.
revoke all on all tables in schema public from anon;
grant select, insert, update on all tables in schema public to authenticated;
