# React Audit Coverage — Package / App Sweep

This file is the only copy of the layer sweep and the coverage gate. Add a layer or a hunt here, not in `SKILL.md`, the rule, or `react-reviewer`.

**When to load:** more than one file, or any package/app scope. Do not use this checklist for single-file scope — still review that file.

Goal: stop “one conditional hook” audits that miss the same effect, key, or client boundary in other components.

Load with `anti-patterns.md`, `principles-table.md`, and `react-rules.md`. Report every hit with `path:line` + dimension id + rule id.

## Hard rules (fail the audit if you skip them)

1. **Do not stop after the first conditional hook.** One critical finding does not clear the package.
2. **Do not trust filenames.** `Safe*`, `Pure*`, `Memo*` can still call hooks inside conditions — read the body.
3. **One clean component is not a package pass.**
4. **Same smell, many layers.** If `key={index}` or an effect that copies props appears in a component **and** a page, file **each** location (or one finding that lists every path:line).
5. **Client-only apps are not boundary failures.** If no file has `"use client"` and nothing is a Server Component, write `n/a — no server components` for `boundary`. Notice ≠ violation.
6. **Do not import other presets' findings.** A missing label is not `key`. Untrusted HTML is not `hooks`.

## Mandatory layer sweep

Walk **every** layer that exists in scope. Skip a row only if that folder is absent.

| Layer | Typical paths | What to hunt |
|-------|---------------|--------------|
| Components | `components/`, widgets | Conditional hooks; effect-derived state; index keys (hooks / state / key) |
| Hooks | `hooks/`, `use*.ts` | Early return before a hook inside the custom hook (hooks) |
| Pages | `app/**/page.tsx`, `pages/` | Server pages that call client hooks; pages that pass functions to client children (boundary) |
| Layouts | `layout.tsx`, shells | `"use client"` on a layout that does not need the client and pulls the tree across (boundary) |
| Client modules | files whose first statement is `"use client"` | A directive on a file with no hook and no handler **and** a Server Component imports that file (boundary). The directive alone, with no server importer, is not a finding |

## Dimension hunt lists (search the tree)

Use ripgrep / file reads. Record hits even when the file looks “peripheral”. Then apply the false-positive list before filing.

### hooks

- `useState`, `useEffect`, `useRef`, `useMemo`, `useCallback`, or `use` after `if (` / `return` in the same function.
- A hook call inside `onClick` / `onSubmit` or inside a function that does not start with `use` and is not a component.

### boundary

- `"use client"` — open the file. File only when the module uses no state, no effect, and no event handler **and** a Server Component imports it. No server importer means notice, not a finding.
- `useState` or `useEffect` in a file that has no directive, in a tree that otherwise uses `"use client"`.
- A Server Component JSX prop that is a function (`onClick={`, `action={` defined in the server file) passed into an imported client component.

If the package never uses `"use client"` and has no Server Component entry, mark the dimension `n/a — no server components`.

### state

- `useEffect` whose body calls `set` with a value built from props or from other state, and does not subscribe, time, or fetch.
- `setX(prop)` inside an effect that depends on that prop.

### key

- `key={index}`, `key={i}`, `key={Math.random()}`, `key={Date.now()}`.
- `.map(` that returns an element with no `key`. File when the array is not a module-level constant.

At `pragmatic`, an index key on a constant array is notice, not a finding.

## Minimum coverage gate (package audit)

Before finishing a package/app review, confirm you can answer **yes** or cite “absent in tree”:

- [ ] Hook-order hunt run **or** explicit “no conditional hooks”
- [ ] `boundary` decided: findings, or `n/a — no server components`
- [ ] Effect `setState` hunt **or** explicit “no prop-mirroring effects”
- [ ] List-key hunt **or** explicit “no dynamic lists”
- [ ] Mount fetches and subscriptions were not filed as `state`
- [ ] No WCAG or security finding filed under a React dimension

If any checkbox is unchecked without a written reason (“folder missing” / “searched, none”), the audit is incomplete — keep searching.

## Reporting duplicates

Prefer:

```
- Location: UserRow.tsx:12; AdminRow.tsx:9
- Dimension: key — List identity
- Rule: R5
- Why: both map a sorted list with key={index}
```

Do not collapse the package into “React looks fine” without paths.
