---
name: coupling
description: "Design, implement, and review code against coupling and encapsulation: Law of Demeter (talk only to immediate friends) and Tell, Don't Ask (the object that owns the data performs the decision). Defaults come from coupling.config.json (shipped as pragmatic). Use when writing or refactoring object collaboration, message chains, feature envy, or anemic decisions, or when the user asks for Law of Demeter, LoD, Tell Don't Ask, train wreck, feature envy, or encapsulation."
paths: "**/*.{ts,tsx,js,jsx,mjs,cjs,py,java,kt,cs,go}"
---

# Coupling — Law of Demeter & Tell, Don't Ask

Use this skill whenever designing, implementing, refactoring, or reviewing how objects collaborate.

**Defaults come from `coupling.config.json` in this skill folder** (`level`: `pragmatic`, `strict`, or `educational`; `dimensions`: a list of `lod`, `tda`). Read that file first on every run. The shipped file is pragmatic with both dimensions.
A level or dimension set stated in the chat overrides the file for that request. Do not ask when the file already has a valid combination.
If the file is missing, a level is not one of the tokens above, a dimension id is outside the two above, or `dimensions` is empty, use pragmatic and both dimensions.

`languages` in that file is example syntax only. It does not select files and it does not turn a dimension on or off. Patterns in `references/code-patterns.md` are TypeScript. Adapt the syntax to the file you are editing. Adding a language does not need a new reference file.

**Scope filter.** After level and dimensions are resolved, apply only the enabled dimensions. A dimension absent from `dimensions` is out of scope. Skip its bullets. Do not file it.

Level behavior has one copy: the table under "Level behavior". The rule file may name the three levels in one line so generation works before this skill is opened. It must not grow a second definition. Once this file is loaded, that table wins.

The markdown references are the working catalogs. This file is the procedure. If a catalog does not settle a case, use that dimension's question in `references/principles-table.md`. Do not invent a third dimension.

An object may use itself, its fields, its parameters, and objects it creates. It should not walk a stranger's internals (`a.getB().getC().doSomething()`), and it should not pull state out just to reimplement a rule the owner should perform. Coupling complements SOLID and KISS. A missing port is SOLID **D**. A god module is SOLID **S**. A pure forwarder added only to shorten a chain is not a fix. A mapper or presenter that reads a data record is not a violation.

The parent agent implements fixes in its own context. `/coupling-reviewer` is a separate readonly audit: it returns the report below and does not edit. Do not start it after ordinary generation or editing. Start it when the user asks for an audit or a parent explicitly delegates one.

## Core Workflow

1. **Read defaults** — Load `coupling.config.json` (same folder as this file; in a project, `.cursor/skills/coupling/coupling.config.json`). Use it unless the user overrides it in chat.
2. **Scope the change** — Identify the collaboration in scope. Prefer the smallest change that keeps the decision on the owner and the call on a friend.
3. **Apply enabled dimensions** — Load `references/principles-table.md` and cover every enabled dimension. That table is the working source for meaning, pass/fail, and severity. Load `references/code-patterns.md` when implementing. Load `references/anti-patterns.md` when reviewing. Skip rows for dimensions that are out of scope.
4. **Package / app reviews** — When the scope is more than one file, or any package/app scope, load `references/audit-coverage.md` and run its layer sweep and coverage gate before finishing. That file owns the trigger and the sweep. Do not stop after the first train wreck. A pass on one type does not close the dimension for the package. For a single-file review, do not use `audit-coverage.md` — still review that file.
5. **Respect the filter** — Apply the level and the enabled dimensions from the scope filter. Do not re-derive them from memory.
6. **Cite dimensions** — When reporting issues or justifying refactors, reference the dimension id and the full name from the table (for example, "lod — Law of Demeter"). Cite only enabled dimensions.
7. **Do not overclaim** — Classify every finding as code, hybrid, or manual. A `pass` needs evidence. Use the report format below. Never state that a module, package, or project is "fully decoupled" or "LoD compliant".

## Key Rules

Each bullet is one dimension. Skip it when that dimension is not enabled. The table is the definition. These lines are the generation reminder.

- **lod** — Call methods on yourself, your fields, your parameters, and objects you create. Do not walk a returned stranger (`order.customer.address.city` in domain policy).
- **tda** — Tell the object that owns the data to do the work. Do not ask for its fields and reimplement its rule outside.

## Level behavior

| Level | Behavior |
|-------|----------|
| `pragmatic` | File a train wreck or an external decision where domain policy or mutation is real. Allow mappers, presenters, and one-hop reads of plain data. |
| `strict` | Challenge every second hop and every external rule on a behavior-bearing type in scope. Every enabled dimension applies. |
| `educational` | Same technical bar as `pragmatic`, plus an explicit rationale for each enabled dimension on every material collaboration. |

## Where a change goes

Edit the catalog that owns the change. Do not paste the same body into this procedure, the rule, and the subagent.

| Change | Edit |
|--------|------|
| Default level, example languages, or enabled dimensions | `coupling.config.json` |
| What a dimension means, a pass/fail signal, or severity | `references/principles-table.md` |
| A smell | `references/anti-patterns.md` |
| An implementation shape | `references/code-patterns.md` |
| A layer, a hunt, or a coverage checkbox | `references/audit-coverage.md` |
| A new level or dimension token | The allowed tokens at the top of this file, the level table if it is a level, then a row in `references/principles-table.md` |
| Evidence rules or the report format | This file, in "Audits — what the code can decide" |

A new smell, layer, or code shape does not belong in this file. The rule may keep one reminder per dimension. The subagent reads this file and does not keep a second template.

## When to Load References

- Defaults, every run → `coupling.config.json`
- Dimension meaning, pass/fail, severity → `references/principles-table.md`
- Implementation shapes → `references/code-patterns.md`
- Smell catalog → `references/anti-patterns.md`
- Package or app audit → `references/audit-coverage.md`

## Common failures

Judgment traps only. Concrete smells live in `references/anti-patterns.md`. Layer hunts live in `references/audit-coverage.md`. Do not treat this section as a substitute for those catalogs.

- Do not claim a package or project is "fully decoupled", "LoD compliant", or "Tell, Don't Ask compliant".
- Do not stop after the first train wreck or the first clean method.
- At `pragmatic`, a mapper or presenter that reads a data record is not a violation — but domain policy that walks or mutates another object's internals still escalates.
- Do not "fix" a chain by adding a method that only forwards. Move the decision onto the owner, or leave a structural read alone.
- Do not file a missing port, a god class, or nested `if`s as coupling. Those belong to SOLID or KISS.
- Do not trust `Encapsulated*`, `Facade`, or `delegateTo` names without reading the body.

Always explain the collaboration rationale when generating or refactoring code. Name the dimension.

## Audits — what the code can decide

This section is the only copy of the evidence rules and the report format. The `coupling-reviewer` subagent reads them from here and returns the report to the parent. The parent applies fixes.

A source review is a coupling assessment. It is not a proof that the system is loosely coupled end to end. Do not write that a module, package, or project is "fully decoupled" or "LoD compliant".

Evidence rules:

- Status `pass` only with evidence: a repository location `path:line`, or a structural property named with the file that shows it. With no such evidence the status is `needs verification`.
- One clean method does not close the dimension for the package. Record the scope of the evidence.
- On a package or app review, a pass on one file does not close the dimension for the package. File the same smell at every in-scope layer where it appears, or mark that layer absent.
- Do not invent a method that only forwards. Prefer the smallest change that puts the rule on the owner or stops at a friend.
- Discuss dimensions that are in the resolved `dimensions` list. A dimension outside that list is out of scope, not a pass.

Dimension disambiguation (before filing):

1. Pick **one primary dimension** per symbol. Add a second only when it is a separate contract (or the catalog explicitly allows “also counts”).
2. Walking a returned stranger (two or more hops) to call or read → **lod**. A one-hop use of a field, parameter, or object you created is not lod.
3. The caller reads fields or getters and then branches, mutates, or recomputes a rule that type owns → **tda**. A read used only to display or to pass a value through is not tda.
4. The same expression walks two hops **and** decides outside: primary **tda** when the failure is the external rule; **lod** also counts when the navigation depth would remain after the rule moved. Do not stamp both for a one-hop getter plus a branch.
5. Structural walks inside mappers, serializers, and presenters are not lod. Collection pipelines (`map` / `filter`) and same-type fluent builders are not lod. Anemic data with no rule to steal is not tda.

Put each finding into one class:

- **Code** — the source alone shows a violation or a satisfied check. Examples: `order.customer.address.city` inside a pricing or shipping policy (lod); `account.lines.push(...)` from outside the account (lod); `if (account.balance < amount) account.withdraw(amount)` (tda); a service that copies another type's fields into a local decision (tda).
- **Hybrid** — the source shows a risk; confirmation needs more modules or the type's contract. Examples: a getter chain whose owner might be a DTO; a branch that might be the caller's policy rather than the callee's; a method that mostly uses another object but also owns a real local rule.
- **Manual** — needs a product or modeling judgment. Examples: whether a type is supposed to stay a data record; whether a UI label rule belongs in the view; whether two hops are an accepted public query API.

### Report format

Use this structure for every review. The summary counts findings. It does not certify the package.

```
## Review result
Scope: <files or module>
Level: <from coupling.config.json, unless the user overrode it>
Dimensions: <enabled set>
Verdict: this is a coupling assessment, not a certification.

### Coverage (package/app audits)
- Layers swept: <types | utils | services | adapters | api | components | pages | jobs>
- Gate: pass | incomplete — <missing hunt or “folder absent”>

### Violations visible in code
- Location: path:line
- Dimension: lod | tda — <name>
- Class: code
- Severity: Critical | High | Medium
- Why it fails:
- Fix:

### Satisfied checks
- Dimension:
- Status: pass
- Evidence: path:line
- Scope: this file or this module. This pass does not close the dimension for the package.

### Needs verification
- Dimension:
- Status: needs verification
- Class: hybrid | manual
- What is missing: no path:line, or ownership judgment outside scope
```

If a section has no items, write "None in this scope." Do not invent a pass. A pass needs `path:line`, or a structural property named with the file that shows it. Otherwise the check goes under "Needs verification".
For a single file, `### Coverage` may say `n/a — file-scoped`. Whenever `audit-coverage.md` was loaded, include `### Coverage`. An incomplete gate means keep searching. Do not close the report on the longest chain alone.
