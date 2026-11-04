# WCAG 2.1 vs WCAG 2.2

Use this file when the user chooses a standard, compares versions, or migrates from 2.1 to 2.2 (or the other way).

WCAG 2.2 is backwards-compatible with 2.1. Every 2.1 criterion except 4.1.1 is still in 2.2, at the same level. 2.4.7 Focus Visible is AA in both.

| | WCAG 2.1 | WCAG 2.2 |
|--|----------|----------|
| Success criteria | 78 | 86 |
| Level A | 30 | 31 |
| Level AA (A + AA) | 50 | 55 |
| Level AAA (all) | 78 | 86 |
| Table | `references/wcag-2.1-success-criteria-table.md` | `references/wcag-2.2-success-criteria-table.md` |
| Normative URL | https://www.w3.org/TR/WCAG21/ | https://www.w3.org/TR/WCAG22/ |

## Removed in 2.2

| Criterion | Level in 2.1 | What to do |
|-----------|--------------|------------|
| **4.1.1** Parsing | A | Do not enforce it for a 2.2 target. It was removed as obsolete. For a 2.1 target, do not file it as a practical failure of modern HTML. |

## Added in 2.2

Do not apply these when the target is WCAG 2.1. Normative paraphrases: `references/new-criteria.md`.

| Criterion | Level | In short |
|-----------|-------|----------|
| **2.4.11** Focus Not Obscured (Minimum) | AA | Focused component is not entirely hidden |
| **2.4.12** Focus Not Obscured (Enhanced) | AAA | No part of the focused component is hidden |
| **2.4.13** Focus Appearance | AAA | Focus indicator at least 2 CSS px, contrast at least 3:1 |
| **2.5.7** Dragging Movements | AA | Single-pointer alternative for dragging |
| **2.5.8** Target Size (Minimum) | AA | At least 24×24 CSS px, or a spacing or inline exception |
| **3.2.6** Consistent Help | A | Help mechanisms stay in the same relative order |
| **3.3.7** Redundant Entry | A | Do not force re-entry of data already provided in the same process |
| **3.3.8** Accessible Authentication (Minimum) | AA | No cognitive test without an alternative; allow paste and password managers |
| **3.3.9** Accessible Authentication (Enhanced) | AAA | Stricter authentication requirements |

Six of these are A or AA (2.4.11, 2.5.7, 2.5.8, 3.2.6, 3.3.7, 3.3.8). That is why 2.2 AA is 55 criteria and 2.1 AA is 50: drop 4.1.1, add those six.

## How to report a migration

List only the delta. Do not restate the shared criteria as new work.

- **2.1 → 2.2:** criteria from “Added in 2.2” that the code does not yet meet, at the requested level. Say that 4.1.1 no longer applies.
- **2.2 → 2.1:** say which 2.2-only criteria are out of scope. Do not call the removal of those criteria a fix.

A migration note is not a conformance claim. Use the report format in `SKILL.md`.
