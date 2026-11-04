# KISS Dimensions Checklist

Working source for what each dimension means, the pass/fail signals, and severity. The skill points here. Do not copy this table into `SKILL.md`, the rule, or `kiss-reviewer`.

Level names, the fallback, and which dimensions are in scope live in `SKILL.md`. The section below only changes severity. Examples: TypeScript. Adapt syntax to the file. A new language does not need a second table.

| Id | Name | Question to ask | Pass signal | Fail signal |
|----|------|-----------------|-------------|-------------|
| **clarity** | Clarity over cleverness | Can a teammate understand this in one pass? | Explicit names, standard patterns, obvious control flow | Dense one-liners, cryptic abbreviations, custom DSL, “magic” |
| **yagni** | You Aren't Gonna Need It | Is this needed for a current, known requirement? | Only paths and options exercised by real requirements | Unused modes/providers/flags; “for later” stubs; speculative branches |
| **abstraction** | Delayed abstraction | Is there a second real use case for this layer? | Concrete until pain; extract on second need | Interface+factory+plugin for one impl; generic framework for one feature |
| **surface** | Small surface area | Can we drop parameters, exports, or config without losing behavior? | Narrow public API; dead code gone | Mega options objects; unused exports; long param lists mostly optional |
| **deps** | Justified dependencies | Does this package pull its weight vs stdlib / existing stack? | Few deps; each has a clear job | New package for a short helper; overlapping libs; heavy framework for a script |
| **flow** | Shallow flow | Is the happy path straight and nesting low? | Guard clauses, early returns, little pure forwarding | Pyramid of `if/else`; wrappers that only re-export; needless indirection |

## Severity guidance

| Severity | Typical cases |
|----------|----------------|
| Critical | Speculative plugin/framework blocking understanding; god options object with many dead paths; dependency that duplicates stdlib and obscures control |
| High | Premature interface/factory for a single concrete; deep nesting (≥4) with no domain need; unused config modes still wired through the stack |
| Medium | Mild naming cleverness; small unused helper; one thin forwarder that might consolidate; tiny stable switch listed on package audits |

## Package audit reminder

When the scope is more than one file, or any package/app scope, also satisfy `audit-coverage.md` (layer sweep + minimum coverage gate). Pass/fail signals above apply **per file**; package health needs breadth, not only the worst module.

## Relationship to SOLID / YAGNI

| Concern | Guidance |
|---------|----------|
| Unused interface with one never-swapped impl | Flag under **abstraction** (and SOLID pragmatic “no ceremony”) |
| Port that already isolates real infra churn | **Not** a KISS fail — keep it |
| God class “to keep one file simple” | **Not** KISS — flag as false simplicity; split by change axis |
| Copy-paste of **identical** logic once | Prefer one helper (clarity) |
| Copy-paste of **divergent** logic forced into one generic | Prefer two clear functions (clarity + yagni) |

## Severity by level

Scope (which dimensions to audit) is owned by `SKILL.md`. This list only changes how hard a signal is filed.

- At `pragmatic`, prefer Medium (or skip) for thin wrappers that clearly document a boundary the team already uses.
- At `strict`, unjustified new abstractions, options, and deps in scope are High.
