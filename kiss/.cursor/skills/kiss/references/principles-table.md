# KISS Dimensions Checklist

Working checklist for generation and review. Examples: TypeScript. Adapt syntax per language.

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

When scope is an app or package, also satisfy `audit-coverage.md` (layer sweep + minimum coverage gate). Pass/fail signals above apply **per file**; package health needs breadth, not only the worst module.

## Relationship to SOLID / YAGNI

| Concern | Guidance |
|---------|----------|
| Unused interface with one never-swapped impl | Flag under **abstraction** (and SOLID pragmatic “no ceremony”) |
| Port that already isolates real infra churn | **Not** a KISS fail — keep it |
| God class “to keep one file simple” | **Not** KISS — flag as false simplicity; split by change axis |
| Copy-paste of **identical** logic once | Prefer one helper (clarity) |
| Copy-paste of **divergent** logic forced into one generic | Prefer two clear functions (clarity + yagni) |

## Config interaction

- Only audit dimensions listed in `kiss.config.json` → `dimensions`.
- At `pragmatic`, prefer Medium (or skip) for thin wrappers that clearly document a boundary the team already uses.
- At `strict`, unjustified new abstractions, options, and deps in scope are High.
