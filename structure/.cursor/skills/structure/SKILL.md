---
name: structure
description: "Design, implement, and review function and local structure: Single Level of Abstraction (SLAP) and guarded DRY (search before invent; extract when copies share a change reason). Defaults come from structure.config.json (shipped as pragmatic). Use when writing or refactoring helpers, near-duplicate functions, mixed-level bodies, or when the user asks for SLAP, DRY, duplication, extract shared, or one level of abstraction."
paths: "**/*.{ts,tsx,js,jsx,mjs,cjs,py,java,kt,cs,go}"
---

# Structure — SLAP & guarded DRY

Use this skill whenever designing, implementing, refactoring, or reviewing the shape of functions and local duplication.

**Defaults come from `structure.config.json` in this skill folder** (`level`: `pragmatic`, `strict`, or `educational`; `dimensions`: a list of `slap`, `dry`). Read that file first on every run. The shipped file is pragmatic with both dimensions.
A level or dimension set stated in the chat overrides the file for that request. Do not ask when the file already has a valid combination.
If the file is missing, a level is not one of the tokens above, a dimension id is outside the two above, or `dimensions` is empty, use pragmatic and both dimensions.

`languages` in that file is example syntax only. It does not select files and it does not turn a dimension on or off. Patterns in `references/code-patterns.md` are TypeScript. Adapt the syntax to the file you are editing. Adding a language does not need a new reference file.

**Scope filter.** After level and dimensions are resolved, apply only the enabled dimensions. A dimension absent from `dimensions` is out of scope. Skip its bullets. Do not file it.

Level behavior has one copy: the table under "Level behavior". The rule file may name the three levels in one line so generation works before this skill is opened. It must not grow a second definition. Once this file is loaded, that table wins.

The markdown references are the working catalogs. This file is the procedure. If a catalog does not settle a case, use that dimension's question in `references/principles-table.md`. Do not invent a third dimension.

Keep each function at one level of abstraction. Before adding a new helper or near-copy, search the repo for an existing implementation of the same behavior and prefer extending or parameterizing it when copies share a reason to change. Structure complements SOLID, KISS, and coupling. A god module is SOLID **S**. Speculative factories and unused options are KISS **yagni** / **surface**. A train wreck is coupling **lod**. Do not extract solely because two snippets look alike. Do not claim code must be "as DRY as possible".

The parent agent implements fixes in its own context. `/structure-reviewer` is a separate readonly audit: it returns the report below and does not edit. Do not start it after ordinary generation or editing. Start it when the user asks for an audit or a parent explicitly delegates one.

## Core Workflow

1. **Read defaults** — Load `structure.config.json` (same folder as this file; in a project, `.cursor/skills/structure/structure.config.json`). Use it unless the user overrides it in chat.
2. **Scope the change** — Identify the functions and near-duplicates in scope. Prefer the smallest change that flattens mixed levels or collapses justified copies.
3. **Apply enabled dimensions** — Load `references/principles-table.md` and cover every enabled dimension. That table is the working source for meaning, pass/fail, and severity. Load `references/code-patterns.md` when implementing. Load `references/anti-patterns.md` when reviewing. Skip rows for dimensions that are out of scope.
4. **Package / app reviews** — When the scope is more than one file, or any package/app scope, load `references/audit-coverage.md` and run its layer sweep and coverage gate before finishing. That file owns the trigger and the sweep. Do not stop after the first mixed-level function. A pass on one file does not close the dimension for the package. For a single-file review, do not use `audit-coverage.md` — still review that file.
5. **Respect the filter** — Apply the level and the enabled dimensions from the scope filter. Do not re-derive them from memory.
6. **Cite dimensions** — When reporting issues or justifying refactors, reference the dimension id and the full name from the table (for example, "slap — Single Level of Abstraction"). Cite only enabled dimensions.
7. **Do not overclaim** — Classify every finding as code, hybrid, or manual. A `pass` needs evidence. Use the report format below. Never state that a module, package, or project is "fully SLAP" or "maximally DRY".

## Key Rules

Each bullet is one dimension. Skip it when that dimension is not enabled. The table is the definition. These lines are the generation reminder.

- **slap** — Keep statements in one function at the same level of abstraction. Orchestrate with named steps; do not interleave high-level policy with low-level I/O or bit fiddling in the same body.
- **dry** — Before adding a new path, search for an existing implementation of the same behavior. Prefer extend or parameterize over a near-copy when copies share a change reason. Do not extract on resemblance alone.

## Level behavior

| Level | Behavior |
|-------|----------|
| `pragmatic` | File mixed-level bodies where policy and plumbing share one function, and near-duplicates (≈3+ sites or clear twin policies) that share a change reason. Allow short similar mappers and one-off edge adapters. |
| `strict` | Challenge every mixed-level step and every near-duplicate pair in scope that shares a change reason. Every enabled dimension applies. |
| `educational` | Same technical bar as `pragmatic`, plus an explicit rationale for each enabled dimension on every material function or duplication decision. |

## Where a change goes

Edit the catalog that owns the change. Do not paste the same body into this procedure, the rule, and the subagent.

| Change | Edit |
|--------|------|
| Default level, example languages, or enabled dimensions | `structure.config.json` |
| What a dimension means, a pass/fail signal, or severity | `references/principles-table.md` |
| A smell | `references/anti-patterns.md` |
| An implementation shape | `references/code-patterns.md` |
| A layer, a hunt, or a coverage checkbox | `references/audit-coverage.md` |
| A new level or dimension token | The allowed tokens at the top of this file, the level table if it is a level, then a row in `references/principles-table.md` |
| Evidence rules or the report format | This file, in "Audits — what the code can decide" |

A new smell, layer, or code shape does not belong in this file. The rule may keep one reminder per dimension. The subagent reads this file and does not keep a second template.

## When to Load References

- Defaults, every run → `structure.config.json`
- Dimension meaning, pass/fail, severity → `references/principles-table.md`
- Implementation shapes → `references/code-patterns.md`
- Smell catalog → `references/anti-patterns.md`
- Package or app audit → `references/audit-coverage.md`

## Common failures

Judgment traps only. Concrete smells live in `references/anti-patterns.md`. Layer hunts live in `references/audit-coverage.md`. Do not treat this section as a substitute for those catalogs.

- Do not claim a package or project is "fully SLAP", "DRY compliant", or "as DRY as possible".
- Do not stop after the first long function or the first clean helper.
- At `pragmatic`, two short similar DTO maps or two HTTP handlers with different contracts are not Critical — but twin domain policies with five near-copies still escalate.
- Do not extract a shared module "for future variants". That is KISS **yagni**, not a structure win.
- Do not file a missing port, a god class, a train wreck without a twin body, or nested `if` clarity alone as structure. Those belong to SOLID, coupling, or KISS unless the cited lines are specifically mixed levels or justified duplication. A free function that pastes an owner method's control flow is still **dry** — do not drop it because the same site is also Tell, Don't Ask.
- Do not trust `Shared*`, `Common*`, `Base*`, or `Utils` names without reading whether the body is a real shared rule or a junk drawer.

Always explain the structure rationale when generating or refactoring code. Name the dimension.

## Audits — what the code can decide

This section is the only copy of the evidence rules and the report format. The `structure-reviewer` subagent reads them from here and returns the report to the parent. The parent applies fixes.

A source review is a structure assessment. It is not a proof that the codebase has no duplication. Do not write that a module, package, or project is "fully SLAP" or "maximally DRY".

Evidence rules:

- Status `pass` only with evidence: a repository location `path:line`, or a structural property named with the file that shows it. With no such evidence the status is `needs verification`.
- One clean function does not close the dimension for the package. Record the scope of the evidence.
- On a package or app review, a pass on one file does not close the dimension for the package. File the same smell at every in-scope layer where it appears, or mark that layer absent.
- Prefer the smallest extract that removes mixed levels or collapses copies that share a change reason. Do not invent a framework.
- Discuss dimensions that are in the resolved `dimensions` list. A dimension outside that list is out of scope, not a pass.
- For **dry**, a High or Critical finding needs named twin locations (`path:line` for each copy) and a stated shared change reason. "Looks similar" alone is Medium at most, or skip at `pragmatic`.

Dimension disambiguation (before filing):

1. Pick **one primary dimension** per symbol. Add a second only when it is a separate contract (or the catalog explicitly allows “also counts”).
2. High-level steps mixed with low-level I/O, parsing, or bit/byte work in one function → **slap**. Deep nesting that is still one abstraction level is KISS **flow**, not slap.
3. Near-identical or parameterized-twin policies / helpers that should change together → **dry**. Accidental resemblance (two maps, two unrelated handlers) is not dry.
4. Speculative shared abstraction with one caller or unused options → KISS **yagni** / **abstraction** / **surface**, not dry. Do not stamp dry for "could be shared someday".
5. A long function that is one level but does many jobs → prefer SOLID **S** if responsibilities diverge; slap only when levels mix.
6. Same twin set is both mixed-level and duplicated: primary **dry** when the fix is one parameterized helper; **slap** also counts when each copy still mixes levels after merge.
7. Ask-then-decide / train wreck **without** a pasted twin body → coupling, not structure. Free function that pastes `Type.method` control flow → **dry** (list both paths); mention coupling only as out-of-scope note, do not skip the dry finding.

Put each finding into one class:

- **Code** — the source alone shows a violation or a satisfied check. Examples: a service method that validates, writes SQL strings, and formats HTML in one body (slap); five `calculateXFee` twins that differ by one literal (dry); a new helper pasted beside an existing one with the same control flow (dry).
- **Hybrid** — the source shows a risk; confirmation needs more modules or product intent. Examples: two helpers that might intentionally diverge per tenant; a function whose "low level" steps might be the right grain for that layer; a shared util that might be the wrong boundary.
- **Manual** — needs a product or ownership judgment. Examples: whether two domains must stay copy-paste separated for legal reasons; whether a package boundary forbids a shared module; whether the team accepts duplication at an anti-corruption edge.

### Report format

Use this structure for every review. The summary counts findings. It does not certify the package.

```
## Review result
Scope: <files or module>
Level: <from structure.config.json, unless the user overrode it>
Dimensions: <enabled set>
Verdict: this is a structure assessment, not a certification.

### Coverage (package/app audits)
- Layers swept: <types | utils | services | adapters | api | components | pages | jobs>
- Gate: pass | incomplete — <missing hunt or “folder absent”>

### Violations visible in code
- Location: path:line
- Dimension: slap | dry — <name>
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
For a single file, `### Coverage` may say `n/a — file-scoped`. Whenever `audit-coverage.md` was loaded, include `### Coverage`. An incomplete gate means keep searching. Do not close the report on the longest function alone.
