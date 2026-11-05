# React Dimensions Checklist

Working source for what each dimension means, the pass/fail signals, and severity. The skill points here. The closed rule names and the dimension each rule maps to live in `react-rules.md`. Do not copy either table into `SKILL.md`, the rule, or `react-reviewer`.

Level names, the fallback, and which dimensions are in scope live in `SKILL.md`. The section below only changes severity. Examples: TypeScript. Adapt syntax to the file. A new language does not need a second table.

| Id | Name | Question to ask | Pass signal | Fail signal |
|----|------|-----------------|-------------|-------------|
| **hooks** | Rules of Hooks | Is every hook called unconditionally at the top of a component or a custom hook? | Hooks sit before any conditional return, in a function component or a `use*` function | A hook after `return`, inside `if` / `for`, in an event handler, or in a plain function |
| **boundary** | Server / client boundary | Does this module sit on the correct side of the client boundary? | `"use client"` is on a leaf that uses state, effects, or events; Server Components pass plain props | A Server Component imports a `"use client"` module that has no state, effect, or event; a client hook in a Server Component; a function prop crosses from server to client |
| **state** | Derived state | Can this value be computed during render? | The value is a const in the body, or a child resets because its `key` changed | An effect's only job is `setState` of something computed from props or state |
| **key** | List identity | Does the key stay with the same item when the list changes? | `key` is a stable id from the item | `key={index}` on a list that sorts, filters, or inserts; `key={Math.random()}`; a dynamic list with no key |

## Severity guidance

| Severity | Typical cases |
|----------|----------------|
| Critical | A hook that sometimes does not run (state crosses items); `useState` in a Server Component; a function passed from a Server Component to a client child |
| High | An effect that copies props into state; `key={index}` while the list is sorted or filtered in that component; a Server Component imports a `"use client"` module that does not need the client |
| Medium | An index key on a list that might later reorder; a dependency array that omits a value the effect reads. At `pragmatic`, prefer Medium or skip for a static list and for a mount fetch |

## Package audit reminder

When the scope is more than one file, or any package/app scope, also satisfy `audit-coverage.md` (layer sweep + minimum coverage gate). Pass/fail signals above apply **per file**; package health needs breadth, not only the first component.

## Relationship to other presets

| Concern | Guidance |
|---------|----------|
| Missing label, contrast, focus | **Not** React — WCAG |
| `dangerouslySetInnerHTML` of untrusted HTML | **Not** React — security **injection** |
| Missing port, god component, train wreck, mixed abstraction | **Not** React — SOLID, coupling, or structure |
| A client-only app with no `"use client"` anywhere | `boundary` is `n/a — no server components` |

## Severity by level

Scope (which dimensions to audit) is owned by `SKILL.md`. This list only changes how hard a signal is filed.

- At `pragmatic`, do not file a subscription effect, a client fetch on mount, or `"use client"` on an interactive leaf.
- At `strict`, an index key in scope is High even when the list looks static.
