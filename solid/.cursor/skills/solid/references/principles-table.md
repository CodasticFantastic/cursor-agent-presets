# SOLID Principles Checklist

Working source for what each letter means, the pass/fail signals, severity, and the paradigm mapping. The skill points here. Do not copy this table into `SKILL.md`, the rule, or `solid-reviewer`.

Level names, the fallback, and which letters are in scope live in `SKILL.md`. The section below only changes severity. Examples: TypeScript. Adapt syntax to the file. A new language does not need a second table.

| Letter | Name | Question to ask | Pass signal | Fail signal |
|--------|------|-----------------|-------------|-------------|
| **S** | Single Responsibility | Does this unit have one reason to change? | Persistence, transport, and domain policy live in separate units when they change independently | God class/hook/store/form; util that also emails/charges/renders; repo with HTML/mail/pay; DTO mixing secrets+UI |
| **O** | Open/Closed | Can I add behavior without editing a closed core **on a real extension axis**? | New behavior via new type/strategy/plugin; closed module stays untouched; closed lifecycle/spec adapters may stay switches | Growing `switch`/`if` on a product axis (kind/channel/plugin/flag family) in a shared module — especially a closed twin beside an open registry; `*-defs/` that don’t open the real switch. Not every tax/state `if` inside a god handler (prefer S) |
| **L** | Liskov Substitution | Can every subtype replace its base without surprising callers? | Subtype honors pre/postconditions and invariants; no “partial” overrides; honest early-refuse that keeps base postconditions | Override that throws / no-ops / returns `NaN`; conditional identity on an effectful base; Square/Rectangle; inverted postcondition; purity/exception-contract break on a subtype; lying cache/read-only repo; template-method step skip; sibling subtypes left unchecked after one OK type; call sites on pages/routes/workers |
| **I** | Interface Segregation | Do clients depend only on methods they use? | Small role interfaces; clients import narrow ports | Fat interface; empty/`throw` impls; admin forced to call unused methods; fat handler inputs; “narrow” type that still extends a fat port |
| **D** | Dependency Inversion | Do high-level policies depend on abstractions? | Domain depends on ports; concrete adapters injected at the edge | `new ConcreteDb()` in domain/utils/UI/API/workers; global god singleton; concrete↔concrete cycles; port types owned by a vendor SDK; DIP theater (type-alias port / Container→`new`). Subtype purity breaks are **L** first, not automatic D |

## Severity guidance

| Severity | Typical cases |
|----------|----------------|
| Critical | Domain logic hard-wired to infrastructure (D); subtype that breaks callers (L); god class blocking any safe change (S); concrete cycles across adapters |
| High | Closed module repeatedly edited for each new variant (O); fat interface dragging unrelated clients (I); same concrete `new`’d across three+ layers (D) |
| Medium | Mild SRP blur inside one feature folder; pragmatic single-implementation concrete that may later need a port; tiny stable switch noted under Needs verification (not auto-filed as O) |

## Package audit reminder

When the scope is more than one file, or any package/app scope, also satisfy `audit-coverage.md` (layer sweep + minimum coverage gate). Pass/fail signals above apply **per file**; package health needs breadth, not only the worst class.

## Functional paradigm mapping

| OOP | Functional / modular |
|-----|----------------------|
| Class with one reason to change | Module or function with one purpose |
| Strategy / polymorphism | Higher-order functions, tagged unions + exhaustive handlers at the edge |
| Subtype contracts | Compatible function types; lawful substitution of handlers |
| Small interfaces | Narrow parameter objects / focused export surfaces |
| Injected ports | Dependencies as parameters or explicit context |

## Severity by level

Scope (which letters to audit) is owned by `SKILL.md`. This list only changes how hard a signal is filed.

- At `pragmatic`, prefer Medium (or skip) for “interface with one impl and no swap pain”.
- At `strict`, missing ports at boundaries are High when the collaborator crosses a layer.
