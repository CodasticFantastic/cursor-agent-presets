# Lane routing

This file is the only copy of which changed file goes to which lane. Add a route here, not in `SKILL.md`, the rule, or `code-reviewer`.

A lane runs only when it is listed in `code-review.config.json` and at least one file in the chunk matches. A lane that is not installed is skipped. Say which lane was skipped. Do not invent its findings.

`security` runs on UI and on API. It is not server-only.

| Changed path | Lanes |
|--------------|--------|
| `**/*.{tsx,jsx}` with component logic (handlers, hooks, data loading) | `react`, `wcag-2.2`, `security`, `solid`, `kiss`, `coupling`, `structure`, `thermos` |
| `**/*.{tsx,jsx}` that is markup only (no handler, hook, or fetch) | `react`, `wcag-2.2`, `security`, `thermos` |
| `**/*.{controller,service,module,guard,pipe,filter,interceptor,dto}.ts` | `nest`, `security`, `solid`, `kiss`, `coupling`, `structure`, `thermos` |
| Other application source `**/*.{ts,js,mjs,cjs,py,java,kt,cs,go}` | `solid`, `kiss`, `coupling`, `structure`, `security`, `thermos` |
| Tests `**/*.{test,spec}.{ts,tsx,js,jsx}` and `**/__tests__/**` | `tdd` |
| `**/*.{sql,prisma}` | `security`, `thermos` |
| Markdown, lockfiles, snapshots, generated files, images | none |

Markup versus logic is decided by reading the file, not by the folder name. A `.tsx` file that fetches or branches is logic.

The lane reviewer is the readonly agent shipped with that preset:

| Lane | Agent | Skill |
|------|--------|--------|
| `solid` | `/solid-reviewer` | `solid` |
| `kiss` | `/kiss-reviewer` | `kiss` |
| `coupling` | `/coupling-reviewer` | `coupling` |
| `structure` | `/structure-reviewer` | `structure` |
| `security` | `/security-reviewer` | `security` |
| `tdd` | `/tdd-reviewer` | `tdd` |
| `react` | `/react-reviewer` | `react` |
| `wcag-2.2` | `/a11y-reviewer` | `wcag-2.2` |
| `nest` | `/nest-reviewer` | `nest` |
| `thermos` | `thermo-nuclear-review-subagent` | the Thermos review skill |

`thermos` runs once per chunk when any file in that chunk matches a row that lists it. Give that one pass every such file. Several matching rows are still one pass. Do not also start `thermo-nuclear-code-quality-review-subagent`. If the Thermos agent is not available, skip the lane and name it. Do not stop the review, and do not require a ticket tracker or a wiki.

Start a lane agent only for the files in that chunk that match its row. Do not give it the rest of the diff, and do not paste another lane's prompt into the Thermos pass.
