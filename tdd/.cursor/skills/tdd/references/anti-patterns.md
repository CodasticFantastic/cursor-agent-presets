# TDD Anti-Patterns

Smell catalog. Add a smell here, not in `SKILL.md`, the rule, or `tdd-reviewer`. Pair with `principles-table.md`, `code-patterns.md`, and (for package audits) `audit-coverage.md`. Apply a row only when its dimension is enabled.

The skill and reviewer describe fixes; they do not edit files.

## cycle — Red-green-refactor

| Smell | Why it fails | Typical fix (for the parent) |
|-------|--------------|------------------------------|
| Production change for new behavior with no new failing test | No red proved the requirement | Add the failing case first; then minimum green |
| Tests written only after a large green implementation | Cycle inverted; tests rubber-stamp design | Split remaining behavior into new red cases; avoid one post-hoc suite for everything |
| "Green" that also adds unrelated features | Mixes making the test pass with scope creep | Pass the current red only; park extras as later reds |
| "Refactor" that changes requirements or public behavior | Not a refactor | New red for the new requirement; keep refactor behavior-preserving |
| Skipping red because "the type already fails" | Compile errors are not a behavior oracle | Still add a failing behavioral test for the rule |

**Not cycle:** fixing a proven regression with a new failing case; deleting a dead test that asserted removed behavior; a pure rename/move with existing coverage.

## behavior — Behavior over internals

| Smell | Why it fails | Typical fix (for the parent) |
|-------|--------------|------------------------------|
| Asserting private helpers or non-exported functions | Couples to structure; refactors break tests without behavior change | Assert through the public API |
| Spying on internal call order as the only oracle | Locks implementation choreography | Assert outputs, thrown contracts, or visible state |
| UI/DOM structure as the contract (`props.children`, className trees, fiber shape) | Locks render internals; wrong copy can still pass | Assert observable text / roles / public props the user sees |
| Heavy mocks of collaborators that reimplement the SUT | Test passes while real wiring is wrong | Prefer real units in-process; mock at I/O boundaries |
| Snapshot of private JSON dump as the contract | Opaque; easy to accept wrong dumps | Prefer explicit expects on public fields |

**Not behavior:** testing a pure exported helper that *is* the public API of the module; contract tests of an interface you own; asserting thrown error **kinds** that are part of the public contract; testing-library queries on visible text/roles.

Weak `toBeDefined` on a element **and** `props.children` on the same case → file **oracle** and **behavior** (sibling axes), not only one.

## focus — One reason to fail

| Smell | Why it fails | Typical fix (for the parent) |
|-------|--------------|------------------------------|
| Kitchen-sink `it` covering auth, pricing, persistence, and HTML | Failure does not name the broken rule | Split into focused cases (or one table of one concern) |
| Many unrelated `expect`s in one case | Ambiguous red | One primary oracle per case; satellites only if they are the same rule |
| Shared setup / shared mutable driving several unrelated rules in one suite | Suite fails for many reasons; which rule broke is unclear | One concern per case (or table); fresh arrange; no cross-rule shared act |
| Copy-paste mega-scenario for every tiny branch | Noise hides the delta | Share arrange helpers; keep the act/assert focused |

**Not focus:** a small table-driven set of inputs for the **same** rule; given/when/then with several asserts that all nail one outcome (value + error code of the same failure); shared **immutable** arrange reused by focused cases.

## oracle — Meaningful assertions

| Smell | Why it fails | Typical fix (for the parent) |
|-------|--------------|------------------------------|
| Only `toBeDefined` / `toBeTruthy` on domain results | Almost anything passes | Assert the concrete value or state delta |
| `expect(fn).not.toThrow()` as the only check | Silent wrong results pass | Assert the return or visible effect |
| Tautology (`expect(x).toEqual(x)` / same object rebuilt in expect) | Does not lock behavior | Derive expected from the rule, not from the SUT output alone |
| Empty `expect.assertions(0)` / missing expect | Green means nothing | Add a real oracle |
| Asserting only mock `toHaveBeenCalled` with no result check | Collaboration without outcome | Prefer outcome; keep interaction checks secondary at boundaries |

**Not oracle:** `toHaveBeenCalledWith` on a **boundary** port (mailer, HTTP client) when that send *is* the behavior; explicit `expect.assertions(n)` paired with real expects.

## isolation — Deterministic isolation

| Smell | Why it fails | Typical fix (for the parent) |
|-------|--------------|------------------------------|
| Real network, clock, or filesystem in a unit test | Flakes and environment coupling | Inject a seam / fake; control time |
| Shared mutable fixture mutated across cases without reset | Order-dependent greens | Fresh arrange per case or reset in `beforeEach` |
| `sleep` / arbitrary timeouts to "wait for async" | Flaky under load | Await conditions, fake timers, or deterministic queues |
| Relying on test file order or previous case side effects | Hidden coupling | Each case self-contained |
| Parallel-unsafe global singleton | Intermittent fails in CI | Isolate or serialize with a clear seam |

**Not isolation:** an intentional E2E against a testcontainer the package owns; a shared **immutable** fixture object; fakes that are stateful but reset every case.

## arrange — Arrange-Act-Assert

| Smell | Why it fails | Typical fix (for the parent) |
|-------|--------------|------------------------------|
| Act buried inside a helper named `setup` | Reader cannot see what is under test | Keep the triggering call in the test body |
| Giant `beforeEach` that builds every scenario | Cases differ only by hidden flags | Per-case arrange, or small factories with visible args |
| Assert mixed into arrange (validating fixtures as the test) | Confuses setup with oracle | Assert only after the act |
| No visible separation of given / when / then | Hard to review and extend | Structure AAA even without comments |

**Not arrange:** a short shared `beforeEach` that only resets doubles; one-line factories used visibly in arrange.

## False positives (especially at `pragmatic`)

Do **not** treat these as violations:

- Framework boilerplate `it("renders", ...)` smoke that is not the contract under change
- Generated snapshots the team already owns (note Needs verification if the dump looks accidental)
- Testing an exported pure function that is the module’s API
- Boundary `toHaveBeenCalledWith` when send/persist *is* the behavior
- Intentional E2E / testcontainer suites labeled as such
- Deleting obsolete tests for removed behavior
- Recommending a second test framework "for completeness" — that is process noise, not a TDD finding

Escalate when money, auth, or state-transition rules lack a failing case, or when the only "coverage" is internal spies and tautologies.

## Review process smells (meta)

Flag the **audit itself** as incomplete when:

- Only one weak `it` is cited and unit, adapter, HTTP, UI, and job tests were not opened
- A bad `it` was filed under a single dimension while other clear signals on that same case were ignored (e.g. kitchen-sink filed as focus only, skipping sole `toBeDefined`, sleep, or act-in-`beforeEach`)
- A cycle break on a time- or I/O-sensitive API was filed without checking isolation on the matching spec (wall clock, sleep, live fetch)
- A missing port, train wreck, or focus ring was filed as TDD
- One clean test was treated as a package-wide pass
- The reviewer edited files or pasted a full replacement suite instead of a report
- "Not enough coverage %" is claimed with no path:line and no dimension
- Cycle was filed solely because types failed to compile, with no behavioral case discussed
