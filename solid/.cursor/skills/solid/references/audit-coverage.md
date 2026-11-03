# SOLID Audit Coverage — Package / App Sweep

Use this checklist on **package- or app-scoped** reviews (not a single 20-line diff).  
Goal: stop “GodService-only” audits that miss the same smell repeated in utils, routes, hooks, pages, **and peripherals** (workers, BFF, bus, config).

Load with `anti-patterns.md` and `principles-table.md`. Report every hit with `path:line` + principle letter.

## Hard rules (fail the audit if you skip them)

1. **Do not stop after the first god class.** One critical finding does not clear the package.
2. **Do not trust filenames.** Names like `*Strategy*`, `*Factory*`, `*Repository*`, `*Manager*`, `*Facade*`, `*Container*`, `*Port*`, `*Plugin*`, `EventBus`, `Template*` can still hide S/O/L/I/D breaks — **read the body**.
3. **One clean file is not a package pass.** `layout.tsx` (or similar) may be intentionally neutral noise; keep sweeping.
4. **Same smell, many layers.** If `new StripeX()` / fat-port / throw-in-override appears in services **and** API **and** UI, file **each** location (or one finding that lists every path:line).
5. **Follow call sites for LSP.** After finding a broken subtype, search who constructs/calls it (pages, layouts, `useEffect`, API routes, **worker jobs**) — demos are often buried outside the hierarchy file.
6. **Name theater.** If you see `create*Port`, `type IFoo = Concrete`, `Ports.*()`, a “plugin registry”, or a DI `Container.resolve` token switch — open the file; do not assume DIP/OCP from the name.
7. **Defs ≠ open.** Folders like `*-defs/`, `method-defs/`, `channel-defs/`, `flags/defs/` do not clear OCP if a closed `Factory` / `Router` / `isOn` switch still must be edited for new variants — open **both**.

## Mandatory layer sweep

Walk **every** layer that exists in scope. Skip a row only if that folder is absent.

| Layer | Typical paths | What to hunt |
|-------|---------------|--------------|
| Types / contracts | `types/`, `*interfaces*`, shared DTOs, `contracts/` | Fat interfaces; DTO mixing auth+pay+UI+SEO+secrets (S/I); handler inputs requiring unused infra fields (I/D); **type-alias “ports”** (`type IRepo = MemoryDb`) (D) |
| Utils / helpers | `utils/`, `lib/utils/`, `helpers/`, `shared-utils/` | Named “hash/cookie/sql/theme/tax/flags/geo/report/csv/pdf” that also do UI, HTTP status, email, DB, payments, SEO (S); growing country/flag/IP switches (O); `new ConcreteDb()` (D) |
| Persistence | `repositories/`, `db/` | Side effects on insert (mail, charge, HTML); browser APIs (`document`); wipe/migrate/S3/render on the same type as CRUD (S/I/D); cache decorators that break write/wipe contracts (L) |
| Adapters | `payments/`, `notifiers/`, `mail/`, `gateways/` | Adapter that owns DB + UI redirect + other adapters; circular `new` between mailer ↔ payment ↔ db (S/D/I); secrets as fields |
| Domain / services | `services/`, `domain/`, `workflows/` | God handlers; action/type switches (O); inheritance that throws / inverts postconditions (L); template-method subclasses that **skip a base step** (L); `new` concretes + global singletons (D) |
| Validation | `validators/` | Persist/charge/email/HTML inside “validate” (S/D); kind/coupon switches (O) |
| State / hooks | `store/`, `hooks/` | Global store with secrets + I/O; one hook exporting the whole system (S/I/D); dispatch switches (O) |
| HTTP / API | `app/api/`, `routes/`, controllers | Fat routes; action switches; returning secrets; constructing adapters; embedding LSP demos (S/O/L/D) |
| UI components | `components/`, widgets, forms | Forms that SQL/pay/theme; widgets implementing fat UI+infra ports; `new Gateway()` in render (S/I/D) |
| Pages / layouts | `app/**/page.tsx`, layouts, screens | Forced ISP method calls; LSP landmines in `useEffect`; checkout that constructs crypto/refund paths; home that mounts every god widget (S/L/I/D) |
| Jobs / workers | `worker/`, `jobs/`, `batch/`, cron runners | Nightly god + plugins; batch that constructs broken subtypes / skips template steps; `new` concretes (S/O/L/D) |
| BFF / compose | `bff/`, `compose.ts`, gateway assemblers | Composes every concrete + fake ports; DIP theater at the edge (S/D) |
| Messaging | `event-bus/`, `bus.ts`, `events/` | Emit handlers that charge/mail/call god; service locator inside bus (S/D); special-cased event if-chains (O) |
| Config / i18n | `config/`, `env.ts`, `i18n/` | Live secrets as defaults (S/D); locale tables that also decide tax/domain policy (S/O) |
| Auth satellites | `token*`, `*policy*`, webhooks, steps, mappers | Token helpers that embed payment secrets; policies that `new` gateways (S/D); closed role/access switches (O) |

## Principle hunt lists (search the tree)

Use ripgrep / semantic search. Record hits even when the file looks “peripheral”.  
Prefer patterns that catch **if-chains** as well as `switch` (many codebases never use the `switch` keyword).

### S — Single Responsibility

- Modules whose public API mixes **two+** of: auth, persistence, payment, email, HTML/PDF/CSV render, cookies/redirect, feature flags, geo, SEO, inventory.
- UI that builds SQL, touches DB, or charges cards.
- “Utils” that decide HTTP status, mutate `document`, or send mail.
- Models carrying secrets + presentation blobs (`paymentGatewaySecret`, `emailBodyHtml`, `pdfReportBlob`, SSN + theme).
- Logger / config / token helpers that email, charge, or ship live secrets as defaults.

### O — Open/Closed

Enumerate **every** closed extension point in scope (not just the largest service):

- `switch` / `if (x === …)` / `else if` on **action**, **type**, **kind**, **channel**, **code**, **country**, **flag**, **mode**, **token**, **locale**.
- Factories that map string → concrete class.
- DI containers: `if (token === "…") return new Concrete`.
- Plugin registries with hardcoded allowlists (`ENABLED_*`, closed name lists) — looks open, edits required for new plugins.
- Base classes that grow shared unrelated methods instead of composition.
- Feature-flag and geolocation tables hardcoded in one function.
- `*-defs/` folders that do **not** replace a still-closed factory/router/`isOn`.

At `pragmatic`, still **list** each magnet; severity may be Medium for tiny stable unions.

### L — Liskov Substitution

- Overrides that `throw` / return `NaN` / no-op where the base promises work.
- Setters that break base invariants (classic Square/Rectangle).
- Subtypes that invert postconditions (e.g. “Discount” that raises price).
- “Read-only” or “cached” subtypes that lie about wipe/save.
- Fake polymorphism (subtype name claims PayPal, body calls Stripe).
- Template-method subclasses that **skip** a required step (e.g. no receipt) while callers assume the full template ran.
- Collections / value types that lie about invariants (unsorted “SortedList”, “immutable” Money that mutates / mixes currency; cache miss → `{}`).
- **Call-graph:** pages, layouts, reports routes, **worker jobs** that construct these subtypes on purpose.

### I — Interface Segregation

- Interfaces mixing CRUD + admin wipe + newsletter + charge + SEO + resize + tickets + DNS/TLS.
- `implements` with empty methods or methods that only throw.
- Pages/admin widgets that call unused methods “because the interface has them”.
- Fat input types forcing db+mailer+stripe+fs on every handler.
- “Narrow” types that still `extends` a fat port.

### D — Dependency Inversion

- `new FakeDb|Smtp|Stripe|…` (or language equivalents) inside domain, validators, utils, hooks, components, API handlers, **workers, BFF**.
- Direct import of a global `god` / service locator singleton.
- Concrete↔concrete cycles (A constructs B, B constructs A).
- UI importing payment/DB modules.
- Missing ports when the same concrete is constructed in **three or more** layers (escalate even at `pragmatic`).
- **DIP theater:** `type IFooPort = ConcreteClass`; `createFooPort()` that hardcodes `new Concrete`; “Port” base that dynamic-imports a vendor; Container that only switches tokens to concretes.

## Minimum coverage gate (package audit)

Before finishing a package/app review, confirm you can answer **yes** or cite “absent in tree”:

- [ ] God / mega handler **and** god hook / form / store / DTO (if present)
- [ ] At least one utils/helpers SRP or OCP hit **or** explicit “utils clean”
- [ ] Fat interface(s) + a forced no-op / unused-method client
- [ ] ≥1 inheritance contract break with call site (not only the class file)
- [ ] ≥2 distinct OCP switches in different files (when the tree has them)
- [ ] `new` concretes in **both** a non-UI layer and a UI or API edge (when both exist)
- [ ] Adapter/repo side effects outside persistence/notification
- [ ] Concrete dependency cycle **or** DIP theater (type-alias port / Container token→`new` / fake `create*Port`) **or** explicit “neither found”
- [ ] Jobs/worker **or** BFF/compose swept **or** both absent
- [ ] ≥1 name-theater body read (`Facade` / `Container` / `*Port*` alias / plugin registry / `EventBus`) **or** none present
- [ ] Template-method step-skip **or** SortedList/Money/cache-miss lie **or** explicit “no subtle LSP in tree”
- [ ] Generated / satellite noise noted once (`generated/mod-*`, policies, webhooks, steps) **or** absent

If any checkbox is unchecked without a written reason (“folder missing” / “searched, none”), the audit is incomplete — keep searching.

## Reporting duplicates

Prefer:

```
- Location: a.ts:10; b.ts:22; c.tsx:40
- Principle: D — Dependency Inversion
- Why: same StripeHardcoded constructed in service, API, and form
```

Do not collapse the package into a single “DIP is generally weak” sentence without paths.
