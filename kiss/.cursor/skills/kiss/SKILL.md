---
name: kiss
description: "Design, implement, and review code against the KISS principle (Keep It Simple, Stupid) — clarity, YAGNI, delayed abstraction, small surfaces, justified dependencies, and shallow control flow. Defaults come from kiss.config.json (shipped as pragmatic). Use when writing or refactoring for simplicity, removing over-engineering, cutting speculative features, or when the user asks for KISS, YAGNI, keep it simple, boring code, or less ceremony."
paths: "**/*.{ts,tsx,js,jsx,mjs,cjs,py,java,kt,cs,go}"
---

# KISS — Keep It Simple, Stupid

Use this skill whenever designing, implementing, refactoring, or reviewing code for simplicity.

**Defaults come from `kiss.config.json` in this skill folder** (`level`: `pragmatic`, `strict`, or `educational`; `dimensions`: a list of `clarity`, `yagni`, `abstraction`, `surface`, `deps`, `flow`). Read that file first on every run. The shipped file is pragmatic with all six dimensions.
A level or dimension set stated in the chat overrides the file for that request. Do not ask when the file already has a valid combination.
If the file is missing, a level is not one of the tokens above, a dimension id is outside the six above, or `dimensions` is empty, use pragmatic and all six dimensions.

`languages` in that file is example syntax only. It does not select files and it does not turn a dimension on or off. Patterns in `references/code-patterns.md` are TypeScript. Adapt the syntax to the file you are editing. Adding a language does not need a new reference file.

**Scope filter.** After level and dimensions are resolved, apply only the enabled dimensions. A dimension absent from `dimensions` is out of scope. Skip its bullets. Do not file it.

Level behavior has one copy: the table under "Level behavior". The rule file may name the three levels in one line so generation works before this skill is opened. It must not grow a second definition. Once this file is loaded, that table wins.

The markdown references are the working catalogs. This file is the procedure. If a catalog does not settle a case, use that dimension's question in `references/principles-table.md`. Do not invent a seventh dimension.

Prefer the **simplest design that correctly solves the current, known requirement**. Simple means easy to read, easy to change for the next real need, few moving parts, little ceremony. It does **not** mean one giant file, duplicated divergent logic, hidden globals, or skipping tests. KISS complements SOLID: both reject unused ceremony. A port that isolates real cross-layer coupling is not a KISS violation.

The parent agent implements fixes in its own context. `/kiss-reviewer` is a separate readonly audit: it returns the report below and does not edit. Do not start it after ordinary generation or editing. Start it when the user asks for an audit or a parent explicitly delegates one.

## Core Workflow

1. **Read defaults** — Load `kiss.config.json` (same folder as this file; in a project, `.cursor/skills/kiss/kiss.config.json`). Use it unless the user overrides it in chat.
2. **Scope the change** — Identify the requirement that must be met. Prefer the smallest design that meets it.
3. **Apply enabled dimensions** — Load `references/principles-table.md` and cover every enabled dimension. That table is the working source for meaning, pass/fail, and severity. Load `references/code-patterns.md` when implementing. Load `references/anti-patterns.md` when reviewing. Skip rows for dimensions that are out of scope.
4. **Package / app reviews** — When the scope is more than one file, or any package/app scope, load `references/audit-coverage.md` and run its layer sweep and coverage gate before finishing. That file owns the trigger and the sweep. Do not stop after the first clever helper. A pass on one type does not close the dimension for the package. For a single-file review, do not use `audit-coverage.md` — still review that file.
5. **Respect the filter** — Apply the level and the enabled dimensions from the scope filter. Do not re-derive them from memory.
6. **Cite dimensions** — When reporting issues or justifying refactors, reference the dimension id and the full name from the table (for example, "yagni — You Aren't Gonna Need It"). Cite only enabled dimensions.
7. **Do not overclaim** — Classify every finding as code, hybrid, or manual. A `pass` needs evidence. Use the report format below. Never state that a module, package, or project is "fully KISS" or "KISS compliant".

## Key Rules

Each bullet is one dimension. Skip it when that dimension is not enabled. The table is the definition. These lines are the generation reminder.

- **clarity** — Code should say what it does. Prefer boring, explicit names and standard patterns over clever tricks.
- **yagni** — Build for today's requirements. No speculative options, feature flags, or “just in case” branches.
- **abstraction** — Wait for a second real use case before extracting interfaces, factories, plugins, or frameworks.
- **surface** — Keep public APIs, configs, and parameters small. Remove dead code and unused knobs.
- **deps** — Prefer the standard library and existing project stack. Every new dependency needs a reason.
- **flow** — Prefer early returns and shallow nesting. Avoid unnecessary indirection (wrappers that only forward).

## Level behavior

| Level | Behavior |
|-------|----------|
| `pragmatic` | Simplify where cognitive load, churn, or ceremony is real. Keep ports and layers that already reduce coupling. |
| `strict` | Challenge every new abstraction, option, dependency, and nested branch in scope; demand justification. Every enabled dimension applies. |
| `educational` | Same technical bar as `pragmatic`, plus an explicit rationale for each enabled dimension on every material design choice. |

## Where a change goes

Edit the catalog that owns the change. Do not paste the same body into this procedure, the rule, and the subagent.

| Change | Edit |
|--------|------|
| Default level, example languages, or enabled dimensions | `kiss.config.json` |
| What a dimension means, a pass/fail signal, or severity | `references/principles-table.md` |
| A smell | `references/anti-patterns.md` |
| An implementation shape | `references/code-patterns.md` |
| A layer, a hunt, or a coverage checkbox | `references/audit-coverage.md` |
| A new level or dimension token | The allowed tokens at the top of this file, the level table if it is a level, then a row in `references/principles-table.md` |
| Evidence rules or the report format | This file, in "Audits — what the code can decide" |

A new smell, layer, or code shape does not belong in this file. The rule may keep one reminder per dimension. The subagent reads this file and does not keep a second template.

## When to Load References

- Defaults, every run → `kiss.config.json`
- Dimension meaning, pass/fail, severity → `references/principles-table.md`
- Implementation shapes → `references/code-patterns.md`
- Smell catalog → `references/anti-patterns.md`
- Package or app audit → `references/audit-coverage.md`

## Common failures

Judgment traps only. Concrete smells live in `references/anti-patterns.md`. Layer hunts live in `references/audit-coverage.md`. Do not treat this section as a substitute for those catalogs.

- Do not claim a package or project is "fully KISS" or "KISS compliant".
- Do not stop after the first over-engineered helper or the first clean util.
- At `pragmatic`, a thin wrapper that documents a team boundary is not Critical by itself — but unused options, speculative factories, or nesting that obscures the requirement still escalate.
- Do not “simplify” by merging domain and infrastructure into a god module, deleting tests, or copy-pasting divergent logic.
- Do not trust `Simple*`, `Lite*`, `Basic*`, `Factory`, `Manager`, or `Framework` names without reading the body.

Always explain the simplicity rationale when generating or refactoring code. Name the dimension.

## Audits — what the code can decide

This section is the only copy of the evidence rules and the report format. The `kiss-reviewer` subagent reads them from here and returns the report to the parent. The parent applies fixes.

A source review is a KISS simplicity assessment. It is not a proof that the product is optimally designed. Do not write that a module, package, or project is "fully KISS" or "KISS compliant".

Evidence rules:

- Status `pass` only with evidence: a repository location `path:line`, or a structural property named with the file that shows it. With no such evidence the status is `needs verification`.
- One clean function does not close the dimension for the package. Record the scope of the evidence.
- On a package or app review, a pass on one file does not close the dimension for the package. File the same smell at every in-scope layer where it appears, or mark that layer absent.
- Do not invent “simplicity” by deleting necessary boundaries. Prefer the smallest change that removes unjustified complexity.
- Discuss dimensions that are in the resolved `dimensions` list. A dimension outside that list is out of scope, not a pass.

Dimension disambiguation (before filing):

1. Pick **one primary dimension** per symbol. Add a second only when it is a separate contract (or the catalog explicitly allows “also counts”).
2. Speculative unused path / provider / flag → **yagni**. Unused export or options sprawl on an otherwise needed API → **surface**. Do not double-stamp both for the same dead knob.
3. Premature interface/factory/plugin with one impl → **abstraction**. The same concrete hard-wired across layers is a SOLID/D concern, not a KISS fail by itself — and a real infra port is **not** abstraction theater.
4. Clever names or nested control flow → **clarity** / **flow**.
5. **False simplicity is not a seventh dimension** — do not add it to `dimensions` or invent a new id. When the smell is a god module, hidden globals/singletons, diverged copy-paste twins, or domain/infra inlined into UI “to keep fewer files”, pick the closest enabled primary (usually **clarity**) and **always** set `Anti-pattern: false-simplicity` on that finding. Omitting the label when the body is that smell is incomplete filing. Catalog: `references/anti-patterns.md` → “False simplicity”.

Put each finding into one class:

- **Code** — the source alone shows a violation or a satisfied check. Examples: unused `mode`/`provider` branches; interface with one impl and no second use case; options object with mostly optional unused fields; dependency imported for a one-liner; nesting depth ≥4 with no domain need.
- **Hybrid** — the source shows a risk; confirmation needs product intent or more modules. Examples: “maybe we need this plugin system later”; package used in one place but may be required by platform policy.
- **Manual** — needs product or team judgment. Examples: whether a second provider is on the roadmap this quarter; whether a shared package is mandated by the org.

### Report format

Use this structure for every review. The summary counts findings. It does not certify the package.

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
- Anti-pattern: false-simplicity
- Class: code
- Severity: Critical | High | Medium
- Why it fails:
- Fix:

When the finding is false simplicity (god module, hidden globals, diverged copy-paste, infra inlined into UI), include the `Anti-pattern: false-simplicity` line. For every other smell, omit that line entirely — do not invent other anti-pattern ids here.

### Satisfied checks
- Dimension:
- Status: pass
- Evidence: path:line
- Scope: this file or this module. This pass does not close the dimension for the package.

### Needs verification
- Dimension:
- Status: needs verification
- Class: hybrid | manual
- What is missing: no path:line, or product or roadmap judgment outside scope
```

If a section has no items, write "None in this scope." Do not invent a pass. A pass needs `path:line`, or a structural property named with the file that shows it. Otherwise the check goes under "Needs verification".
For a single file, `### Coverage` may say `n/a — file-scoped`. Whenever `audit-coverage.md` was loaded, include `### Coverage`. An incomplete gate means keep searching. Do not close the report on the largest over-engineered type alone.
