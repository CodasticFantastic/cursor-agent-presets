---
name: code-review
description: "Orchestrate a diff review by routing changed files to the installed lane presets (solid, kiss, coupling, structure, security, tdd, react, wcag-2.2, nest). Cuts the diff into related chunks so twins and call sites stay together. Use when the user asks for a code review, PR review, or a diff audit of a branch or a large commit."
---

# Code review

Use this skill when the user asks for a review of a diff, a branch, or a commit. Do not start it after an ordinary edit.

This skill does not define a design rule. Lane skills do. This file is the procedure: inventory, chunk, route, review, merge.

**Defaults come from `code-review.config.json` in this skill folder** (`base`, `maxLinesPerChunk`, `reportLanguage`, `priorReports`, `commands`, `lanes`). Read that file first. A base, a line ceiling, a report language, a prior-report directory, a command list, or a lane list stated in the chat overrides the file for that request.
If the file is missing, `base` is `HEAD`, `maxLinesPerChunk` is 2000, `reportLanguage` is `en`, `priorReports` is empty, `commands` is empty, and `lanes` is the ten names in the shipped file. Drop a lane name that is not one of those ten.
`reportLanguage` is a BCP 47 tag (`en`, `pl`, `de`). The merged report and every lane report are written in that language. Severity tokens (`Critical`, `High`, `Medium`), lane ids, family ids, and `path:line` stay as tokens.
`priorReports` is a directory, or empty. Empty means there is no previous report to check.
`commands` is a list of shell commands, or empty. Empty means no lint, typecheck, or test is run, and the report must not say those checks passed.

The parent applies fixes. This procedure returns a report and does not edit product code. `/code-reviewer` may start only the lane reviewers named in `references/routing.md`, including one Thermos pass per chunk when that lane is enabled. It does not start another code review, and it does not edit files. A missing Thermos plugin skips that lane. It does not stop the review.

## Core Workflow

1. **Read defaults** — Load `code-review.config.json`. Use it unless the user overrides it in chat.
2. **Inventory** — List changed paths and line counts against `base`. Do not read every body yet. Follow `references/chunking.md` for what to drop.
3. **Chunk** — Group related files as `references/chunking.md` describes. Keep a function with its callers, callees, tests, and twins. Do not merge unrelated packages to fill `maxLinesPerChunk`.
4. **Prior report** — If `priorReports` is empty, skip this step. If it is a directory, resolve one file:
   - Slug = current branch name with `/` replaced by `-`.
   - Open only `priorReports/<slug>/` when that directory exists. A directory that merely starts with the slug is a different branch. Do not open it.
   - Inside that directory, take the one file whose name starts with the highest integer (`14-….md` beats `11-….md`). Ignore names that do not start with a number. If two files share that integer, take the one with the later timestamp in the name.
   - Done means a `- [x]` / `- [X]` checkbox or a `✅` on that item. A sentence that says "fixed" or "naprawione" without one of those marks is not done.
   - For each done item, read the current code. The mark itself is not evidence. An item that is still broken is a finding again.
5. **Route** — For each chunk, assign lanes from `references/routing.md`. Skip a lane that is not in `lanes` or not installed. Record the skip. If `thermos` is enabled but the Thermos agent is not available, skip it and continue.
6. **Review** — For each chunk and each assigned lane, run that lane's reviewer on only the matching files. The reviewer follows its own skill. Tell it to write its report in `reportLanguage`. Pass sibling paths when a set was split. Do not paste this procedure into the lane prompt. Thermos is one pass on that chunk, not two.
7. **Commands** — If `commands` is empty, do not run a linter, typecheck, or test, and do not write that they passed. If it has entries, run each command once from the repo root and record the exit code.
8. **Merge** — Combine the lane reports with `references/merge.md`, including the synthesis pass. One primary family per symbol.
9. **Report** — Use the format below. Write the prose in `reportLanguage`. Do not claim the branch is clean, secure, or compliant.

## Where a change goes

| Change | Edit |
|--------|------|
| Default base, chunk ceiling, report language, prior-report directory, commands, or enabled lanes | `code-review.config.json` |
| Which files go to which lane | `references/routing.md` |
| How a diff is grouped | `references/chunking.md` |
| Which lane wins when two name the same symbol | `references/merge.md` |
| The workflow or the report format | This file |

## When to Load References

- Defaults, every run → `code-review.config.json`
- File to lane, every run → `references/routing.md`
- Grouping, every run → `references/chunking.md`
- After the lane reports exist → `references/merge.md`

## Report format

```
## Review result
Language: <reportLanguage>
Scope: <base and range>
Chunks: <count, and which sets were split>
Lanes run: <names>
Lanes skipped: <names and why>
Verdict: this is a review of the chunks that ran, not a certification.

### Coverage
- Chunks swept: <ids or folders>
- Synthesis: <pairs checked across chunks, or “none — sets were not split”>
- Gate: pass | incomplete — <chunk not run, or sibling paths not searched>

### Commands
- <command and exit code> | not run — commands is empty

### Prior reports
- <path verified in code> | none — priorReports is empty

### Findings
- Location: path:line
- Lane: <preset>
- Family: <that preset's dimension or principle>
- Severity: Critical | High | Medium
- Why:
- Fix:

### Needs verification
- Lane:
- Location:
- What is missing:
```

If a section has no items, write "None in this scope." A finding without `path:line` stays under "Needs verification". An incomplete gate means say what was not reviewed. Do not close the report on the first chunk.
