# PRD — Ripped

> A minimalist, deeply personal workout app that makes training a habit you look forward to.
> Status: v0.1 draft · Owner: you · Last updated: 2026-10-01
> Companion docs: `design.md` · `architecture.md` · `phases.md`

---

## 1. Problem

Most workout apps fail people in one of two ways:

1. **Too much.** Hundreds of exercises, dozens of tabs, social feeds, ads, and setup forms. Beginners bounce before their first workout.
2. **Too generic.** A fixed "12-week program" that ignores your equipment, schedule, experience, and how last session actually went.

The result: people download, try twice, and quit. The hard part of fitness isn't information — it's **showing up consistently with a plan that fits you**.

## 2. Vision

Open the app → see exactly one thing to do today → do it → feel good about it → come back tomorrow.

Ripped is a **personal trainer that fits in one screen**: it builds a plan around *you*, adapts after every session, and turns consistency into a game you actually want to keep playing — without guilt, noise, or dark patterns.

## 3. Product principles (in priority order)

1. **One clear next action.** Every screen answers "what do I do now?"
2. **Personal, not generic.** Every plan, weight, and rep target comes from the user's own data.
3. **Habit-forming for wellbeing, never at its expense.** Reward consistency and recovery; never reward overtraining, never shame.
4. **Works offline, always.** The gym basement has no signal. The app must never block a workout on the network.
5. **Private by default.** Collect the minimum. Health data is sensitive and treated that way.
6. **Fast.** Cold start to "Start workout" in under 2 seconds; logging a set in one tap.

## 4. Target users

| Persona | Description | What they need |
|---|---|---|
| **Starter Sam** (primary) | 18–35, new or returning to exercise, intimidated by gyms, often trains at home with little equipment | Zero-decision plans, clear form guidance, early wins |
| **Consistent Chris** (primary) | Trains 2–4×/week, knows the basics, plateaus often, hates spreadsheets | Smart progression, effortless logging, visible progress |
| **Busy Bri** (secondary) | Time-poor professional/parent, 20–30 min windows | Short sessions, flexible schedule, streaks that survive busy weeks |

Out of scope for v1: competitive athletes, powerlifting meet prep, physiotherapy/rehab programs, nutrition tracking.

## 5. Goals & success metrics

**North-star metric:** *Weekly Consistent Users* — users who hit their own weekly session target.

| Metric | Launch target (calibrate after beta) |
|---|---|
| Onboarding completion | ≥ 80% |
| First workout completed within 24h of install | ≥ 50% |
| D7 retention | ≥ 25% |
| D30 retention | ≥ 12% |
| Weeks with target hit (per active user) | ≥ 60% |
| Crash-free sessions | ≥ 99.8% |
| Median time to log a set | ≤ 2 s |

**Non-goals for v1:** social feed, nutrition, wearables-first experiences, web app, coach marketplace.

## 6. Core user journey

```
Install → Onboarding quiz (≤ 6 questions, ~60s) → "Your plan is ready" →
Today screen → Start workout → Log sets (1 tap each) → Rest timer →
Workout complete (XP, PRs, streak) → Gentle reminder next scheduled day → repeat
```

No account required to start. Account creation is offered *after* the first completed workout ("Back up your progress").

## 7. Features

Priority: **P0** = MVP launch · **P1** = shortly after launch · **P2** = later / Pro candidate

### 7.1 Onboarding & personalization (P0)
- Questions, one per screen, all skippable with sensible defaults:
  1. Main goal: build strength · build muscle · get fit & healthy · lose fat (supporting role only) · move better
  2. Experience: new · some · experienced
  3. Where & equipment: home (none / dumbbells / bands / pull-up bar) · gym (full)
  4. Days per week (2–6) and preferred days
  5. Session length: 20 · 30 · 45 · 60 min
  6. Anything to avoid? (knees / lower back / shoulders / wrists / none) — used to filter exercises, with a clear "this is not medical advice" note
- Units (kg/lb) auto-detected from locale, editable.
- Output: a generated program the user can preview and accept.

### 7.2 Plan generator (P0)
- Deterministic, rules-based engine (runs on-device, explainable, testable). See `architecture.md §6`.
- Picks a split from days/week, fills slots by movement pattern, respects equipment and avoid-list.
- **Swap** any exercise for an equivalent (same pattern, same equipment) in one tap.
- Regenerate plan anytime from settings.

### 7.3 Today screen (P0)
- One hero card: today's workout (name, est. duration, exercise count) + big **Start** button.
- Rest day? Show a rest-day card that *counts toward the streak* plus an optional 10-min mobility session.
- Weekly progress strip (e.g. ●●○○ "2 of 4 this week").

### 7.4 Active workout logger (P0)
- Pre-filled weight/reps from the progression engine; tap ✓ to log a set as prescribed.
- Steppers for weight/reps (no keyboard needed). Optional RPE/"how hard" (Easy / Good / Hard).
- Auto rest timer with haptic + sound at end; skip/extend.
- Exercise demo (images, instructions) one tap away.
- Survives app kill, phone lock, and calls (state persisted after every set).
- Add/skip/reorder exercises mid-workout.

### 7.5 Workout complete (P0)
- Summary: duration, volume, sets, PRs.
- XP earned, level progress, streak status, any new badge — a short, satisfying celebration (≤ 3 s, skippable).
- Optional one-tap mood/energy check (feeds the adaptation engine).

### 7.6 Progression engine (P0)
- Double progression for weighted lifts; rep/variation progression for bodyweight.
- Auto-deload after repeated stalls. Detailed rules in `architecture.md §6.3`.

### 7.7 Gamification (P0 core, P1 extended)
- **XP & levels** (P0): XP for completing sets/workouts; daily XP cap so more volume ≠ more XP beyond a healthy point.
- **Weekly streak** (P0): a streak counts *weeks* where the user hit their own target — not daily — so rest days are rewarded, not punished.
- **Streak shield** (P0): one free "life happens" shield per month protects a missed week.
- **Personal records** (P0): auto-detected (estimated 1RM, rep PRs, volume PRs) with a celebration.
- **Achievements** (P1): ~30 badges (first workout, 10 workouts, 4-week streak, first pull-up, comeback after a break…). Some are surprise badges.
- **Muscle map / strength levels** (P1): body map that "lights up" as muscle groups get trained this week.
- **Weekly recap** (P1): shareable card (no personal data by default).
- **Explicitly excluded:** guilt notifications, streak-loss shaming, loot boxes, pay-to-keep-streak, public leaderboards of body metrics.

### 7.8 Progress (P0 basic, P1 rich)
- P0: workout history, PR list, streak calendar, per-exercise chart (weight × reps over time).
- P1: volume per muscle group per week, body-weight trend (optional input), consistency heatmap.

### 7.9 Reminders (P0)
- Local notifications on the user's training days at their chosen time. Copy is warm and short. User controls frequency; easy off switch.

### 7.10 Account, backup & sync (P0 — ships before public launch so nobody loses history when changing phones)
- Sign in with Apple, Google, or email one-time code (no passwords).
- Anonymous local data merges into the account on sign-up.
- Multi-device sync; offline-first.
- In-app **account deletion** and **data export** (JSON/CSV).

### 7.11 Health platform integration (P1)
- Write completed workouts to Apple Health / Health Connect (opt-in). Optionally read body weight.

### 7.12 Home-screen widget (P1)
- Shows streak + today's workout; tap to start. High retention lever with minimal UI.

### 7.13 Pro subscription (P2 — see §9)
- Adaptive AI coach, advanced analytics, plateau detection, unlimited custom programs, themes/app icons.

### 7.14 Localization (P0 infra, P1 content)
- All strings externalized from day one. English only, global audience; no region-specific content. More languages only if data shows demand.

## 8. Content & exercise data

**Decision:** Build our own curated catalog from openly licensed sources; never ship scraped or restricted content.

| Source | License / terms | Use? |
|---|---|---|
| **free-exercise-db** (yuhonas) | Unlicense (public domain), 800+ exercises, JSON + 2 photos each | ✅ **Primary seed.** Bundle in app. |
| **wger** exercise data | Creative Commons per entry (commonly CC-BY-SA; check each entry), attribution required | ✅ Secondary, per-entry license check; keep attribution screen |
| **ExerciseDB** (ascendapi) | Repo is AGPL-3.0; the data, videos and GIFs are a paid commercial API with its own Terms of Use; public playground "not for production" | ⚠️ Only later, on a paid plan, after reading their ToS. Good candidate for Pro-era video upgrade. |
| **free-exercise-db-api** (luisaraujoc) — ❌ checked 2026-10-02: videos are of unverified origin (author bought them from an ad) | Repo claims MIT; ~317 exercises, ~593 Full-HD MP4 demo videos (male + female), thumbnails, form cues, common mistakes, breathing notes; REST API, designed to be self-hosted | 🔍 **Top candidate for video.** Verify the media itself (not just the code) is MIT/owned by the author before use; if clean, self-host media in Supabase Storage, never call their demo host. |
| **RepDB exercise-dataset** — ✅ best option for animations: $499 Standard license, looping transparent WebP | Free tier: personal + commercial use in apps with attribution; static illustrations only. Animated previews are paid-tier and explicitly not allowed in production on free tier | 🔍 Candidate for legally clean static illustrations. No animations unless we pay. |
| **WorkoutX** | Hosted API, claims 1,300+ exercises with GIFs, free tier; third-party API + CDN dependency | 🔍 Read current API/license/redistribution terms first. Runtime API dependency conflicts with offline-first — only usable if media can be cached/bundled under their terms. |
| **Hevy scraper** | Logs into Hevy and extracts Hevy's own content; no license | ❌ **Do not use.** Likely violates Hevy's terms and copyright. |

**Media source is an open decision (decide after the core loop is built).** Ship Phase 0–1 with free-exercise-db photos as placeholders. The catalog schema and UI must be media-agnostic (image, GIF, or video per exercise) so we can swap/upgrade sources later. Rules for any source: (1) the *media* license must allow commercial redistribution — an open-source API repo does not imply rights to its images/videos; (2) media is bundled or self-hosted (Supabase Storage/CDN), never hotlinked from a third-party API at workout time; (3) license + attribution recorded per asset.

**Curation:** ship a focused library of ~150 exercises (not 800+) — tagged by movement pattern, equipment, difficulty, joint stress, and substitutes. Minimalism applies to content too. Long-term, record or commission our own demo clips for the core 50 exercises (biggest quality differentiator, fully owned).

## 9. Monetization strategy

**Recommendation: free at launch, "free core forever," Pro subscription once retention is proven.**

Why not paid on day one: an unknown app with no reviews converts poorly; you need retention data and ratings first, and a free app gets far more installs to learn from.

| Phase | Model |
|---|---|
| Launch → ~3 months | 100% free. No ads (ever — they destroy minimalism). Build RevenueCat + entitlements plumbing behind a flag so Pro is a switch-on, not a rewrite. |
| When D30 ≥ ~12% and rating ≥ 4.5 | Introduce **Pro** (monthly + annual, annual as default, 7-day free trial). Regional pricing via the stores. |
| Founders | Users who joined before Pro get a lifetime discount or a free Pro period — rewards early adopters and drives reviews. |

**Free forever:** onboarding, personalized plan, logging, progression engine, streaks, XP, PRs, basic progress, reminders, backup/sync.
**Pro:** AI coach (chat + auto-adjusted plans — costs real money per user, which justifies the subscription), advanced analytics, plateau detection & auto-deload explanations, unlimited custom programs, video demos, themes & app icons.

Rule: **never paywall something a free user already relied on.** Only add new value to Pro.

## 10. Safety, privacy & compliance requirements

- Health disclaimer during onboarding; "not medical advice"; suggest consulting a professional for injuries.
- Guardrails: warn on sudden volume spikes (> ~30% week-over-week), cap daily XP, enforce rest-day messaging, avoid body-shaming copy, weight-loss is never the default goal.
- Data minimization: age range not birthdate; body weight optional; no location.
- GDPR-style rights for everyone: export, delete, consent for health data.
- App Store: Sign in with Apple offered alongside Google (Guideline 4.8); in-app account deletion; accurate privacy nutrition labels. Google Play: Data Safety form, Health Connect permissions declaration.
- Accessibility: WCAG AA contrast, Dynamic Type, screen readers, Reduce Motion.

## 11. Risks & mitigations

| Risk | Mitigation |
|---|---|
| Generic plan feels generic | Strong onboarding, visible "why this exercise" explanations, fast swap, adapt after every session |
| Users quit after 2 weeks | Weekly (not daily) streak, shields, comeback rewards, widget, recap |
| Data loss | Local-first SQLite with transactions; tested migrations; cloud backup after sign-up |
| Licensing problems with media | Only openly licensed sources; attribution screen; own media over time |
| Gamification encourages overtraining | XP caps, rest rewarded, volume-spike warnings |
| Scope creep | Strict phase gates in `phases.md` |

## 12. Open questions to decide together

1. Final name & brand.
2. ~~iOS + Android at launch?~~ **Decided: Android first** (Google Play), iOS later.
3. AI coach scope and which model provider/budget per user.
4. Do we want any social features at all (friends/challenges) — or stay purely personal?
5. Confirm store payout support for your bank/country before Pro launch.
