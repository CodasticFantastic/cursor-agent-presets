# KISS Audit Coverage — Package / App Sweep

Use this checklist on **package- or app-scoped** reviews (not a single 20-line diff).  
Goal: stop “one clever helper” audits that miss the same bloat in config, factories, routes, and UI.

Load with `anti-patterns.md` and `principles-table.md`. Report every hit with `path:line` + dimension id.

## Hard rules (fail the audit if you skip them)

1. **Do not stop after the first over-engineered module.** One critical finding does not clear the package.
2. **Do not trust filenames.** Names like `Simple*`, `Lite*`, `Basic*`, `*Factory*`, `*Manager*` can still hide ceremony — read the body.
3. **One clean file is not a package pass.** A tiny util may be fine while config and services are speculative — keep sweeping.
4. **Same smell, many layers.** If unused `provider`/`mode` options, pure forwarders, or kitchen-sink options appear in services **and** API **and** UI, file **each** location (or one finding that lists every path:line).
5. **Do not recommend false simplicity.** Merging domain + infra into a god file, deleting tests, or hiding deps in globals is out of scope as a “fix”.

## Mandatory layer sweep

Walk **every** layer that exists in scope. Skip a row only if that folder is absent.

| Layer | Typical paths | What to hunt |
|-------|---------------|--------------|
| Types / contracts | `types/`, shared DTOs | Fat options types; unused optional fields; speculative unions with unimplemented members (surface / yagni) |
| Utils / helpers | `utils/`, `lib/`, `helpers/` | Clever one-liners; micro-deps; unused generic helpers (clarity / deps / yagni) |
| Config | `config/`, env schemas, feature flags | Dead flags; unused providers; mega config objects (yagni / surface) |
| Domain / services | `services/`, `domain/` | Premature factories/plugins; deep nesting; boolean-flag APIs (abstraction / flow / clarity) |
| Adapters | `payments/`, `mail/`, `gateways/` | Extra adapter layers with one destination; overlapping client libs (abstraction / deps) |
| HTTP / API | `app/api/`, `routes/`, controllers | Kitchen-sink query options; unused action branches; forwarder controllers (surface / yagni / flow) |
| UI components | `components/`, widgets, forms | Prop sprawl; unused variants; clever render tricks (surface / clarity / yagni) |
| Pages / layouts | `app/**/page.tsx`, screens | Pages wiring speculative modes; indirection-only hooks (yagni / flow) |
| Package manifests | `package.json`, lockfiles (when in scope) | Overlapping libs; deps used once for a trivial helper (deps) |

## Dimension hunt lists (search the tree)

Use ripgrep / semantic search. Record hits even when the file looks “peripheral”.

### clarity

- Nested ternaries, dense reduces, custom DSLs, metaprogramming decorators used for ordinary control flow.
- Abbreviations that hide domain meaning (`svc`, `mgr`, `ctx2`).
- Magic boolean positional args (`doThing(x, true, false)`).

### yagni

- `not implemented` / `TODO later` / `unused` branches in `switch` on provider/mode/strategy.
- Feature flags read once and hardcoded in prod.
- Config keys never referenced outside the schema.
- Plugin registries with zero plugins.

### abstraction

- `interface` + single `class` + `Factory.create()` with no second impl and no test double.
- `abstract class` with one subclass.
- Wrapper packages that only re-export another module.
- Generic “engine/framework” folders owned by one feature.

### surface

- Exported symbols with no importers (dead public API).
- Options/props types with many optional fields unused at call sites.
- Duplicate public functions that wrap each other.

### deps

- Imports from packages used for one trivial call site.
- Two date/HTTP/validation libraries in the same package.
- Heavyweight framework import in a narrow script/tool.

### flow

- Nesting depth ≥4 in ordinary business functions.
- Files that only forward (`return other.fn(...args)`).
- Central dispatchers with a single destination.

## Minimum coverage gate (package audit)

Before finishing a package/app review, confirm you can answer **yes** or cite “absent in tree”:

- [ ] At least one clarity or flow hit **or** explicit “control flow readable”
- [ ] Speculative provider/mode/flag hunt in config **or** explicit “no dead flags”
- [ ] Premature interface/factory hunt **or** explicit “abstractions justified”
- [ ] Surface/options sprawl in API or UI props **or** explicit “surfaces narrow”
- [ ] Dependency smell in manifests or imports **or** explicit “deps lean”
- [ ] False-simplicity check: no recommendation to create a god module

If any checkbox is unchecked without a written reason (“folder missing” / “searched, none”), the audit is incomplete — keep searching.

## Reporting duplicates

Prefer:

```
- Location: a.ts:10; b.ts:22; config.ts:40
- Dimension: yagni — You Aren't Gonna Need It
- Why: unused mail provider branches wired through service, API, and config
```

Do not collapse the package into a single “could be simpler” sentence without paths.
