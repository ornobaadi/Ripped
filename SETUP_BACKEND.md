# Backend setup: Supabase + Google sign-in

Setup: **one Supabase project (prod)**, **Google sign-in only**, Android only.
The app keeps working fully offline. Signing in is optional and only for
backup/sync.

Never paste keys into chat or commit them. Public values go in the
git-ignored `env/*.json` files; secrets stay in the dashboards.

---

## ✅ Step 0: Supabase project + keys (done)

Your project URL and **publishable** key are in `env/prod.json` (and
`env/dev.json`, which points to the same project for now, so test data from
the dev flavor lands in the same database).

`.env` in the project root isn't read by the app. It holds your
`SUPABASE_SECRET_KEY`, which must **never** be in the app or in git. It's
git-ignored, but the safest thing is to delete that line: the app doesn't
need it, and server code (Edge Functions) gets it from Supabase directly.

---

## Step 1: Get your app's SHA-1 fingerprints (5 min)

Google only lets apps it recognises sign in. It identifies the app by package
name + signing certificate fingerprint (SHA-1).

From the project folder:

```bash
cd android
```
```bash
./gradlew signingReport
```

Find the blocks for **`devDebug`** and **`prodRelease`** and note:

- `Variant: devDebug` → **SHA1** (your debug key)
- `Variant: prodRelease` → **SHA1**. Right now this is the same debug key,
  because no release keystore exists yet (`android/key.properties`).

If gradlew doesn't work, use the JDK's keytool:

```bash
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
```

> Later, when you create the release keystore for Play (section "Before
> Play release" below), you add its SHA-1 too. Nothing else changes.

## Step 2: Google Cloud: consent screen (10 min)

1. Open <https://console.cloud.google.com> → top bar project picker →
   **New project** → name `Ripped` → Create → select it.
2. Left menu **APIs & Services → OAuth consent screen** (newer UI: **Google
   Auth Platform → Branding**):
   - App name: **Ripped**
   - User support email: your email
   - Audience: **External**
   - Developer contact: your email → Save.
3. **Data access / Scopes**: add `openid`, `.../auth/userinfo.email`,
   `.../auth/userinfo.profile` → Save.
4. **Audience / Test users**: add your own Google account (and friends who
   will test). While the app is in "Testing", only these accounts can sign
   in. Click **Publish app** before the public launch.

## Step 3: Google Cloud: OAuth clients (10 min)

**APIs & Services → Credentials → + Create credentials → OAuth client ID**.
Create these:

| # | Application type | Name | Package name | SHA-1 |
|---|---|---|---|---|
| A | **Web application** | Ripped Supabase | – | – |
| B | **Android** | Ripped (prod) | `com.ornobaadi.ripped` | prodRelease SHA-1 from Step 1 |
| C | **Android** | Ripped (dev) | `com.ornobaadi.ripped.dev` | devDebug SHA-1 from Step 1 |

- For **A (Web)**: no origins or redirect URIs are needed. After creating, copy
  its **Client ID** and **Client secret**.
- **B and C** just need to exist; the app never uses their IDs directly.
- If B and C have the same SHA-1 right now, that's expected.

> Why a *Web* client for an Android app? Supabase verifies the Google ID
> token, and that token is issued for the Web client ID. The Android clients
> prove the request really comes from your signed app.

## Step 4: Supabase: enable Google (3 min)

<https://supabase.com/dashboard> → your project → **Authentication → Sign In /
Providers → Google**:

- **Enable Sign in with Google**: on
- **Client IDs**: paste the **Web** client ID (A)
- **Client Secret (for OAuth)**: paste the **Web** client secret (A)
- **Skip nonce checks**: leave **off**
- Save

Also check **Authentication → Sign In / Providers → Email** is on (Supabase
uses it internally to store the account's email). You can turn **off**
"Allow new users to sign up" for email, so Google is the only way in.

## Step 5: Put the Web client ID in the app (1 min)

In `env/prod.json` **and** `env/dev.json`, set:

```json
"GOOGLE_WEB_CLIENT_ID": "1234567890-abc...apps.googleusercontent.com"
```

Use the **Web** client ID (A), not an Android one. It isn't a secret, but
it's kept in env with the rest of the config. The client **secret** goes only
into Supabase (Step 4), never into the app.

## Step 6: Build and try it

```bash
flutter run --flavor dev -t lib/main_dev.dart --dart-define-from-file=env/dev.json
```

or install a release APK:

```bash
flutter build apk --release --flavor prod -t lib/main_prod.dart --dart-define-from-file=env/prod.json
```

Open **You** → **Continue with Google** → pick your account. You should see
your name and email on the card, and a new row under Supabase →
**Authentication → Users**.

### If sign-in fails

| Symptom | Usual cause |
|---|---|
| "Couldn't sign in…" immediately, nothing pops up | SHA-1 or package name in the Android client (B/C) doesn't match the build you installed. Dev flavor = `.dev` package + debug SHA-1. |
| Account picker shows, then fails | Supabase Google provider: Web client ID/secret wrong, or the ID isn't in "Client IDs". |
| "Access blocked" / not allowed | Your Google account isn't a **test user** on the consent screen (Step 2.4). |
| No Account card in **You** at all | `SUPABASE_URL` / `SUPABASE_PUBLISHABLE_KEY` empty in the env file you built with. |
| Card shows, button does nothing useful | `GOOGLE_WEB_CLIENT_ID` empty in that env file. |

Send me a screenshot of the error if none of these fit.

---

## Before Play release (later, not needed today)

1. Create the release keystore and keep it backed up forever:
   ```bash
   keytool -genkey -v -keystore %USERPROFILE%\ripped-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias ripped
   ```
   Then create `android/key.properties` (git-ignored):
   ```properties
   storeFile=C:\\Users\\<you>\\ripped-release.jks
   storePassword=<password>
   keyAlias=ripped
   keyPassword=<password>
   ```
2. Add another **Android** OAuth client for `com.ornobaadi.ripped` with the
   release keystore's SHA-1 (`./gradlew signingReport` → prodRelease).
3. After the first Play upload: Play Console → **Test and release → App
   integrity** → copy the **App signing key SHA-1** → add one more Android
   OAuth client with it. Play re-signs your app, so this is the one real users
   will have.
4. Publish the OAuth consent screen (Step 2.4).

## Step 7: Database tables, security rules and account deletion (15 min)

This creates the backup tables (each user can only ever see their own rows)
and the function that deletes an account. You need Node.js (you already have
it) and your Supabase login.

From the project folder:

```bash
npx supabase login
```
```bash
npx supabase link --project-ref fjlsalyzvefhctjjkogc
```
It asks for the database password you set when creating the project.

```bash
npx supabase db push
```
This applies `supabase/migrations/…_sync_schema.sql`.

```bash
npx supabase functions deploy delete-account
```
This deploys `supabase/functions/delete-account`. Supabase provides the
server key to the function automatically; you don't paste it anywhere.

### Check it worked

1. Dashboard → **Table Editor**: 10 tables (`profiles`, `workouts`,
   `workout_sets`, …), each marked **RLS enabled**.
2. Dashboard → **Advisors → Security Advisor**: should show no errors.
   Send me a screenshot of any warnings.
3. On the phone: **You** → the account card should say **Backed up just now**
   (tap **Back up now** if not). Then Table Editor → `workouts` shows your
   workouts.
4. Optional, needs Docker Desktop: the security test suite (user A can never
   see user B's data):
   ```bash
   npx supabase start
   ```
   ```bash
   npx supabase test db
   ```

### Two-phone test (Phase 3 exit check)

Sign in with the same Google account on two phones (or a phone + emulator).
Turn on airplane mode on both, log a workout on each, turn the network back
on, and open the app on both. After a few seconds both should show both
workouts in **Progress → History**.
