# Release guide: Google Play closed testing (Phase 4)

What you do by hand to get Ripped to testers. I prepared everything that's
text; you click through Play Console. Check each Play Console page against
its current wording; Google renames things often.

---

## 0. Before you start

- [ ] Replace `[CONTACT EMAIL]` in `assets/legal/privacy.md`, `terms.md` and
      `delete-account.md`, then run `python tool/build_legal.py`.
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

Everything else (location, contacts, photos, messages, financial, etc.):
**not collected**. Data is not sold and not used for ads. The analytics
events in the app currently go nowhere; if you add PostHog later, add
**App activity → App interactions** (analytics) to this form.

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
- App icon: `store/play_icon_512.png` (placeholder dumbbell; replace with your
  final logo when you have one).
- Feature graphic 1024×500: needed; a dark background with the icon and
  "Ripped" works.
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

## 8. Before applying for production

- Crash-free sessions ≥ 99.8% (Play Console → Quality → Android vitals)
- 7-day retention ≥ 25% among testers
- No open P0/P1 bugs
- Phase 4 checklist in `phases.md` done
