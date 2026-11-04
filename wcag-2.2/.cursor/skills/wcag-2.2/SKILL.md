---
name: wcag-2.2
description: "Implement and review web code for WCAG 2.1 or WCAG 2.2 accessibility. Defaults come from wcag.config.json (shipped as WCAG 2.2 AA). Use when writing or auditing HTML, CSS, JS, React, or other frontend code for accessibility, or when the user asks for WCAG, a11y, accessibility, a 2.1 vs 2.2 migration, focus management, target size, or related requirements."
paths: "**/*.{html,mdx,astro,tsx,jsx,vue,svelte,css,scss}"
---

# WCAG 2.2 — Accessibility Implementation & Review

Use this skill whenever implementing, reviewing, or fixing web content for WCAG 2.1 or WCAG 2.2.

**Defaults come from `wcag.config.json` in this skill folder** (`standard`: `2.1` or `2.2`; `level`: `A`, `AA`, or `AAA`). Read that file first on every run. The shipped file is WCAG 2.2 AA.
A version or level stated in the chat overrides the file for that request. Do not ask when the file already has a valid pair.
If the file is missing or a value is not one of the allowed tokens, use WCAG 2.2 AA.

**Level filter.** After standard and level are resolved, apply only the required column of that standard's table:

- Level A = column A only.
- Level AA = columns A and AA.
- Level AAA = columns A, AA, and AAA.

A criterion named in this file applies only when its level is included and its version matches the resolved standard. Skip AA bullets at level A. Skip AAA bullets unless the resolved level is AAA.

Do not apply the 9 criteria added in 2.2 when the resolved standard is 2.1. Do not enforce 4.1.1 when the resolved standard is 2.2. When the standard is 2.1, 4.1.1 is Level A; do not file it as a practical failure of modern HTML.

The markdown tables are the working source. Normative recommendations: https://www.w3.org/TR/WCAG21/ and https://www.w3.org/TR/WCAG22/. If a table does not answer one criterion, open that criterion on the matching URL. Do not load a PDF into context.

The parent agent implements fixes in its own context. `/a11y-reviewer` is a separate readonly audit: it returns the report below and does not edit. Do not start it after ordinary generation or editing. Start it when the user asks for an audit or a parent explicitly delegates one.

## Core Workflow

1. **Read defaults** — Load `wcag.config.json` (same folder as this file; in a project, `.cursor/skills/wcag-2.2/wcag.config.json`). Use it unless the user names a different standard or level in the chat.
2. **Apply principles** — Follow POUR: Perceivable, Operable, Understandable, Robust. Prefer semantic HTML over ARIA.
3. **Check the whole column** — Load the table for the resolved standard and cover every criterion required at the resolved level. WCAG 2.2: `references/wcag-2.2-success-criteria-table.md`. WCAG 2.1: `references/wcag-2.1-success-criteria-table.md`. For a migration, report only the delta in `references/wcag-2.1-vs-2.2.md`: added criteria that fall inside the resolved level, and that 4.1.1 no longer applies on the way to 2.2. The six new A/AA criteria (2.4.11, 2.5.7, 2.5.8, 3.2.6, 3.3.7, 3.3.8) are that migration delta. They do not replace the rest of the column. Load `references/new-criteria.md` when one of the nine new criteria is in scope.
4. **Implement with patterns** — Use `references/code-patterns.md`. A 2.2-only pattern applies only when the standard is 2.2 and that criterion's level is included.
5. **App / multi-route reviews** — When the scope is more than a single component, load `references/audit-coverage.md` and run its route/layer sweep and coverage gate before finishing. Do not stop after the first broken widget. A pass on one route does not close the criterion for the app. File failures on in-scope routes outside the evidence. Skip this step for a single component.
6. **Test guidance** — Recommend keyboard-only testing, screen reader spot-checks, contrast tools, and axe-core / Lighthouse where applicable. Tool output is evidence for the report. It is not a conformance claim.
7. **Cite criteria** — When reporting issues or justifying code, reference the exact Success Criterion number and level (for example, "2.5.8 Target Size (Minimum) AA"). Cite only criteria in scope.
8. **Do not claim conformance** — Classify every finding as code, hybrid, or manual. A `pass` needs evidence. Use the report format below. Never state that a page, component, or project meets WCAG.

## Key Rules

Each bullet names its level. Skip it when the resolved level is lower, and skip a 2.2-only bullet when the standard is 2.1.

Both versions:

- Prefer native HTML elements (`<button>`, `<a>`, `<input>`, `<select>`, headings, landmarks) over ARIA-enhanced divs.
- Keyboard operation is 2.1.1, Level A. A visible focus indicator is 2.4.7, Level AA, in both 2.1 and 2.2. At level A, do not require 2.4.7.
- Text contrast is 1.4.3, Level AA: 4.5:1 for normal text, 3:1 for large text (18pt, or 14pt and bold). Non-text contrast is 1.4.11, Level AA: 3:1 for UI component states and meaningful graphics against the adjacent color. At AAA, 1.4.6 raises text contrast to 7:1 / 4.5:1.
- Page has `lang` (3.1.1, A); form controls have labels (3.3.2, A); images have appropriate alt text (1.1.1, A).

WCAG 2.2 only:

- Target size is 2.5.8, Level AA: at least 24×24 CSS pixels, unless a spacing, equivalent, inline, user-agent, or essential exception applies. A link inside a sentence is the inline exception. Do not force 24×24 on it.
- Focus not obscured is 2.4.11, Level AA: the focused component is not entirely hidden by author-created content. `scroll-padding` on the scroll container covers the case where the browser scrolls focus into view. `scroll-margin` goes on the focused control. Neither declaration on `main` satisfies the criterion by itself.
- Dragging is 2.5.7, Level AA: provide a single-pointer alternative unless dragging is essential.
- Accessible authentication is 3.3.8, Level AA: a cognitive function test (remembering a password, a puzzle, a CAPTCHA) needs an alternative, a mechanism, object recognition, or personal content the user provided. Password managers and paste are a mechanism for the password step. Allowing paste does not pass a puzzle step that has no alternative.
- Redundant entry is 3.3.7, Level A. Do not force re-entry of data already provided in the same process.
- Consistent help is 3.2.6, Level A.
- 4.1.1 Parsing is removed in WCAG 2.2. Do not enforce it.
- AAA only: 2.4.12 (no part of the focused component is hidden), 2.4.13 (focus indicator area and contrast between focused and unfocused pixels), 3.3.9 (stricter authentication).

WCAG 2.1 only:

- 4.1.1 Parsing is still Level A. It was removed in 2.2 as obsolete. Do not file it as a practical failure of modern HTML.
- Do not require 2.4.11, 2.4.12, 2.4.13, 2.5.7, 2.5.8, 3.2.6, 3.3.7, 3.3.8, or 3.3.9.

Both versions, AAA only:

- 2.5.5 Target Size (Enhanced): 44×44 CSS px. Do not apply it at A or AA. 2.5.8 (24×24, WCAG 2.2) is the AA target-size criterion.

## When to Load References

- Defaults, every run → `wcag.config.json`
- WCAG 2.2 table (A / AA / AAA) → `references/wcag-2.2-success-criteria-table.md`
- WCAG 2.1 table (A / AA / AAA) → `references/wcag-2.1-success-criteria-table.md`
- Version delta for a migration → `references/wcag-2.1-vs-2.2.md`
- One of the nine new 2.2 criteria → `references/new-criteria.md`
- HTML/CSS/JS patterns → `references/code-patterns.md`
- App or multi-route audit → `references/audit-coverage.md`
- A gap in the tables → the matching criterion at https://www.w3.org/TR/WCAG21/ or https://www.w3.org/TR/WCAG22/

## Common Failures to Avoid

Only when the criterion is in scope.

WCAG 2.2:

- Author-created content, including a sticky bar or overlay, that entirely hides the focused component (2.4.11). `scroll-padding` alone does not close this.
- Pointer targets under 24×24 CSS px with no spacing, equivalent, inline, user-agent, or essential exception (2.5.8). Inline text links are exempt.
- Drag-only interactions with no single-pointer alternative, when dragging is not essential (2.5.7).
- An authentication step that is a cognitive test and has none of the 3.3.8 exceptions. Blocking paste fails the password step. A CAPTCHA or puzzle with no alternative fails even when paste is allowed.
- Multi-step flows that force re-entry of data already provided (3.3.7).
- Help in a different relative place on one page than on the rest of the set (3.2.6).

Both versions, when the criterion is in scope:

- Focus style removed with no visible replacement (2.4.7, AA).
- A focus indicator that identifies a state and has less than 3:1 against the adjacent color (1.4.11, AA). The AAA area and focused/unfocused pixel test is 2.4.13. Do not require 2.4.13 at AA.
- A skip link that is positioned off-screen and has no visible `:focus` state, a skip link on only some routes in the same set, or `href="#main"` with no matching `id` on that page (2.4.1, A).
- `aria-labelledby` or `aria-describedby` pointing at a missing id (4.1.2, A).
- A focusable element inside `aria-hidden="true"` (4.1.2, A).
- A layout `<table>` without `role="presentation"`, or a data table without headers (1.3.1, A).
- A positive `tabIndex` that breaks DOM order (2.4.3, A).
- Treating `alt=""` on a decorative image as proof that an informative image may have an empty alt (1.1.1, A).

Always explain the accessibility rationale when generating or fixing code. State the criterion and its level.

## Audits — what the code can decide

This section is the only copy of the evidence rules and the report format. The `a11y-reviewer` subagent reads them from here and returns the report to the parent. The parent applies fixes.

A source review is not a WCAG conformance audit. Lint, axe, and Lighthouse results are not conformance either. Do not write that a page, component, or project is "WCAG compliant", "meets AA", "passes the audit", or is "fully accessible".

Evidence rules:

- Status `pass` only with evidence: a repository location `path:line`, or a tool result that names the tool and the output file. With no such evidence the status is `needs verification`.
- One passing component does not close the criterion for the page. Record the scope of the evidence (this file or this component). A page-level note still needs every relevant part of that page that is in scope.
- On an app or multi-route review, a pass on N routes does not close the criterion for the app. File failures, or an explicit not applicable, for in-scope routes that lack the same pattern.
- Do not infer browser or assistive-technology behavior from a component name or from a UI library's documentation. Evidence is source in the repository or a tool result from a rendered page.
- Discuss criteria that are in scope for the resolved standard and level. A criterion outside that column is out of scope, not a pass.

Put each criterion you discuss into one class:

- **Code** — the source alone shows a failure or a satisfied check. Examples: `html` without `lang` (3.1.1); an `img` with no `alt` attribute (1.1.1); a form control with no label, `aria-label`, or `aria-labelledby` (1.3.1, 3.3.2, 4.1.2); a button or link with no accessible name (2.4.4, 4.1.2); `outline: none` or `outline: 0` with no replacement `:focus-visible` style (2.4.7, AA); a click handler on a non-interactive element with no keyboard operation (2.1.1); a drag-only control in the same component with no single-pointer alternative (2.5.7, WCAG 2.2 AA); `aria-labelledby` or `aria-describedby` targeting a missing id (4.1.2); focusable content inside `aria-hidden="true"` (4.1.2); a layout `<table>` without `role="presentation"` (1.3.1); a skip link missing on a route in the same set as pages that have one, or a skip target id missing (2.4.1).
- **Hybrid** — the source shows a risk, and pass or fail needs the rendered page, computed style, or more than this snippet. Examples: contrast (1.4.3, 1.4.11); target size and its exceptions (2.5.8); focus hidden under author-created content (2.4.11); whether an existing focus style is visible (2.4.7); heading order across the page (1.3.1); link purpose in context (2.4.4); help in the same place on every page (3.2.6); redundant entry across steps that are not all in view (3.3.7). Whether `alt=""` is correct is hybrid when the image purpose is unclear.
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

If a section has no items, write "None in this scope." Do not invent a pass. A check without `path:line` or a tool result goes under "Needs verification".
For a single component, `### Coverage` may say `n/a — component-scoped`. For an app or multi-route review, an incomplete gate means keep searching. Do not close the report on the largest widget failure alone.
