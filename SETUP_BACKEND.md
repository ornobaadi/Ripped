# Backend setup (Phase 3): what you do by hand

Phase 3 adds sign-in, cloud backup/sync and account deletion. The app keeps
working fully offline; the backend is only for backup and moving between
phones. Everything below is a one-time setup in web dashboards. **Never paste
secrets into chat or commit them**: they go only in the git-ignored
`env/*.json` files or stay in the dashboards.

Time needed: about 45–60 minutes.

---

## 1. Supabase projects (database + auth)

1. Go to <https://supabase.com> → sign up (GitHub login is easiest).
2. **New project** → name `ripped-dev`, pick the region closest to most
   of your users, generate a strong database password, and save it in your
   password manager. Plan: Free.
3. Repeat for `ripped-prod`. (The free plan allows two active projects.
   Free projects pause after a week without traffic. That's fine for dev;
   upgrade prod before launch.)
4. In each project: **Project Settings → API** (or **Data API**). Copy:
   - **Project URL** (`https://xxxx.supabase.co`)
   - **anon / publishable key** (public by design; Row Level Security protects
     data)
   - ⚠️ Do **not** copy the `service_role` / secret key anywhere in the app.
5. Put them in the env files (copy from the `.example.json` if missing):

   `env/dev.json` (from `ripped-dev`) and `env/prod.json` (from `ripped-prod`):
   ```json
   {
     "SUPABASE_URL": "https://xxxx.supabase.co",
     "SUPABASE_ANON_KEY": "eyJ...",
     "SENTRY_DSN": "",
     "GOOGLE_WEB_CLIENT_ID": ""
   }
   ```

## 2. Email sign-in with a one-time code

In each Supabase project:

1. **Authentication → Sign In / Providers → Email**: enabled, "Confirm email" on.
2. **Authentication → Email Templates → Magic Link**: make the body show the
   code, for example:
   `Your Ripped sign-in code is {{ .Token }}. It expires in 1 hour.`
3. **Authentication → URL Configuration → Redirect URLs**: add
   `com.ornobaadi.ripped://login-callback`
4. Before public launch: **Project Settings → Authentication → SMTP**. Set up
   a real email sender (for example Resend, free tier). Supabase's built-in
   sender is rate-limited to a few emails per hour.

## 3. Google sign-in (Android)

You need a **release keystore** first, because Google checks the app's
signing fingerprint.

### 3a. Create the release keystore (once, keep it forever)

```bash
keytool -genkey -v -keystore %USERPROFILE%\ripped-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias ripped
```

Back up the `.jks` file and both passwords. If you lose them you can't
update the app with that key. Then create `android/key.properties`
(git-ignored):

```properties
storeFile=C:\\Users\\<you>\\ripped-release.jks
storePassword=<password>
keyAlias=ripped
keyPassword=<password>
```

### 3b. Get the SHA-1 fingerprints

```bash
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
```
```bash
keytool -list -v -keystore %USERPROFILE%\ripped-release.jks -alias ripped
```

After your first Play upload, also copy the **App signing key SHA-1** from
Play Console → your app → **Test and release → App integrity**. Google Play
re-signs the app with its own key.

### 3c. Google Cloud

1. <https://console.cloud.google.com> → create project `Ripped`.
2. **APIs & Services → OAuth consent screen**: External, app name "Ripped",
   your support email, scopes `openid`, `email`, `profile`. Add yourself as a
   test user while it's in testing.
3. **Credentials → Create credentials → OAuth client ID**:
   - Type **Web application**, name "Ripped Supabase". Copy its **Client ID**
     and **Client secret**.
   - Type **Android**, package `com.ornobaadi.ripped`, SHA-1 = release key.
   - Type **Android**, package `com.ornobaadi.ripped`, SHA-1 = Play app
     signing key (after first upload).
   - Type **Android**, package `com.ornobaadi.ripped.dev`, SHA-1 = debug key.
4. In **each Supabase project → Authentication → Sign In / Providers →
   Google**: enable, paste the **Web** client ID and secret, and add the Web
   client ID to "Client IDs" (authorized client IDs).
5. Put the **Web client ID** (not the secret) in `GOOGLE_WEB_CLIENT_ID` in
   `env/dev.json` and `env/prod.json`.

Apple sign-in is skipped for now. It's only required once the app ships on
iOS with Google sign-in.

## 4. Supabase CLI (to apply the database tables I write)

I'll write the tables and security rules as SQL files in
`supabase/migrations/`. You apply them with the CLI:

```bash
npm install -g supabase
```
```bash
supabase login
```
```bash
supabase link --project-ref <dev-project-ref>
```
```bash
supabase db push
```

The project ref is the `xxxx` in your project URL. Repeat `link` + `db push`
for prod when releasing.

## 5. Optional: Sentry (crash reports)

<https://sentry.io> → new project → platform **Flutter** → copy the **DSN**
into `SENTRY_DSN` in `env/prod.json`. The app only enables Sentry when a DSN
is set, and sends no personal data.

---

## When you're done

Tell me "backend ready". I don't need any keys in chat; the app reads them
from your `env/*.json` files. If something in a dashboard looks different
from these steps (they change their UI often), send a screenshot.
