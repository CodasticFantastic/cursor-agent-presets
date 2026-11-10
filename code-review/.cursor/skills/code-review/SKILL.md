---
name: code-review
description: "Orchestrate a diff review by routing changed files to the installed lane presets (solid, kiss, coupling, structure, security, tdd, react, wcag-2.2, nest). Cuts the diff into related chunks so twins and call sites stay together. Use when the user asks for a code review, PR review, or a diff audit of a branch or a large commit."
---

# Code review

Use this skill when the user asks for a review of a diff, a branch, or a commit. Do not start it after an ordinary edit.

This skill does not define a design rule. Lane skills do. This file is the procedure: inventory, chunk, route, review, merge.

**Defaults come from `code-review.config.json` in this skill folder** (`base`, `maxLinesPerChunk`, `reportLanguage`, `priorReports`, `commands`, `lanes`). Read that file first. A base, a line ceiling, a report language, a prior-report directory, a command list, or a lane list stated in the chat overrides the file for that request.
If the file is missing, `base` is `HEAD`, `maxLinesPerChunk` is 2000, `reportLanguage` is `en`, `priorReports` is empty, `commands` is empty, and `lanes` is the ten names in the shipped file. Drop a lane name that is not one of those ten.
`reportLanguage` is a BCP 47 tag (`en`, `pl`, `de`). The published report is entirely in that language: headings, field names, verdicts, checklist titles, and every sentence. Severity tokens (`CRITICAL`, `HIGH`, `MEDIUM`), rule labels, lane ids, family ids, and `path:line` stay as tokens. A lane report in another language is rewritten into `reportLanguage` during the merge.
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
9. **Report** — Use the format below. Write the whole report in `reportLanguage`. Do not claim the branch is clean, secure, or compliant.

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

This is the only copy of the report. Do not name a product, a ticket host, or a documentation site. Path abbreviations are allowed only for a prefix that actually repeats in this diff.

The whole report is in `reportLanguage`. That includes the title, every heading, every field name, the three verdicts, the line for an empty section, the summary, chunk notes, finding titles, problems, and solutions. Do not leave a heading or a sentence in another language. Do not mix languages inside one report.

These stay as written in every language: `CRITICAL`, `HIGH`, `MEDIUM`, the rule label from `references/merge.md`, `HEAD`, lane ids, branch names, SHAs, commands, and `path:line`. Map a lane's Critical to `CRITICAL` and High to `HIGH`.

`en` and `pl` use the fixed strings below. For any other tag, translate the `en` column into that language and do not reuse the `pl` column.

| Role | `en` | `pl` |
|------|------|------|
| Title | Code Review | Przegląd kodu |
| Date | Date | Data |
| Run | Run | Przebieg |
| Mode | Mode | Tryb |
| Files | Files | Pliki |
| Validation | Validation | Walidacja |
| Previous review | Previous review | Poprzedni przegląd |
| No previous review | none | brak |
| Path abbreviations | Path abbreviations | Skróty ścieżek |
| Summary | Summary | Podsumowanie |
| Verdict | Verdict | Werdykt |
| Ready | Ready to merge | Gotowe do merge |
| After fixes | Merge after fixes | Merge po poprawkach |
| Needs fixes | Needs fixes | Wymaga poprawek |
| Checklist | Fix checklist | Checklista poprawek |
| Findings | Code notes | Uwagi do kodu |
| Location | Location | Lokalizacja |
| Severity label | Severity | Ważność |
| Rule field | Rule | Reguła |
| Problem | Problem | Problem |
| Solution | Solution | Rozwiązanie |
| What held | What went well | Co zrobiono dobrze |
| Empty section | None. | Brak. |

The rule value comes from `references/merge.md`. One primary label. A second label only when that file says the other lane also counts. The field name is the Rule field row. The value stays the token (`KISS`, `DRY`, `WCAG 2.2 AA`).

Use this order. The words in the skeleton are the `en` column. Substitute the `pl` column when the tag is `pl`, or the translation of the `en` column for any other tag. Prose in angle brackets is written in `reportLanguage`.

```
# <Title> — `<branch>` → `<base>`

**<Date>:** <YYYY-MM-DD HH:mm>
**HEAD:** `<sha>` (<YYYY-MM-DD HH:mm>)
**<Run>:** <NN, next number after the prior report, or 01>
**<Mode>:** <which lanes ran, which were skipped>
**<Files>:** <count, insertions, deletions, what was left out of chunks>
**<Validation>:** <each command and its exit code, or that commands was empty and nothing was run>
**<Previous review>:** <path of the one prior file, or the No previous review line>

<Path abbreviations line, or omit>

<which chunks ran, which related set was split, sibling paths>

## <Summary>

**<Verdict>:** `<Ready>` | `<After fixes>` | `<Needs fixes>`

<what the review covered, the heaviest user-facing breaks, and that this is not a certification. An incomplete chunk or an unsettled pair is named here.>

### <Checklist>

- [ ] **HIGH** — #1 <short title> (`path:line`)
- [ ] **MEDIUM** — #2 <short title> (`path:line`)

## <Findings>

### 1. <short title>

- **<Location>:** `path:line`
- **<Severity label>:** HIGH
- **<Rule field>:** <label from merge.md>
- **<Problem>:** <what fails>

> **<Solution>:** <the change that closes it>

## <What held>

- <satisfied checks that matter, each with path:line>
```

A new review leaves every checklist box unchecked. Do not mark `[x]` unless this run verified the current code already has the fix.

If a section has no items, write the Empty section line in `reportLanguage`. A finding without `path:line` stays out of this report. Do not close the report on the first chunk. Do not add a section that names agents, models, or this skill.
