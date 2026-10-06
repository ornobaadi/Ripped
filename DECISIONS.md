# Decisions

Format: date · decision · why · alternatives considered.

## 2026-10-02 · App name and id
**Ripped**, package `ripped`, application/bundle id `com.ornobaadi.ripped` (dev: `.dev`, staging: `.stg` suffix on Android).
Replaces the "Momentum" working title.

## 2026-10-02 · Exercise media source deferred
Start with free-exercise-db (Unlicense) photos. Pick the video/GIF source after the core loop is built.
**Why:** licensing needs careful checking, and the UI should drive what media format we need.
**Candidates:** free-exercise-db-api (MIT-claimed videos, self-host; verify the media license itself), RepDB (free static illustrations with attribution, paid animations), WorkoutX (hosted GIF API; terms unverified, runtime dependency conflicts with offline-first), ExerciseDB (paid commercial API).
**Guardrail:** catalog schema and pipeline are media-agnostic (`media` list of image/gif/video, one adapter per source).

## 2026-10-02 · Typography: Inter + Barlow Condensed
Inter for UI text, Barlow Condensed for headings and big numbers.
**Why:** a condensed display face gives large, glanceable numbers in the workout screen without taking extra width. Inter is very legible at small sizes.
**Alternatives:** Inter only (less character, wider numbers), Oswald/Bebas (Bebas is caps-only; Oswald is heavier and less refined).

## 2026-10-02 · Goldens use the test font
Golden tests render with Flutter's default test font (text as blocks), not the real fonts.
**Why:** pixel-stable across Windows dev machines and Linux CI. They verify layout, color, and 200% text reflow. Real-font visual checks happen on device.

## 2026-10-02 · New pattern `isolation_leg`
Added next to `isolation_arm` for leg extension and leg curl, which aren't arm isolation work.

## 2026-10-02 · Catalog images are WebP via ffmpeg
Images are resized to max 720 px and encoded to WebP (quality 75, metadata stripped) with ffmpeg, falling back to JPEG if ffmpeg isn't installed. Catalog went from 24 MB to 11 MB.
**Why:** `package:image` can't encode WebP, and ffmpeg is already on the dev machine.

## 2026-10-02 · Android first, global English
Launch on Google Play only; iOS later. English only, global audience, no region-specific content.
**Why:** one platform to polish and test; Play Console is the first release target.
**Effect:** iOS/macOS/Linux/Windows/web folders stay but are not maintained or tested until iOS is picked up.

## 2026-10-02 · Plain Riverpod, no freezed/json codegen
Providers are written by hand (`Provider`, `StreamProvider`); domain models are small hand-written immutable classes. Removed riverpod_generator, freezed, json_serializable.
**Why:** fewer build_runner steps and faster iteration; the models are small. Drift codegen stays (it's required).
**Revisit:** if providers or models grow enough that boilerplate hurts.

## 2026-10-02 · Feeling check moves into the finish sheet
"How did it feel?" (Easy / Just right / Tough) is asked when tapping Finish, not after the summary.
**Why:** progression runs once, atomically, when the workout is finished, and a "Tough" session must block weight increases. Asking afterwards would mean re-running or undoing progression, and an app kill in between would lose it.

## 2026-10-02 · Timed exercises and equipment overrides in curation
Curation gained `timed: true` (planks, carries, stretches, cardio are prescribed in seconds) and equipment overrides (pull-ups need a "pull-up bar", dips need a station) because the source data marks them "body only".

## 2026-10-02 · Rotation, not weekday, decides the next workout
The next program day follows the last completed one; missed days shift forward instead of being skipped. Rest days still show "Train anyway".

## 2026-10-02 · Plans respect the session length
After filling slots, the generator drops the least important exercises until the estimated time fits the chosen session length (+15%), keeping at least 3. Strength days with long rests were running ~78 min for a 45-min choice.

## 2026-10-02 · Drift stores DateTimes as text
`store_date_time_values_as_text: true` (ISO-8601). Readable in raw SQLite dumps and exports; must not change after release without a migration.

## 2026-10-02 · Streaks derived from workouts; no streak_weeks table
Streak, shields and the weekly calendar are recomputed from completed workout dates on every read (`domain/gamification/streak.dart`). Week math uses calendar days (`DateTime(y, m, d + n)`), never 24-hour Durations, so DST weeks are correct.
**Why:** a stored streak can drift from the data; a derived one can't. It's cheap at this scale.
**Rest-day credit:** interpreted as "the target is your own days/week", so rest days are already accounted for; there's no separate credit counter.

## 2026-10-02 · XP cap order: bonuses before per-set XP
When the daily cap (400) bites, streak/comeback/workout/PR XP are granted first and per-set XP is trimmed. Volume past a healthy point earns nothing, but a capped day still celebrates what matters.

## 2026-10-02 · First session with an exercise sets no PRs
Records need a previous session to beat; otherwise every first workout would be a wall of "new best" cards.

## 2026-10-02 · Reminders are inexact, local, opt-in
`flutter_local_notifications` with `inexactAllowWhileIdle`: no exact-alarm permission (which Play audits), no server. Off by default; permission is asked only when the user turns them on. Rescheduled when training days change.
**Note:** `wakelock_plus` is pinned to 1.8.0; 1.8.1+ needs dbus 0.8 which conflicts with the notifications plugin's Linux implementation.

## 2026-10-02 · Animated exercise media: research result
- **free-exercise-db-api videos: not usable.** The author states they bought the videos from an Instagram ad and can't verify the source ("use with caution"). Only the code and metadata are MIT.
- **RepDB: legally clean, paid.** The Standard license ($499 one-time, 609 exercises) includes looping animations as transparent animated WebP, which Flutter plays natively with no extra package, plus a commercial-app license. The $299 Starter tier has stills only. The free preview isn't licensed for production.
- **Plan:** stay on free-exercise-db photos until the owner decides. If RepDB is bought, add a `sources/repdb.dart` adapter; the schema, UI and loader already handle `image | gif | video` media.

## 2026-10-02 · One Supabase project, Google sign-in only
Prod-only Supabase project for now; `env/dev.json` points at it too (dev test data shares the database). Sign-in is native Google via Credential Manager (`google_sign_in` 7) → `signInWithIdToken`; email OTP is dropped. Apple sign-in comes back only with iOS.
**Why:** owner's choice; fewer moving parts for an Android-only launch.
**Keys:** the app uses the new **publishable** key (`SUPABASE_PUBLISHABLE_KEY`); `supabase_flutter` deprecated `anonKey`. The secret key never enters the app.
**Startup:** Supabase init is skipped without config and capped at 3 s; any failure falls back to offline (`OfflineAuthService`).

## 2026-10-02 · Sync: custom outbox, not PowerSync
SQLite triggers queue every insert/update of a synced table in `sync_outbox`; `SyncService` uploads them (upsert by id) and pulls rows by server-assigned `synced_at`. Conflicts: last write wins per row by the client's `updated_at`, enforced on the server by a trigger and on the device when applying. Pulled rows are written with `sync.applying` set so triggers don't re-queue them.
**Why:** single-user, append-mostly data; no extra paid service; fully testable offline (`test/features/sync_test.dart` runs two phones against a fake server, including offline edits converging).
**Server design:** no foreign keys between synced tables (rows arrive in any order); `user_id` always comes from the JWT; no DELETE policy (deletes are soft); deleting the auth user cascades everything.
**Guards:** a phone remembers which account first synced it and refuses to upload into a different account. `exercise_states` clashes across phones keep the newest. Hard deletes in the app were converted to soft deletes so they sync.
**Alternatives:** PowerSync (managed, Drift integration) if conflict needs grow beyond LWW.

## 2026-10-02 · RevenueCat and remote config deferred
Listed under Phase 3 but they only matter for Pro (Phase 7) and need accounts that don't exist yet. Adding SDKs with nothing to gate is dead weight.

## 2026-10-02 · Backend init off the startup path
`Supabase.initialize` can refresh an expired session over the network. It now runs in the background (`backendProvider`); the app's first frame never waits for it, and auth/sync providers switch from offline to online when it resolves.

## 2026-10-02 · Analytics: events defined, provider pending
`core/analytics/analytics.dart` defines the funnel events and an allow-list of properties (no weights, reps, emails or names can pass). Events print in debug only until a provider is chosen; adding one is a single implementation of `Analytics`, plus a Data Safety form update.

## 2026-10-02 · Legal pages generated from the in-app text
`tool/build_legal.py` renders `assets/legal/*.md` into `docs/*.html` (GitHub Pages), so the Play listing and the app show identical policies. Includes the account-deletion web page Play requires.

## 2026-10-03 — Exercise demo videos + floating nav

- **Decision:** Use Free Exercise DB with Videos for demo videos (owner accepts the provenance risk). 109/181 exercises hand-mapped; videos are cropped to the moving figure, white keyed out onto the theme tile colour, 360 px H.264 CRF 30, ~16 MB total, bundled. Stills stay for the rest.
  **Why:** MP4 was 4–8× smaller than animated WebP (alpha WebP ~500 KB each). Baking per theme avoids needing alpha. **Alternatives:** RepDB ($499), runtime streaming (breaks offline + rule 10).
- **Decision:** M3 Expressive floating pill nav (selected tab expands with a spring, others collapse to icons); Material Symbols Rounded app-wide.
  **Why:** Owner request; fill axis gives selected/unselected state from one glyph.

## 2026-10-06 — Theme switch; video background removal

- **Decision:** Appearance setting (Match phone / Light / Dark), default Dark, stored in the local `settings` table (per device, not synced).
  **Why:** Owner request; light theme existed but was unreachable.
- **Decision:** Exercise videos: remove only edge-connected white (flood fill) plus large enclosed pure-white areas; 540 px, CRF 24.
  **Why:** A white colour key cut holes in the figure's highlights. **Alternatives:** ML matting (heavy), keeping the white tile (clashes with dark UI).

