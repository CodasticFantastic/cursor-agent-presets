# TDD Dimensions Checklist

Working source for what each dimension means, the pass/fail signals, and severity. The skill points here. Do not copy this table into `SKILL.md`, the rule, or `tdd-reviewer`.

Level names, the fallback, and which dimensions are in scope live in `SKILL.md`. The section below only changes severity. Examples: TypeScript / Vitest-Jest. Adapt syntax to the file. A new language does not need a second table.

The skill and reviewer **plan or audit only**. They do not edit test or production files. Pass/fail below still apply to source the parent already wrote, and to the quality of a plan the skill returns.

| Id | Name | Question to ask | Pass signal | Fail signal |
|----|------|-----------------|-------------|-------------|
| **cycle** | Red-green-refactor | Does new behavior start with a failing test, then minimum green, then refactor without new requirements? | Plan or diff shows a red case first; green is the smallest change that passes; refactor does not add features | Production change for new behavior with no failing case planned or present; green that also invents extras; "refactor" that sneaks new requirements |
| **behavior** | Behavior over internals | Does the test lock an observable outcome or public contract? | Asserts return value, thrown domain error, persisted public state, or rendered output through a public API | Asserts private helpers, call order of internals, mock graphs that mirror implementation, or UI structure (`props.children`, className trees) instead of observable output |
| **focus** | One reason to fail | Does one test have one reason to fail (or a tightly related case set)? | Name and body target one rule or one branch; table-driven rows stay one concern | Kitchen-sink `it` that covers happy path, auth, persistence, and formatting; unrelated expects piled in one case; shared setup driving several unrelated rules across a suite |
| **oracle** | Meaningful assertions | Does the assertion check a concrete outcome? | Expected value, error kind/message contract, or state delta is named | Only `toBeDefined` / `toBeTruthy`; empty `expect`; "didn't throw" alone for domain logic; tautology (`expect(x).toEqual(x)`) |
| **isolation** | Deterministic isolation | Is the test repeatable without hidden shared state or real I/O? | Doubles or seams at network/clock/fs; fresh arrange per case; order-independent | Live network/clock/fs without a seam; mutable fixture bleed across cases; timing sleeps; order-dependent suites |
| **arrange** | Arrange-Act-Assert | Are setup, act, and assert readable, with the act visible? | Clear given/when/then or AAA; act is one obvious call | Act buried in helpers; giant shared `beforeEach` that hides the scenario; assert mixed into setup |

## Severity guidance

| Severity | Typical cases |
|----------|----------------|
| Critical | New money/auth/state behavior shipped with no failing case; suite that only mocks internals and never asserts a public outcome for that rule |
| High | Clear cycle break on a material feature; tautological or empty oracle on domain logic; flaky real-I/O test for a unit concern; kitchen-sink case that masks which rule broke |
| Medium | Mild arrange noise; one weak `toBeDefined` beside stronger asserts; short private-spy that is not the only oracle. At `pragmatic`, prefer Medium or skip for framework smoke and generated snapshots |

## Package audit reminder

When the scope is more than one file, or any package/app scope, also satisfy `audit-coverage.md` (layer sweep + minimum coverage gate). Pass/fail signals above apply **per file**; package health needs breadth, not only the first weak `it`.

## Relationship to other presets

| Concern | Guidance |
|---------|----------|
| Missing port, god class, train wreck, mixed abstraction, near-copy | **Not** TDD — SOLID, coupling, structure, or KISS |
| Speculative production options / unused knobs | **Not** TDD — KISS **yagni** / **surface** |
| Over-mocking private methods / call graphs | **behavior** (and often weak **oracle**), not coupling |
| "No tests at all" on a module with no new behavior in scope | At `pragmatic`, prefer Needs verification / skip unless the request is a package TDD audit |
| Focus ring, contrast, security sink | **Not** TDD — WCAG or security |

## Severity by level

Scope (which dimensions to audit or plan) is owned by `SKILL.md`. This list only changes how hard a signal is filed.

- At `pragmatic`, prefer Medium (or skip) for framework boilerplate, tiny smoke `it`s that are not the contract under change, and snapshot files the team already owns.
- At `strict`, a new behavior in scope without a planned or present failing case is High; every enabled dimension applies to the tests in scope.
