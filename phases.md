# Phases — Ripped

> Build order with hard exit criteria. Don't start a phase until the previous one's exit criteria are met. Durations are rough for a solo developer working with Claude Code; quality gates matter more than dates.
> Companion docs: `PRD.md` · `design.md` · `architecture.md`

---

## Overview

| # | Phase | Outcome | Rough duration |
|---|---|---|---|
| 0 | Foundations | Repo, tooling, design tokens, exercise catalog | 1–2 weeks |
| 1 | Core loop (offline MVP) | Onboard → plan → log workout → complete, no account | 3–4 weeks |
| 2 | Habit & gamification v1 | XP, levels, weekly streak, PRs, reminders, progress | 2–3 weeks |
| 3 | Accounts, sync & security | Sign-in, backup, RLS, deletion, export | 3–4 weeks |
| 4 | Polish & closed beta | Real users, bugs, accessibility, store assets | 3–4 weeks |
| 5 | Public launch (free) | Live on stores, monitoring | 1–2 weeks |
| 6 | Retention & adaptation | Achievements, widget, Health, recap, smarter engine | ongoing, 4–6 weeks |
| 7 | Pro subscription | Paywall, AI coach, advanced analytics | 4–6 weeks |
| 8 | Optional: social-lite | Friends/challenges — only if users ask | TBD |

---

## Phase 0 — Foundations

**Goal:** a clean, testable skeleton that Claude Code can extend safely.

Scope
- [x] `flutter create` with flavors (dev/staging/prod), `--dart-define-from-file` env files (git-ignored) — Android flavors done; iOS deferred (Android-first launch)
- [x] Packages: riverpod (+generator), go_router, freezed, json_serializable, drift, very_good_analysis, mocktail — sentry_flutter deferred until a DSN exists
- [x] `CLAUDE.md` (rules + commands + links to the four docs)
- [x] Folder structure from `architecture.md §3`
- [x] Design tokens + theme (light/dark) + first 6 components with golden tests (`AppButton`, `AppCard`, `ChoiceCard`, `ValueStepper`, `SetRow`, `EmptyState`)
- [x] l10n setup (ARB files, English only)
- [x] **Catalog pipeline:** script that pulls free-exercise-db at a pinned commit, applies `curation.yaml`, outputs `catalog.sqlite` + WebP images + `ATTRIBUTIONS.md` (source adapters; media-agnostic schema — final video/GIF source decided later, see PRD §8)
- [x] Curate the first ~150 exercises: pattern, equipment, level, joint_stress, substitutes — 181 exercises
- [x] GitHub Actions: format, analyze, test on every PR
- [x] Install & review chosen agent skills; record them in `CLAUDE.md`

**Exit criteria**
- CI green; app launches in all three flavors
- Catalog builds reproducibly from one command; every exercise has license + attribution
- Golden tests pass for components in light/dark/200% text

---

## Phase 1 — Core loop (offline MVP)

**Goal:** someone can install, get a personal plan, and complete a real workout with zero network.

Scope
- [x] Drift schema v1 (user tables from `architecture.md §4.2`) + migration test scaffold
- [x] Onboarding (6 steps, skippable) → profile saved
- [x] `PlanGenerator` (pure Dart) with table-driven tests for every split × equipment × experience combination
- [x] Plan preview + accept; swap exercise; regenerate plan
- [x] Today screen (workout day / rest day variants)
- [x] Active workout: pre-filled sets, one-tap log, steppers, rest timer, add/skip/reorder, wakelock, state persisted after each set
- [x] "Find your weight" first-session flow
- [x] `ProgressionEngine` (double progression + deload) with exhaustive unit tests
- [x] Workout complete summary (no gamification yet) + feeling check (asked in the finish sheet so it feeds progression)
- [x] Exercise detail screen (image crossfade, instructions, muscles)
- [x] Workout history list
- [x] Health disclaimer
- [x] Crash reporting wired (Sentry, enabled when a DSN is set), `sendDefaultPii=false`

**Exit criteria** (status 2026-10-02: logic verified by `test/app_flow_test.dart` + repository tests on an in-memory DB; on-device Patrol E2E and the 2-week personal trial still to do)
- Patrol E2E: fresh install → onboarding → complete workout → reopen app → next session shows progressed targets
- Kill the app mid-workout → reopen → no data lost
- Airplane mode for the whole flow works
- Domain coverage ≥ 90%
- You've personally trained with it for 2 weeks

---

## Phase 2 — Habit & gamification v1

**Goal:** make coming back feel rewarding — without pressure.

Scope
- [x] `xp_events` ledger + level computation + daily XP cap
- [x] Weekly streak with rest-day credit + monthly shield
- [x] PR detection (e1RM, rep PR, volume PR) + PR cards
- [x] Celebration sequence on Workout Complete (respecting Reduce Motion)
- [x] Haptics map from `design.md §5.6` (rest-timer chime sound not added; haptics only)
- [x] Progress tab: streak calendar, PR list, per-exercise chart
- [x] Local reminders on training days (user-controlled, warm copy)
- [x] Comeback flow after ≥ 2 weeks away
- [x] Volume-spike warning

**Exit criteria** (status 2026-10-02: engine 100% covered incl. DST/year/Sunday-Monday boundaries; shame-free copy reviewed; friends test still to do)
- Gamification engine fully unit-tested, including timezone/week-boundary edge cases (DST, travel, Monday vs Sunday week start)
- Copy reviewed against the shame-free checklist
- 5–10 friends using a test build; qualitative feedback collected

---

## Phase 3 — Accounts, sync & security

**Goal:** users can safely back up and sync; we are store-compliant for accounts.

Scope
- [ ] Supabase projects (staging/prod); local dev via Supabase CLI
- [ ] Postgres schema mirroring Drift + **RLS on every table** + RLS tests (user A ≠ user B)
- [ ] 2-day spike: PowerSync vs custom outbox sync → decide → implement
- [ ] Auth: Google sign-in (done in app, pending owner's Google Cloud setup); Apple later with iOS; email OTP dropped; anonymous data merge on first sign-in
- [ ] Secure token storage; sign-out wipes local session
- [ ] In-app account deletion (Edge Function) + local wipe
- [ ] Data export (JSON/CSV)
- [ ] Privacy policy & Terms (in app + web page)
- [ ] RevenueCat SDK + `pro` entitlement plumbing, **hidden behind remote flag**
- [ ] Remote config / feature flags with safe defaults
- [ ] Security review: run Supabase advisors, secret scan, dependency audit, check logs for PII, review every Edge Function

**Exit criteria**
- Two devices, same account, offline edits on both → sync converges with no lost sets
- RLS test suite green; zero advisor warnings of high severity
- Delete account removes all server rows (verified by query) and RevenueCat alias
- No service-role key anywhere in the app bundle (grep the built artifact)

---

## Phase 4 — Polish & closed beta

**Goal:** prove people stick with it before going public.

Scope
- [ ] Google Play closed testing (TestFlight once iOS ships) (new personal Play accounts must run a closed test with a minimum number of testers for a minimum period before production — check current requirements early and recruit testers now)
- [ ] Accessibility audit with `design.md §7` checklist on every screen
- [ ] Performance: cold start < 2 s on a mid-range Android; jank-free workout screen
- [ ] Device matrix testing
- [ ] Analytics events for the funnel (no health values)
- [ ] Store listing: screenshots, short video, privacy labels / Data Safety form, Health Connect declaration if used
- [ ] In-app feedback link; respond to every beta tester

**Exit criteria**
- Beta D7 retention ≥ 25%, crash-free sessions ≥ 99.8%
- No open P0/P1 bugs
- Store review checklist complete (Sign in with Apple present, account deletion reachable, accurate privacy disclosures)

---

## Phase 5 — Public launch (free)

Scope
- [ ] Staged rollout (Play) / phased release (iOS)
- [ ] Monitoring dashboard: crashes, funnel, retention cohorts
- [ ] In-app review prompt after a positive moment (e.g. 3rd completed workout with a PR), never mid-workout
- [ ] Launch channels: Reddit fitness communities (follow their self-promo rules), Product Hunt, local communities, short-form video of the 1-tap logging

**Exit criteria**
- 100% rollout with crash-free ≥ 99.8%
- First 4 weeks of cohort data collected

---

## Phase 6 — Retention & adaptation

Pick based on data, roughly in this order:
- [ ] Achievements (~30, some hidden)
- [ ] Home-screen widget (streak + start)
- [ ] Apple Health / Health Connect write (opt-in)
- [ ] Weekly recap card (shareable, privacy-safe)
- [ ] Muscle map of the week
- [ ] Smarter adaptation: use feeling + RPE trends, auto-suggest deloads, plan refresh every 6–8 weeks
- [ ] Expand catalog + start recording own demo clips for top 50 exercises

**Exit criteria (to unlock Phase 7)**
- D30 ≥ ~12%, store rating ≥ 4.5, weekly consistent users growing

---

## Phase 7 — Pro subscription

Scope
- [ ] Turn on paywall flag; paywall screen (honest, minimal, annual default, 7-day trial, clear cancel info)
- [ ] RevenueCat webhook → `subscriptions` table (signature verified)
- [ ] AI coach Edge Function: de-identified summary → LLM → JSON schema → validated by domain engine → user approves changes
- [ ] Advanced analytics, plateau explanations, unlimited custom programs, themes/app icons
- [ ] Founders' offer for pre-Pro users
- [ ] Restore purchases, grace period & billing retry handling
- [ ] Price experiments via RevenueCat offerings; regional pricing

**Exit criteria**
- Sandbox purchase/renew/cancel/refund flows tested on both stores
- AI coach can never push a change outside safety bounds (unit-tested validator)
- Nothing previously free became paid

---

## Phase 8 — Social-lite (optional)

Only if users ask: private friend groups, shared weekly challenges, cheers. Requires its own privacy review (blocking, reporting, minors). Stay true to "personal first."

---

## Working rhythm with Claude Code

1. Start each phase by asking Claude Code to read `PRD.md`, `design.md`, `architecture.md`, and this phase, then produce a task plan in plan mode.
2. Domain logic: write tests first, then implementation.
3. One feature per branch/PR; CI must be green; review every diff yourself — especially SQL, RLS, auth, and anything touching payments.
4. After each phase, update these docs with what changed (they're living documents).
5. Keep a `DECISIONS.md` log: date, decision, why, alternatives considered.
