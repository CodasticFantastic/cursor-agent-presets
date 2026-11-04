# Structure Anti-Patterns

Smell catalog. Add a smell here, not in `SKILL.md`, the rule, or `structure-reviewer`. Pair with `principles-table.md`, `code-patterns.md`, and (for package audits) `audit-coverage.md`. Apply a row only when its dimension is enabled.

## slap — Single Level of Abstraction

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| Policy + SQL/HTTP/HTML in one function | Every change axis edits the same body | Orchestrator calls named steps at one level |
| Bit/byte or regex parsing beside business branching | Reader cannot see the story | Extract parse helpers; keep the story in the parent |
| "God method" that validates, persists, notifies, and formats | Levels and jobs collapse | Split by level first; then by responsibility if needed (SOLID S) |
| Inline low-level loops inside a high-level use case | The use case hides the intent | Name the step (`loadOpenOrders`, `applyDiscount`) |
| Comment-labeled sections (`// validate`, `// save`, `// email`) that stay inlined | Comments paper over mixed levels | Turn each section into a function at the same grain |

**Not slap:** a long function that stays at one grain (still may be SOLID S). Deep nesting that is still "decide next branch" (KISS flow). A tiny function that must touch one low-level API because that is its only job.

## dry — Don't Repeat Yourself (guarded)

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| Twin helpers differing by one literal (`feeA` / `feeB` / `feeC`) | Drift when the rule changes | One parameterized function |
| Copy-paste of a domain policy across services/API/worker | Same bug fixed three times | Shared module at the right package; call sites pass differences in |
| New function invented beside an existing one with the same control flow | Author skipped search | Reuse or extend the existing path |
| Near-copy with renamed locals only | No real divergence | Delete the twin; call the original |
| Parallel `switch` / status maps that must stay in sync | Shared change reason ignored | One table or one mapper used everywhere |
| Outside twin of an owner method (same flow as `Type.method`, often beside a Tell-Don't-Ask smell) | Invariant drifts when only one copy is fixed | Delete the free function; call the owner (structure files **dry**; do not drop the twin because coupling also applies) |

**Not dry:** accidental resemblance; two DTO maps; two handlers with different contracts; intentional duplication at an anti-corruption / bounded-context edge; a second implementation required by a different runtime (e.g. edge vs node) when abstraction would be worse; ask-then-decide or a train wreck that does **not** paste a twin body (coupling only).

## False positives (especially at `pragmatic`)

Do **not** treat these as violations:

- Two short field maps that happen to look similar
- HTTP/route handlers that share shape but differ in auth, DTO, or side effects
- Test fixtures and snapshot builders that repeat setup on purpose
- Generated code, Prisma client usage, or framework boilerplate
- A second copy behind a package boundary the team must not cross (note as Needs verification / manual)
- Extracting a shared helper "for future variants" with one caller — that is KISS **yagni**, and recommending it is a review smell
- Collapsing divergent business rules into one boolean-flag monster — false DRY
- Claiming "as DRY as possible" as a goal

Escalate when domain policy (money, auth, inventory, state transitions) is near-copied, or when a use-case function mixes orchestration with raw I/O/format.

## Review process smells (meta)

Flag the **audit itself** as incomplete when:

- Only the longest function is cited and utils, services, API, and jobs were not opened
- Lookalike mappers were filed as dry without a shared change reason
- A speculative extract was recommended as a dry fix
- A missing port, train wreck without a twin body, or god class was filed as structure without mixed levels / twins
- An owner-method near-copy was skipped as “only TDA” instead of filed as dry
- One clean helper was treated as a package-wide pass
- A High/Critical dry finding lists only one location (twins need multiple `path:line`)
- "Not DRY enough" claims have no paths
