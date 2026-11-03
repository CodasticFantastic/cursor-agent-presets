---
name: wcag-2.2
description: "Implement and review web code for WCAG 2.1 or WCAG 2.2 accessibility. Defaults come from wcag.config.json (shipped as WCAG 2.2 AA). Use when writing or auditing HTML, CSS, JS, React, or other frontend code for accessibility, or when the user asks for WCAG, a11y, accessibility, a 2.1 vs 2.2 migration, focus management, target size, or related requirements."
---

# WCAG 2.2 — Accessibility Implementation & Review

Use this skill whenever implementing, reviewing, or fixing web content for WCAG 2.1 or WCAG 2.2 conformance.

**Defaults come from `wcag.config.json` in this skill folder** (`standard`: `2.1` or `2.2`; `level`: `A`, `AA`, or `AAA`). Read that file first on every run. The shipped file is WCAG 2.2 AA.  
A version or level the user states in the chat overrides the file for that request. Do not ask when the file already has a valid pair.  
If the file is missing or a value is not one of the allowed tokens, use WCAG 2.2 AA.  
Apply AAA criteria when the resolved level is AAA.  
Do not apply the 9 criteria added in 2.2 when the resolved standard is 2.1. Do not enforce 4.1.1 when the resolved standard is 2.2.

The markdown tables are the working source. Official recommendations: https://www.w3.org/TR/WCAG21/ and https://www.w3.org/TR/WCAG22/. Fallback PDFs, loaded only when a table does not answer the question: `assets/WCAG_2.1.pdf` and `assets/WCAG_2.2.pdf`. Do not read an entire PDF into context.

## Core Workflow

1. **Read defaults** — Load `wcag.config.json` (same folder as this file; in a project, `.cursor/skills/wcag-2.2/wcag.config.json`). Use it unless the user names a different standard or level in the chat.
2. **Apply principles** — Follow POUR: Perceivable, Operable, Understandable, Robust. Prefer semantic HTML over ARIA.
3. **Respect the version** — For WCAG 2.2, prioritize the 6 new A/AA criteria (`references/new-criteria.md`). For WCAG 2.1, skip every row in “Added in 2.2” in `references/wcag-2.1-vs-2.2.md`. For a migration, report only that delta.
4. **Implement with patterns** — Use the concrete code patterns in `references/code-patterns.md`. Patterns for 2.4.11, 2.5.7, 2.5.8, 3.2.6, 3.3.7, and 3.3.8 apply only when the target is WCAG 2.2.
5. **Checklists** — WCAG 2.2: `references/wcag-2.2-success-criteria-table.md`. WCAG 2.1: `references/wcag-2.1-success-criteria-table.md`. Differences: `references/wcag-2.1-vs-2.2.md`.
6. **App / multi-route reviews** — If scope is more than a single component or tiny diff, also load `references/audit-coverage.md` and run its **route/layer sweep** + **minimum coverage gate** before finishing. Do not stop after the first broken widget. A pass on one route does not close the criterion for the app — file failures on routes outside the evidence scope.
7. **Test guidance** — Recommend keyboard-only testing, screen reader spot-checks, contrast tools, and axe-core / Lighthouse where applicable.
8. **Cite criteria** — When reporting issues or justifying code, reference the exact Success Criterion number and level (e.g., “2.5.8 Target Size (Minimum) AA”).
9. **Do not claim conformance** — Classify every finding as code, hybrid, or manual. A `pass` needs evidence. Use the report format below. Never state that a page, component, or project meets WCAG.

## Key Rules (both versions)

- Prefer native HTML elements (`<button>`, `<a>`, `<input>`, `<select>`, headings, landmarks) over ARIA-enhanced divs.
- Every interactive element must be keyboard-operable and have a visible focus indicator (2.4.7 is AA in both 2.1 and 2.2).
- Color contrast: 4.5:1 for normal text, 3:1 for large text and UI components (1.4.3, 1.4.11).
- Page has `lang` attribute; form controls have labels; images have appropriate alt text.

## Extra rules only for WCAG 2.2

- Target size: minimum 24×24 CSS pixels for pointer targets, unless the spacing or inline exception applies (2.5.8). A link inside a sentence is exempt.
- Focus must not be entirely obscured by sticky headers/footers/banners (2.4.11).
- Provide single-pointer alternatives for dragging (2.5.7).
- Authentication must not require cognitive function tests without alternatives (3.3.8); support password managers and paste.
- Do not force redundant data entry in multi-step processes (3.3.7).
- Help mechanisms must be consistently located (3.2.6).
- 4.1.1 Parsing is removed in WCAG 2.2 — do not enforce it.

## WCAG 2.1 only

- 4.1.1 Parsing is still Level A. It was removed in 2.2 as obsolete. Do not file it as a practical failure of modern HTML.
- Do not require 2.4.11, 2.4.12, 2.4.13, 2.5.7, 2.5.8, 3.2.6, 3.3.7, 3.3.8, or 3.3.9.

## When to Load References

- Defaults, every run → `wcag.config.json`
- WCAG 2.2 table (A / AA / AAA) → `references/wcag-2.2-success-criteria-table.md`
- WCAG 2.1 table (A / AA / AAA) → `references/wcag-2.1-success-criteria-table.md`
- Version delta for a choice or a migration → `references/wcag-2.1-vs-2.2.md`
- New 2.2 criteria normative text → `references/new-criteria.md`
- Ready-to-use HTML/CSS/JS patterns → `references/code-patterns.md`
- App/multi-route audits (mandatory) → `references/audit-coverage.md`
- Fallback PDFs (only for a gap in the tables) → `assets/WCAG_2.1.pdf`, `assets/WCAG_2.2.pdf`

## Common Failures to Avoid

WCAG 2.2 only:

- Sticky headers that completely hide focused elements (2.4.11, F110)
- Buttons or control-like links smaller than 24×24 CSS px without the spacing exception (2.5.8; inline text links are exempt)
- Drag-only interactions with no click/tap alternative (2.5.7)
- Login forms that block password managers or paste (3.3.8)
- Multi-step forms that force re-entry of previously entered data (3.3.7)
- Help in a different relative place on one flow page than on the rest of the set (3.2.6)

Both versions:

- Focus indicators with insufficient contrast or size
- Missing skip links or landmarks for keyboard users — including skip on some routes only, or `href="#main"` with no matching `id` on that page (2.4.1)
- `aria-labelledby` / `aria-describedby` pointing at a missing id (4.1.2)
- Focusable elements inside `aria-hidden="true"` (4.1.2 / 2.4.3)
- Layout `<table>` without `role="presentation"` (or without proper headers if it is a data table) (1.3.1)
- Positive `tabIndex` values that break DOM order (2.4.3)
- Treating a decorative `alt=""` pattern as proof that empty alt on informative product/chart images is OK (1.1.1)

Always explain the accessibility rationale when generating or fixing code.

## Audits — what the code can decide

A source review is not a WCAG conformance audit. Lint, axe, and Lighthouse results are not conformance either. Do not write that a page, component, or project is “WCAG compliant”, “meets AA”, “passes the audit”, or is “fully accessible”.

Evidence rules:

- Status `pass` only with evidence: a repository location `path:line`, or a tool result that names the tool and the output file. With no such evidence the status is `needs verification`.
- One passing component does not close the criterion for the page. Record the scope of the evidence (this file or this component). A page-level note still needs every relevant part of that page that is in scope.
- On app / multi-route scope: a pass on N routes does not close the criterion for the app. File failures (or “not applicable”) for in-scope routes that lack the same pattern.
- Do not infer browser or assistive-technology behavior from a component name or from a UI library’s documentation. Evidence is source in the repository or a tool result from a rendered page.

Put each criterion you discuss into one class:

- **Code** — the source alone shows a failure or a satisfied check. Examples: `html` without `lang` (3.1.1); an `img` with no `alt` attribute (1.1.1); a form control with no label, `aria-label`, or `aria-labelledby` (1.3.1, 3.3.2, 4.1.2); a button or link with no accessible name (2.4.4, 4.1.2); `outline: none` or `outline: 0` with no replacement `:focus-visible` style (2.4.7); a click handler on a non-interactive element with no keyboard operation (2.1.1); a drag-only control in the same component with no single-pointer alternative (2.5.7); `aria-labelledby` / `aria-describedby` targeting a missing id (4.1.2); focusable content inside `aria-hidden="true"` (4.1.2); layout `<table>` without `role="presentation"` (1.3.1); skip link missing on a route that is in the same set as pages that have one, or skip target id missing (2.4.1).
- **Hybrid** — the source shows a risk, and pass or fail needs the rendered page, computed style, or more than this snippet. Examples: contrast (1.4.3, 1.4.11); target size and the inline or spacing exception (2.5.8); focus hidden under sticky UI (2.4.11); whether an existing focus style is visible (2.4.7); heading order across the page (1.3.1); link purpose in context (2.4.4); help in the same place on every page (3.2.6); redundant entry across steps that are not all in view (3.3.7). Whether `alt=""` is correct is hybrid when the image purpose is unclear.
- **Manual** — the source cannot settle it. Examples: screen reader announcement and reading order; a full keyboard walk, including traps that appear only at runtime (2.1.2); whether dragging is essential (2.5.7 exception); accuracy of captions or transcripts (1.2.x); an authentication alternative that is outside this component (3.3.8); flashing content (2.3.1); reflow and 200% zoom (1.4.4, 1.4.10).

### Report format

Use this structure for every review. The summary counts findings. It does not give the page a pass or fail.

```
## Review result
Scope: <files or component>
Standard: <from wcag.config.json, unless the user overrode it>
Level: <from wcag.config.json, unless the user overrode it>
Verdict: this is not a conformance claim.

### Coverage (app / multi-route audits)
- Routes / layers swept: <layout | pages | chrome | forms | widgets | media | css>
- Gate: pass | incomplete — <missing hunt or “folder absent”>

### Failures visible in code
- Location: path:line
- Criterion and level:
- Class: code
- Severity: Critical | High | Medium
- Why it fails:
- Fix:

### Satisfied checks
- Criterion and level:
- Status: pass
- Evidence: path:line  |  <tool name> + <result file>
- Scope: this file or this component. This pass does not close the criterion for the page or app.

### Needs verification
- Criterion and level:
- Status: needs verification
- Class: hybrid | manual
- What is missing: no path:line and no tool result, or the rendered page was not tested
```

If a section has no items, write “None in this scope.” Do not invent a pass. A check without `path:line` or a tool result goes under “Needs verification”.  
For single-component diffs, `### Coverage` may say `n/a — component-scoped`. For app / multi-route scope, incomplete gate means keep searching — do not close with only the largest widget failure.