# Nest Preset for Cursor

Production-ready NestJS preset for Cursor IDE.

It helps apply thin controllers, validation at the HTTP boundary, constructor injection, and HTTP errors kept at the edge, using `nest.config.json`. The shipped file is **pragmatic** with all four dimensions: `controller`, `validation`, `di`, `exceptions`.
Change `level` to `strict` or `educational`, or narrow `dimensions`, in that file. A request in chat overrides the file for that turn.

The closed rule list is N1–N8 in `references/nest-rules.md`. The agent loads that file on every run and does not search the web for extra Nest rules.

A file that does not use Nest is not a Nest finding.

## What this preset includes

| Layer | File / Folder | Purpose |
|-------|---------------|---------|
| **Rules** | `.cursor/rules/nest.mdc` | Applied on Nest file names. Short reminders only. The skill owns the procedure. |
| **Config** | `.cursor/skills/nest/nest.config.json` | Default `level`, `languages`, and `dimensions`. Read on every run. |
| **Skill** | `.cursor/skills/nest/` | The procedure: scope filter, evidence rules, and the report format. Catalogs stay in `references/`. |
| **Subagent** | `.cursor/agents/nest-reviewer.md` | Readonly auditor. Runs when asked, reads the skill, and returns a report to the parent. It does not keep its own template. |
| **References** | `.cursor/skills/nest/references/` | Working catalogs, loaded on demand. Each file owns one kind of change. |

### Key reference files

- `references/nest-rules.md` — the only copy of N1–N8 and which dimension each rule maps to. Loaded on every run
- `references/principles-table.md` — meaning, pass/fail, severity
- `references/code-patterns.md` — implementation shapes
- `references/anti-patterns.md` — smell catalog, including `new` that is not a finding
- `references/audit-coverage.md` — the only copy of the package/app layer sweep and coverage gate
- `nest.config.json` — default level and enabled dimensions
- `SKILL.md` — the only copy of the scope filter, the evidence rules, and the report format

```json
{
  "level": "pragmatic",
  "languages": ["typescript"],
  "dimensions": ["controller", "validation", "di", "exceptions"]
}
```

## Levels

- **pragmatic** — shipped default. File policy in controllers, `new` of providers inside providers, untyped bodies, and `HttpException` in services. Leave health routes and module factories alone.
- **strict** — every controller method, injected collaborator, DTO, and HTTP error in scope follows the closed list.
- **educational** — same technical bar as pragmatic, plus an explicit rationale for each enabled dimension on every material controller or provider.

The agent reads `nest.config.json` before it generates or reviews Nest code. Chat can override that file for one request.

Rule `globs` attach when controller, service, module, guard, pipe, filter, interceptor, or dto files are edited. `/nest` and `/nest-reviewer` still work when invoked explicitly.

## Dimensions

| Id | Focus |
|----|--------|
| `controller` | HTTP adapter only. Ordinary JSON is returned, not written through `@Res()` |
| `validation` | DTO or schema pipe before the handler uses the payload |
| `di` | Constructor injection. `new` of a provider stays in `main.ts` or a factory |
| `exceptions` | Domain errors in services. HTTP exceptions in controllers and filters |

A missing owner check, a concatenated query, and a secret stay in `security`. A provider that mixes two domain jobs and never touches HTTP stays in `solid`. Folder layout of a specific product stays in that product's rules.

## How the layers relate

The skill is the procedure. The parent agent and `nest-reviewer` both read it. The skill does not call the subagent.

- The **parent** writes code and can do a review in the same chat.
- **`nest-reviewer`** is for an audit in a separate context. It returns notes and does not edit. The parent applies fixes.
- Invoke it with `/nest-reviewer` or an explicit review request. It does not start on its own after an edit.

| Change | Edit |
|--------|------|
| Defaults | `nest.config.json` |
| What a dimension means | `references/principles-table.md` |
| The eight Nest rules | `references/nest-rules.md` |
| A smell | `references/anti-patterns.md` |
| A code shape | `references/code-patterns.md` |
| A layer or a coverage check | `references/audit-coverage.md` |
| The workflow, the filter, or the report | `SKILL.md` |

## How to install

1. Copy the entire `.cursor/` folder from this preset into the **root** of your project.
2. Keep this structure:

```
your-project/
├── .cursor/
│   ├── rules/
│   ├── skills/
│   └── agents/
```

3. Restart Cursor or reload the window.

```bash
cp -r /path/to/nest/.cursor ./
```

This preset does not include a hook.

### Combining with other presets

Merge `.cursor/` folders with [`solid`](../solid), [`kiss`](../kiss), [`security`](../security), [`tdd`](../tdd), and the others you use. Only `kiss` ships a hook.

When an orchestrator routes presets, a Nest API gets `nest` and `security`. A React UI gets `react`, `wcag-2.2`, and `security` as well. Security is not API-only.

## How to use

```
/nest
/nest-reviewer
```

**Generation**

```
Add a cancel-order route. The controller calls OrdersService. The id param is a validated DTO. Do not check ownership in this skill; that is security.
```

**Audit**

```
/nest-reviewer Review the billing module for fat controllers, untyped bodies, and HttpException in services.
```

## What the agent knows by default

- Apply the enabled dimensions from `nest.config.json` at the resolved level
- Load N1–N8 from `references/nest-rules.md`. Do not invent a ninth rule
- Do not file non-Nest files, health routes, or `new` in a module factory
- Do not file a missing access check as Nest
- Use `/nest-reviewer` for a readonly audit; the parent applies fixes

## Source

Based on the NestJS documentation for controllers, providers, modules, pipes, and exception filters. Working tables are markdown. This preset does not certify a Nest version.

---

Copy the `.cursor/` folder as-is.
The structure is required for Cursor to load the rules, skill, and the subagent.
