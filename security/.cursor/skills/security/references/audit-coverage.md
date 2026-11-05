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
6. **Do not invent advisories.** A dependency name is not a CVE. File a supply-chain hit only when the repo (or the user) names an advisory id, or when a script in tree runs an unpinned remote payload (`curl | sh`).
7. **Do not write exploits.** The finding names the dimension and the closing control.
8. **Do not import other presets' findings.** A missing port is not access. A focus ring is not injection. A train wreck is not failopen. Display-only math is not logic.

## Mandatory layer sweep

Walk **every** layer that exists in scope. Skip a row only if that folder is absent.

| Layer | Typical paths | What to hunt |
|-------|---------------|--------------|
| HTTP / API | `app/api/`, `routes/`, controllers | State change without an allow/deny; id taken from the URL and not compared to the session (access); cookie CSRF; header/tenant from the client |
| Domain / services | `services/`, `domain/`, `auth/`, `identity/`, `ledger/`, `billing/` | Queries or commands built from arguments that began as request input (injection); checks that return allow on error (failopen); session mint/fix/logout; role helpers; money/inventory writes (logic) |
| Queries | `repositories/`, `db/`, `*.sql`, `prisma/` | Statement text concatenated with values (injection); seeds with live passwords or fixed OTP (secrets) |
| Clients | `web/`, browser code, `middleware.ts` | Secret in a public env var; HTML built from input; token in `localStorage`; framing/CSP headers (secrets / injection / exposure) |
| Views | templates, email HTML | Unencoded interpolation of untrusted text into HTML (injection) |
| Jobs / workers | `worker/`, `jobs/`, webhooks | Webhook URL or fetch target from stored user input (request); job that loads by id and skips the owner (access); signature missing or replayable (failopen) |
| Config / supply | env samples, CORS, logger, `next.config.*`, `scripts/`, `docs/*advisory*`, `keys/`, committed `.env` | Live secret that is not a placeholder; `origin: *` with credentials; TLS off; `curl \| sh`; advisory id pinned to a vulnerable version; private `.pem` in tree |

## Dimension hunt lists (search the tree)

Use ripgrep / file reads. Record hits even when the file looks “peripheral”. Then apply the false-positive list before filing.

### access

- Handlers that read `params.id` or `body.id` and call update/delete/get with no session comparison.
- Assignments from `body.role`, `body.isAdmin`, `body.ownerId`, `body.tenantId`, or `x-tenant-id` used as the authorization tenant.
- Role helpers that use `includes`, substring, or `join(" ").includes` instead of an exact match / `Set`.
- `origin: "*"`, `origin: true`, or a callback that reflects any `Origin` next to `credentials: true`.
- Cookie-authenticated state changes with no CSRF token and no same-site cookie. Do not file bearer-token APIs.
- Session cookie `Set-Cookie` without `HttpOnly` / `Secure` / `SameSite`.
- Login that keeps a caller-supplied session id; logout that clears only the cookie; password/email change without revoke or re-auth.
- JWT decode or verify that trusts `alg` from the token, includes `none`, omits `{ algorithms: [...] }` on asymmetric verify, or skips the signature.

### injection

- Query text that interpolates a variable (`"… " +`, template string) and then runs — including ORDER BY “allowlists” that still splice the raw string.
- `exec(`, `spawn(` with `shell: true`, `eval(`, `new Function`, dynamic `import(` of request data.
- `innerHTML`, `dangerouslySetInnerHTML`, `document.write`; `message` handlers that skip `event.origin`.
- `path.join` or `path.resolve` with a request field or `kid`. File only when the result is not forced back under a root.
- XML with external entities or DTDs; `yaml.load` (not `safeLoad`) on user text; template engine given a user string as the template; zip/tar entry path without a root check.
- LDAP filters; mail/HTTP headers built without stripping CR/LF; `new RegExp(` from query/body; `Content-Type` derived from upload filename (especially `.svg`); CSV cells that only escape quotes.

### secrets

- Assignments that look like keys or connection strings (`apiKey = "`, `postgres://`, `BEGIN PRIVATE KEY`, `sk_live`).
- Committed `.env` (not `.env.example`), `**/keys/*.pem`, and `seed` / fixture files with live-looking passwords or fixed OTP.
- Log calls whose argument is `password`, `authorization`, `cookie`, or `token`.
- `md5`, `sha1`, or plain comparison used on a password.
- `NEXT_PUBLIC_` or `VITE_` holding a secret name (`SECRET`, `KEY`, `TOKEN`, `PASSWORD`).
- `localStorage` / `sessionStorage` of access tokens; `Math.random` for session/reset/OTP; hard-coded crypto keys or zero IVs.
- Secret compares via `startsWith` / prefix, or digest `===` without `timingSafeEqual`; JWT secret defaulting to `""`.

At `pragmatic`, **notice** `example`, `changeme`, `test`, and empty values. **File** when the value looks live. Notice ≠ violation.

### exposure

- Response bodies that include `stack`, `sqlMessage`, or a spread of a user or session row.
- Debug gates that compare `NODE_ENV` to a token other than the platform’s real production value.
- `Cache-Control: public` (or long shared caching) on authenticated or PII responses.
- PII fields inside JWT payloads; `postMessage(..., "*")` with tokens.
- `productionBrowserSourceMaps: true`; routes that return `process.env`.
- CSP / `X-Frame-Options` / `frame-ancestors` applied only to a public path while the authenticated app has none; `unsafe-inline` + `unsafe-eval` on session pages.
- Client code that renders another user's hidden fields because the API type includes them.

### request

- `fetch(`, axios, or `got` whose URL argument is a field of `req`, `body`, `query`, a token header (`jku` / `x5u`), or a stored webhook URL.
- Host **blocklists** (few denied names) especially with `redirect: "follow"` — file unless a real allowlist and post-redirect check exist.
- `redirect(` or `Location` whose target is a request field; helpers that only test `startsWith("/")` (protocol-relative). A same-function allowlist of fixed paths/hosts clears it.
- Password-reset or OAuth links whose host comes from `Host` / `X-Forwarded-Host`.
- `rejectUnauthorized: false` or any outbound client that disables TLS verification.

### failopen

- `catch` blocks that `return true`, `return next()`, invent an admin/`system` user, or return the protected object.
- Signature or token checks whose missing branch still proceeds; valid signatures accepted forever with no timestamp/nonce.
- Malware / scanner `catch` or “scanner down” branches that mark the upload clean.
- JWT verification whose `catch` still accepts the caller; missing OTP or missing `exp` treated as success.
- Rate-limit middleware that fails open to `next()`.

### logic

- Payout / charge / credit / reserve helpers that take `amountCents` (or similar) from the request and persist it as the ledger amount.
- Adjustments that add a client amount with no `<= 0` (or policy) reject.
- `findUnique` / read balance, compare in memory, then `update` with `balance - amount` and no `WHERE balance >= amount` (or version/lock).
- Money-moving POSTs with no idempotency / unique event guard when the same body can create two rows.
- File **access** separately when the same handler also skips ownership; do not collapse both into one vague “auth is weak”.

## Minimum coverage gate (package audit)

Before finishing a package/app review, confirm you can answer **yes** or cite “absent in tree”:

- [ ] State-changing routes checked for an allow/deny **or** explicit “no such routes”
- [ ] Role / tenant helpers read (exact match vs substring; client `x-tenant-*`) **or** explicit “none”
- [ ] Session cookie flags, login id mint, logout revoke, password/email change step-up **or** explicit “no cookie session”
- [ ] Query and command string hunt **or** explicit “no concatenated statements”
- [ ] HTML, `eval` / `Function`, YAML/XML, upload Content-Type, CSV, RegExp sinks hunted **or** explicit “no such sinks”
- [ ] Secret and log-line hunt run — including `.env`, `keys/`, `seed*`, and public env prefixes; placeholders not filed
- [ ] Error responses checked for stack or raw errors; private responses checked for `Cache-Control: public` **or** explicit “errors are codes / no public cache on private data”
- [ ] Outbound URL, redirect, `Host`-built links, and JWKS/`jku` hunt **or** explicit “no caller-chosen URL”
- [ ] Fail-open `catch` hunt on auth, signature, scan, and rate-limit checks **or** explicit “none”
- [ ] Money / inventory / quota writes checked for client-trusted amounts, sign bounds, and atomic update **or** explicit “no such flows”
- [ ] Config / headers / scripts: CORS+credentials, TLS verify, CSP/frame denial on app routes, source maps, `scripts/*` remote install, repo-documented advisories **or** explicit “absent”
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
