# Merge

This file is the only copy of how lane reports become one review. Add a collision here, not in `SKILL.md`, the rule, or `code-reviewer`.

Each lane report keeps its own evidence rules. This file only picks the primary family when two lanes name the same symbol.

## One symbol, one primary family

The primary family is the lane that owns the abuse or the broken rule. A second lane is kept only when that lane's own skill says "also counts". Do not stamp both by default.

| If two lanes name the same symbol | Primary | Leave the other as |
|------------------------------------|---------|--------------------|
| Missing owner check, SQL or HTML built from input, a secret, a caller-chosen URL, a check that allows on error | `security` | Not Nest, not React |
| Domain policy, SQL, or mail inside a Nest controller method | `nest` | SOLID only when the same policy also lives in a provider that is not the HTTP method |
| A provider that mixes two domain jobs and never handles HTTP | `solid` | Not Nest |
| `"use client"` on a module a Server Component imports, a hook in a condition, a list key | `react` | Not WCAG |
| Missing label, contrast, or focus | `wcag-2.2` | Not React, not security |
| Untrusted HTML in an HTML sink | `security` | Not React, not WCAG |
| A train wreck or ask-then-decide | `coupling` | Structure only when a second copy of that body exists |
| Near-copies that share a change reason | `structure` | Not KISS |
| Speculative options, unused abstraction | `kiss` | Not structure |
| A test that does not lock the new behavior | `tdd` | Not a product-code lane |

A finding with no `path:line` does not enter the merged report. It stays in that lane's "needs verification" section.

## Deduping

The same `path` and symbol reported twice in one family counts once. Keep the clearer `path:line`.

A chunk that was not reviewed is `incomplete`. Do not describe that chunk as clean.

## Synthesis

After every chunk has a lane report, do one pass. Do not start the lanes again.

- A symbol defined or changed in chunk A and called or copied in chunk B is one finding if either side shows the break. Name both paths.
- Sibling paths written on a split set count as chunk B even when their bodies were not loaded. Search those paths. Do not read the whole diff.
- If the two sides disagree and the source does not settle it, put the pair under "Needs verification". Do not drop it.

## What the merged report does not say

Do not write that the branch is "fully reviewed", "secure", "accessible", or compliant with any preset. The verdict is a review of the chunks that actually ran.
