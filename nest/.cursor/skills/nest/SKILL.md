---
name: nest
description: "Design, implement, and review NestJS code: thin controllers, validation at the HTTP boundary, constructor injection, and HTTP errors kept at the edge. Defaults come from nest.config.json (shipped as pragmatic). Use when writing or reviewing Nest controllers, modules, providers, DTOs, or pipes, or when the user asks for Nest, NestJS, ValidationPipe, dependency injection, or exception filters."
paths: "**/*.{controller,service,module,guard,pipe,filter,interceptor,dto}.ts"
---

# Nest — Controller, validation, injection, exceptions

Use this skill whenever designing, implementing, refactoring, or reviewing NestJS application code.

**Defaults come from `nest.config.json` in this skill folder** (`level`: `pragmatic`, `strict`, or `educational`; `dimensions`: a list of `controller`, `validation`, `di`, `exceptions`). Read that file first on every run. The shipped file is pragmatic with all four dimensions.
A level or dimension set stated in the chat overrides the file for that request. Do not ask when the file already has a valid combination.
If the file is missing, a level is not one of the tokens above, a dimension id is outside the four above, or `dimensions` is empty, use pragmatic and all four dimensions.

`languages` in that file is example syntax only. It does not select files and it does not turn a dimension on or off. Patterns in `references/code-patterns.md` are TypeScript. Adding a language does not need a new reference file.

**Scope filter.** After level and dimensions are resolved, apply only the enabled dimensions. A dimension absent from `dimensions` is out of scope. Skip its bullets. Do not file it.

Level behavior has one copy: the table under "Level behavior". The rule file may name the three levels in one line so generation works before this skill is opened. It must not grow a second definition. Once this file is loaded, that table wins.

The markdown references are the working catalogs. This file is the procedure. The closed rule list is `references/nest-rules.md` (eight rules, N1–N8). Load it on every run. Do not search the web for extra Nest rules and do not invent N9. If a catalog does not settle a case, use that dimension's question in `references/principles-table.md`, then the matching row in the rules file. Do not invent a fifth dimension.

Apply the rules only to Nest code. A file that does not import `@nestjs/*` and is not registered by a Nest module is `n/a — not a Nest file`. That is not a pass and not a failure.

Nest complements SOLID, KISS, security, and TDD. A missing owner check is security **access**. A concatenated query is security **injection**. A god provider that is not an HTTP method is SOLID **S**. Do not file those as Nest. A missing guard is not a Nest finding when the source shows no check at all: that is security.

The parent agent implements fixes in its own context. `/nest-reviewer` is a separate readonly audit: it returns the report below and does not edit. Do not start it after ordinary generation or editing. Start it when the user asks for an audit or a parent explicitly delegates one.

## Core Workflow

1. **Read defaults** — Load `nest.config.json` (same folder as this file; in a project, `.cursor/skills/nest/nest.config.json`). Use it unless the user overrides it in chat.
2. **Scope the change** — Identify controllers, providers, modules, and DTOs in scope. Prefer the smallest change that restores the broken rule.
3. **Apply enabled dimensions** — Load `references/principles-table.md` and `references/nest-rules.md`. Cover every enabled dimension and every rule that maps to one. The rules file is the closed list. Load `references/code-patterns.md` when implementing. Load `references/anti-patterns.md` when reviewing. Skip rows for dimensions that are out of scope. Skip Nest rows when the file is not Nest code.
4. **Package / app reviews** — When the scope is more than one file, or any package/app scope, load `references/audit-coverage.md` and run its layer sweep and coverage gate before finishing. That file owns the trigger and the sweep. Do not stop after the first fat controller. A pass on one controller does not close the dimension for the package. For a single-file review, do not use `audit-coverage.md` — still review that file.
5. **Respect the filter** — Apply the level and the enabled dimensions from the scope filter. Do not re-derive them from memory.
6. **Cite dimensions** — When reporting issues or justifying fixes, reference the dimension id and the full name from the table (for example, "controller — Thin controller") and the rule id when a row matches (for example, `N1`). Cite only enabled dimensions. Do not cite an id that is not in `references/nest-rules.md`.
7. **Do not overclaim** — Classify every finding as code, hybrid, or manual. A `pass` needs evidence. Use the report format below. Never state that a module, package, or project is "fully Nest" or "Nest compliant".

## Key Rules

Each bullet is one dimension. Skip it when that dimension is not enabled. The table is the definition. These lines are the generation reminder.

- **controller** — A controller method reads HTTP input, calls a provider, and returns. It does not query, send mail, or decide domain policy. It does not take over the response for ordinary JSON.
- **validation** — Body, query, and params enter as a DTO or schema checked by a pipe before the handler uses them. The service does not re-check HTTP shape.
- **di** — Providers receive collaborators through the constructor. `new` of another provider belongs in `main.ts` or a module factory. Import the module that exports a provider; do not re-list that provider.
- **exceptions** — Domain and services throw domain errors. An exception filter or the controller maps them to HTTP. Services do not throw `HttpException`.

## Level behavior

| Level | Behavior |
|-------|----------|
| `pragmatic` | File domain policy in controllers, `new` of providers inside providers, untyped bodies, and `HttpException` in services. Leave health routes, module factories, and value-object `new` alone. |
| `strict` | Every controller method, injected collaborator, DTO, and HTTP error in scope follows the closed list. Every enabled dimension applies. |
| `educational` | Same technical bar as `pragmatic`, plus an explicit rationale for each enabled dimension on every material controller or provider. |

## Where a change goes

Edit the catalog that owns the change. Do not paste the same body into this procedure, the rule, and the subagent.

| Change | Edit |
|--------|------|
| Default level, example languages, or enabled dimensions | `nest.config.json` |
| What a dimension means, a pass/fail signal, or severity | `references/principles-table.md` |
| The eight Nest rules or which dimension a rule maps to | `references/nest-rules.md` |
| A smell | `references/anti-patterns.md` |
| An implementation shape | `references/code-patterns.md` |
| A layer, a hunt, or a coverage checkbox | `references/audit-coverage.md` |
| A new level or dimension token | The allowed tokens at the top of this file, the level table if it is a level, then a row in `references/principles-table.md` |
| Evidence rules or the report format | This file, in "Audits — what the code can decide" |

A new smell, layer, or code shape does not belong in this file. The rule may keep one reminder per dimension. The subagent reads this file and does not keep a second template.

## When to Load References

- Defaults, every run → `nest.config.json`
- Closed Nest rules (N1–N8), every run → `references/nest-rules.md`
- Dimension meaning, pass/fail, severity → `references/principles-table.md`
- Implementation shapes → `references/code-patterns.md`
- Smell catalog → `references/anti-patterns.md`
- Package or app audit → `references/audit-coverage.md`

## Common failures

Judgment traps only. Concrete smells live in `references/anti-patterns.md`. Layer hunts live in `references/audit-coverage.md`. Do not treat this section as a substitute for those catalogs.

- Do not claim a package or project is "fully Nest" or "Nest compliant".
- Do not stop after the first fat controller or the first clean handler.
- At `pragmatic`, a health route with no body is not a validation failure — but a controller that writes SQL, or a service that throws `HttpException`, still escalates.
- Do not file a missing owner check, a concatenated query, or a secret as Nest. Those are security.
- Do not file a provider that does two domain jobs as Nest when it is not an HTTP method. That is SOLID **S**.
- Do not require a Guard when the source shows no access check. The absent check is security **access**.
- Do not trust `*Controller`, `*Service`, or `*Guard` names without reading the body.

Always explain the Nest rationale when generating or refactoring code. Name the dimension.

## Audits — what the code can decide

This section is the only copy of the evidence rules and the report format. The `nest-reviewer` subagent reads them from here and returns the report to the parent. The parent applies fixes.

A source review is a Nest assessment. It is not proof the API is correct. Do not write that a module, package, or project is "fully Nest" or "Nest compliant".

Evidence rules:

- Status `pass` only with evidence: a repository location `path:line`, or a structural property named with the file that shows it. With no such evidence the status is `needs verification`.
- One thin controller does not close the dimension for the package. Record the scope of the evidence.
- On a package or app review, a pass on one file does not close the dimension for the package. File the same smell at every in-scope layer where it appears, or mark that layer absent.
- Prefer the smallest change that restores the rule. Do not rewrite the module graph.
- Discuss dimensions that are in the resolved `dimensions` list. A dimension outside that list is out of scope, not a pass.
- A file that is not Nest code is `n/a — not a Nest file`, not a pass and not a violation.

Dimension disambiguation (before filing):

1. Pick **one primary dimension** per symbol. Add a second only when it is a separate contract (or the catalog explicitly allows “also counts”).
2. SQL, mail, or domain policy inside a controller method → **controller** (N1). `@Res()` used to send ordinary JSON → **controller** (N2).
3. `@Body() body: any` or a DTO with no schema and no pipe → **validation** (N3). The service re-checks that the payload is an object or that a field is a string → **validation** (N4). A domain rule in the service (`balance < price`) is not validation.
4. `new OtherService()` inside a provider → **di** (N5). `new` in `main.ts` or `useFactory` is not di. Re-providing another module's concrete in `providers` instead of `imports` → **di** (N8).
5. A service file throws `HttpException` or imports HTTP decorators → **exceptions** (N7). A controller or filter may throw `HttpException`.
6. Do not stamp security or SOLID onto a Nest rule. No owner check is security **access**. A provider that mixes tax and mail outside a controller is SOLID **S**.

Put each finding into one class:

- **Code** — the source alone shows a violation or a satisfied check. Examples: a controller method that calls `prisma.order.update`; `@Body() body: any`; `new Mailer()` inside a service constructor; `throw new HttpException` in a domain file.
- **Hybrid** — the source shows a risk; confirmation needs another module. Examples: a DTO whose pipe is registered only in `main.ts`, which is outside the file; a provider that might be constructed in a factory you have not opened.
- **Manual** — needs a product judgment. Examples: whether a route is a file download that must use `@Res()`; whether two modules should stay separate.

### Report format

Use this structure for every review. The summary counts findings. It does not certify the package.

```
## Review result
Scope: <files or module>
Level: <from nest.config.json, unless the user overrode it>
Dimensions: <enabled set>
Verdict: this is a Nest assessment, not a certification.

### Coverage (package/app audits)
- Layers swept: <controllers | providers | modules | dto | filters | main>
- Gate: pass | incomplete — <missing hunt or “folder absent”>

### Violations visible in code
- Location: path:line
- Dimension: controller | validation | di | exceptions — <name>
- Rule: <N1–N8 from nest-rules.md> | n/a
- Class: code
- Severity: Critical | High | Medium
- Why it fails:
- Fix:

### Satisfied checks
- Dimension:
- Status: pass
- Evidence: path:line
- Scope: this file or this module. This pass does not close the dimension for the package.

### Needs verification
- Dimension:
- Status: needs verification
- Class: hybrid | manual
- What is missing: no path:line, or the pipe or module factory is outside this file
```

If a section has no items, write "None in this scope." Do not invent a pass. A pass needs `path:line`, or a structural property named with the file that shows it. Otherwise the check goes under "Needs verification".
For a single file, `### Coverage` may say `n/a — file-scoped`. Whenever `audit-coverage.md` was loaded, include `### Coverage`. An incomplete gate means keep searching. Do not close the report on the first fat controller alone.
