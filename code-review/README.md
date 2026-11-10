# Code Review Preset for Cursor

Orchestrates a diff review. It does not add a new design rule. It cuts the diff into related chunks and routes each chunk to the lane presets already in this repo.

A function stays with its callers, callees, tests, and twins so DRY, SOLID, and coupling can see the dependency. `maxLinesPerChunk` only splits a set that is already too big. It does not glue unrelated packages together.

`security` runs on UI and on API.

## What this preset includes

| Layer | File | Purpose |
|-------|------|---------|
| **Rules** | `.cursor/rules/code-review.mdc` | Points at the skill when the user asks for a review. Does not run on an ordinary edit. |
| **Config** | `.cursor/skills/code-review/code-review.config.json` | `base`, `maxLinesPerChunk`, `reportLanguage`, `priorReports`, `commands`, enabled `lanes`. |
| **Skill** | `.cursor/skills/code-review/` | Inventory, chunk, route, merge. |
| **Subagent** | `.cursor/agents/code-reviewer.md` | Readonly orchestrator. May start lane reviewers. Does not edit. |

### References

- `references/chunking.md` — how a diff is grouped
- `references/routing.md` — which files go to which lane, and the agent name for that lane
- `references/merge.md` — which lane wins when two name the same symbol
- `SKILL.md` — the only copy of the workflow and the report format

```json
{
  "base": "HEAD",
  "maxLinesPerChunk": 2000,
  "reportLanguage": "en",
  "priorReports": "",
  "commands": [],
  "lanes": ["solid", "kiss", "coupling", "structure", "security", "tdd", "react", "wcag-2.2", "nest", "thermos"]
}
```

`HEAD` means the working tree and the index against `HEAD`. Name another base in chat when the review is a branch.

`reportLanguage` is a BCP 47 tag. The shipped value is `en`. Set it to `pl` when the review should come back in Polish. A language named in chat overrides the file for that run. The whole merged report is in that language: title, headings, verdicts, and every sentence. `en` and `pl` use the fixed strings in `SKILL.md`. Any other tag translates the English strings. Severity tokens, rule labels, lane ids, and `path:line` stay as tokens.

`priorReports` is a directory of earlier reviews for this repo, or `""`. Empty skips the step. When it is set, the review opens only `priorReports/<branch-slug>/`, where `/` in the branch name is `-`. A longer directory name is a different branch. From that directory it reads the single file with the highest leading number. Items marked `- [x]` or `✅` are checked against the current code. A sentence that says "fixed" is not evidence.

`commands` is empty until the project fills it, for example `["pnpm type-check"]`. Empty means those tools are not run and the report must not say they passed. Each command runs once from the repo root.

`thermos` is one `thermo-nuclear-review-subagent` pass per chunk that contains a file routed to it in `references/routing.md`. Tests, markdown, lockfiles, snapshots, generated files, and images do not start it. A missing plugin skips the lane. It does not block the rest of the review. The code-quality Thermos agent is not run on the same chunk.

## Lane agents this review expects

Install the preset next to `code-review` for every lane you leave enabled. A missing lane is skipped and named in the report. The default list expects all of these:

| Lane | Preset folder | Agent to invoke |
|------|----------------|-----------------|
| `solid` | [`solid`](../solid) | `/solid-reviewer` |
| `kiss` | [`kiss`](../kiss) | `/kiss-reviewer` |
| `coupling` | [`coupling`](../coupling) | `/coupling-reviewer` |
| `structure` | [`structure`](../structure) | `/structure-reviewer` |
| `security` | [`security`](../security) | `/security-reviewer` |
| `tdd` | [`tdd`](../tdd) | `/tdd-reviewer` |
| `react` | [`react`](../react) | `/react-reviewer` |
| `wcag-2.2` | [`wcag-2.2`](../wcag-2.2) | `/a11y-reviewer` |
| `nest` | [`nest`](../nest) | `/nest-reviewer` |
| `thermos` | Cursor Thermos plugin, not a folder in this repo | `thermo-nuclear-review-subagent` |

Copy each preset's `.cursor/` folder into the same project `.cursor/`. Only `kiss` ships a hook. Keep that `hooks.json` when you merge.

You can drop a lane in `code-review.config.json`. UI work still needs `react`, `wcag-2.2`, and `security`. API work still needs `nest` and `security` when the stack is Nest. `solid`, `kiss`, `coupling`, and `structure` are the design lanes for application code. `tdd` runs on tests.

## How to install

```bash
cp -r /path/to/code-review/.cursor ./
```

Merge the other presets the same way. Restart Cursor.

## How to use

```
/code-review
/code-reviewer
```

Or ask for a review of a branch or a diff. The reviewer returns one report. The parent applies fixes.

## What the report is

The merged report uses one shape: header, summary, checklist, numbered findings, and what held. Every heading and sentence follows `reportLanguage`. Each finding names the lane that caught it (`WCAG 2.2 AA`, `KISS`, `DRY`, and the other labels in `references/merge.md`). It is a review of the chunks that ran, not a certification. A chunk that was not reviewed is named in the summary.
