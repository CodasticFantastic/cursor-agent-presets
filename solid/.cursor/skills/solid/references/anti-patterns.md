# SOLID Anti-Patterns

Smell catalog. Add a smell here, not in `SKILL.md`, the rule, or `solid-reviewer`. Pair with `principles-table.md`, `code-patterns.md`, and (for package audits) `audit-coverage.md`. Apply a row only when its letter is enabled.

## S — Single Responsibility

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| God class | Many unrelated reasons to change | Extract collaborators by change axis |
| “Manager” / “Processor” with no clear noun | Hidden multi-responsibility | Rename to the real domain concept; split leftovers |
| Shared `utils.ts` dumping ground | Unrelated helpers couple unrelated features | Feature-local helpers or focused modules |
| **Named util that smuggles other jobs** | “Hasher/Cookie/Sql/Theme/Tax/Flags/Geo/Report/Csv/Pdf” also validates email, sets HTTP status, mutates `document`, emails, charges, embeds SEO/S3 | Keep one verb per module; move side jobs to adapters |
| **Validator that persists / pays / mails / returns HTML** | Validation changes with infra and UI | Pure validate → result; orchestrate elsewhere |
| **Repo/notifier/payment doing each other’s work** | Persistence emails and charges; mailer updates stock; gateway wipes DB and returns redirect HTML | Thin adapters; application service owns orchestration |
| **DTO / model spanning bounded contexts** | User/Order carries SSN, card, theme, SEO, SMTP host, PDF blob, gateway secret | Domain fields only; map presentation/secrets at edges |
| UI component that loads, maps, and posts | View + I/O + policy change together | Hook/service for data; presentational component for UI |
| **Page/layout that boots domain + LSP demos** | Shell changes when pricing/auth/infra change | Shell renders chrome; domain init stays in app services |
| **God hook / god store / god form** | One surface owns auth, checkout, SQL, flags, secrets | Split by user journey; no I/O inside global store |
| **Logger / config / token helper smuggling side jobs** | Logger emails oncall; `env` ships live secrets as defaults; “JWT” embeds payment keys | One concern per module; secrets via real secret store at the edge |

## O — Open/Closed

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| Type `switch` edited for every variant | Extension requires modifying closed core | Strategy / polymorphic handlers |
| **Scattered closed switches** | Same OCP pain when a **product extension axis** (payment method, notification channel, coupon, plugin kind, feature family) grows by editing one core — agent often cites only the largest service | File each **true** OCP magnet with `path:line`; registry/map or strategies per family. Do **not** auto-file every tax/state/country `if` inside a god handler as O — prefer **S** there unless an open twin (strategy/registry) already exists beside the closed switch |
| Feature flags piled inside one service | Same core absorbs every product branch | Separate policies or modules per flag family |
| Base class grows “shared” email/HTML/audit methods | Every new payment method still edits the base | Composition of narrow collaborators |
| Copy-paste variant classes with tiny diffs | Closed reuse missing; still edit many places | Shared composition + small strategies |
| **Plugin registry with hardcoded allowlist** | Looks open; `ENABLED_*` / closed name list still requires editing the registry file | True registration API or config-driven enablement outside the core |
| **`*-defs/` theater** | Def folders look like OCP; real factory/router/`isOn` remains a closed if-chain | Wire defs into a map/registry the core does not edit per variant |
| **Locale / i18n table deciding tax or domain** | i18n churn forces tax edits (and vice versa) | Keep translation tables separate from policy tables |

**Pragmatic exception:** a stable, exhaustive union with 2–3 cases and low churn is acceptable until a fourth variant appears. On package audits you may **note** it under Needs verification / change-rate — **mention is not a violation**. File OCP only when the axis is meant to grow without editing that core, or a closed twin sits next to an already-open registry/strategy.

## L — Liskov Substitution

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| `throw new Error("not supported")` in override | Callers of the base cannot rely on behavior | Split interfaces; do not inherit the capability |
| Empty override / no-op that the base documents as work | Silent contract break | Composition or narrower type |
| **Conditional no-op subtype** | Override sometimes returns the input / early-exits with no effect while the base (or type name) promises real work — e.g. policy/validator/save/notify that is identity below a threshold | Narrow the base contract (“may be identity”), or don’t subtype — separate type / composition |
| **Sibling blindness** | One honest non-subtype in a hierarchy file clears L; a neighboring concrete that `extends` the effectful base still breaks callers | After classifying one type, enumerate **every** concrete subtype of the same base in that module |
| **Honest refusal vs broken postcondition** | Subtype that early-returns / refuses to enter without setting a broken state is not L when the base postcondition still holds; subtype that sets “done” flags with null/invalid results **is** L | Read the base JSDoc/contract; compare siblings before filing |
| Subclass needing extra mandatory setup | Stronger precondition | Factory that returns a ready instance; or don’t subtype |
| Narrowed return that drops base guarantees | Weaker postcondition | Preserve the contract or change the base type |
| **Invariant-breaking setters** (Square/Rectangle) | Helpers written for the base get wrong results | Separate types; immutable dimensions; no subtype lie |
| **Postcondition inversion** (effectful base that raises / returns `NaN` / inverts the promised direction) | Callers cannot rely on “does not worsen” / finite number | Different type or documented adjuster that is not a subtype of the effectful base |
| **Read-only / cache subtype that lies on wipe/save** | Substituting breaks `upsertAll`-style callers | Narrow ports: `Readable` vs `Writable` |
| **Fake polymorphism** (PayPal type charges via Stripe) | Type name lies about behavior | Honest adapter or shared gateway port |
| **Buried LSP demos** | Hierarchy file audited; pages/layouts/report routes/**worker jobs** still construct the bad subtype | Grep call sites; file those paths too |
| **Template-method step skip** | Subclass skips a required step (receipt, validate, persist) while callers assume the full template ran | Don’t inherit the template; compose optional steps explicitly |
| **Lying value / collection contracts** | “Sorted” list that doesn’t sort on push; “immutable” Money that mutates / mixes currency; cache miss → `{}` | Honor documented invariants or rename the type |

## I — Interface Segregation

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| Fat repository / service interface | Clients depend on unused methods | Split by role (read/write/notify/…) |
| Fat port mixes CRUD + wipe + newsletter + charge + SEO + resize + DNS/TLS | Unrelated roles share one type | Role interfaces; clients import one |
| `implements` with methods that only throw / empty | Partial implementation of a fat port | Smaller interfaces |
| Test mocks with 10 empty stubs | Test pain mirrors ISP violation | Narrow the port the SUT needs |
| **Admin/UI forced to call unused methods** | Page exists to exercise ISP junk | Drop methods from the port the UI needs |
| **Fat handler input** (always requires db+mailer+stripe+fs) | Most actions ignore most fields | Narrow context per use case |
| **“Narrow” type that extends a fat port** | Name claims segregation; body inherits every unused method | Actually narrow: only the methods the client needs |

## D — Dependency Inversion

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| `new ConcreteX()` inside domain policy | High-level depends on low-level detail | Inject a port; construct adapter at composition root |
| **Same concrete constructed in services + API + UI/hooks** | Every layer coupled to one vendor type | One composition root; edges receive ports |
| Importing ORM/HTTP SDK in pure domain files | Same as above | Keep adapters at the edge |
| **Subtype that breaks a purity / exception contract** | Interface or base JSDoc says pure, no I/O, or “reject only with `X`”; implementor `fetch`es or throws a different error | Primary letter is **L** (contract substitution). Do not also file **D** for the same symbol unless a separate DIP issue exists (wrong-owned port types, concrete cycle, policy `new` without being a subtype break) |
| Service locator / global singleton as hidden DI | Opaque dependencies; hard to test | Explicit constructor/parameter injection |
| Circular package imports across layers | Dependency arrow points the wrong way | Invert with a port owned by the inner layer |
| **Concrete↔concrete cycles** (mailer↔payment↔db each `new` the others) | No stable inner policy; testing explodes | Ports owned by application layer; adapters depend inward only |
| UI importing payment/DB modules | View depends on infrastructure detail | Server actions / hooks over ports |
| **DIP theater** (`type IFooPort = Concrete`; `create*Port()` → `new`; Port base that dynamic-imports vendor; Container token→`new`) | Name says port/DI; body hardcodes concretes | Real interface + composition root registration |
| **Event bus / Facade that is a god + concretes** | “Messaging” / “Facade” hides orchestration and `new Gateway` | Thin bus/facade over injected ports; no vendor `new` inside |

## False positives (especially at `pragmatic`)

Do **not** treat these as Critical by default:

- A concrete class with a single implementation and no swap need yet
- A private helper used by one module
- Framework entrypoints that must construct the object graph (composition root)
- Tiny scripts / one-off CLIs outside the product domain
- A closed **domain lifecycle** / exhaustive status enum that changes the model when extended (not a product plug-in axis)
- An **adapter for a frozen external spec** (EDI version table, protocol code map) — editing that adapter when the standard changes is expected, not an OCP failure
- Tax / nexus / state `if`s **inside** a multi-concern HTTP or desk handler — file **S** (and D if the edge constructs infra); do not invent a second OCP finding for the same handler unless an open strategy/registry twin already exists
- Second letter on the **same symbol** when the first letter already covers the break (e.g. L for a purity-contract subtype; do not also stamp D solely because the body uses `fetch`)
- Sibling subtype that **refuses work** without violating the base postcondition (contrast with a sibling that leaves invariants broken)

Escalate when there is evidence of churn, test pain, **cross-layer** coupling, or the **same** concrete appearing in three or more layers in the scoped files.

## Review process smells (meta)

Flag the **audit itself** as incomplete when:

- Only the largest god class is cited and utils/pages/API were not opened
- Filenames were trusted without reading bodies (`Facade` / `Container` / `Port` / `Plugin` / `EventBus` unread)
- Workers, BFF, bus, or config exist in the tree but were never opened
- One clean shell/layout was treated as a package-wide pass
- Duplicate violations across layers were collapsed into a vague sentence with no paths
- `*-defs/` were treated as OCP-compliant without checking the still-closed factory/router
