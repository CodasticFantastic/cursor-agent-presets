---
name: tdd
description: "Plan Test-Driven Development (red-green-refactor) and audit test quality: cycle, behavior, focus, oracle, isolation, arrange. Defaults come from tdd.config.json (shipped as pragmatic). Plan-only and audit-only — does not edit files. Use when the user asks for TDD, a failing-test plan, red-green-refactor, or a review of specs, mocks, flaky tests, or weak assertions."
paths: "**/*.{ts,tsx,js,jsx,mjs,cjs,py,java,kt,cs,go}"
---

# TDD — Plan red-green-refactor & audit test quality

Use this skill whenever the user wants a TDD plan for new behavior, or a review of existing tests against the enabled dimensions.

**Defaults come from `tdd.config.json` in this skill folder** (`level`: `pragmatic`, `strict`, or `educational`; `dimensions`: a list of `cycle`, `behavior`, `focus`, `oracle`, `isolation`, `arrange`). Read that file first on every run. The shipped file is pragmatic with all six dimensions.
A level or dimension set stated in the chat overrides the file for that request. Do not ask when the file already has a valid combination.
If the file is missing, a level is not one of the tokens above, a dimension id is outside the six above, or `dimensions` is empty, use pragmatic and all six dimensions.

`languages` in that file is example syntax only. It does not select files and it does not turn a dimension on or off. Patterns in `references/code-patterns.md` are TypeScript. Adapt the syntax to the file you are describing. Adding a language does not need a new reference file.

**Scope filter.** After level and dimensions are resolved, apply only the enabled dimensions. A dimension absent from `dimensions` is out of scope. Skip its bullets. Do not file it.

Level behavior has one copy: the table under "Level behavior". The rule file may name the three levels in one line so generation works before this skill is opened. It must not grow a second definition. Once this file is loaded, that table wins.

The markdown references are the working catalogs. This file is the procedure. If a catalog does not settle a case, use that dimension's question in `references/principles-table.md`. Do not invent a seventh dimension.

**Plan-only / audit-only.** This skill and `/tdd-reviewer` **do not edit** source files, test files, configs, or snapshots. Return a plan or a report. The parent agent (or a human) implements under `.cursor/rules/tdd.mdc`. If the user asks you to write the tests here, refuse the edit, return the plan (or report), and say the parent applies it.

TDD complements SOLID, KISS, coupling, structure, security, and WCAG. A missing port is SOLID **D**. Speculative options are KISS **yagni**. A train wreck is coupling. Untrusted HTML is security **injection**. A focus ring is WCAG. Do not file those as TDD.

The parent agent implements in its own context. `/tdd-reviewer` is a separate readonly audit: it returns the report below and does not edit. Do not start it after ordinary generation or editing. Start it when the user asks for an audit or a parent explicitly delegates one.

## Core Workflow

1. **Read defaults** — Load `tdd.config.json` (same folder as this file; in a project, `.cursor/skills/tdd/tdd.config.json`). Use it unless the user overrides it in chat.
2. **Choose mode** — **Plan** when the user asks for TDD help, a failing-test sequence, or red-green-refactor for new/changed behavior. **Audit** when the user asks for a review of tests, specs, mocks, flakes, or oracles, or when `/tdd-reviewer` runs. If both are requested, plan first, then audit only existing files — still without editing.
3. **Scope the change** — Identify the behavior under change and the tests (or missing tests) in scope. Prefer the smallest plan that drives the known requirement.
4. **Apply enabled dimensions** — Load `references/principles-table.md` and cover every enabled dimension. That table is the working source for meaning, pass/fail, and severity. Load `references/code-patterns.md` when shaping a plan or suggesting a fix shape. Load `references/anti-patterns.md` when reviewing. Skip rows for dimensions that are out of scope.
5. **Package / app reviews** — When the audit scope is more than one file, or any package/app scope, load `references/audit-coverage.md` and run its layer sweep and coverage gate before finishing. That file owns the trigger and the sweep. Do not stop after the first weak `it`. A pass on one file does not close the dimension for the package. For a single-file review, do not use `audit-coverage.md` — still review that file. Plans for a single feature do not need `audit-coverage.md`.
6. **Respect the filter** — Apply the level and the enabled dimensions from the scope filter. Do not re-derive them from memory.
7. **Cite dimensions** — When planning steps or reporting issues, reference the dimension id and the full name from the table (for example, "cycle — Red-green-refactor"). Cite only enabled dimensions.
8. **Do not overclaim** — Classify every audit finding as code, hybrid, or manual. A `pass` needs evidence. Use the plan or report format below. Never state that a module, package, or project is "fully TDD" or "TDD compliant".
9. **Do not edit** — Do not create, patch, or delete files. Describe paths and snippets in the plan/report only.

## Key Rules

Each bullet is one dimension. Skip it when that dimension is not enabled. The table is the definition. These lines are the planning and review reminder.

- **cycle** — New behavior: failing test first, then the smallest green, then refactor without new requirements.
- **behavior** — Lock observable outcomes and public contracts, not private helpers or internal call graphs.
- **focus** — One reason to fail per test (or a tightly related case set).
- **oracle** — Assert a concrete outcome. Reject tautologies and "didn't throw" alone for domain logic.
- **isolation** — Deterministic: seams at I/O, no shared mutable bleed, no flakes.
- **arrange** — Keep Arrange-Act-Assert (or given/when/then) readable; do not bury the act in fixture noise.

## Level behavior

| Level | Behavior |
|-------|----------|
| `pragmatic` | File clear cycle breaks and test-quality sinks the source already shows. Leave tiny smoke checks and framework boilerplate alone when they are not the contract under change. |
| `strict` | Every new behavior in scope needs a planned failing case; every enabled dimension applies to the tests in scope. |
| `educational` | Same technical bar as `pragmatic`, plus an explicit rationale for each enabled dimension on every material plan step or finding. |

## Where a change goes

Edit the catalog that owns the change. Do not paste the same body into this procedure, the rule, and the subagent.

| Change | Edit |
|--------|------|
| Default level, example languages, or enabled dimensions | `tdd.config.json` |
| What a dimension means, a pass/fail signal, or severity | `references/principles-table.md` |
| A smell | `references/anti-patterns.md` |
| A plan or test shape | `references/code-patterns.md` |
| A layer, a hunt, or a coverage checkbox | `references/audit-coverage.md` |
| A new level or dimension token | The allowed tokens at the top of this file, the level table if it is a level, then a row in `references/principles-table.md` |
| Evidence rules, plan format, or report format | This file, in "Plans" and "Audits — what the code can decide" |

A new smell, layer, or code shape does not belong in this file. The rule may keep concrete test-writing principles per dimension. The subagent reads this file and does not keep a second template.

## When to Load References

- Defaults, every run → `tdd.config.json`
- Dimension meaning, pass/fail, severity → `references/principles-table.md`
- Plan / test shapes → `references/code-patterns.md`
- Smell catalog → `references/anti-patterns.md`
- Package or app audit → `references/audit-coverage.md`

## Common failures

Judgment traps only. Concrete smells live in `references/anti-patterns.md`. Layer hunts live in `references/audit-coverage.md`. Do not treat this section as a substitute for those catalogs.

- Do not edit test or production files from this skill or from `/tdd-reviewer`.
- Do not claim a package or project is "fully TDD" or "TDD compliant".
- Do not stop an audit after the first weak assertion, and do not stop after the first dimension on a bad `it` — re-check focus, oracle, isolation, and arrange on that same case when their signals are present.
- At `pragmatic`, a tiny framework smoke `it` is not Critical — but a new domain rule with no failing case still escalates.
- Do not treat a green suite that only spies on private methods as a cycle win.
- Do not file a missing port, god class, train wreck, focus ring, or security sink as TDD.
- Do not recommend a speculative multi-mode test framework "for future cases" as a TDD fix.

Always explain the TDD rationale when planning or reviewing. Name the dimension.

## Plans — ordered red-green-refactor

This section is the only copy of the plan format. Use it in **Plan** mode. Do not implement the steps here.

A plan is guidance for the parent. It is not a certification that the feature will be correct.

Plan rules:

- Order cases from the smallest failing behavior to broader ones.
- Each red step names: suggested test path, example test name, what fails before green, and which enabled dimensions it exercises.
- Green describes the **smallest** production change that should pass that case — as description, not as a patch.
- Refactor lists cleanup that does not add requirements.
- Cite only enabled dimensions.
- At `educational`, add a one-line rationale per enabled dimension on each material step.

### Plan format

```
## TDD plan
Scope: <behavior or feature>
Level: <from tdd.config.json, unless the user overrode it>
Dimensions: <enabled set>
Mode: plan — no files were edited.

### Red (failing cases, in order)
1. Test: <suggested path>::<example name>
   Assert: <concrete outcome>
   Why red: <what is missing or wrong today>
   Dimensions: <ids>

### Green (minimum to pass, in order)
1. After red #n: <smallest production change>
   Dimensions: <ids>

### Refactor (no new requirements)
- <cleanup>
  Dimensions: <ids>

### Out of scope
- <behavior not in this plan>
```

If a section has no items, write "None." Do not invent production code. Do not write a full test file body unless a short illustrative snippet clarifies the assert — prefer names and assert intent over paste-ready suites.

## Audits — what the code can decide

This section is the only copy of the evidence rules and the report format. The `tdd-reviewer` subagent reads them from here and returns the report to the parent. The parent applies fixes.

A source review is a TDD / test-quality assessment. It is not proof the suite is complete. Do not write that a module, package, or project is "fully TDD" or "TDD compliant".

Evidence rules:

- Status `pass` only with evidence: a repository location `path:line`, or a structural property named with the file that shows it. With no such evidence the status is `needs verification`.
- One clean test does not close the dimension for the package. Record the scope of the evidence.
- On a package or app review, a pass on one file does not close the dimension for the package. File the same smell at every in-scope layer where it appears, or mark that layer absent.
- Prefer the smallest change that restores cycle or test quality. Do not invent a second test framework.
- Discuss dimensions that are in the resolved `dimensions` list. A dimension outside that list is out of scope, not a pass.

Dimension disambiguation (before filing):

1. **One smell axis → one finding.** Do not merge unrelated axes into a single vague note. Prefer one primary dimension **per finding**.
2. **Same `it` / symbol can earn multiple findings** when it independently fails more than one dimension question from `principles-table.md`. Example: a kitchen-sink case that also uses only `toBeDefined` and a `setTimeout` → file **focus**, **oracle**, and **isolation** (separate bullets, or one bullet that lists each dimension explicitly). Stopping after the first smell on that case is an incomplete audit.
3. Do **not** invent a second finding for the same axis restated twice. Two weak expects that are both **oracle** on the same `it` stay one oracle finding.
4. New behavior without a failing case, or green that sneaks features, or "refactor" that adds requirements → **cycle**. A post-hoc suite that also never locks concrete outcomes may need **cycle** (inverted order) **and** **oracle** (no numeric/state contract) when both signals are present.
5. Asserts on private helpers / internal call graphs / UI structure (`props.children`, className trees) instead of public outcomes → **behavior**. If that same case is also a kitchen-sink or has only `toHaveBeenCalled()` / `toBeDefined`, still run **focus** / **oracle** on it.
6. Unrelated expects piled into one `it`, or one shared setup driving several unrelated rules across a suite → **focus**.
7. Tautology, empty expect, or "didn't throw" alone for domain logic → **oracle**.
8. Real I/O without a seam, fixture bleed, sleeps, order dependence → **isolation**. A cycle break on a clock-sensitive API does not replace an **isolation** finding when the spec has no injected clock and uses wall time / sleep — re-check isolation before closing that cycle finding.
9. Act buried in setup / unreadable AAA → **arrange**.
10. Do not stamp SOLID, KISS, coupling, structure, security, or WCAG onto a TDD finding.

Put each finding into one class:

- **Code** — the source alone shows a violation or a satisfied check. Examples: production-only diff for a new rule with no new failing test; `expect(fn).not.toThrow()` as the only oracle; `jest.spyOn(svc, 'privateHelper')` as the only assert; shared mutable `let db` mutated across cases without reset.
- **Hybrid** — the source shows a risk; confirmation needs another module or product intent. Examples: a test file that might be backed by a higher-level contract test elsewhere; a snapshot that might be the team’s chosen oracle.
- **Manual** — needs a product or ownership judgment. Examples: whether an E2E with real network is intentional for that package; whether two domains must share one kitchen-sink scenario for compliance demos.

### Report format

Use this structure for every review. The summary counts findings. It does not certify the package.

```
## Review result
Scope: <files or module>
Level: <from tdd.config.json, unless the user overrode it>
Dimensions: <enabled set>
Verdict: this is a TDD / test-quality assessment, not a certification.
Mode: audit — no files were edited.

### Coverage (package/app audits)
- Layers swept: <unit domain | adapters | http | ui | jobs | fixtures>
- Gate: pass | incomplete — <missing hunt or “folder absent”>

### Violations visible in code
- Location: path:line
- Dimension: cycle | behavior | focus | oracle | isolation | arrange — <name>
- Class: code
- Severity: Critical | High | Medium
- Why it fails:
- Fix: <guidance for the parent — do not apply it here>

### Satisfied checks
- Dimension:
- Status: pass
- Evidence: path:line
- Scope: this file or this module. This pass does not close the dimension for the package.

### Needs verification
- Dimension:
- Status: needs verification
- Class: hybrid | manual
- What is missing: no path:line, or judgment outside scope
```

If a section has no items, write "None in this scope." Do not invent a pass. A pass needs `path:line`, or a structural property named with the file that shows it. Otherwise the check goes under "Needs verification".
For a single file, `### Coverage` may say `n/a — file-scoped`. Whenever `audit-coverage.md` was loaded, include `### Coverage`. An incomplete gate means keep searching. Do not close the report on the first weak `it` alone.
