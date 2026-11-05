# Nest Dimensions Checklist

Working source for what each dimension means, the pass/fail signals, and severity. The skill points here. The closed rule names and the dimension each rule maps to live in `nest-rules.md`. Do not copy either table into `SKILL.md`, the rule, or `nest-reviewer`.

Level names, the fallback, and which dimensions are in scope live in `SKILL.md`. The section below only changes severity. Examples: TypeScript. A new language does not need a second table.

| Id | Name | Question to ask | Pass signal | Fail signal |
|----|------|-----------------|-------------|-------------|
| **controller** | Thin controller | Does this method only adapt HTTP to a provider call? | Reads params, calls one provider, returns the result | The method queries, sends mail, or branches on domain policy |
| **validation** | Boundary validation | Is the HTTP payload checked before the handler uses it? | A DTO or schema pipe rejects a bad shape; the service sees a typed value | `@Body() body: any`; the service checks `typeof field === "string"` |
| **di** | Dependency injection | Does this provider receive collaborators instead of constructing them? | Constructor parameters; `new` only in `main.ts` or a module factory | `new OtherService()` inside a provider; another module's concrete listed in `providers` |
| **exceptions** | HTTP at the edge | Do HTTP types stay out of domain code? | A filter or controller maps a domain error to a status | A service throws `HttpException` or imports `@Req` / `@Res` |

## Severity guidance

| Severity | Typical cases |
|----------|----------------|
| Critical | A controller method performs the state change itself (query, charge, mail); a service throws `HttpException` for a domain rule |
| High | Untyped `@Body()`; `new` of a provider inside another provider; a module re-lists another feature's provider |
| Medium | `@Res()` used to send JSON that could have been returned; a service re-checks that a field is present. At `pragmatic`, prefer Medium or skip for a health route and for `new` of a value object |

## Package audit reminder

When the scope is more than one file, or any package/app scope, also satisfy `audit-coverage.md`. Pass/fail signals above apply **per file**.

## Relationship to other presets

| Concern | Guidance |
|---------|----------|
| No owner check, SQL built from input, a secret in source | **Not** Nest — security |
| A provider that mixes tax and mail and is not a controller method | **Not** Nest — SOLID **S** |
| A missing Guard with no check in the method | **Not** Nest — security **access** |
| A file with no `@nestjs/*` import and no module registration | `n/a — not a Nest file` |

## Severity by level

Scope is owned by `SKILL.md`. This list only changes how hard a signal is filed.

- At `pragmatic`, do not file `new` inside `useFactory` or `main.ts`.
- At `strict`, an untyped body on a state-changing route is High even when the service happens to check types.
