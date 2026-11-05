# Nest Anti-Patterns

Smell catalog. Add a smell here, not in `SKILL.md`, the rule, or `nest-reviewer`. Pair with `principles-table.md`, `nest-rules.md`, `code-patterns.md`, and (for package audits) `audit-coverage.md`. Apply a row only when its dimension is enabled.

## controller — Thin controller

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| `prisma.*`, `fetch`, or a mailer call inside a controller method | The route owns the use case | Call a provider. Keep the method to HTTP |
| `if (order.status === "paid")` and further domain branches in the controller | Policy changes with the route | Move the branch into the provider |
| `@Res() res: Response` then `res.json(...)` for a normal body | The framework no longer sets status and interceptors reliably | Return the value. Use `@Res({ passthrough: true })` only when you must set a header |

**Not controller:** a method that calls one provider and returns; a download that writes a stream through `@Res()`.

## validation — Boundary validation

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| `@Body() body: any` or `@Query() query: Record<string, unknown>` | The handler accepts any shape | A DTO or schema, plus `ValidationPipe` or a schema pipe |
| A class used as `@Body()` with no validation decorators and no schema | The type disappears at runtime | Decorators or a Zod schema on that type |
| The service starts with `if (typeof dto.email !== "string")` | HTTP shape leaked into the provider | Reject that in the pipe. Leave domain rules in the service |

**Not validation:** a health route with no body; a service check that the account can pay.

## di — Dependency injection

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| `new Mailer()` or `new OrdersRepository()` in a provider constructor or method | Nest is not the owner of that object | Constructor parameter, registered in the module |
| `providers: [OtherFeatureService]` while that class is also provided by another module | Two containers, hidden coupling | `imports: [OtherFeatureModule]` and an export |
| A circular `imports` pair (`A` imports `B` and `B` imports `A`) with no `forwardRef` and no extracted third module | The graph does not boot cleanly | A third module that both import, or one direction |

**Not di:** `new Money(cents)` for a value; `new` inside `main.ts` or a `useFactory`; a custom provider that returns `new PrismaClient()`.

## exceptions — HTTP at the edge

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| `throw new HttpException` or `BadRequestException` in a service or domain file | The domain learns status codes | Throw a domain error. Map it in a filter |
| A service imports `@Req`, `@Res`, or `@Body` | The provider depends on HTTP | Pass the already-read value from the controller |

**Not exceptions:** `HttpException` thrown in a controller or an exception filter.

## False positives (especially at `pragmatic`)

Do **not** treat these as violations:

- A controller method that delegates and returns
- A health or ready route with no payload
- `new` of a value object, a `Date`, or an `Error`
- `new` in `main.ts` or a module `useFactory`
- `@Res({ passthrough: true })` when a header must be set
- A missing owner check or a SQL string (security)
- A provider that does two domain jobs and never touches HTTP (SOLID **S**)

## Review process smells (meta)

Flag the **audit itself** as incomplete when:

- Only the first controller was opened
- A missing Guard was filed as Nest when the method has no check
- `new PrismaClient()` inside `useFactory` was filed as `di`
- A security or SOLID finding was filed under a Nest dimension
- One thin handler was treated as a package-wide pass
