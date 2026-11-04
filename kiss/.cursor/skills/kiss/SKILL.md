---
name: kiss
description: "Design, implement, and review code against the KISS principle (Keep It Simple, Stupid) — clarity, YAGNI, delayed abstraction, small surfaces, justified dependencies, and shallow control flow. Defaults come from kiss.config.json (shipped as pragmatic). Use when writing or refactoring for simplicity, removing over-engineering, cutting speculative features, or when the user asks for KISS, YAGNI, keep it simple, boring code, or less ceremony."
---

# KISS — Keep It Simple, Stupid

Use this skill whenever designing, implementing, refactoring, or reviewing code for simplicity.

**Defaults come from `kiss.config.json` in this skill folder** (`level`: `pragmatic` | `strict` | `educational`; `dimensions`: list of `clarity` `yagni` `abstraction` `surface` `deps` `flow`). Read that file first on every run. The shipped file is pragmatic with all six dimensions.  
A level or dimension set the user states in chat overrides the file for that request. Do not ask when the file already has valid values.  
If the file is missing or a value is invalid, use pragmatic and all six dimensions.  
Do not strip necessary structure at `pragmatic` level. Do not skip enabled dimensions at `strict` level.

Primary examples are TypeScript. Patterns transfer to other languages; adapt syntax, not the principle.

## What KISS means here

Prefer the **simplest design that correctly solves the current, known requirement**.  
Simple means: easy to read, easy to change for the next real need, few moving parts, little ceremony.  
It does **not** mean: one giant file, duplicated divergent logic, hidden globals, or skipping tests.

KISS sits next to YAGNI and “boring technology”. It complements SOLID: both reject unused interfaces and premature frameworks. Conflict is rare — if SOLID needs a port for real cross-layer coupling, that is not a KISS violation.

## Core Workflow

1. **Read defaults** — Load `kiss.config.json` (same folder as this file; in a project, `.cursor/skills/kiss/kiss.config.json`). Use it unless the user overrides in chat.
2. **Scope the change** — Identify the requirement that must be met. Prefer the smallest design that meets it.
3. **Apply dimensions** — Use `references/principles-table.md` as the checklist. Load `references/code-patterns.md` when implementing. Load `references/anti-patterns.md` when reviewing.
4. **Package / app reviews** — If scope is more than a tiny diff, also load `references/audit-coverage.md` and run its **layer sweep** + **minimum coverage gate** before finishing. Do not stop after the first clever helper.
5. **Respect level** — `pragmatic`: cut real complexity cost, keep useful structure. `strict`: every new abstraction/option/dep/branch in scope needs a concrete justification. `educational`: name each dimension applied and why.
6. **Cite dimensions** — When reporting issues or justifying refactors, reference the dimension id and name (e.g., “yagni — You Aren't Gonna Need It”).
7. **Do not overclaim** — A review is a simplicity assessment, not a certificate. Report findings with evidence (`path:line`). Never claim the codebase is “fully KISS”.

## Key Rules (all levels)

- **clarity** — Code should say what it does. Prefer boring, explicit names and standard patterns over clever tricks.
- **yagni** — Build for today's requirements. No speculative options, feature flags, or “just in case” branches.
- **abstraction** — Wait for a second real use case before extracting interfaces, factories, plugins, or frameworks.
- **surface** — Keep public APIs, configs, and parameters small. Remove dead code and unused knobs.
- **deps** — Prefer the standard library and existing project stack. Every new dependency needs a reason.
- **flow** — Prefer early returns and shallow nesting. Avoid unnecessary indirection (wrappers that only forward).

## Level nuances

| Level | Behavior |
|-------|----------|
| `pragmatic` | Simplify where cognitive load, churn, or ceremony is real. Keep ports/layers that already reduce coupling. |
| `strict` | Challenge every new abstraction, option, dependency, and nested branch in scope; demand justification. |
| `educational` | Same technical bar as pragmatic, plus an explicit dimension rationale on every material design choice. |

## When to Load References

- Defaults, every run → `kiss.config.json`
- Dimension checklist + short definitions → `references/principles-table.md`
- Ready-to-use code patterns → `references/code-patterns.md`
- Common violations and smells → `references/anti-patterns.md`
- Package/app audits (mandatory) → `references/audit-coverage.md`

## Common Failures to Avoid

- Clever one-liners, metaprogramming, or dense DSLs where a loop would do (clarity)
- “Future-proof” config with unused modes, providers, and flags (yagni)
- Interface + factory + base class for a single concrete (abstraction)
- Functions with 8+ parameters or mega options objects mostly unused (surface)
- New npm/pip package for a 10-line utility the project already has (deps)
- Wrapper layers that only re-export or forward without adding behavior (flow / abstraction)
- Deep `if/else` pyramids instead of guard clauses (flow)
- Using KISS to justify a god module or copy-paste of **divergent** logic
- Stopping the audit after naming one over-abstracted service while config/utils still bloat

Always explain the simplicity rationale when generating or refactoring code.

## Audits — what the code can decide

A source review is a KISS simplicity assessment. It is not a proof that the product is optimally designed.

Evidence rules:

- Status `pass` only with evidence: a repository location `path:line`, or a clear structural property visible in the scoped files.
- One clean function does not clear the dimension for the whole package. Record the scope of the evidence.
- Do not invent “simplicity” by deleting necessary boundaries. Prefer the smallest change that removes unjustified complexity.

Put each finding into one class:

- **Code** — the source alone shows a violation or a satisfied check. Examples: unused `mode`/`provider` branches; interface with one impl and no second use case; options object with mostly optional unused fields; dependency imported for a one-liner; nesting depth ≥4 with no domain need.
- **Hybrid** — the source shows a risk; confirmation needs product intent or more modules. Examples: “maybe we need this plugin system later”; package used in one place but may be required by platform policy.
- **Manual** — needs product/team judgment. Examples: whether a second provider is on the roadmap this quarter; whether a shared package is mandated by the org.

### Report format

```
## Review result
Scope: <files or module>
Level: <from kiss.config.json, unless the user overrode it>
Dimensions: <enabled set>
Verdict: this is a simplicity assessment, not a certification.

### Coverage (package/app audits)
- Layers swept: <types | utils | config | services | adapters | api | components | pages>
- Gate: pass | incomplete — <missing hunt or “folder absent”>

### Violations visible in code
- Location: path:line
- Dimension: clarity | yagni | abstraction | surface | deps | flow — <name>
- Class: code
- Severity: Critical | High | Medium
- Why it fails:
- Fix:

### Satisfied checks
- Dimension:
- Status: pass
- Evidence: path:line
- Scope: this file or this module. This pass does not clear the dimension for the package.

### Needs verification
- Dimension:
- Status: needs verification
- Class: hybrid | manual
- What is missing: no path:line, or product/roadmap judgment outside scope
```

If a section has no items, write “None in this scope.” Do not invent a pass. A check without `path:line` goes under “Needs verification”.  
For single-file diffs, `### Coverage` may say `n/a — file-scoped`. For package/app scope, incomplete gate means keep searching — do not close with only the largest over-engineered type.
