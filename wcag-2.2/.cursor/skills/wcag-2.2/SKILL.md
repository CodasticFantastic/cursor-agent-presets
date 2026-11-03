---
name: wcag-2.2
description: "Implement and review web code for WCAG 2.2 accessibility compliance (Level AA by default). Use when writing or auditing HTML, CSS, JS, React, or other frontend code for accessibility, or when the user asks for WCAG, a11y, accessibility, focus management, target size, or related requirements."
---

# WCAG 2.2 — Accessibility Implementation & Review

Use this skill whenever implementing, reviewing, or fixing web content for WCAG 2.2 conformance.

**Default target is Level AA** (all A + AA criteria).  
Only apply AAA criteria when the user explicitly requests Level AAA.  
WCAG 2.2 is backwards-compatible with 2.1 and 2.0; the main additions are 9 new Success Criteria (6 at A/AA).

Source of truth: the official W3C Recommendation (user-provided `WCAG_2.2.pdf` or https://www.w3.org/TR/WCAG22/).

## Core Workflow

1. **Identify scope** — Ask for the target conformance level (A / AA / AAA) if not stated. Default to AA.
2. **Apply principles** — Follow POUR: Perceivable, Operable, Understandable, Robust. Prefer semantic HTML over ARIA.
3. **Prioritize new 2.2 criteria** — Especially the 6 A/AA additions (see `references/new-criteria.md`).
4. **Implement with patterns** — Use the concrete code patterns in `references/code-patterns.md`.
5. **Checklists** — For audits, use the single table in `references/wcag-2.2-success-criteria-table.md`.
6. **Test guidance** — Recommend keyboard-only testing, screen reader spot-checks, contrast tools, and axe-core / Lighthouse where applicable.
7. **Cite criteria** — When reporting issues or justifying code, reference the exact Success Criterion number and level (e.g., “2.5.8 Target Size (Minimum) AA”).

## Key Rules (Always Apply)

- Prefer native HTML elements (`<button>`, `<a>`, `<input>`, `<select>`, headings, landmarks) over ARIA-enhanced divs.
- Every interactive element must be keyboard-operable and have a visible focus indicator.
- Color contrast: 4.5:1 for normal text, 3:1 for large text and UI components (1.4.3, 1.4.11).
- Target size: minimum 24×24 CSS pixels (or spacing exception) for pointer targets (2.5.8).
- Focus must not be entirely obscured by sticky headers/footers/banners (2.4.11).
- Provide single-pointer alternatives for dragging (2.5.7).
- Authentication must not require cognitive function tests without alternatives (3.3.8); support password managers and paste.
- Do not force redundant data entry in multi-step processes (3.3.7).
- Help mechanisms must be consistently located (3.2.6).
- Page has `lang` attribute; form controls have labels; images have appropriate alt text.
- 4.1.1 Parsing is obsolete/removed in WCAG 2.2 — do not enforce it.

## When to Load References

- **Main table of all criteria A / AA / AAA** (single file) → `references/wcag-2.2-success-criteria-table.md`  
  (always use as the primary source — agent sees the level of every criterion immediately)
- New 2.2 criteria normative text → `references/new-criteria.md`
- Ready-to-use HTML/CSS/JS patterns → `references/code-patterns.md`

## Common Failures to Avoid

- Sticky headers that completely hide focused elements (F110)
- Buttons/links smaller than 24×24 CSS px without spacing
- Drag-only interactions with no click/tap alternative
- Login forms that block password managers or paste
- Multi-step forms that force re-entry of previously entered data
- Focus indicators with insufficient contrast or size
- Missing skip links or landmarks for keyboard users

Always explain the accessibility rationale when generating or fixing code.