# Security Audit Coverage — Package / App Sweep

This file is the only copy of the layer sweep and the coverage gate. Add a layer or a hunt here, not in `SKILL.md`, the rule, or `security-reviewer`.

**When to load:** more than one file, or any package/app scope. Do not use this checklist for single-file scope — still review that file.

Goal: stop “one SQL string” audits that miss the same missing check, sink, or fail-open path in routes, jobs, and clients.

Load with `anti-patterns.md` and `principles-table.md`. Report every hit with `path:line` + dimension id.

## Hard rules (fail the audit if you skip them)

1. **Do not stop after the first sink.** One critical finding does not clear the package.
2. **Do not trust filenames.** `Secure*`, `Safe*`, `Auth*`, `Guard*`, `sanitize` can still trust the client or build a query — read the body.
3. **One guarded route is not a package pass.** A health check may be public while the order route is not — keep sweeping.
4. **Same smell, many layers.** If string-built SQL or an unchecked id appears in services **and** routes **and** jobs, file **each** location (or one finding that lists every path:line).
5. **Public routes are not automatic failures.** Health, ready, and login are in scope to **notice** and usually **not** to file. Notice ≠ violation.
6. **Do not invent advisories.** A dependency name is not a CVE.
7. **Do not write exploits.** The finding names the dimension and the closing control.
8. **Do not import other presets' findings.** A missing port is not access. A focus ring is not injection. A train wreck is not failopen.

## Mandatory layer sweep

Walk **every** layer that exists in scope. Skip a row only if that folder is absent.

| Layer | Typical paths | What to hunt |
|-------|---------------|--------------|
| HTTP / API | `app/api/`, `routes/`, controllers | State change without an allow/deny; id taken from the URL and not compared to the session (access) |
| Domain / services | `services/`, `domain/` | Queries or commands built from arguments that began as request input (injection); checks that return allow on error (failopen) |
| Queries | `repositories/`, `db/`, `*.sql` | Statement text concatenated with values (injection) |
| Clients | `web/`, browser code | Secret in a public env var; HTML built from input (secrets / injection) |
| Views | templates, email HTML | Unencoded interpolation of untrusted text into HTML (injection) |
| Jobs / workers | `worker/`, `jobs/`, webhooks | Webhook URL or fetch target from stored user input (request); job that loads by id and skips the owner (access) |
| Config | env samples, CORS setup, logger setup | Live secret in a sample that is not a placeholder; `origin: *` with credentials (secrets / access) |

## Dimension hunt lists (search the tree)

Use ripgrep / file reads. Record hits even when the file looks “peripheral”. Then apply the false-positive list before filing.

### access

- Handlers that read `params.id` or `body.id` and call update/delete/get with no session comparison.
- Assignments from `body.role`, `body.isAdmin`, `body.ownerId`, `body.tenantId`.
- `origin: "*"` or `origin: true` next to `credentials: true`.
- Cookie-authenticated state changes with no CSRF token and no same-site cookie. Do not file bearer-token APIs.
- JWT decode or verify that trusts `alg` from the token, includes `none`, or does not check the signature.

### injection

- Query text that interpolates a variable (`"… " +`, template string) and then runs.
- `exec(`, `spawn(` with `shell: true`, `eval(`, `new Function`.
- `innerHTML`, `dangerouslySetInnerHTML`, `document.write`.
- `path.join` or `path.resolve` with a request field. File only when the result is not forced back under a root.
- XML parsed with external entities or DTDs enabled; a template engine given a user string as the template; a zip or tar entry path joined under the extract directory without a root check.

### secrets

- Assignments that look like keys or connection strings (`apiKey = "`, `postgres://`, `BEGIN PRIVATE KEY`, `sk_live`).
- Log calls whose argument is `password`, `authorization`, `cookie`, or `token`.
- `md5`, `sha1`, or plain comparison used on a password.
- `NEXT_PUBLIC_` or `VITE_` holding a secret name (`SECRET`, `KEY`, `TOKEN`, `PASSWORD`).

At `pragmatic`, **notice** `example`, `changeme`, `test`, and empty values. **File** when the value looks live. Notice ≠ violation.

### exposure

- Response bodies that include `stack`, `sqlMessage`, or a spread of a user or session row.
- Client code that renders another user's hidden fields because the API type includes them.

### request

- `fetch(`, axios, or `got` whose URL argument is a field of `req`, `body`, `query`, or a stored webhook URL.
- `redirect(` or `Location` whose target is a request field. A same-function allowlist clears it.
- `rejectUnauthorized: false` or any outbound client that disables TLS verification.

### failopen

- `catch` blocks that `return true`, `return next()`, or return the protected object.
- Signature or token checks whose missing branch still proceeds.
- JWT verification whose `catch` still accepts the caller.

## Minimum coverage gate (package audit)

Before finishing a package/app review, confirm you can answer **yes** or cite “absent in tree”:

- [ ] State-changing routes checked for an allow/deny **or** explicit “no such routes”
- [ ] Query and command string hunt **or** explicit “no concatenated statements”
- [ ] HTML and `eval` sinks hunted **or** explicit “no such sinks”
- [ ] Secret and log-line hunt run; placeholders not filed
- [ ] Error responses checked for stack or raw errors **or** explicit “errors are codes”
- [ ] Outbound URL and redirect hunt **or** explicit “no caller-chosen URL”
- [ ] Fail-open `catch` hunt on auth or signature checks **or** explicit “none”
- [ ] No invented CVE and no exploit steps in the report

If any checkbox is unchecked without a written reason (“folder missing” / “searched, none”), the audit is incomplete — keep searching.

## Reporting duplicates

Prefer:

```
- Location: orders.controller.ts:40; jobs/cancel-order.ts:18
- Dimension: access — Broken access control
- Why: both cancel by order id and never compare ownerId to the session
```

Do not collapse the package into a single “auth is weak” sentence without paths.
