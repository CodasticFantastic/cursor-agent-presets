---
name: solid
description: "Design, implement, and review code against the SOLID principles (Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion). Defaults come from solid.config.json (shipped as pragmatic OOP). Use when writing or refactoring classes, modules, services, or APIs, or when the user asks for SOLID, SRP, OCP, LSP, ISP, DIP, clean architecture, or coupling/cohesion improvements."
---

# SOLID — Design Implementation & Review

Use this skill whenever designing, implementing, refactoring, or reviewing code for SOLID compliance.

**Defaults come from `solid.config.json` in this skill folder** (`level`: `pragmatic` | `strict` | `educational`; `paradigm`: `oop` | `functional`; `principles`: list of `S` `O` `L` `I` `D`). Read that file first on every run. The shipped file is pragmatic OOP with all five principles.  
A level, paradigm, or principle set the user states in chat overrides the file for that request. Do not ask when the file already has valid values.  
If the file is missing or a value is invalid, use pragmatic OOP and all five principles.  
Do not invent unused abstractions at `pragmatic` level. Do not skip enabled principles at `strict` level.

Primary examples are TypeScript. Patterns transfer to other languages; adapt syntax, not the principle.

## Core Workflow

1. **Read defaults** — Load `solid.config.json` (same folder as this file; in a project, `.cursor/skills/solid/solid.config.json`). Use it unless the user overrides in chat.
2. **Scope the change** — Identify types, modules, and boundaries in scope. Prefer the smallest change that restores the broken principle.
3. **Apply principles** — Use `references/principles-table.md` as the checklist. Load `references/code-patterns.md` when implementing. Load `references/anti-patterns.md` when reviewing.
4. **Package / app reviews** — If scope is more than a tiny diff, also load `references/audit-coverage.md` and run its **layer sweep** + **minimum coverage gate** before finishing. Do not stop after the first god class.
5. **Respect level** — `pragmatic`: fix real coupling/change pain, avoid ceremony. `strict`: every new public type in scope must satisfy enabled principles. `educational`: name each principle applied and why.
6. **Respect paradigm** — OOP uses classes/interfaces/ports. Functional maps to modules, pure functions, and injected dependencies (see the rule file mapping).
7. **Cite principles** — When reporting issues or justifying refactors, reference the letter and full name (e.g., “S — Single Responsibility”).
8. **Do not overclaim** — A review is a design assessment, not a certificate. Report findings with evidence (`path:line`). Never claim the codebase is “fully SOLID”.

## Key Rules (all levels)

- **S** — One module/class has one reason to change. Separate persistence, transport, and domain policy when they change for different reasons.
- **O** — Add behavior by adding types or strategies, not by editing closed decision cores. Prefer polymorphism / composition over growing type switches.
- **L** — A subtype must be usable wherever the base is expected without surprising the caller. Prefer composition when inheritance would lie.
- **I** — Split fat interfaces so callers depend only on what they use.
- **D** — High-level policy depends on abstractions; concrete adapters live at the edges and are injected.

## Level nuances

| Level | Behavior |
|-------|----------|
| `pragmatic` | Apply where change risk or coupling is real. One implementation may stay concrete until a second is needed. |
| `strict` | Interfaces/ports for every cross-boundary collaborator in scope. No fat interfaces. No type-switch growth in closed modules. |
| `educational` | Same technical bar as pragmatic, plus an explicit S/O/L/I/D rationale on every material design choice. |

## When to Load References

- Defaults, every run → `solid.config.json`
- Principle checklist + short definitions → `references/principles-table.md`
- Ready-to-use code patterns → `references/code-patterns.md`
- Common violations and smells → `references/anti-patterns.md`
- Package/app audits (mandatory) → `references/audit-coverage.md`

## Common Failures to Avoid

- God class / “Utils” dumping ground (S)
- Helpers that also render UI, set HTTP status, email, charge, or touch `document` (S)
- Open `switch`/`if` on type **scattered** across tax/flags/geo/factory/router/API/UI — not only one service (O)
- Overriding a method to throw `NotImplemented` or to weaken the contract (L)
- Broken subtypes constructed from pages, layouts, or report routes — not only the hierarchy file (L)
- One mega-interface implemented “partially” by several clients; admin UI calling unused methods (I)
- `new ConcreteService()` buried inside domain **and** the same concrete in hooks/components/API (D)
- Concrete↔concrete cycles (mailer constructs DB/payment and vice versa) (D)
- Stopping the audit after naming one god class while utils/pages/workers/BFF still violate
- Trusting `*Strategy*` / `*Repository*` / `*Factory*` / `*Facade*` / `*Container*` / `*Port*` / plugin / EventBus names without reading bodies
- Treating `*-defs/` as OCP-compliant while a closed factory/router/`isOn` remains
- DIP theater: type-alias “ports”, `create*Port()` → `new Concrete`, Container token switches
- Premature interface with a single never-swapped implementation when level is `pragmatic`

Always explain the design rationale when generating or refactoring code.

## Audits — what the code can decide

A source review is a SOLID design assessment. It is not a proof that the system is well-architected end-to-end.

Evidence rules:

- Status `pass` only with evidence: a repository location `path:line`, or a clear structural property visible in the scoped files.
- One clean class does not clear the principle for the whole package. Record the scope of the evidence.
- Do not invent missing layers. Prefer the smallest refactor that restores the principle.

Put each finding into one class:

- **Code** — the source alone shows a violation or a satisfied check. Examples: class that both persists and renders UI (S); `switch (type)` inside a closed calculator extended by editing that switch (O); subclass method that throws or no-ops where the base promises work (L); interface with unrelated methods where clients use disjoint subsets (I); domain function that constructs a concrete HTTP/DB client (D).
- **Hybrid** — the source shows a risk; confirmation needs more modules or runtime wiring. Examples: “maybe two reasons to change” without seeing callers; DI container wiring outside the scoped files; LSP risk that depends on undocumented caller assumptions.
- **Manual** — needs product/change-rate judgment. Examples: whether a second implementation will ever exist; whether splitting an interface is worth the ceremony at `pragmatic` level; team convention conflicts.

### Report format

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
- Scope: this file or this module. This pass does not clear the principle for the package.

### Needs verification
- Principle:
- Status: needs verification
- Class: hybrid | manual
- What is missing: no path:line, or wiring/change-rate judgment outside scope
```

If a section has no items, write “None in this scope.” Do not invent a pass. A check without `path:line` goes under “Needs verification”.  
For single-file diffs, `### Coverage` may say `n/a — file-scoped`. For package/app scope, incomplete gate means keep searching — do not close with only the largest god class.
