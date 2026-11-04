# SOLID Preset for Cursor

Production-ready design-principles preset for Cursor IDE.

It enforces and helps implement the level and paradigm in `solid.config.json`. The shipped file is **pragmatic OOP** with all five SOLID principles.  
Change `level` to `strict` or `educational`, or `paradigm` to `functional`, in that file. A request in chat overrides the file for that turn.  
Narrow `principles` to a subset (e.g. `["S","D"]`) when you want a focused audit.

## What this preset includes

| Layer | File / Folder | Purpose |
|-------|---------------|---------|
| **Rules** | `.cursor/rules/solid.mdc` | Automatically applied on source files. Forces SOLID-aware generation. |
| **Config** | `.cursor/skills/solid/solid.config.json` | Default `level`, `paradigm`, `languages`, and `principles`. Read on every run. |
| **Skill** | `.cursor/skills/solid/` | On-demand full workflow, principle checklist, patterns and anti-patterns. |
| **Subagent** | `.cursor/agents/solid-reviewer.md` | Specialized, independent SOLID auditor (readonly). |
| **Hook** | `.cursor/hooks.json` + `hooks/solid-reminder.sh` | After every source edit: logs a SOLID reminder; runs ESLint complexity heuristics when available. |
| **References** | `.cursor/skills/solid/references/` | Principles table, code patterns, anti-patterns. Loaded on demand. |

### Key reference files

- `references/principles-table.md` — checklist for S / O / L / I / D with pass/fail signals
- `references/code-patterns.md` — ready-to-use TypeScript (and functional) patterns
- `references/anti-patterns.md` — smells, fixes, and pragmatic false positives
- `references/audit-coverage.md` — **mandatory layer sweep** for package/app audits (utils, pages, workers/BFF/bus/config, name theater, scattered OCP, LSP call sites, DIP cycles/theater)
- `solid.config.json` — default level, paradigm, and enabled principles

```json
{
  "level": "pragmatic",
  "paradigm": "oop",
  "languages": ["typescript", "javascript"],
  "principles": ["S", "O", "L", "I", "D"]
}
```

## Levels

- **pragmatic** — shipped default. Apply SOLID where it reduces real coupling or change risk. Avoid unused interfaces and ceremony.
- **strict** — enforce enabled principles on every new public type and cross-boundary collaborator in scope.
- **educational** — same technical bar as pragmatic, plus an explicit S/O/L/I/D rationale on material choices.

The agent reads `solid.config.json` before it generates or reviews design-sensitive code. Chat can override that file for one request.

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
cp -r /path/to/solid/.cursor ./
```

On Unix, ensure the hook is executable:

```bash
chmod +x .cursor/hooks/solid-reminder.sh
```

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

## Hook behavior

After every edit of a source file (`.ts`, `.tsx`, `.js`, `.py`, `.java`, …) the hook:

1. Detects that the file is application source.
2. Writes a SOLID reminder to `.cursor/logs/hooks/solid-YYYYMMDD.log`.
3. If the project has ESLint, runs complexity / max-lines-per-function heuristics on the changed file.
4. Never blocks the agent (fail-open).

Complexity warnings are **heuristics**, not a SOLID verdict. Use `/solid-reviewer` for a real design assessment.

To get the lint part, install ESLint in your project:

```bash
npm install --save-dev eslint
```

## Stronger automation (recommended for real projects)

This preset works great on its own, but for maximum reliability add automated tooling:

1. **ESLint** (`complexity`, `max-lines-per-function`, import boundaries)
2. **Architecture tests** (e.g. dependency-cruiser, ArchUnit, custom layer tests)
3. **Review ritual** — run `/solid-reviewer` on PRs that touch domain or service boundaries

These tools complement the Cursor preset — they catch structural regressions the AI might miss and enforce the same standards in CI.

## What the agent knows by default

- Prefer one reason to change per module (S) — including utils, validators, repos, and UI shells
- Extend with strategies/composition instead of editing closed cores (O) — hunt **scattered** switches, not only the largest service; defs folders do not clear a closed factory
- Subtypes must honor base contracts; prefer composition when inheritance would lie (L) — also follow call sites on pages/layouts/routes/workers; watch template-method skips, conditional identity on effectful bases, and sibling subtypes after one OK type
- Prefer small role interfaces over fat ports (I)
- Depend on abstractions; inject concrete adapters at the edge (D) — flag concrete↔concrete cycles, `new` in UI/API, and DIP theater (type-alias ports / fake Container)
- Package/app audits must pass the `audit-coverage.md` gate (do not stop after one god class; sweep workers/BFF/bus/config when present; do not trust Strategy/Factory/Facade/Port names alone)
- At pragmatic level: do not invent unused interfaces or layers; still escalate cross-layer concrete coupling
- Functional mapping when `paradigm` is `functional`

## Source

Based on the SOLID principles as commonly attributed to Robert C. Martin (Uncle Bob), with pragmatic guidance to avoid over-engineering. Working tables and patterns are markdown.

---

Copy the `.cursor/` folder as-is.  
The structure is required for Cursor to load the rules, skill and agent correctly.
