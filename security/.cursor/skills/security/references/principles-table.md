# Security Dimensions Checklist

Working source for what each dimension means, the pass/fail signals, and severity. The skill points here. The closed OWASP Top 10:2025 names and the dimension each risk maps to live in `owasp-top-10.md`. Do not copy either table into `SKILL.md`, the rule, or `security-reviewer`.

Level names, the fallback, and which dimensions are in scope live in `SKILL.md`. The section below only changes severity. Examples: TypeScript. Adapt syntax to the file. A new language does not need a second table.

Untrusted data is anything a caller, file upload, webhook, or queue message can set. A bound parameter or an encoded text node is not a sink.

| Id | Name | Question to ask | Pass signal | Fail signal |
|----|------|-----------------|-------------|-------------|
| **access** | Broken access control | Does this read or change check the caller against this resource? | Server compares the session principal to the owner, role, or tenant on the server; roles match exactly; cookie sessions use CSRF or SameSite | Handler loads or mutates by caller-supplied id with no ownership check; client sends `role` or `isAdmin` and the server trusts it; role check uses substring/`includes`; session fixation or logout without server revoke |
| **injection** | Injection | Can untrusted data change the query, command, path, or markup? | Bound SQL parameters; shell with an argument array; HTML text encoded; no `eval` of input | String-built SQL, shell, or path; HTML or script sink fed by a request field; unsafe YAML/XML; user RegExp; client-chosen Content-Type; CSV formula cells |
| **secrets** | Secrets and weak crypto | Is secret material out of the repo, logs, and fast hashes? | Secret read from the environment or a secret store; password hashed with a slow password hash; full-value timing-safe compare | Live-looking key, password, `.pem`, or connection string in source, seed, or committed `.env`; secret in a log or public env; password stored with MD5, SHA-1, or plain text; prefix compare on a secret |
| **exposure** | Sensitive data exposure | Can the client see internals or someone else's sensitive fields? | Error response is a stable code; a response DTO lists only fields that caller may see; private responses are not publicly cached | Stack trace, SQL, or filesystem path returned to the client; a response includes another user's token, secret, or full record; `Cache-Control: public` on private data; PII in a JWT; prod source maps / env dump |
| **request** | SSRF and open redirect | Is every outbound URL and redirect target on an allowlist? | Host compared to a fixed allowlist before `fetch` or redirect; public origin from config for links | `fetch`, HTTP client, or `Location` uses a caller-supplied URL or host; short host denylist with follow-redirects; reset/OAuth host from `Host` header; `jku` fetch |
| **failopen** | Fail-open controls | Does a failed check deny? | `catch` logs and returns 401/403 or rethrows; default branch is deny | `catch` returns the protected resource, `true`, `next()`, or an admin session; missing signature is treated as valid; scanner-down marks clean; replay of a signed body with no freshness |
| **logic** | Unsafe business rules | Can the caller bend a money, inventory, or quota rule the server should own? | Server recomputes or caps the amount; illegal signs rejected; balance/stock change is one atomic predicate | Client amount posted as the paid/reserved figure; negative or out-of-bounds amount accepted; read-check-then-write (TOCTOU) without `WHERE`/`version` guard |

## Severity guidance

| Severity | Typical cases |
|----------|----------------|
| Critical | Auth or ownership check absent on a state change; SQL, command, or path built from request input; live secret in source; server fetches a caller-supplied URL; permission check returns allow on error; money movement with TOCTOU or a fully client-chosen amount |
| High | IDOR on a read of a private object; untrusted HTML in an HTML sink; password hashed with a fast hash; stack or internal error returned to the client; secret written to a log; open redirect; negative or unbounded adjustment accepted |
| Medium | Broad CORS without credentials; debug error text behind a flag that is still in the production path; PII in a debug log. At `pragmatic`, prefer Medium or skip for placeholders and health routes |

## Package audit reminder

When the scope is more than one file, or any package/app scope, also satisfy `audit-coverage.md` (layer sweep + minimum coverage gate). Pass/fail signals above apply **per file**; package health needs breadth, not only the first sink.

## Relationship to other presets

| Concern | Guidance |
|---------|----------|
| Missing port, god class, train wreck, mixed abstraction, near-copy | **Not** security — SOLID, coupling, KISS, or structure |
| Focus, contrast, name, keyboard | **Not** security — WCAG |
| Untrusted HTML in `innerHTML` or `dangerouslySetInnerHTML` | **injection** |
| Password or API key in a log line | **secrets**, not exposure |
| Stack trace or another user's email in an HTTP body | **exposure** |
| Session fixation, missing cookie flags, logout without revoke | **access** (auth session control), not a separate id |
| CSP / framing / prod source maps / reflecting CORS | **access** or **exposure** (A02), not a separate id |
| `yaml.load` / `__fn` deserialization into a call | **injection**; missing webhook freshness with a valid signature → **failopen** |
| Client-trusted payout amount, missing sign check, or balance TOCTOU | **logic** — even when allow/deny is correct |
| Missing allow/deny on the same money handler | **access** (authz); file **logic** only for the unsafe rule itself |
| Display-only arithmetic with no state change | **Not** logic |
| Dependency with no advisory in the repo | **Not** a finding. Do not invent a CVE |

## Severity by level

Scope (which dimensions to audit) is owned by `SKILL.md`. This list only changes how hard a signal is filed.

- At `pragmatic`, prefer Medium (or skip) for example placeholders, public health and login routes, and React text interpolation.
- At `strict`, a state-changing handler without a visible allow/deny in scope is High.
