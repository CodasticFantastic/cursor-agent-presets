# Coupling Dimensions Checklist

Working source for what each dimension means, the pass/fail signals, and severity. The skill points here. Do not copy this table into `SKILL.md`, the rule, or `coupling-reviewer`.

Level names, the fallback, and which dimensions are in scope live in `SKILL.md`. The section below only changes severity. Examples: TypeScript. Adapt syntax to the file. A new language does not need a second table.

Friends of an object: **itself**, its **fields**, its **parameters**, and objects **it creates**. A value **returned** by one of those is a stranger. One use of a friend is not a violation.

| Id | Name | Question to ask | Pass signal | Fail signal |
|----|------|-----------------|-------------|-------------|
| **lod** | Law of Demeter | Does this call stop at a friend? | Uses `this`, a field, a parameter, or an object it just created. Structure walks stay inside mappers, serializers, and presenters | Domain or service code calls through a returned stranger (`order.customer.address.city`, `a.getB().getC().doSomething()`), or mutates another object's internals (`account.lines.push`) |
| **tda** | Tell, Don't Ask | Does the owner of the data perform the rule? | Caller tells the object what to do (`account.withdraw(amount)`); reads that only display or pass a value through | Caller pulls fields or getters and then branches, mutates, or recomputes a rule that type owns (`if (account.balance < amount) …`) |

## Severity guidance

| Severity | Typical cases |
|----------|----------------|
| Critical | Domain policy mutates another aggregate's internals through a chain; money, auth, or state-transition rules reimplemented by asking across objects |
| High | Train wreck in a service or domain function; feature envy that copies another type's fields into a local decision |
| Medium | One extra hop on a behavior-bearing type with no mutation; a small external branch that could move onto the owner. At `pragmatic`, prefer Medium or skip for mapper and presenter reads |

## Package audit reminder

When the scope is more than one file, or any package/app scope, also satisfy `audit-coverage.md` (layer sweep + minimum coverage gate). Pass/fail signals above apply **per file**; package health needs breadth, not only the longest chain.

## Relationship to SOLID / KISS

| Concern | Guidance |
|---------|----------|
| Missing port / `new Concrete` inside policy | **Not** coupling — SOLID **D** |
| God class mixing jobs | **Not** coupling — SOLID **S**, unless the cited lines are specifically a train wreck or an external rule |
| Nested `if` without a stranger walk | **Not** coupling — KISS **flow** |
| Pure forwarder added only to shorten `a.b().c()` | **Not** a coupling fix — the method must own a rule or hide a real structure |
| Mapper / serializer / presenter reading a data record | **Not** a fail |
| `items.map` / `filter`, or `query.where().limit()` on the same fluent type | **Not** lod |

## Severity by level

Scope (which dimensions to audit) is owned by `SKILL.md`. This list only changes how hard a signal is filed.

- At `pragmatic`, prefer Medium (or skip) for structural reads, one-hop getters, and UI label branches on a view model.
- At `strict`, a second hop or an external rule on a behavior-bearing type in domain or services is High.
