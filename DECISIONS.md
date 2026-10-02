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
