# Chunking

This file is the only copy of how a diff is cut. Add a grouping rule here, not in `SKILL.md`, the rule, or `code-reviewer`.

The parent needs a file list and line counts first. It does not read every changed body before the chunks exist.

`maxLinesPerChunk` in `code-review.config.json` is a ceiling, not a target. Do not glue two unrelated directories together to fill it.

## What stays together

One chunk is one related set:

- A changed function and the files in the same feature folder that call it or are called by it.
- A test file and the source file it exercises.
- Near-copies and twins the change touches (`*Fee`, `*Mapper`, the same exported name in a sibling folder). Search imports of the changed files before you close the set. DRY, SOLID, and coupling need those siblings in the same check.
- A Nest controller and its service, DTO, and module when they change together.
- A React component and the hooks it uses when they change together.

## What stays apart

- Two top-level packages that do not import each other.
- A UI tree and an API module that only share a name.
- Generated files, lockfiles, and snapshots. They are not a chunk.

## When a set is too big

If one related set is over `maxLinesPerChunk`:

1. Split on the next folder boundary inside that set.
2. On each smaller chunk, list the sibling paths that were cut away. The lane reviewer must search those paths for twins and call sites. It does not read them all.
3. Say in the report that the set was split, and which paths were named as siblings.

## Inventory

Compare against `base` from config unless the user names another base. `HEAD` means the working tree and the index against `HEAD`.

Drop paths that match none in `routing.md` before you count lines.
