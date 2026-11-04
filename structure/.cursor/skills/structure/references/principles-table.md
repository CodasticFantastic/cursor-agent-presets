# Structure Dimensions Checklist

Working source for what each dimension means, the pass/fail signals, and severity. The skill points here. Do not copy this table into `SKILL.md`, the rule, or `structure-reviewer`.

Level names, the fallback, and which dimensions are in scope live in `SKILL.md`. The section below only changes severity. Examples: TypeScript. Adapt syntax to the file. A new language does not need a second table.

**Guarded DRY:** Prefer as little justified duplication as the shared change reason allows. Never optimize for "as DRY as possible". Accidental similarity is not a fail.

| Id | Name | Question to ask | Pass signal | Fail signal |
|----|------|-----------------|-------------|-------------|
| **slap** | Single Level of Abstraction | Are the steps in this function at one grain? | Body orchestrates named peers, or stays entirely at one low/high grain | One function interleaves high-level policy with low-level I/O, parsing, SQL strings, HTML, or bit/byte work |
| **dry** | Don't Repeat Yourself (guarded) | Did we search first, and do near-copies share a change reason? | New path reuses or extends an existing behavior; twins that must diverge stay separate | Near-identical helpers/policies (often 3+) that should change together; a new near-copy beside an existing implementation of the same behavior |

## Severity guidance

| Severity | Typical cases |
|----------|----------------|
| Critical | Domain money/auth/state policy copied in many places with drift; a single function mixes orchestration with raw persistence and presentation so every change is high-risk |
| High | Clear twin policies or helpers (≈3+ sites or two large twins) with a shared change reason; a service method that both decides and does low-level transport/format work |
| Medium | Two short near-copies that could parameterize; a mild mix of levels in one function. At `pragmatic`, prefer Medium or skip for lookalike mappers and unrelated handlers |

## Package audit reminder

When the scope is more than one file, or any package/app scope, also satisfy `audit-coverage.md` (layer sweep + minimum coverage gate). Pass/fail signals above apply **per file**; package health needs breadth, not only the longest function.

## Relationship to SOLID / KISS / coupling

| Concern | Guidance |
|---------|----------|
| God class / many change axes | **Not** structure alone — SOLID **S** (slap only if levels mix in the cited body) |
| Missing port / `new Concrete` in policy | **Not** structure — SOLID **D** |
| Speculative factory / unused options / extract for someday | **Not** dry — KISS **yagni** / **abstraction** / **surface** |
| Nested `if`s that stay one abstraction level | **Not** slap — KISS **flow** |
| Train wreck / ask-then-decide | **Not** structure — coupling **lod** / **tda** |
| Two similar DTO maps or HTTP handlers with different contracts | **Not** a dry fail at `pragmatic` |
| Shared util that is a junk drawer | Prefer SOLID **S** / KISS clarity; dry does not bless a fat `utils` dump |

## Severity by level

Scope (which dimensions to audit) is owned by `SKILL.md`. This list only changes how hard a signal is filed.

- At `pragmatic`, prefer Medium (or skip) for short lookalike mappers, one-off edge adapters, and two-site copies without a clear shared change reason. Require named twin paths for High+.
- At `strict`, a mixed-level domain/service body or a near-duplicate pair with a shared change reason in scope is High.
