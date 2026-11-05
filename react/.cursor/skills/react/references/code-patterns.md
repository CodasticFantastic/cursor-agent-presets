# Code Patterns for React

Implementation shapes. Add a shape here, not in `SKILL.md`, the rule, or `react-reviewer`. Examples are TypeScript. Adapt the syntax to the file. `languages` in `react.config.json` does not limit which files these shapes apply to, and a new language does not need a new file.

Prefer the smallest change that restores the rule.

## hooks — Call them first

```tsx
function Profile({ userId }: { userId: string }) {
  const [user, setUser] = useState<User | null>(null);

  if (!userId) return null;

  return <p>{user?.name}</p>;
}
```

A custom hook starts with `use` and calls its hooks on every run, before any conditional return.

## boundary — Leaf client, plain props

```tsx
"use client";

export function Counter() {
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(count + 1)}>{count}</button>;
}
```

A Server Component imports `Counter` and passes `initial` as a number. It does not pass `onClick`. It does not call `useState`.

Drop `"use client"` from a file that only returns static JSX when a Server Component imports that file. A directive that no server file imports does not move the boundary.

## state — Derive during render

```tsx
function Greeting({ first, last }: { first: string; last: string }) {
  const fullName = first + " " + last;
  return <h1>{fullName}</h1>;
}
```

Reset a subtree by changing its identity:

```tsx
<Editor key={documentId} documentId={documentId} />
```

An effect is for a subscription:

```tsx
useEffect(() => {
  const subscription = events.subscribe(onEvent);
  return () => subscription.unsubscribe();
}, [onEvent]);
```

## key — Stable id on the element you return

```tsx
items.map((item) => <Row key={item.id} item={item} />)
```

Do not use `key={index}` when `items` is sorted or filtered in this render. Do not use `Math.random()`.
