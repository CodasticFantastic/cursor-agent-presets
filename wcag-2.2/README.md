# WCAG 2.2 Preset for Cursor

Production-ready accessibility preset for Cursor IDE.

It enforces and helps implement the standard and level in `wcag.config.json`. The shipped file is **WCAG 2.2 Level AA**.  
Change `standard` to `2.1` or `level` to `A` or `AAA` in that file. A request in chat overrides the file for that turn.  
The same preset can show what changes between 2.1 and 2.2.

## What this preset includes

| Layer | File / Folder | Purpose |
|-------|---------------|---------|
| **Rules** | `.cursor/rules/wcag-2.2.mdc` | Automatically applied on UI files. Forces good accessibility patterns while generating code. |
| **Config** | `.cursor/skills/wcag-2.2/wcag.config.json` | Default `standard` (`2.1` or `2.2`) and `level` (`A`, `AA`, or `AAA`). Read on every run. |
| **Skill** | `.cursor/skills/wcag-2.2/` | On-demand full workflow, normative criteria, code patterns and the complete success criteria table. |
| **Subagent** | `.cursor/agents/a11y-reviewer.md` | Specialized, independent accessibility auditor (readonly). |
| **Hook** | `.cursor/hooks.json` + `hooks/a11y-reminder.sh` | After every UI file edit: detects the file and runs `eslint-plugin-jsx-a11y` when available. Logs results. |
| **References** | `.cursor/skills/wcag-2.2/references/` | Criteria tables for 2.1 and 2.2, the version delta, new 2.2 criteria, and code patterns. Loaded on demand. |
| **Assets** | `.cursor/skills/wcag-2.2/assets/` | Official WCAG 2.1 and 2.2 PDFs. Fallback when a table is not enough. Cursor loads skill assets from this folder. |

### Key reference files

- `references/wcag-2.2-success-criteria-table.md` — all 86 WCAG 2.2 criteria with A / AA / AAA columns
- `references/wcag-2.1-success-criteria-table.md` — all 78 WCAG 2.1 criteria with A / AA / AAA columns
- `references/wcag-2.1-vs-2.2.md` — what 2.2 adds, what it removes, and how to report a migration
- `references/new-criteria.md` — normative text of the 9 new WCAG 2.2 success criteria
- `references/code-patterns.md` — ready-to-use HTML/CSS/JS patterns for the highest-impact criteria
- `assets/WCAG_2.1.pdf`, `assets/WCAG_2.2.pdf` — official recommendation PDFs
- `wcag.config.json` — default standard and level

```json
{
  "standard": "2.2",
  "level": "AA"
}
```

## Conformance levels

- **Level A** — minimum (only criteria marked in column A)
- **Level AA** — shipped default (all A + AA). Recommended for almost all projects.
- **Level AAA** — strictest (A + AA + AAA). Applied when `wcag.config.json` or the chat sets `level` to `AAA`.

The agent reads `wcag.config.json` before it generates or reviews UI. Chat can override that file for one request.

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
- Minimum target size 24×24 CSS px, with the spacing and inline exceptions (2.5.8, WCAG 2.2 only)
- Focus must not be fully obscured by sticky elements (2.4.11, WCAG 2.2 only)
- Single-pointer alternatives for dragging (2.5.7, WCAG 2.2 only)
- Accessible authentication (password managers + paste) (3.3.8, WCAG 2.2 only)
- No redundant data entry in multi-step flows (3.3.7, WCAG 2.2 only)
- Consistent help location (3.2.6, WCAG 2.2 only)
- Proper contrast, labels, `lang`, alt text, etc. (both versions)
- 4.1.1 Parsing is in WCAG 2.1 and removed in WCAG 2.2

## Source

Based on the official W3C WCAG 2.1 and WCAG 2.2 Recommendations. Working tables are markdown. The PDFs in `assets/` are the fallback copies.

---

Copy the `.cursor/` folder as-is.  
The structure is required for Cursor to load the rules, skill and agent correctly.
