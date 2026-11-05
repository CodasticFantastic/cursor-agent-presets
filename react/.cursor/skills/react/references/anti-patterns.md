# React Anti-Patterns

Smell catalog. Add a smell here, not in `SKILL.md`, the rule, or `react-reviewer`. Pair with `principles-table.md`, `react-rules.md`, `code-patterns.md`, and (for package audits) `audit-coverage.md`. Apply a row only when its dimension is enabled.

## hooks — Rules of Hooks

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| `useState` / `useEffect` after `if` or after an early `return` | Later renders call the hooks in a different order | Call the hook first. Return after it |
| A hook inside `items.map` in a way that the number of calls changes | The same shift | One component per item, hooks inside that component |
| A hook inside an event handler or a plain helper | It is not a render | Move the hook into the component or into a `use*` function |
| A custom hook that sometimes returns before its own hooks | Callers cannot keep hook order | Hooks first inside the custom hook too |

**Not hooks:** a hook at the top of a function component; a `use*` function that calls hooks unconditionally.

## boundary — Server / client boundary

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| A Server Component imports a file whose only `"use client"` reason is the directive itself (no state, effect, event, or browser API) | That import pulls the server parent onto the client | Drop the directive, or move the client leaf into the file the server actually needs |
| `useState` or `useEffect` in a module that has no `"use client"` while the app is an RSC tree | Server Components cannot call those hooks | Add `"use client"` on that leaf, or remove the hook |
| A Server Component passes `onClick`, a class instance, or another function to a client child | That prop cannot cross the boundary | Keep the handler inside the client child. Pass an id or a plain object |
| A client module imports a module that reads the database or `server-only` | The server code ships toward the browser | Import the server module from a Server Component and pass plain data down |

**Not boundary:** `"use client"` on a button, form, or hook that needs the client; the same directive on a module that no Server Component imports; a client-only app (no RSC). Write `n/a — no server components` instead of a finding when the tree has no server/client split.

## state — Derived state

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| `useEffect` that `setState`s `first + last`, a filter of props, or a boolean computed from props | The render already knows the value. The effect paints a stale frame | `const fullName = first + " " + last` during render |
| `useEffect` that does `setValue(prop)` whenever `prop` changes | State is a copy of a prop | Use the prop, or set `key` on the child to reset its own state |
| State that stores `items.filter(...)` and is refreshed in an effect | Two sources of truth | Compute the filtered list during render |

**Not state:** an effect that subscribes, starts a timer, writes to `document`, or fetches on mount; a `useState` initializer that reads the prop once (`useState(prop)` with no effect keeping them in sync).

## key — List identity

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| `key={index}` while the array is sorted, filtered, spliced, or reversed in that render | State inside the row sticks to the wrong item | `key={item.id}` |
| `key={Math.random()}` or `key={Date.now()}` | The row remounts every render | A stable id |
| `array.map` of components with no `key` | React uses the index anyway | A stable id on the element returned from `map` |
| `key` on an inner `<div>` while the component returned from `map` has no key | The list identity is on the wrong node | Put `key` on the outermost element returned from `map` |

**Not key:** `key={item.id}`; an index on a list that is a constant and never reordered, at `pragmatic`.

## False positives (especially at `pragmatic`)

Do **not** treat these as violations:

- A hook called unconditionally before any return
- `"use client"` on a leaf that uses state, an effect, or an event
- A client-only app with no server/client split
- Fetching data in an effect on mount
- An effect that subscribes and unsubscribes
- `useState(initialProp)` that does not mirror later prop changes in an effect
- `key={item.id}`
- A missing label, a contrast pair, or `dangerouslySetInnerHTML` (those are WCAG or security)

## Review process smells (meta)

Flag the **audit itself** as incomplete when:

- Only the first component was opened
- `boundary` was filed in a client-only app
- `"use client"` was filed on a module that no Server Component imports
- A mount fetch or a subscription was filed as derived state
- An index key on a constant list was filed as Critical at `pragmatic`
- A WCAG or security issue was filed as React
- One clean component was treated as a package-wide pass
