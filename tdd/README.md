# TDD Preset for Cursor

Production-ready Test-Driven Development preset for Cursor IDE.

It helps **plan** red-green-refactor work and **audit** test quality using the level and dimensions in `tdd.config.json`. The shipped file is **pragmatic** with all six dimensions: `cycle`, `behavior`, `focus`, `oracle`, `isolation`, `arrange`.
Change `level` to `strict` or `educational`, or narrow `dimensions`, in that file. A request in chat overrides the file for that turn.

The **skill and `/tdd-reviewer` do not edit files**. They return an ordered TDD plan or a findings report. The parent agent (or a human) implements tests and production code under the rule. Never claim a package is "fully TDD" or "TDD compliant".

## What this preset includes

| Layer | File / Folder | Purpose |
|-------|---------------|---------|
| **Rules** | `.cursor/rules/tdd.mdc` | Applied on source and test files. Concrete test-writing principles. The skill owns the plan/audit procedure. |
| **Config** | `.cursor/skills/tdd/tdd.config.json` | Default `level`, `languages`, and `dimensions`. Read on every run. |
| **Skill** | `.cursor/skills/tdd/` | The procedure: scope filter, plan format, evidence rules, and the report format. Catalogs stay in `references/`. Plan-only and audit-only — no file edits. |
| **Subagent** | `.cursor/agents/tdd-reviewer.md` | Readonly auditor. Runs when asked, reads the skill, and returns a report to the parent. It does not keep its own template. |
| **References** | `.cursor/skills/tdd/references/` | Working catalogs, loaded on demand. Each file owns one kind of change. |

### Key reference files

Each catalog has one owner. A new smell, layer, or code shape goes in that file. It does not get pasted into the rule or the subagent.

- `references/principles-table.md` — working source for the six dimensions: meaning, pass/fail, severity
- `references/code-patterns.md` — plan and test shapes (TypeScript / Vitest-Jest examples; adapt the syntax)
- `references/anti-patterns.md` — smell catalog, including false positives
- `references/audit-coverage.md` — the only copy of the package/app layer sweep and coverage gate
- `tdd.config.json` — default level, example languages, and enabled dimensions
- `SKILL.md` — the only copy of the scope filter, the plan format, the evidence rules, and the report format

```json
{
  "level": "pragmatic",
  "languages": ["typescript", "javascript"],
  "dimensions": ["cycle", "behavior", "focus", "oracle", "isolation", "arrange"]
}
```

## Levels

Aligned with the level table in `SKILL.md`:

- **pragmatic** — shipped default. File clear cycle breaks and test-quality sinks the source already shows. Leave tiny smoke checks and framework boilerplate alone when they are not the contract under change.
- **strict** — every new behavior in scope needs a planned failing case; every enabled dimension applies to the tests in scope.
- **educational** — same technical bar as pragmatic, plus an explicit rationale for each enabled dimension on every material plan step or finding.

The agent reads `tdd.config.json` before it plans or reviews. Chat can override that file for one request.

`languages` picks example syntax only. Rule `globs` attach reminders when matching files are edited. Skill `paths` scopes auto-surfacing of the skill for the same extensions. `/tdd` and `/tdd-reviewer` still work when invoked explicitly.

## Dimensions

| Id | Focus |
|----|--------|
| `cycle` | Red-green-refactor — failing test first, minimum green, then refactor without new requirements |
| `behavior` | Lock observable outcomes / public contract, not private helpers or call graphs |
| `focus` | One reason to fail per test (or a tightly related case set) |
| `oracle` | Meaningful assertions — concrete outcomes, not tautologies or "didn't throw" alone |
| `isolation` | Deterministic tests — seams at I/O, no shared mutable bleed, no flakes |
| `arrange` | Clear Arrange-Act-Assert; the act is not buried in fixture noise |

## How the layers relate

The skill is the procedure. The parent agent and `tdd-reviewer` both read it. The skill does not call the subagent.

- The **parent** (or a human) writes tests and production code, guided by the rule.
- **`/tdd`** returns an ordered red-green-refactor **plan** and does not edit.
- **`tdd-reviewer`** is for an audit in a separate context. It returns notes and does not edit. The parent decides the next task and applies fixes.
- Do not expect the subagent to start on its own after every edit. Invoke it with `/tdd-reviewer` or an explicit review request.

When the guidance changes, edit the owner and leave the procedure alone:

| Change | Edit |
|--------|------|
| Defaults | `tdd.config.json` |
| What a dimension means | `references/principles-table.md` |
| A smell | `references/anti-patterns.md` |
| A code or plan shape | `references/code-patterns.md` |
| A layer or a coverage check | `references/audit-coverage.md` |
| The workflow, the filter, the plan format, or the report | `SKILL.md` |

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
cp -r /path/to/tdd/.cursor ./
```

This preset does not include a hook. Adding `hooks.json` later is optional and is not required for the rule, the skill, or the subagent to load.

### Combining with other presets

If you already use [`solid`](../solid), [`kiss`](../kiss), [`coupling`](../coupling), [`structure`](../structure), [`security`](../security), or [`wcag-2.2`](../wcag-2.2), merge the contents of each preset’s `.cursor/` folders (rules, skills, agents, and hooks when present) into one project `.cursor/`.
Only `kiss` ships a hook. Keep that `hooks.json` as-is when merging.

TDD complements the others. Missing tests are not KISS. A god test file is not filed as SOLID **S** in a TDD report. Over-mocking private methods is `behavior`, not coupling.

## How to use

### Automatic (recommended)
When editing application or test files, the rule applies concrete test-writing principles. Ask `/tdd` for a plan before implementing new behavior.

### Manual / deeper review
You can invoke the skill or subagent at any time:

```
/tdd
/tdd-reviewer
```

Or simply ask in chat:
- “Plan the TDD steps for this payout rule”
- “Review these specs for behavior vs internals and weak oracles”
- “What failing tests come first for this change?”

### Example prompts

**Plan (no code from the skill)**
```
/tdd Plan red-green-refactor for adding a hull premium ladder. List failing cases first.
```

**Audit**
```
/tdd-reviewer Review packages/ledger tests for cycle, behavior, oracle, and isolation.
```

**Strict / educational**
```
Plan this feature at tdd strict level and name every enabled dimension on each step.
```

```
Explain each TDD dimension while planning these three cases (educational).
```

## What the agent knows by default

- Apply the enabled dimensions from `tdd.config.json` at the resolved level
- Skill and reviewer plan or audit only — they do not write test or production files
- Concrete smells and layer hunts live in `references/` — open them on review or package/app audit
- A test that only checks internals or tautologies is not a cycle win
- Use `/tdd-reviewer` for a readonly audit in a separate context; the parent applies fixes

## Source

Based on classic Test-Driven Development (red-green-refactor) and common test-design practice (behavior-focused cases, AAA, deterministic isolation, meaningful oracles). Working tables and patterns are markdown.

---

Copy the `.cursor/` folder as-is.
The structure is required for Cursor to load the rules, skill and agent correctly.
