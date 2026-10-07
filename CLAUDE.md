# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Project

**Ripped** (Dart package `ripped`, app id / bundle id `com.ornobaadi.ripped`): a minimalist, local-first, personal workout app. **Android first** (Google Play); iOS later. Global, English only. Onboard → get a generated plan → log workouts → adaptive progression → habit/gamification.

**Current state:** Phases 0–2 implemented. Phase 1 core loop (onboarding → plan → Today → workout → summary → history, offline). Phase 2: XP ledger + levels, weekly streak + shields, PRs, celebration, Progress tab (streak calendar, PRs, trend chart), reminders, comeback, volume-spike note. Schema v2. Open exit items: on-device Patrol E2E, personal 2-week trial, friends test. Phase 3 implemented: optional Google sign-in, custom outbox sync (`core/sync/`), server schema + RLS (`supabase/migrations/`, tests in `supabase/tests/`), delete-account Edge Function, data export, legal drafts. Schema v3. Owner applies migrations per `SETUP_BACKEND.md` Step 7. RevenueCat/remote config deferred to Phase 7. Phase 6 started (achievements, weekly recap, muscle balance, easy week / plan refresh; widget + Health Connect open). Phase 5 code done (analytics delivery, review prompt, launch guide); owner runs rollout. Phase 4 in progress: a11y audit test, backend init in background, analytics events, feedback link, store/release guide in `RELEASE.md`; owner handles Play Console + testers.

Map:
- `lib/domain/` (pure Dart): `catalog/exercise.dart`, `plan/` (profile, plan, `plan_generator.dart`, `schedule.dart`), `progression/progression_engine.dart`, `gamification/` (`xp.dart`, `streak.dart`), `records/personal_records.dart`.
- `lib/core/`: `db/` (Drift `AppDatabase`, tables, mapping), `catalog/` (loads the bundled sqlite into memory), `design/` (tokens, theme, components), `utils/format.dart` (kg↔lb + formatting).
- `lib/features/<name>/{data,presentation}`: `plan/data/program_repository.dart` (profile + program), `workout/data/workout_repository.dart` (logging, finish + progression in one transaction).
- `lib/app/`: `providers.dart` (Riverpod graph), `router.dart` (3-tab shell + modal routes, onboarding redirect), `bootstrap.dart`.

Gotchas:
- SDK lints prefer the new `const new(...)` / `factory name(...)` constructor syntax. `dart fix --apply` handles it, **but** it will also delete `String.fromEnvironment(...)` arguments it thinks match a default value — keep those constructor params `required` (see `app/config.dart`).
- Goldens render with the Flutter test font (text shows as blocks) on purpose, for cross-platform stability. Helper: `test/helpers/golden.dart` → `goldenTest(name, builder)` produces light/dark/darkLargeText.
- Components use `context.colors` (theme extension) and `context.l10n`; widgets under test must be wrapped with `wrapForTest`.
- Android has product flavors, so `flutter run`/`build` need `--flavor` (pubspec sets `default-flavor: dev`).
- **Don't run `flutter build`** — the user runs builds; give them the command. `flutter test` / `flutter analyze` are fine.
- `dart fix --apply` may also annotate family providers with `package:riverpod/src/...` types and add `riverpod: any` to pubspec — revert both; use the documented `// ignore: specify_nonobvious_property_types` instead.
- Sync: every synced table must stay in `AppDatabase.syncedTables` (triggers + export + wipe use it) and in the SQL migration. New synced table = Drift migration + SQL migration + RLS via `private.make_synced`. Never hard-delete synced rows; set `deletedAt` + `updatedAt` and filter `deleted_at IS NULL` in reads.
- Week/day math: always `Schedule.weekStart` / `Schedule.addDays` (calendar days), never `Duration(days: n)` — DST days aren't 24 h.
- Riverpod is used **without codegen** (plain `Provider`/`StreamProvider`); no freezed/json_serializable. Drift is the only codegen (`*.g.dart`).
- Widget tests that touch Drift: wrap in `tester.runAsync`, pump with real delays, and unmount + pump at the end (see `test/app_flow_test.dart`), or Drift's stream timers fail the test.
- `Column` inside a `Row` in a bottom bar / sheet needs `mainAxisSize: MainAxisSize.min`, or it stretches to the full height (this blanked the workout screen once).
- Catalog changes: edit `tool/build_catalog/curation.yaml`, rerun the build (uses the cached dataset; needs ffmpeg for WebP), commit `assets/catalog/`. `test/tool/catalog_integrity_test.dart` guards it.
- Legal text lives in `assets/legal/*.md`; after editing run `python tool/build_legal.py` to regenerate `docs/*.html`.
- Analytics: only via `analyticsProvider`; props must be in `analyticsAllowedProps` — never add health values. Sent by `PostHogAnalytics` (plain HTTPS, no SDK) only when `POSTHOG_KEY`/`POSTHOG_HOST` are set and the user hasn't opted out; id is a random install id, never the account.
- Insights (Phase 6) live in `lib/domain/insights/` and are all derived from `sessionsProvider` (`SessionLog`): achievements, weekly recap, muscle balance, `RecoveryAdvisor` (easy week / plan refresh). Never store earned badges. Achievement copy is English in the domain file. Easy week = `startWorkout(easyWeek:)` + `finishWorkout(easyWeek:)` (progression not saved); the user's choices are in `settings` keys `coach.*`.
- Workout screen is the focus view: one set at a time, one big button (`_action` in `active_workout_screen.dart`), rest shown as the hero; the old set list lives in the "All sets" sheet. Encouragement lines come from `domain/engagement/encouragement.dart` (deterministic).
- Plan building: `PlanBuildingView` ticks off `PlanSummary` facts; pace via `planBuildPaceProvider` (override to `Duration.zero` in tests). `PlanAnimation` plays `assets/anim/<name>.json` (Lottie) and falls back to a drawn animation when the file is missing; record every file in `assets/anim/ATTRIBUTIONS.md`.
- Plan editing: `ProgramRepository.addExercise/removeExercise/moveExercise/updatePrescription/renameDay`; values go through `PlanLimits.clamp`; removal is a soft delete and a day keeps at least one exercise.
- Training style: `TrainingStyle` (auto / fullBody / upperLower / pushPullLegs / bodyPart) is passed to `PlanGenerator.generate(profile, style:)`; `styleOptions(days)` lists what to offer and `dayNames` previews the week. The choice is stored in the local `settings` key `plan.style` (not on the profile, so no schema change). `buildDay(parts, profile)` + `ProgramRepository.replaceDay` rebuild one day around chosen body parts.
- Share card: `ShareCard` (colours of the chosen `BrandLogo`, never the phone's theme; 4:5 post or 9:16 story, exported 1080 px wide) is previewed in a sheet and captured from there; drawn on a fixed 360-wide canvas with text scaling off.
- Haptics: only via `Haptics.play(HapticCue)` (`core/haptics/haptics.dart`); never call `HapticFeedback` directly. `Haptics.enabled` follows the `haptics.enabled` setting; tests can set `Haptics.observer`.
- Notifications: `NotificationPlanner.plan` (domain) decides everything; `refreshNotifications(container)` rebuilds the whole list (app open/resume, workout finished, reminder settings, plan change, missed day handled). One-off notifications only, 7-day window, no weekly repeats. Don't add a notification without a rule + test there.
- Schedule: the plan is a rotation (`nextDayIndex`), not fixed weekdays. `Schedule.missedDay` finds a skipped training day; the user's choices live in `settings` keys `schedule.*` (`ScheduleChoices`): `chooseNextDay` overrides the rotation until the next finished workout.
- Review prompt: rule in `domain/engagement/review_prompt.dart`, fired from the summary screen's Done button via `reviewServiceProvider`.
- Icons: Material Symbols Rounded (`Symbols.*_rounded`), not `Icons.*`; show state with `fill:` (0/1), not separate outlined glyphs.
- Nav: `FloatingNavBar` floats over tab content (`extendBody`). Tab screens use `SafeArea(bottom: false)` + bottom padding `MediaQuery.paddingOf(context).bottom`. In tests tap tabs via `navTab(label)` (collapsed labels are zero-width).
- `ExerciseMotion` (video_player, muted, `mixWithOthers`) is disabled under `FLUTTER_TEST`; tests see the poster.
- Theme: user setting `appearance.theme` (system/light/dark, default dark) via `themeProvider`; seeded in bootstrap with `initialThemeProvider` so there's no flash. Both themes must look right; check goldens for light too.
- Exercise videos: background is removed by flood fill from the frame edge (never a plain white colour key: it eats body highlights). 540 px, CRF 24.
- Web (Chrome) is for quick previews only: shared code must not import `dart:io`/`dart:ffi` (use conditional imports like `catalog_open_io.dart` / `catalog_open_web.dart`). `web/sqlite3.wasm` + `web/drift_worker.js` must match the `sqlite3` / `drift` versions in pubspec.lock (download from their GitHub releases after upgrading).
- Brand: the logo is the Weight Stack R in three colourways (`BrandLogo`: volt = primary, ember, chalk). `python tool/gen_brand.py` builds everything from `PLATES` + `PALETTES`: the kit in `assets/brand/` (SVG + PNG, not bundled), `lib/core/design/brand.dart`, Android launcher/splash/notification resources, `store/` (Play icon, feature graphic) and web icons. Never hand-edit those outputs. In-app use `BrandMark` (drawn in code, no image). The user's pick is the `settings` key `appearance.logo` (`brandLogoProvider`): it changes the in-app logo and the share card, not the launcher icon (launcher aliases would break `flutter run`, which only finds a launcher `<activity>`). `res/raw/keep.xml` keeps `ic_notification` through resource shrinking.

## Source-of-truth docs (read before planning any work)

- `PRD.md` — problem, principles, features & priorities, safety/privacy requirements
- `design.md` — screens, gamification UX, design tokens (color, type, spacing, motion, haptics), components, accessibility checklist, copy rules
- `architecture.md` — tech stack, folder structure, data model, sync, domain engines (plan generator, progression, gamification, PRs), auth, security, testing
- `phases.md` — build order with exit criteria; don't start a phase until the previous one's exit criteria are met

These are living documents — update them when a decision changes. Record decisions in `DECISIONS.md` (date, decision, why, alternatives).

Env files: copy `env/<flavor>.example.json` → `env/<flavor>.json` (git-ignored).

## Commands

```bash
flutter pub get
flutter analyze
dart format .
flutter test                                   # unit + widget + golden
flutter test --update-goldens                  # regenerate golden files (review the PNG diffs!)
flutter gen-l10n                               # after editing lib/l10n/arb/*.arb
dart run build_runner build -d                 # Drift codegen
dart run drift_dev make-migrations             # after bumping schemaVersion: snapshot + migration tests
flutter test --coverage && python tool/coverage_report.py   # domain coverage gate (>= 90%)
dart run tool/build_catalog/build_catalog.dart # rebuild assets/catalog from curation.yaml
flutter run --flavor dev -t lib/main_dev.dart --dart-define-from-file=env/dev.json
flutter build appbundle --release --flavor prod -t lib/main_prod.dart --dart-define-from-file=env/prod.json --obfuscate --split-debug-info=build/symbols
supabase db reset                              # Phase 3+: reset local Supabase
```

## Stack (see architecture.md §2)

Riverpod (no codegen) · go_router · Drift (SQLite, single source of truth) · very_good_analysis · mocktail · patrol (E2E) · Sentry · flutter_local_notifications · flutter_secure_storage. Phase 3+: Supabase (Auth, Postgres+RLS, Edge Functions), PowerSync or custom sync. Phase 7: RevenueCat.

Rejected: Isar, Hive, Firestore as primary store — don't introduce them.

## Target structure (feature-first)

```
lib/
  app/        # App widget, router, theme, bootstrap
  core/       # design/ (tokens, theme, components), db/ (Drift), sync/, auth/, analytics/, l10n/, utils/
  domain/     # PURE DART: plan/, progression/, gamification/, records/
  features/<name>/{data,application,presentation}/
assets/catalog/catalog.sqlite   # generated by tool/build_catalog/
supabase/{migrations,functions}/
```

## Hard rules

1. **`lib/domain/` is pure Dart** — no `package:flutter` imports. All plan/progression/gamification/PR logic lives here and is unit-tested (≥90% coverage). Write tests first for domain logic.
2. **Local-first:** the network is never on the critical path of a workout. Startup does no network work. Persist active workout state after every set (single DB transaction).
3. **Every feature ships with tests.** Every Drift schema change gets a migration + migration test. Every component gets light/dark/200%-text golden tests and a semantics label.
4. **Never commit secrets.** The root `.env` holds the Supabase secret key for reference only; never read it from app code. Env via `--dart-define-from-file` (git-ignored). Only the Supabase anon key may ship in the app; the service role key lives only in Edge Functions.
5. **RLS on every new Postgres table**, deny by default, with own-rows policies (template in architecture.md §8) and two-user RLS tests. `subscriptions` is client read-only.
6. **Data conventions:** client-generated UUIDv7 ids; every user table has `user_id`, `created_at`, `updated_at`, `deleted_at` (soft delete). Weights stored in **kg**, converted at the UI edge. Level/XP/streaks are **derived** from `xp_events` (append-only) and `streak_weeks`, never stored.
7. **Privacy:** never log or send health values, emails, or tokens to analytics/Sentry. Collect minimal data.
8. **Design:** use tokens from `core/design/` — no hard-coded colors/sizes. Dark mode is default. Accent on at most one element per screen; no red/shaming for missed days. Respect Reduce Motion and text scaling up to 200%.
9. **Wellbeing:** never reward overtraining (XP daily cap, max one progression step per session, flag >~30% weekly volume jumps).
10. **Exercise media:** demo videos from Free Exercise DB with Videos (owner's decision, 2026-10-03), mapped by hand via `video:` in `curation.yaml`, cropped and baked per theme (`_dark`/`_light`.mp4 on `surfaceRaised`) + first-frame `.webp` thumbs; exercises without a match keep yuhonas stills. Never hotlink at runtime. Credit sources only in You → Credits (no per-media captions).
11. Review SQL, RLS, auth, and payment changes with extra care; one feature per branch/PR.
