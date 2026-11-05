# React Preset for Cursor

Production-ready React preset for Cursor IDE.

It helps apply the Rules of Hooks, the server/client boundary, derived state, and list keys using `react.config.json`. The shipped file is **pragmatic** with all four dimensions: `hooks`, `boundary`, `state`, `key`.
Change `level` to `strict` or `educational`, or narrow `dimensions`, in that file. A request in chat overrides the file for that turn.

The closed rule list is R1–R8 in `references/react-rules.md`. The agent loads that file on every run and does not search the web for extra React rules.

`boundary` applies only when the app has a server/client split. A client-only app is not a boundary failure.

## What this preset includes

| Layer | File / Folder | Purpose |
|-------|---------------|---------|
| **Rules** | `.cursor/rules/react.mdc` | Applied on JSX and TSX. Short reminders only. The skill owns the procedure. |
| **Config** | `.cursor/skills/react/react.config.json` | Default `level`, `languages`, and `dimensions`. Read on every run. |
| **Skill** | `.cursor/skills/react/` | The procedure: scope filter, evidence rules, and the report format. Catalogs stay in `references/`. |
| **Subagent** | `.cursor/agents/react-reviewer.md` | Readonly auditor. Runs when asked, reads the skill, and returns a report to the parent. It does not keep its own template. |
| **References** | `.cursor/skills/react/references/` | Working catalogs, loaded on demand. Each file owns one kind of change. |

### Key reference files

Each catalog has one owner. A new smell, layer, or code shape goes in that file. It does not get pasted into the rule or the subagent.

- `references/react-rules.md` — the only copy of R1–R8 and which dimension each rule maps to. Loaded on every run
- `references/principles-table.md` — working source for the four dimensions: meaning, pass/fail, severity
- `references/code-patterns.md` — implementation shapes (TypeScript examples; adapt the syntax)
- `references/anti-patterns.md` — smell catalog, including effects and keys that are not findings
- `references/audit-coverage.md` — the only copy of the package/app layer sweep and coverage gate
- `react.config.json` — default level, example languages, and enabled dimensions
- `SKILL.md` — the only copy of the scope filter, the evidence rules, and the report format

```json
{
  "level": "pragmatic",
  "languages": ["typescript", "javascript"],
  "dimensions": ["hooks", "boundary", "state", "key"]
}
```

## Levels

Aligned with the level table in `SKILL.md`:

- **pragmatic** — shipped default. File broken hook order, effects that mirror props, non-serializable server props, and index keys on lists that reorder. Leave mount fetches and `"use client"` on interactive leaves alone.
- **strict** — every hook call, client boundary, derived value, and list key in scope follows the closed list. Every enabled dimension applies.
- **educational** — same technical bar as pragmatic, plus an explicit rationale for each enabled dimension on every material component or hook.

The agent reads `react.config.json` before it generates or reviews React code. Chat can override that file for one request.

`languages` picks example syntax only. Rule `globs` attach reminders when JSX or TSX files are edited. Skill `paths` scopes auto-surfacing of the skill for the same extensions. `/react` and `/react-reviewer` still work when invoked explicitly.

## Dimensions

| Id | Focus |
|----|--------|
| `hooks` | Rules of Hooks — top level only, components and custom hooks only |
| `boundary` | `"use client"` only when a Server Component imports a module that does not need the client; serializable props across the boundary |
| `state` | Derive during render. Effects subscribe; they do not copy props |
| `key` | Stable list identity. Not the index when the list can reorder |

Accessibility stays in `wcag-2.2`. Untrusted HTML stays in `security`. Function shape stays in `structure` and `kiss`.

## How the layers relate

The skill is the procedure. The parent agent and `react-reviewer` both read it. The skill does not call the subagent.

- The **parent** writes code and can do a review in the same chat.
- **`react-reviewer`** is for an audit in a separate context. It returns notes and does not edit. The parent decides the next task and applies fixes.
- Do not expect the subagent to start on its own after every edit. Invoke it with `/react-reviewer` or an explicit review request.

When the guidance changes, edit the owner and leave the procedure alone:

| Change | Edit |
|--------|------|
| Defaults | `react.config.json` |
| What a dimension means | `references/principles-table.md` |
| The eight React rules | `references/react-rules.md` |
| A smell | `references/anti-patterns.md` |
| A code shape | `references/code-patterns.md` |
| A layer or a coverage check | `references/audit-coverage.md` |
| The workflow, the filter, or the report | `SKILL.md` |

## How to install

1. Copy the entire `.cursor/` folder from this preset into the **root** of your project.
2. The structure must stay exactly like this (do not rename or flatten folders):

```
your-project/
├── .cursor/
│   ├── rules/
│   ├── skills/
│   └── agents/
├── ... (your source code)
```

3. Restart Cursor or reload the window.

```bash
# From your project root
cp -r /path/to/react/.cursor ./
```

This preset does not include a hook. Adding `hooks.json` later is optional and is not required for the rule, the skill, or the subagent to load.

### Combining with other presets

If you already use [`solid`](../solid), [`kiss`](../kiss), [`coupling`](../coupling), [`structure`](../structure), [`security`](../security), [`tdd`](../tdd), or [`wcag-2.2`](../wcag-2.2), merge the contents of each preset’s `.cursor/` folders into one project `.cursor/`.
Only `kiss` ships a hook. Keep that `hooks.json` as-is when merging.

## How to use

### Automatic (recommended)
Just write or generate JSX or TSX. The rule is applied on those files.

### Manual / deeper review

```
/react
/react-reviewer
```

Or ask in chat:

- "This effect copies the user prop into state. Derive it during render."
- "Review the list pages for index keys."
- "Move use client onto the button, not the whole page."

### Example prompts

**Generation**

```
Create a counter button as a client leaf. The page that renders it stays a Server Component and passes a numeric initial value. Do not claim the screen is accessible.
```

**Audit**

```
/react-reviewer Review the account components for hook order, effects, and list keys.
```

**Strict**

```
Audit this package at React strict level and list every index key.
```

## What the agent knows by default

- Apply the enabled dimensions from `react.config.json` at the resolved level
- Load R1–R8 from `references/react-rules.md`. Do not invent a ninth rule
- Do not apply `boundary` to a client-only app
- Do not file a mount fetch, a subscription, or a WCAG issue as React
- Use `/react-reviewer` for a readonly audit in a separate context; the parent applies fixes

## Source

Based on the React docs: Rules of Hooks, You Might Not Need an Effect, Rendering Lists, and Server Components. Working tables are markdown. This preset does not certify a React version.

---

Copy the `.cursor/` folder as-is.
The structure is required for Cursor to load the rules, skill and agent correctly.
