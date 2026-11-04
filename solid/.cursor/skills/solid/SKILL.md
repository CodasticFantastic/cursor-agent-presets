---
name: solid
description: "Design, implement, and review code against the SOLID principles (Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion). Defaults come from solid.config.json (shipped as pragmatic OOP). Use when writing or refactoring classes, modules, services, or APIs, or when the user asks for SOLID, SRP, OCP, LSP, ISP, DIP, clean architecture, or coupling/cohesion improvements."
paths: "**/*.{ts,tsx,js,jsx,mjs,cjs,py,java,kt,cs,go}"
---

# SOLID — Design Implementation & Review

Use this skill whenever designing, implementing, refactoring, or reviewing code for SOLID compliance.

**Defaults come from `solid.config.json` in this skill folder** (`level`: `pragmatic`, `strict`, or `educational`; `paradigm`: `oop` or `functional`; `principles`: a list of `S`, `O`, `L`, `I`, `D`). Read that file first on every run. The shipped file is pragmatic OOP with all five principles.
A level, paradigm, or principle set stated in the chat overrides the file for that request. Do not ask when the file already has a valid combination.
If the file is missing, a level or paradigm is not one of the tokens above, a letter is outside `S` `O` `L` `I` `D`, or `principles` is empty, use pragmatic OOP and all five principles.

`languages` in that file is example syntax only. It does not select files and it does not turn a principle on or off. Patterns in `references/code-patterns.md` are TypeScript. Adapt the syntax to the file you are editing. Adding a language does not need a new reference file.

**Scope filter.** After level, paradigm, and principles are resolved, apply only the enabled letters. A letter absent from `principles` is out of scope. Skip its bullets. Do not file it.

Level behavior has one copy: the table under "Level behavior". The rule file may name the three levels in one line so generation works before this skill is opened. It must not grow a second definition. Once this file is loaded, that table wins.

The markdown references are the working catalogs. This file is the procedure. If a catalog does not settle a case, use that letter's question in `references/principles-table.md`. Do not invent a sixth principle.

The parent agent implements fixes in its own context. `/solid-reviewer` is a separate readonly audit: it returns the report below and does not edit. Do not start it after ordinary generation or editing. Start it when the user asks for an audit or a parent explicitly delegates one.

## Core Workflow

1. **Read defaults** — Load `solid.config.json` (same folder as this file; in a project, `.cursor/skills/solid/solid.config.json`). Use it unless the user overrides it in chat.
2. **Scope the change** — Identify types, modules, and boundaries in scope. Prefer the smallest change that restores the broken principle.
3. **Apply enabled letters** — Load `references/principles-table.md` and cover every enabled letter. That table is the working source for meaning, pass/fail, severity, and the paradigm mapping. Load `references/code-patterns.md` when implementing. Load `references/anti-patterns.md` when reviewing. Skip rows for letters that are out of scope.
4. **Package / app reviews** — When the scope is more than one file, or any package/app scope, load `references/audit-coverage.md` and run its layer sweep and coverage gate before finishing. That file owns the trigger and the sweep. Do not stop after the first god class. A pass on one type does not close the letter for the package. For a single-file review, do not use `audit-coverage.md` — still review that file.
5. **Respect the filter** — Apply the level and the enabled letters from the scope filter. Do not re-derive them from memory.
6. **Respect paradigm** — Use the mapping table in `references/principles-table.md`. Do not keep a second mapping in this file or in the rule. Adapt syntax to the file.
7. **Cite principles** — When reporting issues or justifying refactors, reference the letter and the full name from the table (for example, "S — Single Responsibility"). Cite only enabled letters.
8. **Do not overclaim** — Classify every finding as code, hybrid, or manual. A `pass` needs evidence. Use the report format below. Never state that a module, package, or project is "fully SOLID" or "SOLID compliant".

## Key Rules

Each bullet is one letter. Skip it when that letter is not enabled. The table is the definition. These lines are the generation reminder.

- **S** — One module or class has one reason to change. Separate persistence, transport, and domain policy when they change for different reasons.
- **O** — Add behavior by adding types or strategies, not by editing a closed decision core. Prefer polymorphism or composition over a growing type switch.
- **L** — A subtype must be usable wherever the base is expected without surprising the caller. Prefer composition when inheritance would lie.
- **I** — Split fat interfaces so callers depend only on what they use.
- **D** — High-level policy depends on abstractions. Concrete adapters live at the edges and are injected.

## Level behavior

| Level | Behavior |
|-------|----------|
| `pragmatic` | Apply an enabled letter where change risk or coupling is real. One implementation may stay concrete until a second is needed. |
| `strict` | Ports for every cross-boundary collaborator in scope. No fat interface. No type-switch growth in a closed module. Every enabled letter applies. |
| `educational` | Same technical bar as `pragmatic`, plus an explicit rationale for each enabled letter on every material design choice. |

## Where a change goes

Edit the catalog that owns the change. Do not paste the same body into this procedure, the rule, and the subagent.

| Change | Edit |
|--------|------|
| Default level, paradigm, example languages, or enabled letters | `solid.config.json` |
| What a letter means, a pass/fail signal, severity, or the paradigm mapping | `references/principles-table.md` |
| A smell | `references/anti-patterns.md` |
| An implementation shape | `references/code-patterns.md` |
| A layer, a hunt, or a coverage checkbox | `references/audit-coverage.md` |
| A new level or paradigm token | The allowed tokens at the top of this file, the level table if it is a level, then a row in `references/principles-table.md` |
| Evidence rules or the report format | This file, in "Audits — what the code can decide" |

A new smell, layer, or code shape does not belong in this file. The rule may keep one reminder per letter. The subagent reads this file and does not keep a second template.

## When to Load References

- Defaults, every run → `solid.config.json`
- Letter meaning, pass/fail, severity, paradigm mapping → `references/principles-table.md`
- Implementation shapes → `references/code-patterns.md`
- Smell catalog → `references/anti-patterns.md`
- Package or app audit → `references/audit-coverage.md`

## Common failures

Judgment traps only. Concrete smells live in `references/anti-patterns.md`. Layer hunts live in `references/audit-coverage.md`. Do not treat this section as a substitute for those catalogs.

- Do not claim a package or project is "fully SOLID" or "SOLID compliant".
- Do not stop after the first god class or the first clean type.
- At `pragmatic`, a missing interface for one concrete is not Critical by itself — but the same concrete constructed across three or more layers still escalates.
- Do not trust `Strategy`, `Repository`, `Factory`, `Facade`, `Container`, `Port`, plugin, or EventBus names without reading the body.

Always explain the design rationale when generating or refactoring code. Name the letter.

## Audits — what the code can decide

This section is the only copy of the evidence rules and the report format. The `solid-reviewer` subagent reads them from here and returns the report to the parent. The parent applies fixes.

A source review is a SOLID design assessment. It is not a proof that the system is well-architected end to end. Do not write that a module, package, or project is "fully SOLID" or "SOLID compliant".

Evidence rules:

- Status `pass` only with evidence: a repository location `path:line`, or a structural property named with the file that shows it. With no such evidence the status is `needs verification`.
- One clean type does not close the letter for the package. Record the scope of the evidence.
- On a package or app review, a pass on one file does not close the letter for the package. File the same smell at every in-scope layer where it appears, or mark that layer absent.
- Do not invent a missing layer. Prefer the smallest refactor that restores the letter.
- Discuss letters that are in the resolved `principles` list. A letter outside that list is out of scope, not a pass.

Letter disambiguation (before filing):

1. Pick **one primary letter** per symbol. Add a second letter only when it is a separate contract (or the catalog explicitly allows “also counts”).
2. **O** needs a real extension axis — not every `if`/`switch`. Closed lifecycles and frozen-spec adapters are not O by default; god-handler tax/state branches are usually **S** first.
3. Subtype that breaks a documented purity / exception / postcondition contract → **L**. **D** is wrong-owned abstraction, concrete `new` in policy, vendor-typed “ports”, or concrete cycles — do not double-stamp L+D for the same purity break.

Put each finding into one class:

- **Code** — the source alone shows a violation or a satisfied check. Examples: a class that both persists and renders UI (S); `switch (type)` inside a closed calculator that grows by editing that switch (O); a subclass method that throws or no-ops where the base promises work (L); an interface with unrelated methods that clients use in disjoint subsets (I); a domain function that constructs a concrete HTTP or database client (D).
- **Hybrid** — the source shows a risk, and pass or fail needs more modules or the runtime wiring. Examples: two reasons to change that are not visible without callers; a DI container wired outside the scoped files; an LSP risk that depends on caller assumptions that are not in the source.
- **Manual** — needs a product or change-rate judgment. Examples: whether a second implementation will exist; whether splitting an interface is worth the ceremony at `pragmatic`; a conflict with a team convention; whether a tiny stable switch is churning enough to file as O.

### Report format

Use this structure for every review. The summary counts findings. It does not certify the package.

```
## Review result
Scope: <files or module>
Level: <from solid.config.json, unless the user overrode it>
Paradigm: <from solid.config.json, unless the user overrode it>
Principles: <enabled set>
Verdict: this is a design assessment, not a certification.

### Coverage (package/app audits)
- Layers swept: <types | utils | repos | adapters | services | validators | store/hooks | api | components | pages | jobs/workers | bff | messaging | config/i18n>
- Gate: pass | incomplete — <missing hunt or “folder absent”>

### Violations visible in code
- Location: path:line
- Principle: S | O | L | I | D — <name>
- Class: code
- Severity: Critical | High | Medium
- Why it fails:
- Fix:

### Satisfied checks
- Principle:
- Status: pass
- Evidence: path:line
- Scope: this file or this module. This pass does not close the letter for the package.

### Needs verification
- Principle:
- Status: needs verification
- Class: hybrid | manual
- What is missing: no path:line, or wiring or change-rate judgment outside scope
```

If a section has no items, write "None in this scope." Do not invent a pass. A pass needs `path:line`, or a structural property named with the file that shows it. Otherwise the check goes under "Needs verification".
For a single file, `### Coverage` may say `n/a — file-scoped`. Whenever `audit-coverage.md` was loaded, include `### Coverage`. An incomplete gate means keep searching. Do not close the report on the largest god class alone.
