# WCAG Judgment Traps — Do Not File These as Failures

This file is the only copy of common **false-positive** traps for WCAG 2.1 / 2.2 audits. Load it on every audit (with the success-criteria table). Apply a trap only when the criterion is in scope for the resolved level.

Normative detail stays in the W3C Understanding docs. These lines stop decoy filings.

## Always (both 2.1 and 2.2)

| Trap | Do **not** file | Instead |
|------|-----------------|---------|
| Duplicate `id` with no accessibility relationship broken | 4.1.1 (removed in 2.2) or bare “invalid HTML” | File 1.3.1 / 4.1.2 only if an `aria-*` / `for` / label points at the wrong node |
| Two `h1`s on one view | 1.3.1 automatically | Fail fake headings (`p.h2`, `div` as heading); heading *skip* alone is not a failure |
| Skipped heading level (h1→h3) | 1.3.1 / 2.4.6 automatically | Fail missing section headings when structure is needed; skip alone is OK |
| `outline: none` on unfocused rule with a strong `:focus` / `:focus-visible` replacement | 2.4.7 | Fail only when focus has no visible indicator (e.g. outline removed and background shift ≈ 1:1) |
| Disabled control low contrast | 1.4.3 / 1.4.11 | Exempt when truly `disabled` / `aria-disabled` and not the only path |
| Placeholder color the author did not set | 1.4.3 | Ignore UA placeholder chrome unless authored |
| Link purpose clear from the **same sentence/paragraph** (“…click here”, “…Begin”) | 2.4.4 A | At AAA, 2.4.9 may still fail link-text-alone |
| `aria-labelledby` giving a clear name while visible text differs | 2.4.4 alone | Often a **2.5.3** Label in Name failure instead |
| Redundant `role="navigation"` on `<nav>` | 4.1.2 | Harmless |
| Layout `<table role="presentation">` | 1.3.1 | Correct pattern for layout tables |
| Data table with captions/`th` | 1.3.1 | Pass |
| Decorative image `alt=""` / flourish | 1.1.1 | Pass when truly decorative |
| Logo with text alternative | 1.1.1 / 1.4.5 | Logotype exception for images of text |
| Native `<input type="range">` / color / unchecked browser chrome size | 2.1.1 / 2.5.8 | UA control exception when not restyled undersized |
| Carousel / media with working pause or native `controls` | 2.2.2 | Pass for that widget; does not clear a separate ticker |
| Live auction / real-time clock essential to the activity | 2.2.1 / 2.2.2 timing | Essential / real-time exception |
| Emergency alert that cannot be dismissed | 2.2.4 interruptions | Emergency exception |
| `target="_blank"` after an explicit link activation | 3.2.2 / 3.2.5 | User-initiated |
| Select that only reorders in-page list without navigation | 3.2.2 | Not a context change |
| Process step 2 reached only from step 1 | 2.4.5 | Usually N/A for multiple ways |

## Keyboard & pointer

| Trap | Do **not** file | Instead |
|------|-----------------|---------|
| Signature / path-based canvas that requires a pointer path | **2.1.1** | Path-based exception at A; at AAA file **2.1.3** if in scope |
| Dragging with a single-pointer alternative on the same UI | 2.5.7 | Pass |
| Undersized control with an **equivalent** control ≥24×24 (AA) or ≥44×44 (AAA 2.5.5) on the same page | 2.5.8 / 2.5.5 | Equivalent exception |
| Undersized targets whose 24px-diameter circles do not intersect | 2.5.8 | Spacing exception (AA only — does **not** clear 2.5.5) |
| Inline link in a sentence | 2.5.8 | Inline exception |
| Focus trap inside a dialog that can be closed (Escape / Cancel) | 2.1.2 | Pass; true trap = no exit |

## Auth & forms (esp. WCAG 2.2)

| Trap | Do **not** file | Instead |
|------|-----------------|---------|
| Password field when paste + password manager work | 3.3.8 / 3.3.9 | Mechanism exception |
| Object-recognition challenge (pick the kayaks / objects) at **AA** | **3.3.8** | Allowed exception at AA; still check **1.1.1** if images lack a non-visual alternative; at AAA file **3.3.9** |
| Character / transcription CAPTCHA | — | **Does** fail 3.3.8 (and 1.1.1) unless a non-cognitive alternative exists |
| “Confirm password” re-entry | 3.3.7 | Security exception |
| “Confirm email” empty while email already entered in-process | — | Usually **does** fail 3.3.7 (not a security exception) |
| New address fields after user marks prior address invalid | 3.3.7 | Information no longer valid |
| Visible label present but `htmlFor`/`id` mismatch | **3.3.2** alone | File **1.3.1** / **4.1.2**; 3.3.2 may still pass if the label text is visible |
| Error text that names the field but gives no format hint | **3.3.1** | Identification may pass; missing suggestion is **3.3.3** |
| “Email or password is incorrect” | 3.3.3 | Security; still may need 4.1.3 if no live region / focus |

## Consistent help & navigation (WCAG 2.2 / AA)

| Trap | Do **not** file | Instead |
|------|-----------------|---------|
| Page offers fewer help mechanisms but keeps remaining order | **3.2.6** | Subset is allowed |
| Primary nav omits an item but keeps relative order of the rest | **3.2.3** | Omission ≠ reordering |
| Primary nav items reversed or reordered | — | **Does** fail 3.2.3 |
| Help mechanisms swap relative order (bot before phone, Contact before FAQ, etc.) | — | **Does** fail 3.2.6 |

## Bypass (2.4.1)

| Trap | Do **not** file | Instead |
|------|-----------------|---------|
| Missing skip link while `header` / `nav` / `main` (or equivalent) exist | **2.4.1** | Landmarks are a bypass mechanism |
| Skip `href` mismatch while landmarks still bypass repeated blocks | **2.4.1** alone | Broken skip is a defect to fix, but not automatic 2.4.1 if landmarks work |
| Page without repeated chrome (standalone letter, bare 404, stub) | 2.4.1 | N/A — nothing to bypass |
| Repeated custom link strip **without** skip, landmarks, or headings | — | **Does** fail 2.4.1 |

## Media & motion

| Trap | Do **not** file | Instead |
|------|-----------------|---------|
| Autoplay audio ≤3 seconds, not looping | 1.4.2 | Under threshold |
| Decorative muted video ≤5 seconds, not looping | 2.2.2 | Under threshold |
| Decorative muted looping video >5s without pause | — | **Does** fail 2.2.2 (not 1.2.1) |
| Prerecorded sync media missing captions | 1.2.1 | Use 1.2.2+ |
| Full text alternative present | 1.2.5 | Satisfies 1.2.3 A, **not** 1.2.5 AA |
| Tiny CSS blink below general flash area threshold | 2.3.1 | May still fail AAA 2.3.2; check area for A |
| Author flash rate in a media manifest / technical record | “cannot know without binary” | Treat the record as evidence for 2.3.1 |

## Language

| Trap | Do **not** file | Instead |
|------|-----------------|---------|
| Whole page in language A with `lang=A` | 3.1.1 | Pass |
| One route fully in another language under root `lang` | — | **Does** fail 3.1.1 for that page |
| Passage with correct `lang` on the element | 3.1.2 | Pass |
| Borrowed word in surrounding language (“café”) | 3.1.2 | Usually OK |

## How to use

1. Find a suspicious pattern.
2. Check this table for the criterion you are about to cite.
3. If the row says do not file — skip or reclassify.
4. If unsure, prefer `needs verification` over a hard fail **only** when evidence is truly missing — not when the trap already resolves it.
