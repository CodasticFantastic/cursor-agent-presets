# React rules — closed list

Working list of the React rules this preset applies. The skill points here. Do not copy this table into `SKILL.md`, the rule, or `react-reviewer`. Do not search the web for a longer React rule set. Do not invent a rule that is not in this file.

Names follow the React docs (https://react.dev): Rules of Hooks, You Might Not Need an Effect, Rendering Lists, and Server Components. This file is the copy the agent uses.

`boundary` applies only when the tree has a server/client split (a file with `"use client"`, or a module that runs as a Server Component). A client-only app has no `boundary` findings. Write `n/a — no server components`. That is not a pass and not a failure.

| Id | Rule | Dimension | File when the source shows | Do not file |
|----|------|-----------|----------------------------|-------------|
| R1 | Call hooks only at the top level | `hooks` | A hook after a conditional return, inside `if` / `for` / `while`, or after a conditional that sometimes skips it | A hook at the top of the function, before any return |
| R2 | Call hooks only from React functions | `hooks` | A hook inside a plain function, a class method, or an event handler | A hook in a function component or in a function whose name starts with `use` |
| R3 | Effects synchronize with outside systems | `state` | An effect whose only job is to `setState` a value computed from props or state already in render | A subscription, timer, log, or browser API; a client fetch on mount |
| R4 | Reset state by identity, not by copying props | `state` | An effect that writes a prop into state whenever that prop changes | `key` on the child so React remounts it, or state derived during render |
| R5 | A list key is a stable identity among siblings | `key` | `key={index}` or `key={Math.random()}` on a list that is sorted, filtered, inserted, or reordered; a missing key on a dynamic list | `key={item.id}` ; an index on a static list that never changes order |
| R6 | The client boundary is the file that needs the client | `boundary` | A Server Component imports a module whose `"use client"` is the only client need: that module has no state, no effects, no events, and no browser APIs | `"use client"` on a leaf that calls a hook or an event handler; the same directive on a module that no Server Component imports |
| R7 | Server Components do not use client hooks | `boundary` | `useState`, `useEffect`, or another client hook in a module with no `"use client"` directive in an RSC tree | The same hooks in a client-only app, or in a file that starts with `"use client"` |
| R8 | Props that cross to the client are serializable | `boundary` | A Server Component passes a function, a class instance, or a non-plain object to a Client Component | Plain objects, strings, numbers; a promise passed into `use()` |

## How to cite

Cite the dimension from `principles-table.md` and the id from this table when the row matches (for example, `hooks — Rules of Hooks`, `R1`). One primary dimension. Do not cite `R9`.

If nothing in the list matches, use the dimension question in `principles-table.md`. Do not add a rule from memory.
