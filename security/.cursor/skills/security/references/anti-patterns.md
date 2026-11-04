# Security Anti-Patterns

Smell catalog. Add a smell here, not in `SKILL.md`, the rule, or `security-reviewer`. Pair with `principles-table.md`, `code-patterns.md`, and (for package audits) `audit-coverage.md`. Apply a row only when its dimension is enabled.

Do not include payloads or bypass steps. Name the sink and the control that closes it.

## access — Broken access control

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| Read or update by id with no comparison to the session principal | Any caller who knows the id gets the row | Load the row, compare owner or tenant to the server-side session, then act |
| Client field `role`, `isAdmin`, or `ownerId` copied into the decision | The caller grants themselves access | Derive role and owner from the session or the stored row |
| State-changing route with no guard and no in-handler check | The action is public | A server-side guard or an explicit allow/deny before the mutation |
| CORS `origin: *` together with credentialed cookies | A foreign page can call with the user's cookie | An explicit origin list, or no credentials on a public API |
| Mass assignment of `role`, `tenantId`, or `balance` from the body | Privilege fields ride in with the profile update | A write DTO that omits privilege fields |
| Cookie session on a state-changing request with no CSRF token and no same-site restriction in source | Another site can send the browser's cookie | A CSRF token checked on the server, or a same-site cookie. Bearer-token APIs are not this row |
| JWT accepted without verifying the signature, or with `alg` taken from the token (`none` included) | The caller chooses the identity | Verify with a server-side secret or public key and an allowlist of algorithms that excludes `none` |

**Not access:** a health or login route that is intentionally public; a handler that calls one shared `requireOwner` helper visible in the same file; a bearer-token API with no cookie session.

## injection — Injection

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| SQL or NoSQL text built with request input | The query structure changes with the input | Bound parameters or the query builder's parameter API |
| `exec`, `spawn` with `shell: true`, or a shell string from input | The shell parses the input | An argument array and a fixed executable |
| Path built with `../` from input (`join(root, req.query.file)` without a root check) | The read can leave the intended directory | A basename allowlist, or resolve and require the result to stay under the root |
| `innerHTML`, `document.write`, or `dangerouslySetInnerHTML` of request or stored HTML | The browser parses attacker markup | Text content, or a sanitizer used on a documented HTML subset |
| `eval`, `new Function`, or deserializing input into a call | Input becomes code | A parser for the data shape you expect |
| XML parser that resolves external entities or DTDs on untrusted XML | The parser reads or sends data the caller named | Disable DTDs and external entities. Prefer a format that has no entity expansion |
| User string passed as the template source to a template engine | The engine runs the caller’s template | Pass a fixed template and the user value as data |
| Archive entry path joined onto the extract directory with no root check | The entry writes outside the intended directory | Resolve the entry and require it to stay under the extract root |

**Not injection:** a React or JSX text node (`{name}`); a SQL call that passes values separately from the statement; a constant HTML string the author wrote; XML or a template whose source is a file the repo owns.

## secrets — Secrets and weak crypto

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| API key, password, private key, or connection string with a live-looking value in source | The repo is a secret store | Environment or secret store; rotate the leaked value |
| `console.log` / logger of `password`, `authorization`, `cookie`, or the raw token | Logs become the secret store | Log a request id. Do not log the credential |
| Password stored or compared as plain text, MD5, or SHA-1 | The hash is reversible at guessing speed | A password hash made for passwords (slow, salted) |
| Secret written into a frontend bundle or a `NEXT_PUBLIC_` / `VITE_` variable | The browser receives the secret | A server-only read |

**Not secrets:** `.env.example` or fixtures whose values are `changeme`, `example`, or empty; a test double that is obviously fake.

## exposure — Sensitive data exposure

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| `catch` sends `err.stack`, SQL, or a filesystem path to the client | The error teaches the internals | A stable error code. The stack stays in the server log |
| Response DTO spreads the whole database row (`{ ...user }`) | Hidden columns (password hash, other users' fields) leave the server | An explicit list of fields that caller may see |
| Token, session secret, or reset link rendered into HTML or a query string that is then logged | The value leaks via the page or the access log | A one-time server-side token, not a secret in the URL the access log stores |

**Not exposure:** a validation message that names the field; a public display name.

## request — SSRF and open redirect

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| `fetch(req.body.url)` or an HTTP client whose host comes from the caller | The server requests internal addresses | Allowlist of hosts, then fetch |
| `redirect(req.query.next)` or `Location` from input | The user lands on an attacker site after a trusted click | Allow relative paths you own, or an allowlist of hosts |
| Webhook URL stored from the user and called later with no host check | The same forge, delayed | Check the host at save time and again at call time |
| TLS verification turned off on an outbound client (`rejectUnauthorized: false`, a custom check that always accepts, or verification disabled in the process) | The server will talk to whoever answers | Leave verification on. Pin a certificate only when the host is fixed and the pin is in source |

**Not request:** a fixed URL written in source; a host checked against a list in the same function before the call; TLS verification left at the platform default.

## failopen — Fail-open controls

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| `catch { return true }` or `catch { return resource }` around auth, signature, or payment | The failure is an allow | Deny on error |
| Missing or empty signature treated as valid | The check is optional in practice | Reject when the signature is absent |
| Default `switch` branch grants access | The unknown case is privileged | Default denies |
| JWT `verify` error or a missing signature still accepts the token | The failed check is an allow | Deny when verification throws or the signature is absent |

**Not failopen:** a catch that logs and returns 401/403; a catch that rethrows; an optional analytics call that ignores its own failure.

## False positives (especially at `pragmatic`)

Do **not** treat these as violations:

- Health, ready, and login routes with no session
- Placeholder secrets (`changeme`, `example`, `test`, empty)
- JSX text interpolation and parameterized queries
- A guard or `requireOwner` in the same handler or the route's middleware file you opened
- Allowlisted redirect or fetch in the same function
- A bearer-token API with no cookie session (not CSRF)
- A JWT checked with a server-side key and an algorithm allowlist that excludes `none`
- A catch that denies
- A dependency you merely dislike, with no advisory id in the repo

Escalate when the source shows a state change without a check, untrusted data in a sink, live secret material, a caller-controlled URL, or an allow-on-error path.

## Review process smells (meta)

Flag the **audit itself** as incomplete when:

- Only the first query or the first guarded route was opened
- A name (`Secure*`, `sanitize`, `AuthGuard`) was trusted without the body
- React text or a bound parameter was filed as injection
- A placeholder or `.env.example` was filed as a live secret
- A CVE was invented for a package
- A missing port, focus ring, or train wreck was filed as security
- Exploit steps or payloads were written into the report
- One clean handler was treated as a package-wide pass
