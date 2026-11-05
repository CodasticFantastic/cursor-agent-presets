# Nest Audit Coverage — Package / App Sweep

This file is the only copy of the layer sweep and the coverage gate. Add a layer or a hunt here, not in `SKILL.md`, the rule, or `nest-reviewer`.

**When to load:** more than one file, or any package/app scope. Do not use this checklist for single-file scope — still review that file.

Goal: stop “one fat controller” audits that miss the same `new`, untyped body, or `HttpException` in other features.

Load with `anti-patterns.md`, `principles-table.md`, and `nest-rules.md`. Report every hit with `path:line` + dimension id + rule id.

## Hard rules (fail the audit if you skip them)

1. **Do not stop after the first fat controller.** One critical finding does not clear the package.
2. **Do not trust filenames.** `*Controller` can still run SQL. `*Guard` can still be unused.
3. **One thin handler is not a package pass.**
4. **Same smell, many modules.** If `HttpException` in a service or `new Repository()` appears in two features, file **each** location.
5. **Non-Nest files are not findings.** A React component or a plain function with no `@nestjs/*` import is `n/a — not a Nest file`.
6. **Do not import other presets' findings.** A missing owner check is not `controller`. A SQL string in a repository is not `validation`.

## Mandatory layer sweep

Walk **every** layer that exists in scope. Skip a row only if that folder is absent.

| Layer | Typical paths | What to hunt |
|-------|---------------|--------------|
| Controllers | `*.controller.ts` | SQL, mail, domain branches, `@Res()` for JSON (controller) |
| Providers | `*.service.ts`, repositories registered in a module | `new` of another provider (di); `HttpException` (exceptions) |
| Modules | `*.module.ts` | A concrete from another feature listed in `providers`; circular `imports` (di) |
| DTOs and pipes | `*.dto.ts`, `*.pipe.ts` | A body type with no schema (validation) |
| Filters | `*.filter.ts` | A filter that contains domain policy instead of mapping (controller). Mapping a domain error is a pass |
| Composition root | `main.ts` | `new` here is allowed. Note a global `ValidationPipe` so DTO checks are not filed twice |

## Dimension hunt lists (search the tree)

### controller

- `prisma.`, `fetch(`, mailer calls, and status comparisons inside `*.controller.ts` methods.
- `@Res()` without `passthrough: true` followed by `res.json` or `res.send`.

### validation

- `@Body() body: any`, `@Body() body: object`, `@Query() q: any`.
- A class used as `@Body()` whose file has no validation decorator and no schema pipe.

### di

- `new` of a class whose name ends with `Service`, `Repository`, or `Client` inside a provider method or constructor.
- Do not file `new` in `useFactory` or `main.ts`.
- `providers: [` containing a class that another module also provides.

### exceptions

- `HttpException`, `BadRequestException`, `NotFoundException` imported by a file that is not a controller or a filter.
- `@Req(` or `@Res(` inside a `*.service.ts`.

## Minimum coverage gate (package audit)

Before finishing a package/app review, confirm you can answer **yes** or cite “absent in tree”:

- [ ] Controller methods opened, not only the class decorator
- [ ] `@Body` / `@Query` hunt **or** explicit “no HTTP input”
- [ ] `new` hunt in providers, with factories excluded
- [ ] `HttpException` hunt outside controllers and filters **or** explicit “none”
- [ ] Module `providers` compared with `imports` **or** explicit “one module”
- [ ] No security or SOLID finding filed under a Nest dimension

If any checkbox is unchecked without a written reason (“folder missing” / “searched, none”), the audit is incomplete — keep searching.

## Reporting duplicates

Prefer:

```
- Location: orders.controller.ts:22; billing.controller.ts:14
- Dimension: controller — Thin controller
- Rule: N1
- Why: both methods call prisma and send mail
```

Do not collapse the API into “Nest looks thin” without paths.
