# KISS Preset for Cursor

Production-ready simplicity preset for Cursor IDE.

It enforces and helps apply **Keep It Simple, Stupid** using the level and dimensions in `kiss.config.json`. The shipped file is **pragmatic** with all six dimensions: clarity, yagni, abstraction, surface, deps, flow.  
Change `level` to `strict` or `educational`, or narrow `dimensions`, in that file. A request in chat overrides the file for that turn.

## What this preset includes

| Layer | File / Folder | Purpose |
|-------|---------------|---------|
| **Rules** | `.cursor/rules/kiss.mdc` | Automatically applied on source files. Forces KISS-aware generation. |
| **Config** | `.cursor/skills/kiss/kiss.config.json` | Default `level`, `languages`, and `dimensions`. Read on every run. |
| **Skill** | `.cursor/skills/kiss/` | On-demand full workflow, dimension checklist, patterns and anti-patterns. |
| **Subagent** | `.cursor/agents/kiss-reviewer.md` | Specialized, independent KISS auditor (readonly). |
| **Hook** | `.cursor/hooks.json` + `hooks/kiss-reminder.sh` | After every source edit: logs a KISS reminder; runs ESLint complexity heuristics when available. |
| **References** | `.cursor/skills/kiss/references/` | Dimensions table, code patterns, anti-patterns, audit coverage. Loaded on demand. |

### Key reference files

- `references/principles-table.md` — checklist for clarity / yagni / abstraction / surface / deps / flow
- `references/code-patterns.md` — ready-to-use TypeScript patterns (simple vs over-engineered)
- `references/anti-patterns.md` — smells, fixes, false positives, and false simplicity
- `references/audit-coverage.md` — **mandatory layer sweep** for package/app audits
- `kiss.config.json` — default level and enabled dimensions

```json
{
  "level": "pragmatic",
  "languages": ["typescript", "javascript"],
  "dimensions": ["clarity", "yagni", "abstraction", "surface", "deps", "flow"]
}
```

## Levels

- **pragmatic** — shipped default. Cut complexity where it hurts. Keep structure that already reduces real coupling or change risk.
- **strict** — every new abstraction, option, dependency, and nested branch in scope needs a concrete justification.
- **educational** — same technical bar as pragmatic, plus an explicit dimension rationale on material choices.

The agent reads `kiss.config.json` before it generates or reviews design-sensitive code. Chat can override that file for one request.

## Dimensions

| Id | Focus |
|----|--------|
| `clarity` | Readable, boring, explicit code over clever tricks |
| `yagni` | No speculative features, flags, or unused providers |
| `abstraction` | Delay interfaces/factories/frameworks until a second real need |
| `surface` | Small public APIs, configs, and parameter lists |
| `deps` | Justify every new package; prefer stdlib / existing stack |
| `flow` | Shallow nesting, early returns, no pure-forward wrappers |

## How to install

1. Copy the entire `.cursor/` folder from this preset into the **root** of your project.
2. The structure must stay exactly like this (do not rename or flatten folders):

```
your-project/
├── .cursor/
│   ├── rules/
│   ├── skills/
│   ├── agents/
│   └── hooks/
├── ... (your source code)
```

3. Restart Cursor or reload the window.

```bash
# From your project root
cp -r /path/to/kiss/.cursor ./
```

On Unix, ensure the hook is executable:

```bash
chmod +x .cursor/hooks/kiss-reminder.sh
```

### Combining with other presets

If you already use [`solid`](../solid) or [`wcag-2.2`](../wcag-2.2), merge the contents of each preset’s `.cursor/` folders (rules, skills, agents, hooks) into one project `.cursor/`.  
For hooks: merge the `afterFileEdit` command arrays in `hooks.json` so both reminder scripts run.

KISS and SOLID complement each other: both reject unused ceremony. KISS does **not** excuse god modules or hard-wiring infrastructure into domain code.

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

## Hook behavior

After every edit of a source file (`.ts`, `.tsx`, `.js`, `.py`, `.java`, …) the hook:

1. Detects that the file is application source.
2. Writes a KISS reminder to `.cursor/logs/hooks/kiss-YYYYMMDD.log`.
3. If the project has ESLint, runs complexity / max-depth / max-params / max-lines-per-function heuristics on the changed file.
4. Never blocks the agent (fail-open).

Complexity warnings are **heuristics**, not a KISS verdict. Use `/kiss-reviewer` for a real simplicity assessment.

To get the lint part, install ESLint in your project:

```bash
npm install --save-dev eslint
```

## Stronger automation (recommended for real projects)

This preset works great on its own, but for maximum reliability add automated tooling:

1. **ESLint** (`complexity`, `max-depth`, `max-params`, `max-lines-per-function`)
2. **Dependency hygiene** (e.g. depcheck, knip, or similar unused-export tools)
3. **Review ritual** — run `/kiss-reviewer` on PRs that add frameworks, factories, or config knobs

These tools complement the Cursor preset — they catch complexity regressions the AI might miss and enforce the same standards in CI.

## What the agent knows by default

- Prefer clarity over cleverness — named steps beat dense one-liners
- Do not build speculative providers, flags, or “for later” branches (yagni)
- Wait for a second real use case before interfaces, factories, and plugins
- Keep public APIs and options small; delete dead code
- Justify every new dependency; prefer stdlib and the existing stack
- Prefer early returns and shallow nesting; remove pure-forward wrappers
- Package/app audits must pass the `audit-coverage.md` gate
- At pragmatic level: do not strip ports/layers that already reduce real coupling
- False simplicity (god modules, hidden globals, deleting tests) is not KISS

## Source

Based on the KISS principle (Keep It Simple, Stupid) as commonly used in software engineering, alongside YAGNI and preference for boring, explicit designs. Working tables and patterns are markdown.

---

Copy the `.cursor/` folder as-is.  
The structure is required for Cursor to load the rules, skill and agent correctly.
