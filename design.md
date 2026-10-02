# Design — Ripped

> The design system and UX rules. If a screen breaks a rule here, the screen is wrong, not the rule.
> Companion docs: `PRD.md` · `architecture.md` · `phases.md`

---

## 1. Design principles

1. **One screen, one job.** Each screen has a single primary action, visually dominant and in the thumb zone.
2. **Calm by default, joyful on success.** The UI is quiet and monochrome; color, motion and haptics are *saved* for wins (set logged, PR, workout done). Scarcity makes rewards feel rewarding.
3. **Zero typing in the gym.** Steppers, pre-filled values, big tap targets. Sweaty hands, shaky arms, bad lighting.
4. **Show progress, not pressure.** Encouraging copy, no red "failure" states for missed days.
5. **Explain the "why" once, quietly.** Small "why this?" affordances instead of tutorials.
6. **Accessible is the baseline**, not a feature.

## 2. Information architecture

Three tabs. That's it.

```
┌──────────────────────────────────────────┐
│  Today          Progress         You     │
└──────────────────────────────────────────┘
Today     → today's workout / rest day, weekly strip, start button
Progress  → streak calendar, PRs, history, charts, achievements
You       → plan settings, reminders, units, account, privacy, (Pro)
```

Modal flows (full-screen, no tab bar): Onboarding · Active workout · Workout complete · Exercise detail · Paywall (later).

## 3. Key screens

### 3.1 Onboarding (6 steps max)
- One question per screen, large tappable cards (not dropdowns), progress dots at top, "Skip" top-right.
- Final step: "Building your plan…" (≤ 1.5 s, real work happening) → **plan preview**: the week at a glance, each day expandable, "Looks good" CTA.
- Health disclaimer is a single plain-language card, not a wall of legal text.

### 3.2 Today
```
┌─────────────────────────────┐
│ Thursday                     │
│ ●●○○  2 of 4 this week   🔥6 │  ← weekly strip + weekly streak
│                              │
│ ┌──────────────────────────┐ │
│ │ Upper Body A              │ │
│ │ 6 exercises · ~40 min     │ │
│ │ Bench · Row · OHP · …     │ │
│ │                            │ │
│ │   [   Start workout   ]    │ │  ← the only accent-colored element
│ └──────────────────────────┘ │
│  Swap day · Preview          │  ← quiet secondary actions
└─────────────────────────────┘
```
- Rest day variant: calm illustration, "Rest is training too ✓ counts toward your week", optional "10-min mobility".

### 3.3 Active workout (the most important screen)
- Current exercise name large; set rows below: `Set 2   60 kg × 8   [✓]`.
- Tap ✓ = logged as prescribed. Long-press or tap value = stepper sheet (±2.5 kg / ±1 rep, configurable increments).
- After logging: rest timer slides up as a full-width bar with countdown; screen stays awake.
- Next exercise preview at the bottom. Swipe horizontally between exercises.
- Persistent mini-header: elapsed time, progress (e.g. 7/18 sets), finish button.
- Tap targets ≥ 56 pt here (above the normal 48 pt minimum).

### 3.4 Workout complete
- Sequence (each ≤ 1 s, all skippable with a tap): ✓ Done → stats → XP bar filling → PR cards (if any) → streak update → badge (if any).
- Then a calm summary with "Done" and an optional "How did it feel?" (3 emoji-free text chips: Easy · Just right · Tough).

### 3.5 Progress
- Top: weekly streak calendar (weeks as rows, a filled pill when target hit, a shield icon when protected).
- PR list (most recent first), exercise charts, history list.
- Achievements grid: earned in full color, unearned as quiet outlines with hints (surprise badges show "???").

### 3.6 Exercise detail
- Start/end position images (crossfade loop between frames for a "pseudo animation"), 3–5 short instruction bullets, primary/secondary muscles, equipment, "Swap for…" list.

## 4. Gamification UX

| Element | Visual | Rules |
|---|---|---|
| XP | Thin progress bar under level badge | XP per set + completion bonus; daily cap; never shown as a "loss" |
| Level | Number + title (e.g. *Beginner → Regular → Dedicated → Athlete → Legend*) | Curve gets slower but every level ≤ ~2 weeks for a regular user early on |
| Weekly streak | Flame + number of weeks | Target = user's own days/week; rest days count; shields protect |
| Streak shield | Small shield glyph | 1/month free; auto-applied; shown as kindness, not currency |
| PR | Card with exercise + old → new | Celebrate with haptic `heavy` + short confetti burst |
| Badges | Simple geometric icons in a consistent style | ~30 at launch; some hidden |
| Comeback | "Welcome back" card | After ≥ 2 weeks away: bonus XP, *no* mention of the broken streak |

Copy voice: short, warm, specific. "New best: 62.5 kg × 8 on bench." — not "AMAZING!!! 🔥🔥🔥".

## 5. Visual language

### 5.1 Color
Monochrome base + **one accent**. Dark mode is the default (gyms, evenings); light mode fully supported.

| Token | Dark | Light | Use |
|---|---|---|---|
| `bg` | `#0E0F11` | `#FAFAF9` | App background |
| `surface` | `#17191C` | `#FFFFFF` | Cards |
| `surfaceRaised` | `#202328` | `#F2F2F0` | Sheets, active rows |
| `textPrimary` | `#F5F5F4` | `#111214` | Main text |
| `textSecondary` | `#A1A1AA` | `#5B5E66` | Labels |
| `border` | `#2A2D33` | `#E4E4E1` | Hairlines |
| `accent` | `#C6F432` (volt) | `#4F7A00` | Primary CTA, progress, wins only |
| `onAccent` | `#0E0F11` | `#FFFFFF` | Text on accent |
| `success` | `#4ADE80` | `#15803D` | Logged set ✓ |
| `warning` | `#FBBF24` | `#B45309` | Volume-spike warning |

Rules: accent appears on **at most one element per screen** at rest. No red for missed days — missed = neutral gray. Check every pair against WCAG AA (4.5:1 text, 3:1 large text/UI) before shipping; the accent is a starting point to test, not final.

### 5.2 Typography
- **Decided: two families.** **Inter** for UI text (body, labels, buttons) and **Barlow Condensed** for headings and big numbers (weights, reps, timers), which stay readable at arm's length mid-set. All OFL; bundled under `assets/fonts/`, never fetched at runtime. Tokens: `AppFonts` in `tokens.dart`.
- Scale (sp): `display 40/44` · `title 28/34` · `headline 22/28` · `body 16/24` · `label 14/20` · `caption 12/16`.
- All numbers use tabular figures so timers and weights don't jitter.
- Respect system text scaling up to 200%; layouts must reflow, not truncate.

### 5.3 Spacing, shape, elevation
- 4-pt grid: `4 · 8 · 12 · 16 · 24 · 32 · 48`. Screen gutters 16 (phone) / 24 (tablet).
- Radii: `8` (chips) · `16` (cards) · `28` (sheets, primary button).
- Elevation by surface color, not shadows (flat, minimal). One subtle shadow allowed on bottom sheets.

### 5.4 Iconography & illustration
- One outline icon set (e.g. Lucide or Phosphor — both permissive licenses), 1.5 px stroke, 24 px grid.
- Illustrations: flat, two-tone (text color + accent), used only on empty states, rest days, and onboarding.

### 5.5 Motion
| Token | Duration | Curve | Use |
|---|---|---|---|
| `fast` | 120 ms | easeOut | Taps, toggles |
| `base` | 220 ms | easeInOutCubic | Sheets, page transitions |
| `celebrate` | 600–900 ms | spring | XP fill, PR, badge |

If system **Reduce Motion** is on: replace movement with fades, disable confetti.

### 5.6 Haptics & sound
| Event | Haptic |
|---|---|
| Set logged | `selectionClick` / light |
| Rest timer ends | `medium` ×2 + optional chime |
| PR / level up | `heavy` |
| Error | none (use clear text instead) |
Sounds off by default except rest-timer chime (user toggle).

## 6. Components (build these first, as a widget library)

`AppButton` (primary/secondary/ghost) · `AppCard` · `SetRow` · `ValueStepper` · `RestTimerBar` · `WeeklyStrip` · `StreakFlame` · `XpBar` · `LevelBadge` · `PrCard` · `BadgeTile` · `ChoiceCard` (onboarding) · `ExerciseThumb` · `EmptyState` · `SectionHeader` · `AppSheet`.

Every component: light + dark golden tests, 200% text-scale golden, semantics label.

## 7. Accessibility checklist (definition of done for every screen)

- [ ] Contrast AA for all text and essential UI
- [ ] Works at 200% text scale without clipping
- [ ] Every tappable has a semantics label and ≥ 48 pt target (56 pt in active workout)
- [ ] Not color-only: states also use icons/text
- [ ] Reduce Motion respected
- [ ] Screen-reader order matches visual order
- [ ] Copy reviewed for shame-free language

## 8. Content & copy guidelines

- Second person, present tense, ≤ 12 words for headings.
- Celebrate specifics ("+5 kg on squat since March").
- Missed workouts: "Want to pick up where you left off?" — never "You failed / You broke your streak."
- Localization-ready: no text baked into images; allow 40% string expansion for future languages.

## 9. Design workflow with Claude Code + skills

- Keep design tokens in `lib/core/design/tokens.dart`; this file is the source of truth, `design.md` documents intent.
- Useful skills from skills.sh to try (review each before installing): `anthropics/skills → frontend-design`, `leonxlnx/taste-skill → minimalist-ui`, `designed-by-ai/skills → design-mobile-apps`. Tell Claude Code: "Follow design.md over any skill when they conflict."
- Prototype screens as Flutter widgets with golden tests rather than separate mockups — the code *is* the design file.
