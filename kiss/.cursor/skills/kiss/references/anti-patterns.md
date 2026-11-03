# KISS Anti-Patterns

Smells to flag in reviews. Pair with `principles-table.md`, `code-patterns.md`, and (for package audits) `audit-coverage.md`.

## clarity — Clarity over cleverness

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| Dense one-liner / nested ternaries | Readers must decode, not read | Split into named steps |
| Cryptic abbreviations / single-letter domain names | Intent hidden | Use domain vocabulary |
| Custom mini-DSL or heavy metaprogramming | One author understands it | Plain functions and data |
| “Smart” defaults that flip behavior by environment magic | Surprises at runtime | Explicit parameters or config with obvious names |
| Over-generic names (`Manager`, `Helper`, `Util`, `Handler`) | No noun for the job | Name the real concept |

## yagni — You Aren't Gonna Need It

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| Unused `mode` / `provider` / `strategy` branches | Speculative product surface | Delete until a real second case exists |
| Feature flags that are always on/off in prod | Dead decision points | Remove flag; keep one path |
| TODOs / stubs “for enterprise later” in the hot path | Noise and false APIs | Delete or park outside the product path |
| Config schema with fields nothing reads | Ceremony and false flexibility | Drop unused keys |
| Abstract “extension points” with zero plugins | Imaginary future | Ship the concrete feature |

## abstraction — Delayed abstraction

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| Interface + factory + base for one concrete | Ceremony without payoff | Use the concrete; extract on second need |
| Premature DI container for a tiny module | Indirection tax | Constructor/params at the composition root only |
| String-token `resolve` / service locator where a token name (e.g. `OrderRepository`, `IUserPort`) returns a different concrete (e.g. raw `prisma`, DB client) | Name lies; hides hard-wiring behind “DI” | Read every `token → return` branch; file the mismatch; prefer direct construction |
| Type/class named like a real vendor SDK (`PrismaClient`, `*Client`, Stripe/PayPal wrapper) whose body is `Map` / in-memory / stub | Name lies; readers assume real infra | Open the body; file the lie; rename or use an honest fake |
| Generic “framework” wrapping one use case | Readers learn a fake platform | Inline the feature |
| Repository / gateway ports never swapped and never tested via fakes | Unused seam | Concrete until test or second adapter needs a port |
| Deep inheritance for shared bags of methods | Fragile reuse | Composition of small helpers |

**Pragmatic exception:** a port already used to isolate real infra (HTTP/DB/payment) or to enable tests with a fake is justified — do not “simplify” by hard-wiring vendors into domain.

## surface — Small surface area

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| Options object with 10+ mostly optional unused fields | Call sites guess which matter | Required fields only; split configs by use case |
| Public export of internals “just in case” | Accidental API lock-in | Export the minimal surface |
| Function with many parameters mostly defaulted | Hard to call correctly | Object with few required keys, or split functions |
| Dead code / commented-out blocks (esp. speculative paths left in services) | Noise; hides “for later” product surface | Delete (VCS remembers); file under yagni when the comment is event-sourcing / outbox / provider theater |
| Dual APIs doing the same thing (`doX` + `doXAsync` synonyms) | Choice without benefit | Keep one |
| Solitary unused export of a tiny helper (no importers) | Real but low-cost surface noise | At `pragmatic`: Medium or skip — do not escalate; do not treat the file as a package pass |

## deps — Justified dependencies

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| New package for a 5–15 line helper | Supply-chain and API surface | Write the helper locally or use stdlib |
| Two libraries for the same job (date, HTTP, validation) | Inconsistent patterns | Standardize on one |
| Heavy UI/framework dep inside a CLI or backend-only path | Wrong tool | Use lighter APIs |
| Pinning a dep only for one transitive type | Coupling theater | Local type or narrower import |

## flow — Shallow flow

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| Pyramid of nested `if/else` | Hard to follow happy path | Guard clauses / early returns |
| Wrapper that only forwards to another wrapper | Indirection without value | Call the leaf directly |
| Boolean flag parameters that fork behavior (`fn(x, true, false)`) | Unreadable call sites | Separate functions or a small options object with names |
| Needless async layers / Promise wrapping | Extra states to reason about | Sync when sync; async only at I/O |
| Central “dispatcher” that only routes to one destination | Fake flexibility | Direct call |

## False positives (especially at `pragmatic`)

Do **not** treat these as Critical by default:

- A thin adapter that isolates a real vendor SDK
- A port with one production impl **and** a test double in use
- Composition root / framework bootstrap that must wire the graph
- Exhaustive `switch` on a small stable union (2–3 cases, low churn)
- Shared helper extracted after real duplication appeared
- Clear domain types that look “extra” but prevent primitive obsession
- A decoy / unused one-liner util with no call sites (note it at most as Medium; never Critical; never a package pass)

Escalate when there is evidence of unused ceremony, dead options, speculative frameworks, or nesting that obscures the requirement.

## False simplicity (not KISS)

Flag these as **anti-KISS** even if the file count went down:

- One god module “so we don’t have folders”
- Hidden globals / singletons to avoid parameters
- Copy-paste of logic that already diverges in two places
- Deleting tests or types to “make it simpler”
- Inlining SQL/HTTP/payment into UI for fewer files

## Review process smells (meta)

Flag the **audit itself** as incomplete when:

- Only one over-abstracted service is cited and config/utils/pages were not opened
- Filenames like `Simple*` / `Lite*` were trusted without reading bodies
- One clean helper was treated as a package-wide pass
- “Could be simpler” claims have no `path:line` or no deleted-ceremony suggestion
