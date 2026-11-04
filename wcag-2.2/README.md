# WCAG 2.2 Preset for Cursor

Accessibility preset for Cursor IDE. It helps implement and review the standard and level in `wcag.config.json`. The shipped file is **WCAG 2.2 Level AA**.

Change `standard` to `2.1` or `level` to `A` or `AAA` in that file. A request in chat overrides the file for that turn.
The same preset can show what changes between 2.1 and 2.2.

This preset does not make a page conform to WCAG. The agent must not claim that a page, component, or project "meets WCAG" or "passes AA". A passing check needs a source location or a named tool result. Lint, axe, and Lighthouse are evidence, not a conformance statement.

## What this preset includes

| Layer | File / Folder | Purpose |
|-------|---------------|---------|
| **Rules** | `.cursor/rules/wcag-2.2.mdc` | Applied on UI files. The level filter and the short requirements live here. |
| **Config** | `.cursor/skills/wcag-2.2/wcag.config.json` | Default `standard` (`2.1` or `2.2`) and `level` (`A`, `AA`, or `AAA`). Read on every run. |
| **Skill** | `.cursor/skills/wcag-2.2/` | Workflow, level filter, evidence rules, code patterns, and the success criteria tables. |
| **Subagent** | `.cursor/agents/a11y-reviewer.md` | Readonly auditor. Runs when asked, keeps the review in its own context, and returns a report to the parent. |
| **References** | `.cursor/skills/wcag-2.2/references/` | Criteria tables for 2.1 and 2.2, the version delta, new 2.2 criteria, and code patterns. Loaded on demand. |

### Key reference files

- `references/wcag-2.2-success-criteria-table.md` — all 86 WCAG 2.2 criteria with A / AA / AAA columns
- `references/wcag-2.1-success-criteria-table.md` — all 78 WCAG 2.1 criteria with A / AA / AAA columns
- `references/wcag-2.1-vs-2.2.md` — what 2.2 adds, what it removes, and how to report a migration
- `references/new-criteria.md` — paraphrases of the 9 new WCAG 2.2 success criteria
- `references/code-patterns.md` — HTML/CSS/JS patterns for the highest-impact criteria
- `wcag.config.json` — default standard and level

Normative text: https://www.w3.org/TR/WCAG21/ and https://www.w3.org/TR/WCAG22/. The working copy for the agent is the markdown tables.

```json
{
  "standard": "2.2",
  "level": "AA"
}
```

## Conformance levels

The rule and the skill apply only the column for the resolved level.

- **Level A** — column A only
- **Level AA** — columns A and AA. Shipped default. Recommended for almost all projects.
- **Level AAA** — columns A, AA, and AAA

A WCAG 2.2 bullet (2.4.11, 2.5.7, 2.5.8, 3.2.6, 3.3.7, 3.3.8, and the AAA criteria 2.4.12, 2.4.13, 3.3.9) applies only when the resolved standard is 2.2 and the resolved level includes that criterion.

The agent reads `wcag.config.json` before it generates or reviews UI. Chat can override that file for one request.

## How the layers relate

The skill is the procedure. The parent agent and `a11y-reviewer` both read it. The skill does not call the subagent.

- The **parent** writes code and can do a review in the same chat.
- **`a11y-reviewer`** is for an audit in a separate context. It returns notes and does not edit. The parent decides the next task and applies fixes.
- Do not expect the subagent to start on its own after every UI edit. Invoke it with `/a11y-reviewer` or an explicit review request.

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
cp -r /path/to/wcag-2.2/.cursor ./
```

This preset does not include a hook. Adding `hooks.json` later is optional and is not required for the rule, the skill, or the subagent to load.

## How to use

### While writing

Write or generate UI code. The rule is applied on HTML, MDX, Astro, JSX, TSX, Vue, Svelte, CSS, and SCSS files. It tells the agent to follow the `wcag-2.2` skill.

### Review in this chat

```
/wcag-2.2
```

Or ask in chat:

- "Review this component against WCAG 2.2 AA and list what the source cannot prove."
- "Fix the accessibility issues in this form."
- "Make this modal keyboard accessible."

### Review in a separate context

```
/a11y-reviewer Review the navigation and modal components for WCAG 2.2 AA issues.
```

The subagent returns a report. It does not change files. Ask the parent to apply the fixes.

### Example prompts

**Generation**

```
Create an accessible login form that supports password managers. Target WCAG 2.2 AA. Do not claim the form conforms.
```

**Audit**

```
/a11y-reviewer Review the navigation and modal components for WCAG 2.2 AA issues.
```

**Fix**

```
The sticky header is covering focused elements. Fix it according to 2.4.11. scroll-padding alone is not enough. Update the code.
```

**Level A**

```
Use level A for this change. Apply only column A.
```

**Level AAA**

```
Audit this page against WCAG 2.2 Level AAA and list the additional criteria that fail.
```

## Checks outside the agent

The preset does not run axe, Lighthouse, or a keyboard test. For a project, add those beside the preset:

1. **eslint-plugin-jsx-a11y** (React / JSX)

   ```bash
   npm install --save-dev eslint-plugin-jsx-a11y
   ```

   Enable the recommended rules in the project's ESLint config. The agent can read diagnostics the IDE surfaces. This preset does not shell out to ESLint.

2. **@axe-core/react** or **jest-axe**

   ```bash
   npm install --save-dev @axe-core/react
   ```

   Assert accessibility in component tests so regressions are caught in CI.

3. Browser checks: axe DevTools, Lighthouse, and a keyboard-only pass.

These tools catch issues the model can miss. Their output still is not a WCAG conformance claim.

## What the agent applies by default

Shipped config is WCAG 2.2 AA, so column A and column AA are in scope. Column AAA is not, until `level` is `AAA`.

- Semantic HTML before ARIA
- Keyboard operation (2.1.1, A) and a visible focus indicator (2.4.7, AA)
- Text contrast 4.5:1, and 3:1 for large text (18pt, or 14pt bold). UI states 3:1 (1.4.3 and 1.4.11, AA)
- Labels, `lang`, and alt text
- WCAG 2.2 AA additions: 24×24 CSS px targets with the spacing, equivalent, inline, user-agent, and essential exceptions (2.5.8); focus not entirely hidden by author-created content (2.4.11); a single-pointer alternative for dragging (2.5.7); authentication without an unsupported cognitive test (3.3.8); no forced re-entry (3.3.7, A); consistent help (3.2.6, A)
- 4.1.1 Parsing is removed in WCAG 2.2. It stays in 2.1 and is not treated as a practical HTML failure

At level AAA the agent also uses the AAA column, including 1.4.6, 2.5.5 (44×44), and, on WCAG 2.2, 2.4.12, 2.4.13, and 3.3.9.

## Source

Based on the W3C WCAG 2.1 and WCAG 2.2 Recommendations. The working tables are markdown. The recommendation URLs above are the normative source.

---

Copy the `.cursor/` folder as-is.
The structure is required for Cursor to load the rule, the skill, and the subagent.
