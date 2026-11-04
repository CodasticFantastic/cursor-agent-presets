# SOLID Preset for Cursor

Production-ready design-principles preset for Cursor IDE.

It enforces and helps implement the level and paradigm in `solid.config.json`. The shipped file is **pragmatic OOP** with all five SOLID principles.  
Change `level` to `strict` or `educational`, or `paradigm` to `functional`, in that file. A request in chat overrides the file for that turn.  
Narrow `principles` to a subset (e.g. `["S","D"]`) when you want a focused audit.

## What this preset includes

| Layer | File / Folder | Purpose |
|-------|---------------|---------|
| **Rules** | `.cursor/rules/solid.mdc` | Applied on source files. Short reminders only. The skill owns the procedure. |
| **Config** | `.cursor/skills/solid/solid.config.json` | Default `level`, `paradigm`, `languages`, and `principles`. Read on every run. |
| **Skill** | `.cursor/skills/solid/` | The procedure: scope filter, evidence rules, and the report format. Catalogs stay in `references/`. |
| **Subagent** | `.cursor/agents/solid-reviewer.md` | Readonly auditor. Runs when asked, reads the skill, and returns a report to the parent. It does not keep its own template. |
| **References** | `.cursor/skills/solid/references/` | Working catalogs, loaded on demand. Each file owns one kind of change. |

### Key reference files

Each catalog has one owner. A new smell, layer, or code shape goes in that file. It does not get pasted into the rule or the subagent.

- `references/principles-table.md` — working source for S / O / L / I / D: meaning, pass/fail, severity, and the functional mapping
- `references/code-patterns.md` — implementation shapes (TypeScript examples; adapt the syntax)
- `references/anti-patterns.md` — smell catalog
- `references/audit-coverage.md` — the only copy of the package/app layer sweep and coverage gate
- `solid.config.json` — default level, paradigm, example languages, and enabled principles
- `SKILL.md` — the only copy of the scope filter, the evidence rules, and the report format

```json
{
  "level": "pragmatic",
  "paradigm": "oop",
  "languages": ["typescript", "javascript"],
  "principles": ["S", "O", "L", "I", "D"]
}
```

## Levels

Aligned with the level table in `SKILL.md`:

- **pragmatic** — shipped default. Apply an enabled letter where change risk or coupling is real. One implementation may stay concrete until a second is needed.
- **strict** — ports for every cross-boundary collaborator in scope. No fat interface. No type-switch growth in a closed module. Every enabled letter applies.
- **educational** — same technical bar as pragmatic, plus an explicit rationale for each enabled letter on every material design choice.

The agent reads `solid.config.json` before it generates or reviews design-sensitive code. Chat can override that file for one request.

`languages` picks example syntax only. Rule `globs` attach reminders when matching files are edited. Skill `paths` scopes auto-surfacing of the skill for the same extensions. `/solid` and `/solid-reviewer` still work when invoked explicitly.

## How the layers relate

The skill is the procedure. The parent agent and `solid-reviewer` both read it. The skill does not call the subagent.

- The **parent** writes code and can do a review in the same chat.
- **`solid-reviewer`** is for an audit in a separate context. It returns notes and does not edit. The parent decides the next task and applies fixes.
- Do not expect the subagent to start on its own after every edit. Invoke it with `/solid-reviewer` or an explicit review request.

When the guidance changes, edit the owner and leave the procedure alone:

| Change | Edit |
|--------|------|
| Defaults | `solid.config.json` |
| What a letter means, or the functional mapping | `references/principles-table.md` |
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
cp -r /path/to/solid/.cursor ./
```

This preset does not include a hook. Adding `hooks.json` later is optional and is not required for the rule, the skill, or the subagent to load.

## How to use

### Automatic (recommended)
Just write or generate application code. The rules are applied automatically on TypeScript, JavaScript, Python, Java, Kotlin, C#, and Go files.

### Manual / deeper review
You can invoke the skill or subagent at any time:

```
/solid
/solid-reviewer
```

Or simply ask in chat:
- “Refactor this service for Single Responsibility”
- “Review this module for SOLID violations”
- “Introduce a port for the payment gateway (DIP)”

### Example prompts

**Generation**
```
Create an order pricing module that follows SOLID (pragmatic). Inject a price catalog port.
```

**Audit**
```
/solid-reviewer Review the checkout and payment classes for SOLID issues.
```

**Fix**
```
This FeeCalculator switch grows for every payment method. Refactor it for Open/Closed and update the code.
```

**Strict / educational**
```
Audit this package at SOLID strict level and list missing ports at the domain boundary.
```

```
Explain each SOLID principle you apply while refactoring this class (educational).
```

## Stronger automation (recommended for real projects)

This preset works great on its own, but for maximum reliability add automated tooling beside it:

1. **ESLint** (`complexity`, `max-lines-per-function`, import boundaries)
2. **Architecture tests** (e.g. dependency-cruiser, ArchUnit, custom layer tests)
3. **Review ritual** — run `/solid-reviewer` on PRs that touch domain or service boundaries

These tools complement the Cursor preset — they catch structural regressions the AI might miss and enforce the same standards in CI.

## What the agent knows by default

- Apply the enabled letters from `solid.config.json` at the resolved level and paradigm
- Do not invent unused abstractions at `pragmatic`; do not skip enabled letters at `strict`
- Map OOP ↔ functional using `references/principles-table.md` when `paradigm` is `functional`
- Concrete smells and layer hunts live in `references/` — open them on review or package/app audit
- Use `/solid-reviewer` for a readonly audit in a separate context; the parent applies fixes

## Source

Based on the SOLID principles as commonly attributed to Robert C. Martin (Uncle Bob), with pragmatic guidance to avoid over-engineering. Working tables and patterns are markdown.

---

Copy the `.cursor/` folder as-is.  
The structure is required for Cursor to load the rules, skill and agent correctly.
