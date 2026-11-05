# Agent Presets

Reusable AI agent configurations for [Cursor](https://cursor.com).

**Important:** Each preset is a ready-to-use `.cursor/` folder.
You **must copy the entire `.cursor/` directory exactly as-is** into the root of your project.
Do **not** rename, move or flatten any folders — Cursor expects this precise structure.

## Table of Contents

- [Agent Presets](#agent-presets)
  - [Table of Contents](#table-of-contents)
  - [Available Presets](#available-presets)
  - [How to Use](#how-to-use)
  - [Required Cursor Structure](#required-cursor-structure)
  - [Contributing](#contributing)

## Available Presets

| Preset                   | Description                                                                                                      | Target           |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------- | ---------------- |
| [`wcag-2.2`](./wcag-2.2) | WCAG 2.1 / 2.2 accessibility aid (A/AA/AAA) with a rule, a skill, and a readonly review subagent                | Frontend / UI    |
| [`solid`](./solid)       | SOLID design principles (pragmatic / strict / educational) with a rule, a skill, and a readonly review subagent | Application code |
| [`kiss`](./kiss)         | KISS simplicity (clarity, YAGNI, delayed abstraction, small surfaces) with a rule, a skill, and a readonly review subagent | Application code |
| [`coupling`](./coupling) | Law of Demeter and Tell, Don't Ask (pragmatic / strict / educational) with a rule, a skill, and a readonly review subagent | Application code |
| [`structure`](./structure) | SLAP and guarded DRY (search before invent; pragmatic / strict / educational) with a rule, a skill, and a readonly review subagent | Application code |
| [`security`](./security) | Source-level security (access, injection, secrets, exposure, SSRF, fail-open) with a rule, a skill, and a readonly review subagent | Application code |
| [`tdd`](./tdd) | TDD planning and test-quality audit (cycle, behavior, focus, oracle, isolation, arrange); skill/reviewer plan or audit only — no file edits | Application / tests |
| [`react`](./react) | React (Rules of Hooks, server/client boundary, derived state, list keys) with a rule, a skill, and a readonly review subagent | React UI |
| [`nest`](./nest) | NestJS (thin controllers, boundary validation, dependency injection, HTTP errors at the edge) with a rule, a skill, and a readonly review subagent | NestJS API |
| [`code-review`](./code-review) | Diff orchestrator. Chunks related changes together and routes them to the lane reviewers below | A review of a diff or branch |

[`code-review`](./code-review) does not replace the other presets. A full review expects these agents in the same `.cursor/`:

| Lane | Agent |
|------|--------|
| `solid` | `/solid-reviewer` |
| `kiss` | `/kiss-reviewer` |
| `coupling` | `/coupling-reviewer` |
| `structure` | `/structure-reviewer` |
| `security` | `/security-reviewer` |
| `tdd` | `/tdd-reviewer` |
| `react` | `/react-reviewer` |
| `wcag-2.2` | `/a11y-reviewer` |
| `nest` | `/nest-reviewer` |
| `thermos` | `thermo-nuclear-review-subagent` (plugin; skip the lane if it is not installed) |

`security` is routed to UI and to API. A missing lane is skipped and named in the report. Details of the chunks and the merge live in the [code-review preset](./code-review).

## How to Use

1. Clone or download this repository.
2. Copy the **entire** `.cursor` folder from the chosen preset into the **root** of your project.
3. The resulting structure must look exactly like this:

```
your-project/
├── .cursor/
│   ├── rules/
│   ├── skills/
│   └── agents/
├── ... (your source code)
```

4. Restart Cursor (or reload the window).

**Example (correct):**

```bash
# From your project root
cp -r /path/to/agent-presets/wcag-2.2/.cursor ./
```

**Wrong (do not do this):**

- Copying only individual files
- Renaming `.cursor` to something else
- Putting the contents of `.cursor` directly into the project root

## Required Cursor Structure

Cursor loads each layer from its own path. A preset does not need every layer.

```
.cursor/
├── rules/
│   └── *.mdc                 # Rules (always-on or glob-based)
├── skills/
│   └── <skill-name>/
│       ├── SKILL.md
│       └── references/       # Optional supporting files
└── agents/
    └── *.md                  # Subagents
```

| Layer    | Exact Location                   | Purpose                                  |
| -------- | -------------------------------- | ---------------------------------------- |
| Rules    | `.cursor/rules/*.mdc`            | Always-on or file-type constraints       |
| Skill    | `.cursor/skills/<name>/SKILL.md` | On-demand detailed workflow + references |
| Subagent | `.cursor/agents/*.md`            | Specialized reviewer with own context    |

If the path of a layer is wrong, Cursor will not load that layer. The other layers still load.

## Contributing

1. Create a new folder named after the preset.
2. Place a complete, correctly structured `.cursor/` directory inside it.
3. Add a short description to the table above.
4. Open a pull request.

---

Built for teams that want consistent, production-grade AI-assisted development.
