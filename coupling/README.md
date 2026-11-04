# Coupling Preset for Cursor

Production-ready coupling preset for Cursor IDE.

It enforces and helps apply **Law of Demeter** and **Tell, Don't Ask** using the level and dimensions in `coupling.config.json`. The shipped file is **pragmatic** with both dimensions: `lod`, `tda`.
Change `level` to `strict` or `educational`, or narrow `dimensions`, in that file. A request in chat overrides the file for that turn.

An object may use itself, its fields, its parameters, and objects it creates. It should not walk a stranger returned by one of those, and it should not pull state out just to reimplement a rule the owner should perform.

## What this preset includes

| Layer | File / Folder | Purpose |
|-------|---------------|---------|
| **Rules** | `.cursor/rules/coupling.mdc` | Applied on source files. Short reminders only. The skill owns the procedure. |
| **Config** | `.cursor/skills/coupling/coupling.config.json` | Default `level`, `languages`, and `dimensions`. Read on every run. |
| **Skill** | `.cursor/skills/coupling/` | The procedure: scope filter, evidence rules, and the report format. Catalogs stay in `references/`. |
| **Subagent** | `.cursor/agents/coupling-reviewer.md` | Readonly auditor. Runs when asked, reads the skill, and returns a report to the parent. It does not keep its own template. |
| **References** | `.cursor/skills/coupling/references/` | Working catalogs, loaded on demand. Each file owns one kind of change. |

### Key reference files

Each catalog has one owner. A new smell, layer, or code shape goes in that file. It does not get pasted into the rule or the subagent.

- `references/principles-table.md` — working source for lod / tda: meaning, pass/fail, severity
- `references/code-patterns.md` — implementation shapes (TypeScript examples; adapt the syntax)
- `references/anti-patterns.md` — smell catalog, including mapper and pipeline exceptions
- `references/audit-coverage.md` — the only copy of the package/app layer sweep and coverage gate
- `coupling.config.json` — default level, example languages, and enabled dimensions
- `SKILL.md` — the only copy of the scope filter, the evidence rules, and the report format

```json
{
  "level": "pragmatic",
  "languages": ["typescript", "javascript"],
  "dimensions": ["lod", "tda"]
}
```

## Levels

Aligned with the level table in `SKILL.md`:

- **pragmatic** — shipped default. File a train wreck or an external decision where domain policy or mutation is real. Allow mappers, presenters, and one-hop reads of plain data.
- **strict** — challenge every second hop and every external rule on a behavior-bearing type in scope. Every enabled dimension applies.
- **educational** — same technical bar as pragmatic, plus an explicit rationale for each enabled dimension on every material collaboration.

The agent reads `coupling.config.json` before it generates or reviews collaboration-sensitive code. Chat can override that file for one request.

`languages` picks example syntax only. Rule `globs` attach reminders when matching files are edited. Skill `paths` scopes auto-surfacing of the skill for the same extensions. `/coupling` and `/coupling-reviewer` still work when invoked explicitly.

## Dimensions

| Id | Focus |
|----|--------|
| `lod` | Law of Demeter — talk only to immediate friends, not `a.getB().getC()` |
| `tda` | Tell, Don't Ask — the owner of the data performs the decision |

## How the layers relate

The skill is the procedure. The parent agent and `coupling-reviewer` both read it. The skill does not call the subagent.

- The **parent** writes code and can do a review in the same chat.
- **`coupling-reviewer`** is for an audit in a separate context. It returns notes and does not edit. The parent decides the next task and applies fixes.
- Do not expect the subagent to start on its own after every edit. Invoke it with `/coupling-reviewer` or an explicit review request.

When the guidance changes, edit the owner and leave the procedure alone:

| Change | Edit |
|--------|------|
| Defaults | `coupling.config.json` |
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
cp -r /path/to/coupling/.cursor ./
```

This preset does not include a hook. Adding `hooks.json` later is optional and is not required for the rule, the skill, or the subagent to load.

### Combining with other presets

If you already use [`solid`](../solid), [`kiss`](../kiss), or [`wcag-2.2`](../wcag-2.2), merge the contents of each preset’s `.cursor/` folders (rules, skills, agents, and hooks when present) into one project `.cursor/`.
Only `kiss` ships a hook. Keep that `hooks.json` as-is when merging.

Coupling complements SOLID and KISS. A missing port is SOLID. A god module is SOLID. Nested control flow is KISS. Do **not** “fix” a chain with a method that only forwards.

## How to use

### Automatic (recommended)
Just write or generate application code. The rules are applied automatically on TypeScript, JavaScript, Python, Java, Kotlin, C#, and Go files.

### Manual / deeper review
You can invoke the skill or subagent at any time:

```
/coupling
/coupling-reviewer
```

Or simply ask in chat:
- “Stop this service from walking `order.customer.address`”
- “Review this module for Law of Demeter and Tell, Don't Ask”
- “Move this balance check onto the account”

### Example prompts

**Generation**
```
Create an Order.ship() that refuses unless the order is paid. Callers must not read status and set it themselves.
```

**Audit**
```
/coupling-reviewer Review the billing and shipping folders for train wrecks and ask-then-decide.
```

**Fix**
```
This handler uses order.customer.address.city to price the shipment. Hide the walk and update the code.
```

**Strict / educational**
```
Audit this package at coupling strict level and list every second hop in domain code.
```

```
Explain each coupling dimension you apply while moving this decision onto Account (educational).
```

## What the agent knows by default

- Apply the enabled dimensions from `coupling.config.json` at the resolved level
- Do not file mapper or presenter reads at `pragmatic`; do not skip domain train wrecks at `strict`
- Concrete smells and layer hunts live in `references/` — open them on review or package/app audit
- A pure forwarder is not a fix. A missing port is not a coupling finding
- Use `/coupling-reviewer` for a readonly audit in a separate context; the parent applies fixes

## Source

Based on the Law of Demeter (principle of least knowledge) and Tell, Don't Ask as commonly used in object-oriented design. Working tables and patterns are markdown.

---

Copy the `.cursor/` folder as-is.
The structure is required for Cursor to load the rules, skill and agent correctly.
