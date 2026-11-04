# WCAG Audit Coverage — App / Multi-route Sweep

Use this checklist on **app-scoped or multi-page reviews** (not a single-component diff).  
Goal: stop “one good page” audits that miss the same failure on other routes, and catch hidden ARIA / structure bugs.

Load with the success-criteria table for the resolved standard and `code-patterns.md`. Report every hit with `path:line` + criterion number.

## Hard rules (fail the audit if you skip them)

1. **Do not stop after the first broken component.** One Critical finding does not clear the app.
2. **Do not trust filenames or prop names.** `Safe*`, `*ok`, `Decorative*`, `mode="safe"`, `labelled` can still hide failures — read the call site on each route.
3. **One passing page is not an app pass.** A skip link on `/` does not satisfy 2.4.1 for `/checkout`. Record evidence scope; file failures on routes outside that scope.
4. **Same smell, many routes.** If help placement, titles, skip targets, focus utilities, or unlabeled search differ by page, file **each** route (or one finding that lists every `path:line`).
5. **Scoped pass ⇒ check the complement.** When you mark a criterion `pass` with evidence on N pages, list the in-scope pages **without** that pattern. Missing ones are failures (or explicit “not applicable”), not silent omissions.
6. **Do not claim conformance.** Counts and evidence only.

## Mandatory route / layer sweep

Walk **every** layer that exists in scope. Skip a row only if that folder is absent.

| Layer | Typical paths | What to hunt |
|-------|---------------|--------------|
| Document shell | `layout.tsx`, `_document`, root `html` | `lang`; default title; global CSS focus / motion / scroll-padding |
| Pages / routes | `app/**/page.tsx`, `pages/**`, screens | Skip link + matching `#main` / `id`; unique `title`; headings; media tracks |
| Shared chrome | header, footer, nav, help slots | Help order consistency (3.2.6); sticky chrome (2.4.11); landmarks |
| Forms / auth | login, checkout, multi-step | Labels, errors, paste/autocomplete (3.3.8), redundant entry (3.3.7) |
| Interactive widgets | modals, carousels, drag, toolbars | Keyboard, dialog semantics, pause controls, target size, drag alternatives |
| Media / graphics | `img`, SVG charts, `video`/`audio` | `alt` (missing / empty-on-informative); text alternative; captions |
| CSS utilities | global / module CSS | `outline: none` without replacement; color-only state; motion without reduced-motion |

## Cross-route criterion hunt (search the tree)

Use ripgrep / file reads. Record hits even when another route already “looks fine”.

### 2.4.1 Bypass Blocks

- Skip link present on some routes but absent on others in the same app.
- Skip `href="#main"` (or similar) with **no** matching `id` on `<main>` / target on that route.
- Landmarks alone may help; still note missing skip where the rest of the set has one.

### 2.4.2 Page Titled

- Same generic `metadata.title` / `<title>` reused on distinct views (shop vs cart vs product).

### 3.2.6 Consistent Help (WCAG 2.2)

- Help in header on most pages, only in footer (or omitted) on one flow page — relative location changed.

### 1.3.1 / 4.1.2 Structure & name

- Layout `<table>` used for grid/columns **without** `role="presentation"` or without headers when it is a data table (contrast with a clean `role="presentation"` instance elsewhere — do not fail the clean one).
- `aria-labelledby` / `aria-describedby` pointing at an **id that does not exist** in the tree.
- Focusable controls (`a`, `button`, `tabIndex≥0`) inside `aria-hidden="true"`.
- Positive `tabIndex` (`1`, `2`, …) reordering focus.

### 1.1.1 Non-text Content

- Missing `alt` vs `alt=""` on **informative** images (painted product name, chart) — empty decorative pattern elsewhere is not a free pass for those.
- Informative SVG without name / `role="img"` / title.

### Forms & status

- Placeholder-only inputs; crossed `htmlFor` / `id`; visible label vs `aria-label` mismatch (2.5.3).
- Status text injected into the DOM without `role="status"` / `aria-live`.

## Minimum coverage gate (app audit)

Before finishing an app / multi-route review, confirm you can answer **yes** or cite “absent in tree”:

- [ ] Every in-scope route file was opened (or listed absent)
- [ ] Skip / bypass checked **per route** (present + target id, or filed missing)
- [ ] Page titles checked for uniqueness across distinct views
- [ ] Help / primary nav consistency across the page set (esp. checkout vs rest) when 2.2 is in scope
- [ ] ARIA idrefs: at least one search for `aria-labelledby` / `aria-describedby` vs existing ids
- [ ] Layout tables: hunt `<table>` without data headers / without `role="presentation"`
- [ ] Scoped-pass complement: no criterion left as pass-only-on-N without stating other routes

If any checkbox is unchecked without a written reason (“folder missing” / “searched, none”), the audit is incomplete — keep searching.

## Reporting multi-route hits

Prefer:

```
- Location: app/products/page.tsx:12; app/cart/page.tsx:9; app/checkout/page.tsx:8
- Criterion and level: 2.4.1 Bypass Blocks (A)
- Class: code
- Why it fails: skip link exists on home/account/help but these routes have no skip and/or no id="main"
- Fix: add the same skip + matching main id on every page in the set
```

Do not collapse the app into “bypass mostly OK” when only some routes have evidence.
