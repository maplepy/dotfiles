---
name: ui-design-principles
description: Design principles for app UI, especially settings screens. Use when designing, building or reviewing views, settings panes, dialogs, lists, destructive actions, UI copy, or screenshot tests.
---

# UI design principles

Token-based and framework-agnostic. Colours, fonts and exact metrics live in the project's design doc; this skill holds the rules behind them. Apply every rule to the view in hand.

## Tokens

- Every colour, size, radius, font and spring comes from one theme. Views name tokens.
- One accent token. It carries focus, links, info and any live state.
- Primary button is neutral (contrast), never accent-coloured.
- Raw numbers in views are layout metrics only.
- Define one scale each for radii (cards and modals > rows and buttons > compact controls), type (base, muted description) and icons (one size, icon tokens).
- Both light and dark work on every view.

## Structure

- Pane = Basics first, then one Advanced fold, closed by default. Related advanced settings sit together.
- Unproven features live in Labs, off by default.
- Missing OS capability omits the row; show no imitation.
- A setting that depends on another is hidden unless the parent is on.
- Settings auto-save: switches and menus at once, text after a ~250 ms pause, sliders on release. No Save button.

## Components

- Grouping: a muted section label over one raised card. Nothing else groups.
- Row: title, optional one-line description, control on the right, optional leading icon. A row that toggles is one switch, whole row is the target.
- Buttons come in three kinds:
  - Primary: at most one per screen, the thing the person came to do.
  - Secondary: everything else.
  - Danger: destructive actions and armed confirmations only.
- Icon-only buttons carry an accessible label. No tooltips; the description carries the meaning.
- Control choice: switch for on/off, segmented for up to 4 exclusive options, dropdown for more, value button plus modal for big catalogs.
- Modals are for browsing or comparing big things. Esc or scrim click closes.
- Headers show the 1 to 3 most used actions; the rest go in an overflow menu, destructive last, label ending in `…`.
- Search appears only on lists past ~10 items.

## Interaction

- Hover is instant. A settings row never fills on hover or press; only its control reacts.
- Hover fill belongs to single clickable targets: list rows, menu items, sidebar items. List rows select on pointer down.
- One focus ring, in the accent token.
- Motion: a few named springs, critically damped, no bounce. Modals scale from 0.96 and fade. Honour reduce motion.

## Destructive actions

- Two steps in place: the first press turns the control into a Danger button naming the stake (`Delete 466 MB?`), with Cancel beside it.
- No confirm modal, no "cannot be undone" text, no Return key on irreversible actions.
- Never delete what is in use.

## Empty and error states

- One empty state: icon badge, title, hint.
- Errors are text in the row description, in the danger colour, with a recovery action beside it. No toast.
- A failure never blocks the app's core job; say so when true.

## Copy

- Sentence case everywhere.
- `…` is one character: progress (`Saving…`) and buttons that open a further choice (`Choose folder…`).
- Description: one phrase, no closing period (two sentences keep theirs). It says the consequence, not the mechanism.
- Titles are short nouns. One line per control. No intro paragraphs, no On/Off beside switches.
- Errors state the cause, no apology.
- Progress shows the stage: `Downloading 42%`, `Verifying model`.

## Verification

- Build each view from named scenes (state set up in code, never live data).
- Render every scene headless in light and dark; compare against golden images generated from this project's own UI.
- Update goldens in the same change as the visual change, and look at every changed image.
- Assert one Primary per scene.
