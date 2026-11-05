---
name: react
description: "Design, implement, and review React code: Rules of Hooks, the server/client boundary, state derived during render, and list keys. Defaults come from react.config.json (shipped as pragmatic). Use when writing or reviewing components, hooks, or Server Components, or when the user asks for React, hooks, useEffect, use client, Server Components, or list keys."
paths: "**/*.{jsx,tsx}"
---

# React — Hooks, boundary, state, keys

Use this skill whenever designing, implementing, refactoring, or reviewing React components and hooks.

**Defaults come from `react.config.json` in this skill folder** (`level`: `pragmatic`, `strict`, or `educational`; `dimensions`: a list of `hooks`, `boundary`, `state`, `key`). Read that file first on every run. The shipped file is pragmatic with all four dimensions.
A level or dimension set stated in the chat overrides the file for that request. Do not ask when the file already has a valid combination.
If the file is missing, a level is not one of the tokens above, a dimension id is outside the four above, or `dimensions` is empty, use pragmatic and all four dimensions.

`languages` in that file is example syntax only. It does not select files and it does not turn a dimension on or off. Patterns in `references/code-patterns.md` are TypeScript. Adapt the syntax to the file you are editing. Adding a language does not need a new reference file.

**Scope filter.** After level and dimensions are resolved, apply only the enabled dimensions. A dimension absent from `dimensions` is out of scope. Skip its bullets. Do not file it.

Level behavior has one copy: the table under "Level behavior". The rule file may name the three levels in one line so generation works before this skill is opened. It must not grow a second definition. Once this file is loaded, that table wins.

The markdown references are the working catalogs. This file is the procedure. The closed rule list is `references/react-rules.md` (eight rules, R1–R8). Load it on every run. Do not search the web for extra React rules and do not invent R9. If a catalog does not settle a case, use that dimension's question in `references/principles-table.md`, then the matching row in the rules file. Do not invent a fifth dimension.

`boundary` applies only in a server/client tree. A client-only app is `n/a — no server components` for that dimension. That is not a pass and not a failure.

React complements SOLID, KISS, coupling, structure, security, WCAG, and TDD. A missing port is SOLID **D**. A focus ring is WCAG. Untrusted HTML is security **injection**. A mixed-level function is structure **slap**. Do not file those as React.

The parent agent implements fixes in its own context. `/react-reviewer` is a separate readonly audit: it returns the report below and does not edit. Do not start it after ordinary generation or editing. Start it when the user asks for an audit or a parent explicitly delegates one.

## Core Workflow

1. **Read defaults** — Load `react.config.json` (same folder as this file; in a project, `.cursor/skills/react/react.config.json`). Use it unless the user overrides it in chat.
2. **Scope the change** — Identify components, hooks, and list renders in scope. Prefer the smallest change that restores the broken rule.
3. **Apply enabled dimensions** — Load `references/principles-table.md` and `references/react-rules.md`. Cover every enabled dimension and every rule that maps to one. The rules file is the closed list. Load `references/code-patterns.md` when implementing. Load `references/anti-patterns.md` when reviewing. Skip rows for dimensions that are out of scope. Skip `boundary` rows when the app has no server/client split.
4. **Package / app reviews** — When the scope is more than one file, or any package/app scope, load `references/audit-coverage.md` and run its layer sweep and coverage gate before finishing. That file owns the trigger and the sweep. Do not stop after the first conditional hook. A pass on one component does not close the dimension for the package. For a single-file review, do not use `audit-coverage.md` — still review that file.
5. **Respect the filter** — Apply the level and the enabled dimensions from the scope filter. Do not re-derive them from memory.
6. **Cite dimensions** — When reporting issues or justifying fixes, reference the dimension id and the full name from the table (for example, "hooks — Rules of Hooks") and the rule id when a row matches (for example, `R1`). Cite only enabled dimensions. Do not cite an id that is not in `references/react-rules.md`.
7. **Do not overclaim** — Classify every finding as code, hybrid, or manual. A `pass` needs evidence. Use the report format below. Never state that a module, package, or project is "fully React" or "React compliant".

## Key Rules

Each bullet is one dimension. Skip it when that dimension is not enabled. The table is the definition. These lines are the generation reminder.

- **hooks** — Call hooks at the top level of a function component or a custom hook. Do not call them from conditions, loops, or plain functions.
- **boundary** — In a server/client tree, `"use client"` sits on the leaf that needs state, effects, or events. Server Components do not call client hooks. Props that cross the boundary are serializable.
- **state** — Compute values during render. Use an effect to subscribe to something outside React, not to copy props into state.
- **key** — A list key is a stable id among siblings. Do not use the index when the list can reorder, filter, or insert. Do not use a random key.

## Level behavior

| Level | Behavior |
|-------|----------|
| `pragmatic` | File broken hook order, non-serializable server props, effects that mirror props, and index keys on lists that reorder. Leave mount fetches, subscriptions, and `"use client"` on interactive leaves alone. |
| `strict` | Every hook call, client boundary, derived value, and list key in scope follows the closed list. Every enabled dimension applies. |
| `educational` | Same technical bar as `pragmatic`, plus an explicit rationale for each enabled dimension on every material component or hook. |

## Where a change goes

Edit the catalog that owns the change. Do not paste the same body into this procedure, the rule, and the subagent.

| Change | Edit |
|--------|------|
| Default level, example languages, or enabled dimensions | `react.config.json` |
| What a dimension means, a pass/fail signal, or severity | `references/principles-table.md` |
| The eight React rules or which dimension a rule maps to | `references/react-rules.md` |
| A smell | `references/anti-patterns.md` |
| An implementation shape | `references/code-patterns.md` |
| A layer, a hunt, or a coverage checkbox | `references/audit-coverage.md` |
| A new level or dimension token | The allowed tokens at the top of this file, the level table if it is a level, then a row in `references/principles-table.md` |
| Evidence rules or the report format | This file, in "Audits — what the code can decide" |

A new smell, layer, or code shape does not belong in this file. The rule may keep one reminder per dimension. The subagent reads this file and does not keep a second template.

## When to Load References

- Defaults, every run → `react.config.json`
- Closed React rules (R1–R8), every run → `references/react-rules.md`
- Dimension meaning, pass/fail, severity → `references/principles-table.md`
- Implementation shapes → `references/code-patterns.md`
- Smell catalog → `references/anti-patterns.md`
- Package or app audit → `references/audit-coverage.md`

## Common failures

Judgment traps only. Concrete smells live in `references/anti-patterns.md`. Layer hunts live in `references/audit-coverage.md`. Do not treat this section as a substitute for those catalogs.

- Do not claim a package or project is "fully React" or "React compliant".
- Do not stop after the first conditional hook or the first clean component.
- At `pragmatic`, a client fetch on mount or `"use client"` on a button is not Critical — but a hook after `return`, or an effect that copies props into state, still escalates.
- Do not require `"use client"` in a client-only app.
- Do not file missing alt text, contrast, a focus ring, untrusted HTML, a missing port, or a mixed-level function as React.
- Do not trust `Safe*`, `Pure*`, or `Memo*` names without reading the body.

Always explain the React rationale when generating or refactoring code. Name the dimension.

## Audits — what the code can decide

This section is the only copy of the evidence rules and the report format. The `react-reviewer` subagent reads them from here and returns the report to the parent. The parent applies fixes.

A source review is a React assessment. It is not proof the UI is correct. Do not write that a module, package, or project is "fully React" or "React compliant".

Evidence rules:

- Status `pass` only with evidence: a repository location `path:line`, or a structural property named with the file that shows it. With no such evidence the status is `needs verification`.
- One clean component does not close the dimension for the package. Record the scope of the evidence.
- On a package or app review, a pass on one file does not close the dimension for the package. File the same smell at every in-scope layer where it appears, or mark that layer absent.
- Prefer the smallest change that restores the rule. Do not rewrite the screen.
- Discuss dimensions that are in the resolved `dimensions` list. A dimension outside that list is out of scope, not a pass.
- `boundary` with no server/client split in the tree is `n/a — no server components`, not a pass and not a violation.

Dimension disambiguation (before filing):

1. Pick **one primary dimension** per symbol. Add a second only when it is a separate contract (or the catalog explicitly allows “also counts”).
2. A hook in a condition, loop, event handler, or plain function → **hooks** (R1 or R2).
3. A Server Component imports a `"use client"` module that has no state, effect, or event → **boundary** (R6). The directive with no server importer is not R6. A client hook in a Server Component, or a function passed from a Server Component → **boundary** (R7 or R8). Skip the whole dimension when the app is client-only.
4. An effect that `setState`s a value already computable in render, or that copies a prop into state on every change → **state** (R3 or R4). A subscription or a mount fetch is not state.
5. `key` is the index or a random value on a list that can change order → **key** (R5). A missing key on a dynamic list is **key**. An index on a static list is not a finding at `pragmatic`.
6. Do not stamp security, WCAG, SOLID, KISS, structure, or TDD onto a React rule. Untrusted HTML is security **injection**. A missing label is WCAG.

Put each finding into one class:

- **Code** — the source alone shows a violation or a satisfied check. Examples: `useState` after `if (!ready) return null`; an effect that does `setFullName(first + " " + last)`; `key={index}` while the list is sorted in that function; a Server Component that passes `onClick` to a client child.
- **Hybrid** — the source shows a risk; confirmation needs the parent or the framework mode. Examples: a file without `"use client"` that might still be imported only from a client module; a list that might be static even though it uses an index.
- **Manual** — needs a product judgment. Examples: whether a module should stay a Server Component; whether a list is append-only forever.

### Report format

Use this structure for every review. The summary counts findings. It does not certify the package.

```
## Review result
Scope: <files or module>
Level: <from react.config.json, unless the user overrode it>
Dimensions: <enabled set>
Verdict: this is a React assessment, not a certification.

### Coverage (package/app audits)
- Layers swept: <components | hooks | pages | layouts | client-modules>
- Gate: pass | incomplete — <missing hunt or “folder absent”>

### Violations visible in code
- Location: path:line
- Dimension: hooks | boundary | state | key — <name>
- Rule: <R1–R8 from react-rules.md> | n/a
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
- What is missing: no path:line, or the server/client split is outside this file
```

If a section has no items, write "None in this scope." Do not invent a pass. A pass needs `path:line`, or a structural property named with the file that shows it. Otherwise the check goes under "Needs verification".
For a single file, `### Coverage` may say `n/a — file-scoped`. Whenever `audit-coverage.md` was loaded, include `### Coverage`. An incomplete gate means keep searching. Do not close the report on the first conditional hook alone.
