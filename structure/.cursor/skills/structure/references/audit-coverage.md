# Structure Audit Coverage — Package / App Sweep

This file is the only copy of the layer sweep and the coverage gate. Add a layer or a hunt here, not in `SKILL.md`, the rule, or `structure-reviewer`.

**When to load:** more than one file, or any package/app scope. Do not use this checklist for single-file scope — still review that file.

Goal: stop “one long function” audits that miss the same mixed levels or the same near-copy in utils, services, API, and jobs.

Load with `anti-patterns.md` and `principles-table.md`. Report every hit with `path:line` + dimension id. For **dry**, list every twin location.

## Hard rules (fail the audit if you skip them)

1. **Do not stop after the first long function.** One critical finding does not clear the package.
2. **Do not trust filenames.** `Shared*`, `Common*`, `Base*`, `*Utils*` can still mix levels or hide junk-drawer duplication — read the body.
3. **One clean helper is not a package pass.** A tiny pure function may be fine while services still paste twins — keep sweeping.
4. **Same smell, many layers.** If the same fee/tax/status policy appears in services **and** API **and** worker, file **each** location (or one finding that lists every path:line).
5. **Search before declaring "no duplication".** For dry, ripgrep for sibling names (`*Fee`, `*Tax`, `calculate*`, `to*Dto`) and skim near matches. "I did not notice twins" is not a pass.
6. **Do not recommend speculative extracts.** A dry fix needs existing twins with a shared change reason — not a future framework.
7. **Do not import other presets' findings.** A missing port is not slap. A train wreck is not dry. Nested `if` clarity alone is KISS flow unless levels mix.
8. **High/Critical dry needs ≥2 paths.** One location cannot prove duplication.

## Mandatory layer sweep

Walk **every** layer that exists in scope. Skip a row only if that folder is absent.

| Layer | Typical paths | What to hunt |
|-------|---------------|--------------|
| Types / contracts | `types/`, shared DTOs | Fat mappers that mix parsing with policy (slap); duplicated mapping tables that must stay in sync (dry) |
| Utils / helpers | `utils/`, `lib/`, `helpers/` | Near-copy helpers; junk-drawer "shared" that duplicates domain policy (dry / slap) |
| Domain / services | `services/`, `domain/` | Mixed-level use cases; twin fee/tax/status policies (slap / dry) |
| Adapters | `payments/`, `mail/`, `gateways/` | Adapter that inlines policy already living in domain (dry); adapter that also orchestrates use case + HTML (slap) |
| HTTP / API | `app/api/`, `routes/`, controllers | Handlers that embed full use cases with SQL/HTML (slap); copy-pasted handler bodies that share a change reason (dry) |
| UI components | `components/`, widgets, forms | Components that reimplement domain fee/status rules (dry). Presentational repetition alone is not a fail |
| Pages / layouts | `app/**/page.tsx`, screens | Pages that paste the same data-prep policy as the API (dry / slap) |
| Jobs / workers | `worker/`, `jobs/`, `batch/` | Batch twins of service policies; mixed-level job bodies (dry / slap) |

## Dimension hunt lists (search the tree)

Use ripgrep / file reads. Record hits even when the file looks “peripheral”. Then apply the false-positive list before filing.

### slap

- Functions with comment banners (`// validate`, `// save`, `// send`) still inlined.
- Bodies that both branch on domain state and contain raw SQL, HTML templates, or byte/hex work.
- Use-case methods longer than a short orchestration list that call no named peers.
- At `pragmatic`, **notice** dense but single-grain algorithms. **File** when policy and plumbing share the body. Notice ≠ violation.

### dry

- Sibling names: `*Fee`, `*Tax`, `*Discount`, `calculate*`, `compute*`, `to*Dto`, `map*`, `is*Active`.
- Blocks that differ by one literal, one enum, or renamed locals.
- The same `switch` / status map in two packages.
- A new file that mirrors control flow of a neighbor in the same folder.
- At `pragmatic`, **do not file** short lookalike DTO maps or unrelated handlers. **File** when domain policy twins share a change reason.
- For each High+ finding, list every twin `path:line` and one sentence for the shared change reason.

## Minimum coverage gate (package audit)

Before finishing a package/app review, confirm you can answer **yes** or cite “absent in tree”:

- [ ] Mixed-level / comment-banner hunt in domain/services **or** explicit “no mixed levels”
- [ ] Near-duplicate hunt via name/sibling search **or** explicit “searched, no justified twins”
- [ ] Lookalike mappers and unrelated handlers **not** filed as dry without a change reason
- [ ] No recommended fix is a speculative multi-mode framework
- [ ] API or UI edge swept for pasted domain policy **or** that edge absent
- [ ] Jobs/workers swept **or** absent
- [ ] Every High/Critical dry finding lists ≥2 locations
- [ ] No finding whose real axis is a missing port (SOLID D), train wreck (coupling), or YAGNI theater (KISS)

If any checkbox is unchecked without a written reason (“folder missing” / “searched, none”), the audit is incomplete — keep searching.

## Reporting duplicates

Prefer:

```
- Location: packages/billing/src/rush-fee.ts:4; packages/billing/src/overnight-fee.ts:4; apps/worker/src/fees.ts:12
- Dimension: dry — Don't Repeat Yourself (guarded)
- Why: same mileage ladder with different base/per-mile; a rate change must touch all three
```

Do not collapse the package into a single “not DRY enough” sentence without paths.
