# Structure Preset for Cursor

Production-ready structure preset for Cursor IDE.

It enforces and helps apply **Single Level of Abstraction (SLAP)** and **guarded DRY** using the level and dimensions in `structure.config.json`. The shipped file is **pragmatic** with both dimensions: `slap`, `dry`.
Change `level` to `strict` or `educational`, or narrow `dimensions`, in that file. A request in chat overrides the file for that turn.

Keep each function at one abstraction level. Before adding a near-copy, search for an existing implementation of the same behavior and prefer extending or parameterizing it when copies share a change reason. Do **not** aim for "as DRY as possible".

## What this preset includes

| Layer | File / Folder | Purpose |
|-------|---------------|---------|
| **Rules** | `.cursor/rules/structure.mdc` | Applied on source files. Short reminders only. The skill owns the procedure. |
| **Config** | `.cursor/skills/structure/structure.config.json` | Default `level`, `languages`, and `dimensions`. Read on every run. |
| **Skill** | `.cursor/skills/structure/` | The procedure: scope filter, evidence rules, and the report format. Catalogs stay in `references/`. |
| **Subagent** | `.cursor/agents/structure-reviewer.md` | Readonly auditor. Runs when asked, reads the skill, and returns a report to the parent. It does not keep its own template. |
| **References** | `.cursor/skills/structure/references/` | Working catalogs, loaded on demand. Each file owns one kind of change. |

### Key reference files

Each catalog has one owner. A new smell, layer, or code shape goes in that file. It does not get pasted into the rule or the subagent.

- `references/principles-table.md` — working source for slap / dry: meaning, pass/fail, severity
- `references/code-patterns.md` — implementation shapes (TypeScript examples; adapt the syntax)
- `references/anti-patterns.md` — smell catalog, including false-DRY and lookalike exceptions
- `references/audit-coverage.md` — the only copy of the package/app layer sweep and coverage gate
- `structure.config.json` — default level, example languages, and enabled dimensions
- `SKILL.md` — the only copy of the scope filter, the evidence rules, and the report format

```json
{
  "level": "pragmatic",
  "languages": ["typescript", "javascript"],
  "dimensions": ["slap", "dry"]
}
```

## Levels

Aligned with the level table in `SKILL.md`:

- **pragmatic** — shipped default. File mixed-level policy+plumbing and near-duplicates that share a change reason. Allow short similar mappers and one-off edge adapters.
- **strict** — challenge every mixed-level step and every justified near-duplicate pair in scope. Every enabled dimension applies.
- **educational** — same technical bar as pragmatic, plus an explicit rationale for each enabled dimension on every material function or duplication decision.

The agent reads `structure.config.json` before it generates or reviews structure-sensitive code. Chat can override that file for one request.

`languages` picks example syntax only. Rule `globs` attach reminders when matching files are edited. Skill `paths` scopes auto-surfacing of the skill for the same extensions. `/structure` and `/structure-reviewer` still work when invoked explicitly.

## Dimensions

| Id | Focus |
|----|--------|
| `slap` | Single Level of Abstraction — one grain of steps per function |
| `dry` | Guarded DRY — search before invent; extract when copies share a change reason |

## How the layers relate

The skill is the procedure. The parent agent and `structure-reviewer` both read it. The skill does not call the subagent.

- The **parent** writes code and can do a review in the same chat.
- **`structure-reviewer`** is for an audit in a separate context. It returns notes and does not edit. The parent decides the next task and applies fixes.
- Do not expect the subagent to start on its own after every edit. Invoke it with `/structure-reviewer` or an explicit review request.

When the guidance changes, edit the owner and leave the procedure alone:

| Change | Edit |
|--------|------|
| Defaults | `structure.config.json` |
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
cp -r /path/to/structure/.cursor ./
```

This preset does not include a hook. Adding `hooks.json` later is optional and is not required for the rule, the skill, or the subagent to load.

### Combining with other presets

If you already use [`solid`](../solid), [`kiss`](../kiss), [`coupling`](../coupling), or [`wcag-2.2`](../wcag-2.2), merge the contents of each preset’s `.cursor/` folders (rules, skills, agents, and hooks when present) into one project `.cursor/`.
Only `kiss` ships a hook. Keep that `hooks.json` as-is when merging.

Structure complements the others. Speculative extracts are KISS. God modules and missing ports are SOLID. Train wrecks are coupling. Do **not** collapse divergent rules into flag soup in the name of DRY.

## How to use

### Automatic (recommended)
Just write or generate application code. The rules are applied automatically on TypeScript, JavaScript, Python, Java, Kotlin, C#, and Go files.

### Manual / deeper review
You can invoke the skill or subagent at any time:

```
/structure
/structure-reviewer
```

Or simply ask in chat:
- “Search for an existing fee helper before adding another”
- “Review this module for SLAP and near-duplicates”
- “Flatten this use case so policy is not mixed with SQL”

### Example prompts

**Generation**
```
Add overnight delivery pricing. Search billing for existing fee ladders first and extend them instead of a new twin.
```

**Audit**
```
/structure-reviewer Review billing and worker for mixed-level functions and justified DRY twins.
```

**Fix**
```
This closeDay method validates, queries SQL, and builds HTML. Split to one abstraction level and keep the orchestration thin.
```

**Strict / educational**
```
Audit this package at structure strict level and list every near-duplicate pair with a shared change reason.
```

```
Explain each structure dimension you apply while parameterizing these three fee helpers (educational).
```

## What the agent knows by default

- Apply the enabled dimensions from `structure.config.json` at the resolved level
- Search before inventing a near-copy; do not aim for "as DRY as possible"
- Concrete smells and layer hunts live in `references/` — open them on review or package/app audit
- A speculative multi-mode util is not a dry fix. Accidental resemblance is not a fail
- Use `/structure-reviewer` for a readonly audit in a separate context; the parent applies fixes

## Source

Based on the Single Level of Abstraction Principle and Don't Repeat Yourself as commonly used in Clean Code practice, with explicit guards against false DRY and premature abstraction. Working tables and patterns are markdown.

---

Copy the `.cursor/` folder as-is.
The structure is required for Cursor to load the rules, skill and agent correctly.
