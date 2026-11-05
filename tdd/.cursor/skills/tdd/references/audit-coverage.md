# TDD Audit Coverage — Package / App Sweep

This file is the only copy of the layer sweep and the coverage gate. Add a layer or a hunt here, not in `SKILL.md`, the rule, or `tdd-reviewer`.

**When to load:** more than one file, or any package/app scope **in audit mode**. Do not use this checklist for single-file scope — still review that file. Do not use this checklist for a single-feature **plan** — plans use the plan format in `SKILL.md`.

Goal: stop “one weak `it`” audits that miss the same cycle break or the same bad oracle in adapters, HTTP, UI, and jobs.

Load with `anti-patterns.md` and `principles-table.md`. Report every hit with `path:line` + dimension id. Do not edit files.

## Hard rules (fail the audit if you skip them)

1. **Do not stop after the first weak test.** One critical finding does not clear the package.
2. **Do not trust filenames.** `*spec*`, `*test*`, `__tests__`, `*.test.ts` can still spy on privates or skip oracles — read the body.
3. **One clean test is not a package pass.** A pure helper case may be fine while handlers still lack reds for new behavior — keep sweeping.
4. **Same smell, many layers.** If tautologies or kitchen-sink cases appear in unit **and** HTTP **and** worker tests, file **each** location (or one finding that lists every path:line).
5. **Search before declaring "tests look fine".** Ripgrep for `toBeDefined`, `not.toThrow`, `spyOn`, `any)`, `setTimeout`, `beforeEach`, and sibling `*.test.*` / `*.spec.*`. "I only opened one file" is not a pass.
6. **Sibling dimensions on the same symbol.** After you file kitchen-sink, spy-only, cycle break, act-in-`beforeEach`, live I/O, or sleep on a case, immediately re-check that same `it` / suite for the other enabled dimensions (focus, oracle, isolation, arrange, behavior, cycle). File each independent fail. One primary finding does not close the other axes for that symbol.
7. **Do not recommend a new test framework.** A TDD fix reshapes cases and oracles — not a second runner "just in case".
8. **Do not import other presets' findings.** A missing port is not cycle. A train wreck is not arrange. Nested `if` clarity alone is KISS flow. Untrusted HTML is security injection.
9. **Do not edit.** Describe the fix for the parent; leave the tree unchanged.
10. **Cycle on a package audit** needs evidence of **new/changed behavior** without a failing case (diff, new export, or unmatched requirement) — not "coverage % is low" alone.

## Mandatory layer sweep

Walk **every** layer that exists in scope. Skip a row only if that folder is absent.

| Layer | Typical paths | What to hunt |
|-------|---------------|--------------|
| Unit / domain | `**/*.test.ts`, `**/*.spec.ts`, colocated tests under `domain/`, `services/` | Missing red for new rules (cycle); private spies (behavior); weak oracles; kitchen-sink `it` (focus); AAA noise (arrange) |
| Fixtures / factories | `fixtures/`, `factories/`, `test-utils/` | Shared mutable bleed (isolation); act hidden in factories (arrange); tautological fixture self-checks (oracle) |
| Adapters | `payments/`, `mail/`, `gateways/` + their tests | Real network in unit tests (isolation); mocks that reimplement domain (behavior) |
| HTTP / API | controller/route tests, `supertest`, nest testing module | Mega-cases that mix auth+body+persist (focus); no failing case for new endpoints (cycle); only `status(201)` without body contract (oracle) |
| UI | component tests, testing-library | Asserting implementation class names / `props.children` / fiber shape (behavior); weak defined-only on elements (oracle); giant render setup hiding the act (arrange) |
| Jobs / workers | `worker/`, `jobs/` tests | Time sleeps (isolation); no red for new job behavior (cycle); call-order spies (behavior) |

## Dimension hunt lists (search the tree)

Use ripgrep / file reads. Record hits even when the file looks “peripheral”. Then apply the false-positive list before filing.

### cycle

- New production exports / handlers in the diff with no new or updated failing test.
- Large post-hoc test files added in the same commit as the full feature (inverted cycle) — file when the suite only mirrors implementation.
- At `pragmatic`, **notice** refactors with existing greens. **File** when new behavior has no red. Notice ≠ violation.

### behavior

- `spyOn(... as any`, access to `_private`, `["privateMethod"]`, call-order matchers as the only oracle.
- Mocks whose setup is a second copy of the production algorithm.
- UI asserts on `props.children`, className trees, or element shape instead of visible text/roles (often beside a weak oracle — file **both**).

### focus

- `it(` / `test(` bodies with many unrelated `expect` topics (auth + money + HTML).
- Single cases named `works` / `handles everything`.
- Suites where one shared mutable / shared act in `beforeEach` drives several unrelated rules across cases — file **focus** on the suite (and isolation/arrange when those signals apply).

### oracle

- `toBeDefined`, `toBeTruthy`, `not.toThrow` as the sole expect on domain results.
- `expect(x).toEqual(x)` or expected object built by calling the SUT twice.

### isolation

- `setTimeout`, `sleep`, real `fetch`/`axios` without a fake, `Date.now()` coupled to wall clock, shared `let` mutated across cases.
- Order-dependent cases (`it.only` leftovers, reliance on previous `it`).
- Production or specs that call wall clock / sleep with **no injected clock** — even when you already filed **cycle** for missing reds on that API.

### arrange

- `beforeEach` that runs the act; helpers named `setupAndRun`; asserts before the triggering call.

## Minimum coverage gate (package audit)

Before finishing a package/app review, confirm you can answer **yes** or cite “absent in tree”:

- [ ] Cycle hunt against new/changed behavior **or** explicit “no new behavior in scope”
- [ ] Behavior hunt (private spies / call-order-only) **or** explicit “searched, none”
- [ ] Oracle hunt (`toBeDefined` / `not.toThrow` / tautology) **or** explicit “searched, none”
- [ ] Isolation hunt (sleep / live I/O / fixture bleed) **or** explicit “searched, none”
- [ ] Focus / arrange sampled on the heaviest specs **or** those files absent
- [ ] For every kitchen-sink, spy-only, cycle-break, or flaky case already cited, sibling axes on that symbol were checked (oracle / isolation / arrange / focus as applicable) **or** explicit “no second axis”
- [ ] Every cycle finding on a clock- or I/O-sensitive API was re-checked for **isolation** on the matching spec (injected clock / fake / seam) **or** explicit “seam present”
- [ ] Adapters or HTTP or jobs swept **or** that edge absent
- [ ] No finding whose real axis is SOLID, coupling, KISS, structure, security, or WCAG
- [ ] No files were edited by the reviewer

If any checkbox is unchecked without a written reason (“folder missing” / “searched, none”), the audit is incomplete — keep searching.

## Reporting duplicates

Prefer:

```
- Location: packages/ledger/src/hull-premium.test.ts:12; apps/api/src/payouts/payout.controller.spec.ts:40
- Dimension: oracle — Meaningful assertions
- Why: both cases only use toBeDefined on the premium result; a wrong rate still passes
```

One finding may list many paths. Do not open a second identical finding per file unless the parent asked for a file-scoped list.
