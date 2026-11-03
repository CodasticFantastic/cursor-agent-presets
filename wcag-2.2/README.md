# WCAG 2.2 Preset for Cursor

Production-ready accessibility preset for Cursor IDE.

It enforces and helps implement **WCAG 2.2 Level AA** by default (the most common legal and industry requirement).  
Level A and Level AAA are also fully supported when you explicitly ask for them.

## What this preset includes

| Layer | File / Folder | Purpose |
|-------|---------------|---------|
| **Rules** | `.cursor/rules/wcag-2.2.mdc` | Automatically applied on UI files. Forces good accessibility patterns while generating code. |
| **Skill** | `.cursor/skills/wcag-2.2/` | On-demand full workflow, normative criteria, code patterns and the complete success criteria table. |
| **Subagent** | `.cursor/agents/a11y-reviewer.md` | Specialized, independent accessibility auditor (readonly). |
| **Hook** | `.cursor/hooks.json` + `hooks/a11y-reminder.sh` | After every UI file edit: detects the file and runs `eslint-plugin-jsx-a11y` when available. Logs results. |
| **References** | `.cursor/skills/wcag-2.2/references/` | Single source of truth table (A/AA/AAA) + new 2.2 criteria + code patterns. |

### Key reference files

- `references/wcag-2.2-success-criteria-table.md` — complete readable table of all 86 criteria with A / AA / AAA columns
- `references/new-criteria.md` — normative text of the 9 new WCAG 2.2 success criteria
- `references/code-patterns.md` — ready-to-use HTML/CSS/JS patterns for the highest-impact criteria

## Conformance levels

- **Level A** — minimum (only criteria marked in column A)
- **Level AA** — default target (all A + AA). Recommended for almost all projects.
- **Level AAA** — strictest (A + AA + AAA). Only applied when you explicitly request it.

The agent always knows the difference and will not enforce AAA unless you ask.

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
cp -r /path/to/wcag-2.2/.cursor ./
```

## How to use

### Automatic (recommended)
Just write or generate UI code. The rules are applied automatically on HTML, JSX, TSX, Vue, Svelte and CSS files.

### Manual / deeper review
You can invoke the skill or subagent at any time:

```
/wcag-2.2
/a11y-reviewer
```

Or simply ask in chat:
- “Review this component for WCAG 2.2 AA”
- “Fix accessibility issues in this form”
- “Make this modal fully keyboard accessible”

### Example prompts

**Generation**
```
Create a accessible login form that supports password managers and meets WCAG 2.2 AA.
```

**Audit**
```
/a11y-reviewer Review the navigation and modal components for WCAG 2.2 AA issues.
```

**Fix**
```
The sticky header is covering focused elements. Fix it according to 2.4.11 and update the code.
```

**Level AAA (explicit)**
```
Audit this page against WCAG 2.2 Level AAA and list the additional criteria that fail.
```

## Hook behavior

After every edit of a UI file (`.tsx`, `.jsx`, `.vue`, `.html`, `.css` …) the hook:

1. Detects that the file is UI-related.
2. If the project has `eslint-plugin-jsx-a11y` installed, runs ESLint on the changed file.
3. Writes a log to `.cursor/logs/hooks/a11y-YYYYMMDD.log`.
4. Never blocks the agent (fail-open).

This gives you automatic local feedback the moment the agent touches a component, without slowing down generation.

To activate the lint part, install the plugin in your project:

```bash
npm install --save-dev eslint-plugin-jsx-a11y
```

## Stronger automation (recommended for real projects)

This preset works great on its own, but for maximum reliability add automated tooling:

1. **eslint-plugin-jsx-a11y** (for React/JSX projects)
   ```bash
   npm install --save-dev eslint-plugin-jsx-a11y
   ```
   Then enable the recommended rules in your ESLint config. The agent will see the lint errors and fix them.

2. **@axe-core/react** or **jest-axe** (component tests)
   ```bash
   npm install --save-dev @axe-core/react
   ```
   Add accessibility assertions in your component tests so regressions are caught in CI.

3. Optional: browser-based tools (axe DevTools, Lighthouse, keyboard-only testing).

These tools complement the Cursor preset — they catch issues the AI might miss and enforce the same standards in CI.

## What the agent knows by default

- Prefer semantic HTML over ARIA
- Visible focus indicators and no focus traps
- Minimum target size 24×24 CSS px (2.5.8)
- Focus must not be fully obscured by sticky elements (2.4.11)
- Single-pointer alternatives for dragging (2.5.7)
- Accessible authentication (password managers + paste) (3.3.8)
- No redundant data entry in multi-step flows (3.3.7)
- Consistent help location (3.2.6)
- Proper contrast, labels, `lang`, alt text, etc.
- 4.1.1 Parsing is obsolete in WCAG 2.2 — do not enforce it

## Source

Based on the official W3C WCAG 2.2 Recommendation (12 December 2024).

---

Copy the `.cursor/` folder as-is.  
The structure is required for Cursor to load the rules, skill and agent correctly.
