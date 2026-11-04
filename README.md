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

> More presets will be added over time (security, TDD, React patterns, etc.).

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
