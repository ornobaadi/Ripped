# Release guide: Google Play closed testing (Phase 4)

What you do by hand to get Ripped to testers. I prepared everything that's
text; you click through Play Console. Check each Play Console page against
its current wording; Google renames things often.

---

## 0. Before you start

- [x] Contact email is in the legal pages (`assets/legal/*.md`, `docs/`).
- [ ] Add the same email as `SUPPORT_EMAIL` in `env/prod.json` (shows
      **Send feedback** in the app).
- [ ] Publish the legal pages: GitHub repo → **Settings → Pages → Deploy from
      a branch → `main` / `/docs`**. Free Pages needs a **public** repo (or a
      paid plan). Your links will be:
  - Privacy: `https://ornobaadi.github.io/Ripped/privacy.html`
  - Terms: `https://ornobaadi.github.io/Ripped/terms.html`
  - Account deletion: `https://ornobaadi.github.io/Ripped/delete-account.html`
- [ ] Supabase → **Advisors → Security Advisor**: no errors.

## 1. Release signing key (once, keep forever)

Steps are in `SETUP_BACKEND.md` → "Before Play release". Create the keystore,
add `android/key.properties`, and add its SHA-1 as an Android OAuth client
(otherwise Google sign-in fails in the Play build).

## 2. Build the bundle

```bash
flutter build appbundle --release --flavor prod -t lib/main_prod.dart --dart-define-from-file=env/prod.json --obfuscate --split-debug-info=build/symbols
```

Output: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`. Keep
`build/symbols/` for that version (it turns crash stack traces back into
readable code).

Bump `version:` in `pubspec.yaml` (`1.0.0+1` → `1.0.0+2`, …) for every upload.

## 3. Play Console: create the app

<https://play.google.com/console> → **Create app**: name **Ripped**, default
language English (United States), **App**, **Free**, accept the declarations.

## 4. App content (Policy → App content)

| Section | Answer |
|---|---|
| Privacy policy | Privacy URL from step 0 |
| App access | "All functionality is available without special access." Sign-in is optional. |
| Ads | No ads |
| Content rating | Questionnaire → category **Reference, News, or Educational** or **Health & Fitness** style app; no violence, user-generated content, gambling, etc. Expect **Everyone / PEGI 3**. |
| Target audience | 18+ (simplest; the policy says not for under-16s) |
| News app | No |
| Health apps | Declare it as a **fitness** app (workout tracking). No medical features, no Health Connect. |
| Government app | No |
| Financial features | None |
| Data safety | See section 5 |
| Account deletion | Yes, accounts can be created. Deletion URL: the account-deletion page from step 0 |

## 5. Data safety form

**Does your app collect or share user data?** Yes (only when signed in).
**Is all data encrypted in transit?** Yes (HTTPS).
**Can users request deletion?** Yes (in app + web page).

| Data type | Collected | Shared | Purpose | Optional? |
|---|---|---|---|---|
| Personal info → **Email address** | Yes | No | Account management | Optional (sign-in is optional) |
| Personal info → **Name** | Yes | No | Account management | Optional |
| Personal info → **User IDs** | Yes | No | Account management, app functionality | Optional |
| Health and fitness → **Fitness info** | Yes (workout logs, when signed in) | No | App functionality (backup/sync) | Optional |
| App info and performance → **Crash logs** | Only if you add a Sentry DSN | No | Analytics / diagnostics | — |

| App activity → **App interactions** | Only if you set `POSTHOG_KEY` | No | Analytics | Optional (user can turn it off) |
| Device or other IDs | Only if you set `POSTHOG_KEY` (random install ID) | No | Analytics | Optional |

Everything else (location, contacts, photos, messages, financial, etc.):
**not collected**. Data is not sold and not used for ads.

## 6. Store listing (Grow → Store presence → Main store listing)

**App name:** Ripped

**Short description (≤ 80 chars):**
> A personal workout plan that adapts every session. Simple, offline, no ads.

**Full description:**
> Ripped builds a strength plan around you and tells you exactly what to do
> today. Answer six quick questions about your goal, experience, equipment and
> schedule, and you get a week of workouts that fits.
>
> One clear next action
> Open the app, see today's workout, tap Start. Every set is pre-filled; log it
> with one tap. A rest timer runs between sets and the screen stays on.
>
> It adapts as you get stronger
> Hit the top of your rep range and the weight goes up next time. Stall, and
> it adjusts. Feel beaten up? Tell it, and it won't push harder.
>
> Progress you can see
> Weekly streaks that count your rest days, personal records, levels and a
> strength chart for every lift. No guilt when you miss a day.
>
> Yours, and private
> Works fully offline in the gym basement. No account needed. Sign in with
> Google only if you want a backup and sync between phones. No ads, no selling
> data, export or delete everything anytime.
>
> 180+ exercises with step-by-step instructions, for gyms, home dumbbells or no
> equipment at all.
>
> Ripped gives general fitness guidance, not medical advice.

**Graphics:**
- App icon: `store/play_icon_512.png` (512 x 512, ready to upload).
- Feature graphic: `store/feature_graphic_1024x500.png` (ready to upload).
- Both use the primary logo (Volt). Other sizes and colourways, if a
  listing or a press page needs them, are in `assets/brand/png/` and
  `assets/brand/svg/`.
- Phone screenshots (2–8, portrait): take on your phone with real data:
  1. Today screen with a workout
  2. Active workout mid-session (rest timer showing)
  3. Workout complete celebration (XP + a new record)
  4. Plan preview
  5. Progress tab (streak + chart)

**Category:** Health & Fitness. **Contact email:** your support email.

## 7. Closed testing

New personal developer accounts must run a closed test before production.
At the time of writing: **at least 12 testers opted in continuously for 14
days**. Check the current numbers in Play Console under the production
access requirements.

1. **Test and release → Testing → Closed testing → Create track** (or use
   "Alpha").
2. **Testers:** create an email list with your testers' Google accounts (aim
   for 15–20 so dropouts don't reset the count). Add the same accounts as
   **test users** on the Google Cloud OAuth consent screen, or publish the
   consent screen, so they can sign in.
3. **Create release** → upload the `.aab` → release notes → **Review and roll
   out**.
4. Share the **opt-in link** with testers. They must accept it and install
   from Play.
5. After the first upload: Play Console → **App integrity** → copy the
   **App signing key SHA-1** → add an Android OAuth client with it
   (`SETUP_BACKEND.md`). Without this, Google sign-in fails for testers.
6. Ask testers to use it for real workouts and send feedback (You → Send
   feedback). Reply to every message.

## 8. Monitoring (set up before the closed test)

Both are optional and off until you add the keys to `env/prod.json`.

- **Crashes:** create a free project at <https://sentry.io> (platform:
  Flutter) → copy the **DSN** → `"SENTRY_DSN"`.
- **Funnel and retention:** create a free project at <https://posthog.com>
  (pick the EU or US region) → Project settings → copy the **Project API
  key** (starts with `phc_`) → `"POSTHOG_KEY"`, and set `"POSTHOG_HOST"` to
  `https://eu.i.posthog.com` or `https://us.i.posthog.com` to match.
  The key is write-only and safe to ship.
- In PostHog, build one dashboard:
  1. **Funnel:** `onboardingCompleted` → `planAccepted` → `workoutStarted`
     → `workoutCompleted`.
  2. **Retention:** first `appOpened` → returning `appOpened`, weekly (this
     is the D7 number in the exit criteria).
  3. **Trend:** `workoutCompleted` per week, `workoutAbandoned` per week.

## 9. Before applying for production

- Crash-free sessions ≥ 99.8% (Play Console → Quality → Android vitals)
- 7-day retention ≥ 25% among testers
- No open P0/P1 bugs
- Phase 4 checklist in `phases.md` done

## 10. Public launch (Phase 5)

1. **Production access:** Play Console → Dashboard → **Apply for
   production** once the closed test meets Google's requirement. Answer the
   questions about your test honestly (who tested, what you changed).
2. **Staged rollout:** Production → Create release → upload the bundle →
   set **Rollout percentage** to 10%. Watch Android vitals and Sentry for
   2–3 days, then 25% → 50% → 100%. Use **Halt rollout** if crash-free
   sessions drop below 99.8%.
3. **Reviews:** the app asks for a rating by itself: after someone has
   finished at least 3 workouts and just hit a record, a level-up or a
   completed week, never during a workout, and at most once every 120 days.
   Google decides whether the sheet really shows. Reply to every review.
4. **Launch posts** (read each community's self-promotion rules first):
   - Reddit: r/androidapps, r/fitness (weekly self-promo thread only),
     r/bodyweightfitness, r/homegym. Lead with what it does and that it is
     free, offline and has no ads. Ask for feedback, not downloads.
   - Product Hunt: tagline "A workout plan that adapts every session.
     Offline, no ads."; first comment: why you built it, what's next.
   - A 15–20 second screen recording of logging a set with one tap and the
     rest timer starting is the best single asset; reuse it everywhere.
5. Keep a weekly note of the PostHog retention number for the first four
   weeks (Phase 5 exit criterion).
