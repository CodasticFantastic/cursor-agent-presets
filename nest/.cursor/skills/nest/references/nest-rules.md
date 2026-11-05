# Nest rules — closed list

Working list of the NestJS rules this preset applies. The skill points here. Do not copy this table into `SKILL.md`, the rule, or `nest-reviewer`. Do not search the web for a longer Nest rule set. Do not invent a rule that is not in this file.

Names follow the NestJS docs: controllers, providers, modules, pipes, and exception filters. This file is the copy the agent uses.

Apply these rules only when the file is Nest code: it imports `@nestjs/*`, or it is a provider registered by a Nest module in the same app. A plain TypeScript module with no Nest import and no module registration is `n/a — not a Nest file`. That is not a pass and not a failure.

A missing allow/deny, a SQL string, or a secret is security, not one of these rules.

| Id | Rule | Dimension | File when the source shows | Do not file |
|----|------|-----------|----------------------------|-------------|
| N1 | A controller is an HTTP adapter | `controller` | A controller method queries a database, sends mail, or computes domain policy | A method that reads the HTTP input, calls one provider, and returns |
| N2 | The controller does not take over the response | `controller` | `@Res()` without `{ passthrough: true }` used to `send` a normal JSON body | A stream or file download that must write the response; `@Res({ passthrough: true })` |
| N3 | Input is a validated DTO | `validation` | `@Body()`, `@Query()`, or `@Param()` typed as `any`, `object`, or an interface with no schema and no pipe | A DTO class or schema (class-validator, Zod, or a pipe) checked before the handler body; a health route with no body |
| N4 | Validation stays at the boundary | `validation` | The service's first job is to reject the shape of the HTTP payload | The service rejects a domain rule (insufficient funds, unknown status) |
| N5 | Collaborators are injected | `di` | A provider constructs another provider with `new` in the constructor or a method | Constructor parameters that Nest injects; `new` of a value object or a plain DTO |
| N6 | The module graph owns construction | `di` | A feature class imports another feature's concrete provider and constructs it | `new` inside `main.ts`, a module `useFactory`, or a custom provider | 
| N7 | HTTP errors stay at the edge | `exceptions` | A service or domain file throws `HttpException` or imports `@nestjs/common` HTTP decorators | An exception filter maps a domain error to a status; a controller throws `HttpException` |
| N8 | One module exports what others may use | `di` | Module A imports a provider file from module B and lists that provider in A's `providers` instead of importing B | `imports: [BModule]` and B exports the provider |

## How to cite

Cite the dimension from `principles-table.md` and the id from this table when the row matches (for example, `controller — Thin controller`, `N1`). One primary dimension. Do not cite `N9`.

If nothing in the list matches, use the dimension question in `principles-table.md`. Do not add a rule from memory.
