# Architecture — Ripped

> Technical blueprint. Optimized for: reliability (works offline, never loses a set), security (least privilege, minimal data), and being easy for Claude Code to build and test incrementally.
> Companion docs: `PRD.md` · `design.md` · `phases.md`

---

## 1. Architecture at a glance

```
┌─────────────────────────── Flutter app ───────────────────────────┐
│  UI (widgets)  ←  Riverpod providers / controllers                 │
│                         │                                          │
│                Domain (pure Dart)                                  │
│   PlanGenerator · ProgressionEngine · GamificationEngine · PRs     │
│                         │                                          │
│                 Repositories (interfaces)                          │
│                         │                                          │
│   Local DB: Drift (SQLite)  ← SINGLE SOURCE OF TRUTH               │
│   Bundled catalog DB (read-only exercises + images)                │
│                         │  (Phase 3+)                              │
│                   Sync layer  ──────────────┐                      │
└─────────────────────────────────────────────┼──────────────────────┘
                                              ▼
                ┌──────────────── Supabase ────────────────┐
                │ Auth (Apple, Google, email OTP)          │
                │ Postgres + Row Level Security            │
                │ Storage (exercise media CDN)             │
                │ Edge Functions (account deletion,        │
                │  RevenueCat webhook, AI coach proxy)     │
                └──────────────────────────────────────────┘
        RevenueCat (subscriptions) · Sentry (crashes) · Health APIs
```

**Core decision: local-first.** The app reads and writes only to the on-device database. The network is used for backup/sync, never on the critical path of a workout. This is what makes the app "almost never crash" in practice: no spinners, no failed requests mid-set, no server outage can stop a workout.

## 2. Tech stack & rationale

| Concern | Choice | Why |
|---|---|---|
| Framework | Flutter (latest stable), Dart 3 | Your choice; one codebase iOS + Android |
| State mgmt | **Riverpod** (with code generation) | Testable, compile-safe, well-known to Claude Code |
| Navigation | **go_router** | Declarative, deep links (for widget/notification taps) |
| Models | **freezed** + **json_serializable** | Immutable models, unions for states |
| Local DB | **Drift** (SQLite) | Relational (perfect for sets/reps/history queries), type-safe SQL, reactive streams, **built-in migration testing**. SQLite is among the most battle-tested storage engines that exist |
| At-rest encryption (optional) | SQLCipher via Drift | Enable if threat model needs it; verify current Drift setup docs |
| Backend | **Supabase** (Postgres, Auth, Storage, Edge Functions) | Postgres + RLS = security enforced in the database; SQL analytics; low lock-in (it's just Postgres) |
| Sync | Phase 3 decision: **PowerSync** (Supabase-integrated, has Drift integration) *or* lightweight custom sync | See §5 |
| Subscriptions | **RevenueCat** (`purchases_flutter`) | Handles StoreKit/Play Billing edge cases, receipts, webhooks |
| Crash reporting | **Sentry** (or Firebase Crashlytics) | PII scrubbing, release health |
| Product analytics | **PostHog** (EU cloud or self-host) or minimal Firebase Analytics | Event-based, privacy controls; send no health values |
| Notifications | `flutter_local_notifications` | Reminders are local; no server or push token needed |
| Secure storage | `flutter_secure_storage` | Keychain / Keystore for tokens |
| Health | `health` package (HealthKit / Health Connect) | Phase 6 |
| Widgets | `home_widget` | Phase 6 |
| Lints | `very_good_analysis` (or `flutter_lints` strict) | Consistent code from AI and humans |
| Testing | `flutter_test`, `mocktail`, golden tests, **patrol** for E2E | |
| CI/CD | GitHub Actions + fastlane (or Codemagic) | |

**Rejected:** Isar (original project is unmaintained — only community forks remain), Hive (no relational queries), Firebase Firestore as primary store (works, but NoSQL makes progression/history queries and data export harder; security rules are less expressive than Postgres RLS for this data shape). Firebase remains a fine fallback if you prefer it.

## 3. Project structure (feature-first)

```
lib/
  main_dev.dart / main_staging.dart / main_prod.dart   # flavors
  app/                  # App widget, router, theme wiring, bootstrap
  core/
    design/             # tokens.dart, theme.dart, components/
    db/                 # Drift database, tables, DAOs, migrations
    sync/               # (phase 3) sync engine
    auth/               # (phase 3) auth service
    analytics/ logging/ errors/ l10n/ utils/
  domain/               # PURE DART — no Flutter imports
    plan/               # PlanGenerator, split templates, slot rules
    progression/        # ProgressionEngine
    gamification/       # XP, levels, streaks, achievements
    records/            # PR detection, e1RM
  features/
    onboarding/  today/  workout/  complete/  progress/  exercise/  settings/  paywall/
      ├─ data/          # repositories impl
      ├─ application/   # Riverpod controllers
      └─ presentation/  # screens & widgets
assets/
  catalog/catalog.sqlite   # prebuilt exercise catalog (generated)
  images/exercises/*.webp
tool/
  build_catalog/        # Dart/Python script: source JSON → curated catalog.sqlite + WebP
supabase/
  migrations/           # SQL migrations (RLS included)
  functions/            # Edge Functions
test/ integration_test/
```

Rule for Claude Code: **`domain/` must stay pure Dart** so the plan, progression, and gamification logic is 100% unit-testable without a device.

## 4. Data model

### 4.1 Catalog (read-only, bundled, versioned)

```
exercises(id TEXT PK, slug, name, primary_muscles JSON, secondary_muscles JSON,
          equipment TEXT, pattern TEXT, level TEXT, mechanic TEXT,
          joint_stress JSON,           -- e.g. ["knee","lower_back"] for avoid-list
          is_bodyweight BOOL, unilateral BOOL,
          instructions JSON, form_cues JSON NULL, common_mistakes JSON NULL,
          media JSON,                  -- [{kind: image|gif|video, uri, thumb_uri, variant: male|female|null, license, attribution}]
          source TEXT, license TEXT, attribution TEXT,
          catalog_version INT)
exercise_substitutes(exercise_id, substitute_id, rank)
```
`pattern` ∈ squat · hinge · lunge · horizontal_push · vertical_push · horizontal_pull · vertical_pull · carry · core_anti_extension · core_rotation · calf · isolation_arm · isolation_leg · conditioning · mobility.

`joint_stress`, `pattern`, and substitutes are **our curation** on top of the source data — that's the moat.

### 4.2 User data (Drift locally; mirrored in Postgres from Phase 3)

All user tables share: `id UUID (v7, client-generated)`, `user_id UUID`, `created_at`, `updated_at`, `deleted_at` (soft delete for sync).

```
profiles(goal, experience, equipment JSON, days_per_week, preferred_days JSON,
         session_minutes, avoid JSON, units, age_range NULL, onboarding_done_at)
programs(name, split_type, generated_by_version, active BOOL, started_at)
program_days(program_id, day_index, name)
program_exercises(program_day_id, exercise_id, order, sets, rep_min, rep_max,
                  rest_seconds, progression_rule)
workouts(program_day_id NULL, day_index NULL, name, started_at, finished_at,
         duration_s, feeling NULL, notes NULL, status)  -- in_progress|completed|abandoned
workout_exercises(workout_id, exercise_id, order)
workout_sets(workout_exercise_id, set_index, weight_kg NULL, reps,
             rpe NULL, is_warmup BOOL, completed_at)
exercise_state(exercise_id, current_weight_kg, current_rep_target,
               stall_count, last_total_reps, last_decision,
               last_progressed_at)                -- progression memory
personal_records(exercise_id, type, value, workout_set_id, achieved_at)
xp_events(source_type, source_id, amount, reason, occurred_at)   -- APPEND-ONLY ledger
user_achievements(achievement_id, earned_at)
streak_weeks(week_start DATE, target, completed, shield_used BOOL)
body_metrics(metric, value, measured_at)          -- optional
settings(key, value)
```

Weights stored in **kg** always; convert at the UI edge. Phase 1 ships schema v1 with the profile, program, workout and exercise_state tables; gamification tables (xp_events, achievements, streaks, PRs, body metrics) arrive as migrations in Phase 2. `workout_sets` rows are created pre-filled when a workout starts and `completed_at` marks a logged set.

**Derived, not stored:** level and total XP are computed from `xp_events`; streak length from `streak_weeks`. Deterministic recomputation = no drift bugs and easy server verification later.

### 4.3 Server-only tables (Postgres)
```
subscriptions(user_id, entitlement, status, product_id, expires_at, store, updated_at)
  -- written ONLY by the RevenueCat webhook Edge Function (service role)
deletion_requests(user_id, requested_at, completed_at)
```

## 5. Sync strategy (Phase 3)

Data shape makes sync easier than most apps: workout logs are **append-mostly** and owned by a single user.

- Client-generated UUIDv7 IDs → no ID collisions offline.
- Every row has `updated_at`; deletes are soft (`deleted_at`).
- Conflict policy: last-write-wins per row (fine for single-user data); workout_sets are effectively immutable after the workout completes.
- First sign-in: upload all anonymous local rows, stamped with the new `user_id`.

**Option A — PowerSync (recommended if budget allows):** proven Supabase integration, Flutter SDK, Drift integration (`drift_sqlite_async`), handles queueing/retries/consistency. Cost: a paid service at scale (or self-hosted Open Edition).
**Option B — Custom sync:** an outbox table of pending changes, pushed via Supabase upserts; pull by `updated_at > last_synced_at`. Cheaper; more code to get right; must be heavily tested.

Decide at the start of Phase 3 with a 2-day spike of each. Until then, the app is fully functional local-only.

## 6. Domain engines

### 6.1 Plan generator (deterministic)
1. Choose split from `days_per_week`:
   - 2–3 → Full Body A/B(/C)
   - 4 → Upper/Lower ×2
   - 5 → Upper/Lower/Push/Pull/Legs
   - 6 → Push/Pull/Legs ×2
2. Each day template lists **slots** by pattern (e.g. Full Body A: squat, horizontal_push, horizontal_pull, hinge, core).
3. Slot count from `session_minutes` (≈ 20 min → 3–4 slots, 30 → 4–5, 45 → 5–6, 60 → 6–7).
4. Fill each slot: filter catalog by pattern ∩ available equipment ∩ level ≤ experience ∩ no `joint_stress` in avoid-list; rank by a curated priority; ensure no duplicates across the week where possible.
5. Prescription by goal × experience (e.g. strength: 3–5 sets × 4–6; muscle: 3 × 8–12; fitness: 2–3 × 10–15; rest 60–180 s).
6. Output includes a human-readable **reason** per exercise ("Chosen because: horizontal pull, dumbbells, beginner-friendly").
7. Engine is versioned (`generated_by_version`) so improvements don't silently change existing plans.

### 6.2 Starting weights
No guessing heavy loads: first session uses a "find your weight" flow (start light, user adjusts; app records). Bodyweight exercises start at the easiest appropriate variation.

### 6.3 Progression engine (double progression)
- Target: rep range `[min, max]`, e.g. 8–12.
- **If** all working sets hit `max` reps and feeling ≠ "Tough" → increase weight by the smallest sensible increment (barbell 2.5 kg / 5 lb; dumbbell next pair; machine one plate step).
- **Else if** reps improved → keep weight, target +1 rep.
- **Else** → `stall_count++`. After 3 stalls → deload 10% and reset reps to `min`.
- Bodyweight: progress reps to a ceiling, then suggest a harder variation (via substitutes ranked by difficulty).
- Safety: never increase more than one step per session; flag weekly volume jumps > ~30%.

### 6.4 Gamification engine
- `xp_events` appended for: set completed (+10), workout completed (+50), PR (+25), streak week (+100), achievement (+varies). Daily cap (e.g. 400 XP) to avoid rewarding excess volume.
- Level curve: `xpForLevel(n) = round(100 × n^1.5)` — tune with beta data.
- Weekly streak: a week counts if `completed_sessions ≥ target` (the target is the user's own days/week, so planned rest days never count against them); one shield per calendar month auto-covers a missed week, but never starts a streak. Computed from completed workout dates every time (no `streak_weeks` table): deterministic and impossible to drift. The week in progress never counts as missed.
- Achievements defined declaratively (id, condition function, hidden flag) in `domain/gamification/achievements.dart`, evaluated after each workout.

### 6.5 PR detection
Estimated 1RM via Epley `w × (1 + reps/30)` for reps ≤ 12; also rep-PR at a given weight and best session volume per exercise.

## 7. Authentication

- **Anonymous-first:** no account to start. Data lives locally.
- Sign-up offered after first workout and in Settings. Providers:
  - **Sign in with Apple** (required on iOS when Google sign-in is offered — App Store Guideline 4.8)
  - **Google**
  - **Email one-time code / magic link** (no passwords → nothing to leak, nothing to reset)
- Native sign-in SDKs → ID token → `supabase.auth.signInWithIdToken`. Use a nonce for Apple.
- Sessions managed by `supabase_flutter`; tokens stored in Keychain/Keystore (secure storage); short-lived access tokens with refresh.
- **Account deletion** in-app (required by Apple and Google): calls an Edge Function that deletes all user rows + auth user + RevenueCat customer alias; local DB wiped; confirmation shown.
- **Data export:** JSON + CSV of all user tables, generated on-device.

## 8. Security model

"No data ever leaks" can't be guaranteed by any system — so we design so that (a) we hold as little as possible, (b) every layer assumes the one above it failed, and (c) we'd detect problems fast.

**Database (the real security boundary)**
- RLS **enabled on every table**, deny by default. Template policy:
  ```sql
  alter table public.workouts enable row level security;
  create policy "own rows: select" on public.workouts
    for select using ((select auth.uid()) = user_id);
  create policy "own rows: insert" on public.workouts
    for insert with check ((select auth.uid()) = user_id);
  create policy "own rows: update" on public.workouts
    for update using ((select auth.uid()) = user_id)
    with check ((select auth.uid()) = user_id);
  create policy "own rows: delete" on public.workouts
    for delete using ((select auth.uid()) = user_id);
  ```
- `subscriptions` is **read-only** to clients; only the webhook (service role) writes.
- No views/functions with `security definer` unless reviewed; run Supabase's security & performance advisors in CI and before each release.
- RLS tests: automated tests that user A cannot read/write user B's rows (pgTAP or integration tests with two test users).

**App**
- Only the Supabase **anon/publishable** key ships in the app (it's public by design; RLS protects data). **Service role key never leaves Edge Functions.**
- No secrets in the repo: `.env` per flavor via `--dart-define-from-file`, git-ignored; secret scanning on in GitHub.
- Release builds: `--obfuscate --split-debug-info`.
- Never log health values, emails or tokens. Sentry `beforeSend` scrubs PII.
- TLS everywhere (default). Certificate pinning: optional, adds ops risk; revisit later.
- Dependency hygiene: Dependabot/Renovate, `dart pub outdated` monthly, review new packages before adding.

**Privacy**
- Data minimization (age range, optional body weight, no location, no contacts).
- Analytics events carry no health values — only behavior ("workout_completed", "sets: 18" is fine; weight lifted is not sent).
- Health data consent screen; Apple Health/Health Connect data never sent to our server unless the user explicitly syncs it.
- Privacy policy + Terms before any account feature ships.

**Agent skills supply chain:** skills from skills.sh are third-party instructions/code run by your agent — check the site's security audits, read the SKILL.md, and pin versions before installing.

## 9. Exercise catalog pipeline

`tool/build_catalog/` (run locally, output committed):
1. Pull free-exercise-db JSON (pinned commit hash) and selected wger entries (store each entry's license + author).
2. Apply curation file `curation.yaml` (our ~150 chosen exercises, `pattern`, `joint_stress`, substitutes, priority, renamed titles).
3. Convert images → WebP, max 720 px, strip metadata.
4. Emit `assets/catalog/catalog.sqlite` + `ATTRIBUTIONS.md` (shown in-app under Settings → Credits).
5. Catalog is attached read-only by Drift at runtime; user DB references exercises by stable `id`.

Media source is not final (see PRD §8: free-exercise-db-api videos, RepDB illustrations, WorkoutX are under evaluation). The pipeline uses one adapter per source (`tool/build_catalog/sources/*.dart`) mapping into the common schema, so swapping sources only changes the adapter + curation file. The app renders whatever `media` kind exists (video > gif > image fallback).

Later: host media in Supabase Storage/CDN for over-the-air catalog updates; never hotlink GitHub raw URLs in production.

## 10. Subscriptions (Phase 7, plumbing earlier)

- RevenueCat SDK configured in Phase 3 with a single `pro` entitlement; paywall hidden behind a remote flag.
- Client checks entitlement via RevenueCat for UI; **server-side features** (AI coach) verify via `subscriptions` table populated by the RevenueCat webhook Edge Function (signature verified).
- Restore purchases button; handle grace periods and billing retry states.

## 11. AI coach (Phase 7, Pro)

- Edge Function proxy → LLM API (e.g. Claude). API key lives only in the function.
- Input: compact, de-identified training summary (last 4–8 weeks of sessions, PRs, feeling, goal) — no name/email.
- Output constrained to a JSON schema of **proposed plan changes**, validated by the domain engine before applying (the AI suggests, deterministic rules verify safety bounds).
- Rate limits per user; cost tracking per request.

## 12. Reliability engineering

- Every set write is a single DB transaction; active workout state is persisted after each set → survives app kill.
- Drift schema migrations: one per release, each with a migration test generated from schema snapshots.
- Global error boundary (`FlutterError.onError`, `PlatformDispatcher.instance.onError`) → Sentry + graceful fallback UI.
- Startup does no network work; remote config fetched in background with cached defaults.
- Feature flags (remote config with safe local defaults) for risky features.
- Release health gate: don't promote a staged rollout below 99.8% crash-free sessions.

## 13. Testing strategy

| Layer | Tooling | Target |
|---|---|---|
| Domain engines | unit tests, table-driven + property-based where useful | ≥ 90% coverage |
| DB & migrations | Drift migration tests, DAO tests with in-memory DB | every migration |
| Widgets | widget + golden tests (light/dark, 200% text) | all components |
| Flows | patrol integration tests: onboarding → workout → complete | critical path |
| Backend | RLS tests (two users), Edge Function tests | every table/function |
| Manual | device matrix: small Android, mid Android, latest iPhone, iPad | each release |

## 14. Environments & CI/CD

- Flavors: `dev` (local Supabase via CLI), `staging`, `prod` — separate Supabase projects, separate RevenueCat projects/sandbox.
- GitHub Actions on PR: format, analyze, unit + widget + golden tests, Supabase migration lint.
- On tag: build signed AAB/IPA via fastlane → Play internal track / TestFlight.
- Staged rollouts (Play) / phased release (App Store).

## 15. Working with Claude Code

- Add a `CLAUDE.md` at repo root that points to these four docs, lists commands (`flutter test`, `dart run build_runner build -d`, `supabase db reset`), and states hard rules: domain is pure Dart; every feature ships with tests; never commit secrets; RLS on every new table.
- Build one phase at a time (`phases.md`), in plan mode first, tests before implementation for domain logic.
- Candidate skills (review before installing): `supabase/agent-skills → supabase`, `supabase-postgres-best-practices`; `obra/superpowers → test-driven-development`, `systematic-debugging`; `mattpocock/skills → tdd`, `grill-me` (to stress-test plans).
