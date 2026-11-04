# WCAG Audit Coverage — App / Multi-route Sweep

This file is the only copy of the route/layer sweep and the coverage gate. Add a layer or a hunt here, not in `SKILL.md`, the rule, or `a11y-reviewer`.

**When to load:** more than one component, or any app / multi-page / multi-route review. Do not use this checklist for single-component scope — still review that component.

Goal: stop “one good page” audits that miss the same failure on other routes, and catch hidden ARIA / structure bugs.

Load with the success-criteria table for the resolved standard, `code-patterns.md`, and `judgment-traps.md`. Report every hit with `path:line` + criterion number.

## Hard rules (fail the audit if you skip them)

1. **Do not stop after the first broken component.** One Critical finding does not clear the app.
2. **Do not trust filenames or prop names.** `Safe*`, `*ok`, `Decorative*`, `mode="safe"`, `labelled` can still hide failures — read the call site on each route.
3. **One passing page is not an app pass.** A pattern that works on `/` does not close the same criterion for `/checkout`. Record evidence scope; file failures (or explicit N/A) on routes outside that scope.
4. **Same smell, many routes.** If help *relative order*, titles, bypass mechanisms, focus utilities, or unlabeled search differ by page, file **each** route (or one finding that lists every `path:line`).
5. **Scoped pass ⇒ check the complement.** When you mark a criterion `pass` with evidence on N pages, list the in-scope pages **without** that pattern. Missing ones are failures (or explicit “not applicable”), not silent omissions.
6. **Do not claim conformance.** Counts and evidence only.
7. **Do not invent failures from decoys.** Before filing 2.4.1, 2.5.8, 3.2.3, 3.2.6, 3.3.8, or similar, apply `judgment-traps.md`.

## Mandatory route / layer sweep

Walk **every** layer that exists in scope. Skip a row only if that folder is absent.

| Layer | Typical paths | What to hunt |
|-------|---------------|--------------|
| Document shell | `layout.tsx`, `_document`, root `html` | `lang`; default title; global CSS focus / motion / scroll-padding / fixed chrome |
| Pages / routes | `app/**/page.tsx`, `pages/**`, screens | Bypass mechanism; unique `title`; headings; media tracks; `locatable` / sitemap / search entry |
| Shared chrome | header, footer, nav, help slots | Help **relative order** (3.2.6); nav **order of repeated items** (3.2.3); sticky/fixed chrome (2.4.11); landmarks |
| Forms / auth | login, checkout, multi-step | Labels, errors, paste/autocomplete (3.3.8), redundant entry (3.3.7), autocomplete tokens (1.3.5), mousedown activation (2.5.2), legal/financial confirm (3.3.4) |
| Interactive widgets | modals, carousels, drag, toolbars | Keyboard, dialog semantics, pause controls, target size + exceptions, drag alternatives |
| Media / graphics | `img`, SVG charts, `video`/`audio`, media manifests | `alt`; captions/AD/transcript fields; autoplay; flash rates in source records |
| CSS utilities | global / module CSS | `outline: none` without replacement; color-only state; motion; hex contrast; `min-width` / `nowrap` / spacing locks |

## Cross-route criterion hunt (search the tree)

Use ripgrep / file reads. Record hits even when another route already “looks fine”.

### 2.4.1 Bypass Blocks

A page fails when it **repeats blocks** (site nav, chrome links) **and** offers **no** bypass mechanism.

A bypass mechanism includes any of: a working skip link to a real target id; landmarks that let AT jump past the repeated block (`nav` / `main` / equivalent); a heading structure that serves the same role on that page.

**File as failure when:**
- The page repeats chrome/nav **and** has no skip, no landmarks, and no usable heading bypass (example: a custom toplinks strip with no `nav`/`main`/`h1`–`h6`).
- A skip link exists but its `href` target id is **missing** on that page **and** there is also no landmark/`main` bypass — then the skip is broken *and* bypass is absent.

**Do not file as failure when:**
- Skip is omitted or points at a wrong id, but the page still has a clear landmark set (`header` / `nav` / `main` / `footer` or equivalent) that bypasses the repeated block.
- The page does **not** repeat the site chrome (standalone notice, 404 without shared nav, legacy redirect stub).

Inconsistency of skip across routes is a quality note, not an automatic 2.4.1 failure when landmarks remain.

### 2.4.2 Page Titled

- Same generic `metadata.title` / `<title>` reused on distinct views (shop vs cart vs product).
- Title that does not describe the purpose (`Info`, `Watch`, `Page`, inherited home title on a different language letter).

### 2.4.5 Multiple Ways (AA)

- Pages that are part of the site set but appear in only one discovery path (e.g. linked from one paragraph, absent from primary nav, sitemap, and search index).
- Process steps (wizard step 2) are usually N/A — they are reached in sequence, not as independent locatable pages.

### 3.2.3 Consistent Navigation (AA)

- **Fail** when the **relative order** of repeated navigational components changes across pages in the set (e.g. primary items reversed).
- **Do not fail** only because one page **omits** an item while keeping the remaining items in the same relative order.

### 3.2.4 Consistent Identification (AA)

- The same function labeled differently across pages (Search vs Find; Start application vs Begin for the same destination).

### 3.2.6 Consistent Help (WCAG 2.2 A)

Help mechanisms: human contact details, human contact mechanism, self-help, automated contact (e.g. phone, FAQ/help link, contact link, chat bot).

- **Fail** when mechanisms that appear on multiple pages change their **relative order** with respect to each other / other page content (e.g. bot moves from end to header; FAQ and Contact swap).
- **Do not fail** when a page offers a **subset** of mechanisms but keeps the remaining ones in the same relative order. Absence of a mechanism is not a 3.2.6 failure.

### 1.3.1 / 4.1.2 Structure & name

- Layout `<table>` used for grid/columns **without** `role="presentation"` or without headers when it is a data table (contrast with a clean `role="presentation"` instance elsewhere — do not fail the clean one).
- Fake headings (`div`/`p` + heading class) and radio/checkbox groups without `fieldset`/`legend` or `role="group"` / `radiogroup` name.
- CSS-generated list numbers (`.counter-list` via `content`) instead of `ol` / real list semantics.
- Visible format hints not referenced by `aria-describedby`.
- Div grids that present as tables without table/ARIA table semantics.
- `aria-labelledby` / `aria-describedby` pointing at an **id that does not exist**, or at the **wrong** duplicate id.
- Focusable controls (`a`, `button`, `tabIndex≥0`) inside `aria-hidden="true"`.
- Positive `tabIndex` (`1`, `2`, …) reordering focus.
- Do **not** fail solely for two `h1`s or a skipped heading level — see `judgment-traps.md`.

### 1.3.2 Meaningful Sequence

- Flex/grid `order` (or similar) that visualizes a different sequence than the DOM for steps, warnings above actions, etc.

### 1.3.5 Identify Input Purpose (AA)

- User data fields from the WCAG input-purpose list with missing, `off`, or invalid `autocomplete` tokens (`postalCode` instead of `postal-code`, missing `street-address` / `bday` / `cc-*` / `transaction-amount`).

### 1.1.1 Non-text Content

- Missing `alt` vs `alt=""` on **informative** images (painted product name, chart) — empty decorative pattern elsewhere is not a free pass for those.
- Informative SVG / chart without a text alternative (name alone like `"Chart"` is not enough when values are not elsewhere).
- Character CAPTCHA image without a non-visual alternative (also 3.3.8).

### 1.4.3 / 1.4.11 Contrast (when hex/roles are in source)

- Author hex pairs for normal/large text and UI borders/icons that compute below threshold — file as **code** with the ratio, not only “needs verification”.
- Disabled controls are exempt.

### 1.4.4 / 1.4.10 Resize & Reflow (when CSS locks are in source)

- Author `min-width` on reading UI, `white-space: nowrap` on sentences, fixed column widths that force horizontal scroll at 320 CSS px or 200% text — file as **code** when the lock is visible in CSS.
- Two-dimensional content (data tables, maps, canvases) may be excepted for 1.4.10 — do not auto-fail every scroll container.

### 1.4.5 Images of Text (AA)

- `<img>` (or background graphic) whose essential content is text that could be real text (marketing banner, “Download” glyph as the only name), unless logotype / essential / incidental.

### 1.4.12 / 1.4.13

- Author `!important` locks on line-height / spacing that defeat user text-spacing.
- Hover-only subnav or tips that are not dismissible, hoverable, and persistent (or focus-triggered).

### 2.4.11 Focus Not Obscured (AA, WCAG 2.2)

- Fixed/sticky author chrome whose box fully covers another focusable control (compute from `position` + `bottom`/`top` + sizes in CSS). `scroll-margin` on `main` alone does not clear a control that stays under a fixed FAB.

### 2.5.2 Pointer Cancellation (A)

- Actions that complete on `mousedown` / `pointerdown` without an up-event cancel path (Pay now, delete account, clear draft).

### Forms, auth, status

- Placeholder-only inputs; crossed `htmlFor` / `id` (1.3.1 / 4.1.2 — visible label still present means 3.3.2 may pass); visible label vs `aria-label` mismatch (2.5.3).
- Status text injected into the DOM without `role="status"` / `aria-live` and without moving focus to it (4.1.3).
- Financial / data-deletion submits with no review, confirm, or undo (3.3.4 AA).
- Confirm-email empty while email already entered in the same process (3.3.7) — password confirm may be a security exception; email confirm usually is not.

### Media manifests / players

- Autoplay audio >3s without controls (1.4.2); looping/moving media >5s without pause (2.2.2).
- Missing captions / AD / transcript fields vs kind of media.
- Flash rate recorded in source (`flashes.perSecond` etc.) above the 2.3.1 general threshold — treat the record as evidence.

## Minimum coverage gate (app audit)

Before finishing an app / multi-route review, confirm you can answer **yes** or cite “absent in tree”:

- [ ] Every in-scope route file was opened (or listed absent)
- [ ] Bypass checked **per route** using the 2.4.1 rules above (mechanism present, or N/A — not “skip missing ⇒ fail”)
- [ ] Page titles checked for uniqueness across distinct views
- [ ] Help **relative order** and primary nav **order of repeated items** checked when those criteria are in scope
- [ ] ARIA idrefs: at least one search for `aria-labelledby` / `aria-describedby` vs existing ids
- [ ] Layout tables: hunt `<table>` without data headers / without `role="presentation"`
- [ ] CSS contrast / reflow / fixed-chrome hunts run when utilities exist in tree
- [ ] Judgment traps applied before filing 2.4.1 / 2.5.8 / 3.2.3 / 3.2.6 / 3.3.8 decoys
- [ ] Scoped-pass complement: no criterion left as pass-only-on-N without stating other routes

If any checkbox is unchecked without a written reason (“folder missing” / “searched, none”), the audit is incomplete — keep searching.

## Reporting multi-route hits

Prefer:

```
- Location: app/meetings/live/page.js:5; components/LiveStage.js:17
- Criterion and level: 2.4.1 Bypass Blocks (A)
- Class: code
- Why it fails: repeated toplinks with no skip, no nav/main landmarks, and no headings
- Fix: add landmarks and/or a skip target; do not require skip on every Shell page that already has nav+main
```

Do not collapse the app into “bypass mostly OK” when only some routes have evidence. Do not mass-fail every page that omits a skip link when landmarks remain.
