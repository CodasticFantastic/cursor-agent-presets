# Coupling Audit Coverage — Package / App Sweep

This file is the only copy of the layer sweep and the coverage gate. Add a layer or a hunt here, not in `SKILL.md`, the rule, or `coupling-reviewer`.

**When to load:** more than one file, or any package/app scope. Do not use this checklist for single-file scope — still review that file.

Goal: stop “one train wreck” audits that miss the same walk or the same external decision in services, API, and UI.

Load with `anti-patterns.md` and `principles-table.md`. Report every hit with `path:line` + dimension id.

## Hard rules (fail the audit if you skip them)

1. **Do not stop after the first chain.** One critical finding does not clear the package.
2. **Do not trust filenames.** `Encapsulated*`, `*Facade*`, `delegate*` can still walk strangers — read the body.
3. **One clean method is not a package pass.** A tiny command may be fine while a service still asks and decides — keep sweeping.
4. **Same smell, many layers.** If `order.customer.address` or `if (status === …)` appears in services **and** API **and** UI, file **each** location (or one finding that lists every path:line).
5. **Mappers are not automatic failures.** A structural read in `toDto` / `fromRow` / a presenter is in scope to **notice** and usually **not** to file. Notice ≠ violation.
6. **Do not recommend a pure forwarder.** The fix owns a rule or hides a real structure. A one-line `return a.b.c` is not a coupling fix.
7. **Do not import other presets' findings.** A missing port is not lod. A god class is not tda unless the cited lines ask and decide. Nested `if`s without a stranger or a stolen rule are not coupling.

## Mandatory layer sweep

Walk **every** layer that exists in scope. Skip a row only if that folder is absent.

| Layer | Typical paths | What to hunt |
|-------|---------------|--------------|
| Types / contracts | `types/`, shared DTOs | Behavior-bearing types whose callers still walk `.a.b.c`; commands that leave invariants to the caller (lod / tda) |
| Utils / helpers | `utils/`, `lib/`, `helpers/` | Helpers that accept an aggregate and walk three levels (lod) |
| Domain / services | `services/`, `domain/` | Train wrecks; `if (entity.field)` then mutate; feature envy (lod / tda) |
| Adapters | `payments/`, `mail/`, `gateways/` | Adapter reaching into a domain graph instead of taking a leaf value (lod) |
| HTTP / API | `app/api/`, `routes/`, controllers | Handlers that walk `body.order.customer…` **and then apply domain rules** (lod / tda). Parsing a DTO into arguments is not a fail |
| UI components | `components/`, widgets, forms | View code that mutates a domain graph or reimplements a domain rule. Label reads on a view model are not a fail (lod / tda) |
| Pages / layouts | `app/**/page.tsx`, screens | Pages that reach through entities to decide shipping, price, or status (tda / lod) |
| Jobs / workers | `worker/`, `jobs/`, `batch/` | Batch code that walks or mutates aggregates the service already owns (lod / tda) |

## Dimension hunt lists (search the tree)

Use ripgrep / file reads. Record hits even when the file looks “peripheral”. Then apply the false-positive list before filing.

### lod

- Two or more hops on a domain or service object: `.getX().getY(`, `order.customer.address`, `a.b.c.d`.
- Mutation through a hop: `.push(`, `.splice(`, index assign on another object's collection.
- A chain whose intermediate is a **returned** object, not a field of `this` and not a parameter of this function.
- At `pragmatic`, **notice** mapper and presenter walks. **File** when the same walk sits in domain policy or mutates. Notice ≠ violation.
- Do not file `map` / `filter` / `reduce`, stdlib chains, or fluent calls that return the same builder type.

### tda

- `if` / ternary on a getter or field immediately followed by a mutation or a second call on that object (`balance <`, `status ===`, then `withdraw` / `ship` / assignment).
- A function whose body mostly reads another type's fields and branches.
- Callers that set two fields that must stay in sync (`items` and `total`).
- At `pragmatic`, **do not file** a display read, a pass-through argument, a null check, or the caller's own authz check.
- Anemic records with no invariant: skip, or Needs verification if you cannot tell whether a rule was stolen.

## Minimum coverage gate (package audit)

Before finishing a package/app review, confirm you can answer **yes** or cite “absent in tree”:

- [ ] Train-wreck or second-hop hunt in domain/services **or** explicit “no stranger walks”
- [ ] Ask-then-decide / feature-envy hunt **or** explicit “no stolen rules”
- [ ] Mapper and presenter walks noticed and **not** filed as lod **or** explicit “no mappers”
- [ ] Collection pipelines and same-type fluent builders **not** filed
- [ ] API or UI edge swept for domain rules hiding in handlers **or** that edge absent
- [ ] Jobs/workers swept **or** absent
- [ ] No suggested fix is only a pure forwarder
- [ ] No finding whose real axis is a missing port (SOLID D) or a god class (SOLID S)

If any checkbox is unchecked without a written reason (“folder missing” / “searched, none”), the audit is incomplete — keep searching.

## Reporting duplicates

Prefer:

```
- Location: order-service.ts:40; ship/route.ts:18
- Dimension: lod — Law of Demeter
- Why: shipping policy reads order.customer.address.city in the service and again in the route
```

Do not collapse the package into a single “coupling is weak” sentence without paths.
