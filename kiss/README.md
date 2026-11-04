# KISS Preset for Cursor

Production-ready simplicity preset for Cursor IDE.

It enforces and helps apply **Keep It Simple, Stupid** using the level and dimensions in `kiss.config.json`. The shipped file is **pragmatic** with all six dimensions: clarity, yagni, abstraction, surface, deps, flow.
Change `level` to `strict` or `educational`, or narrow `dimensions`, in that file. A request in chat overrides the file for that turn.

## What this preset includes

| Layer | File / Folder | Purpose |
|-------|---------------|---------|
| **Rules** | `.cursor/rules/kiss.mdc` | Applied on source files. Short reminders only. The skill owns the procedure. |
| **Config** | `.cursor/skills/kiss/kiss.config.json` | Default `level`, `languages`, and `dimensions`. Read on every run. |
| **Skill** | `.cursor/skills/kiss/` | The procedure: scope filter, evidence rules, and the report format. Catalogs stay in `references/`. |
| **Subagent** | `.cursor/agents/kiss-reviewer.md` | Readonly auditor. Runs when asked, reads the skill, and returns a report to the parent. It does not keep its own template. |
| **References** | `.cursor/skills/kiss/references/` | Working catalogs, loaded on demand. Each file owns one kind of change. |

### Key reference files

Each catalog has one owner. A new smell, layer, or code shape goes in that file. It does not get pasted into the rule or the subagent.

- `references/principles-table.md` — working source for clarity / yagni / abstraction / surface / deps / flow: meaning, pass/fail, severity
- `references/code-patterns.md` — implementation shapes (TypeScript examples; adapt the syntax)
- `references/anti-patterns.md` — smell catalog
- `references/audit-coverage.md` — the only copy of the package/app layer sweep and coverage gate
- `kiss.config.json` — default level, example languages, and enabled dimensions
- `SKILL.md` — the only copy of the scope filter, the evidence rules, and the report format

```json
{
  "level": "pragmatic",
  "languages": ["typescript", "javascript"],
  "dimensions": ["clarity", "yagni", "abstraction", "surface", "deps", "flow"]
}
```

## Levels

Aligned with the level table in `SKILL.md`:

- **pragmatic** — shipped default. Simplify where cognitive load, churn, or ceremony is real. Keep ports and layers that already reduce coupling.
- **strict** — challenge every new abstraction, option, dependency, and nested branch in scope; demand justification. Every enabled dimension applies.
- **educational** — same technical bar as pragmatic, plus an explicit rationale for each enabled dimension on every material design choice.

The agent reads `kiss.config.json` before it generates or reviews design-sensitive code. Chat can override that file for one request.

`languages` picks example syntax only. Rule `globs` attach reminders when matching files are edited. Skill `paths` scopes auto-surfacing of the skill for the same extensions. `/kiss` and `/kiss-reviewer` still work when invoked explicitly.

## Dimensions

| Id | Focus |
|----|--------|
| `clarity` | Readable, boring, explicit code over clever tricks |
| `yagni` | No speculative features, flags, or unused providers |
| `abstraction` | Delay interfaces/factories/frameworks until a second real need |
| `surface` | Small public APIs, configs, and parameter lists |
| `deps` | Justify every new package; prefer stdlib / existing stack |
| `flow` | Shallow nesting, early returns, no pure-forward wrappers |

False simplicity (god module, hidden globals, diverged copy-paste, infra in UI) is **not** a seventh dimension. Audits keep a six-dimension primary and add `Anti-pattern: false-simplicity` on that finding — see `SKILL.md`.

## How the layers relate

The skill is the procedure. The parent agent and `kiss-reviewer` both read it. The skill does not call the subagent.

- The **parent** writes code and can do a review in the same chat.
- **`kiss-reviewer`** is for an audit in a separate context. It returns notes and does not edit. The parent decides the next task and applies fixes.
- Do not expect the subagent to start on its own after every edit. Invoke it with `/kiss-reviewer` or an explicit review request.

When the guidance changes, edit the owner and leave the procedure alone:

| Change | Edit |
|--------|------|
| Defaults | `kiss.config.json` |
| What a dimension means | `references/principles-table.md` |
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
cp -r /path/to/kiss/.cursor ./
```

### Combining with other presets

If you already use [`solid`](../solid), [`coupling`](../coupling), or [`wcag-2.2`](../wcag-2.2), merge the contents of each preset’s `.cursor/` folders (rules, skills, agents) into one project `.cursor/`.

KISS and SOLID complement each other: both reject unused ceremony. KISS does **not** excuse god modules or hard-wiring infrastructure into domain code. A message chain is coupling, not a KISS nesting issue. Do **not** shorten it with a method that only forwards.

## How to use

### Automatic (recommended)
Just write or generate application code. The rules are applied automatically on TypeScript, JavaScript, Python, Java, Kotlin, C#, and Go files.

### Manual / deeper review
You can invoke the skill or subagent at any time:

```
/kiss
/kiss-reviewer
```

Or simply ask in chat:
- “Simplify this module — KISS pragmatic”
- “Review this service for over-engineering”
- “Remove speculative options and unused providers”

### Example prompts

**Generation**
```
Create an order total helper that follows KISS. One path, no provider switch.
```

**Audit**
```
/kiss-reviewer Review the billing and config folders for KISS issues.
```

**Fix**
```
This MailerFactory has four unimplemented providers. Collapse to the one we use and update the code.
```

**Strict / educational**
```
Audit this package at KISS strict level and list every unjustified abstraction.
```

```
Explain each KISS dimension you apply while simplifying this class (educational).
```

## Stronger automation (recommended for real projects)

This preset works great on its own, but for maximum reliability add automated tooling:

1. **ESLint** (`complexity`, `max-depth`, `max-params`, `max-lines-per-function`)
2. **Dependency hygiene** (e.g. depcheck, knip, or similar unused-export tools)
3. **Review ritual** — run `/kiss-reviewer` on PRs that add frameworks, factories, or config knobs

These tools complement the Cursor preset — they catch complexity regressions the AI might miss and enforce the same standards in CI.

## What the agent knows by default

- Apply the enabled dimensions from `kiss.config.json` at the resolved level
- Do not strip useful structure at `pragmatic`; do not skip enabled dimensions at `strict`
- Concrete smells and layer hunts live in `references/` — open them on review or package/app audit
- False simplicity (god modules, hidden globals, deleting tests) is not KISS
- Use `/kiss-reviewer` for a readonly audit in a separate context; the parent applies fixes

## Source

Based on the KISS principle (Keep It Simple, Stupid) as commonly used in software engineering, alongside YAGNI and preference for boring, explicit designs. Working tables and patterns are markdown.

---

Copy the `.cursor/` folder as-is.
The structure is required for Cursor to load the rules, skill and agent correctly.
