# Security Anti-Patterns

Smell catalog. Add a smell here, not in `SKILL.md`, the rule, or `security-reviewer`. Pair with `principles-table.md`, `code-patterns.md`, and (for package audits) `audit-coverage.md`. Apply a row only when its dimension is enabled.

Do not include payloads or bypass steps. Name the sink and the control that closes it.

Session, misconfiguration, and integrity failures stay under `access` / `exposure` / `injection` / `failopen` / `request` — not extra ids. Business-rule abuse is the seventh token: `logic`. Do not invent an eighth id.

## access — Broken access control

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| Read or update by id with no comparison to the session principal | Any caller who knows the id gets the row | Load the row, compare owner or tenant to the server-side session, then act |
| Client field `role`, `isAdmin`, or `ownerId` copied into the decision | The caller grants themselves access | Derive role and owner from the session or the stored row |
| Role or permission check via `includes`, substring, or join-then-search on a role string | A longer role name satisfies a shorter needed token | Exact role match, a `Set`, or a structured claim list |
| State-changing route with no guard and no in-handler check | The action is public | A server-side guard or an explicit allow/deny before the mutation |
| CORS `origin: *` (or reflecting any `Origin`) together with credentialed cookies | A foreign page can call with the user's cookie | An explicit origin list, or no credentials on a public API |
| Mass assignment of `role`, `tenantId`, or `balance` from the body | Privilege fields ride in with the profile update | A write DTO that omits privilege fields |
| Cookie session on a state-changing request with no CSRF token and no same-site restriction in source | Another site can send the browser's cookie | A CSRF token checked on the server, or a same-site cookie. Bearer-token APIs are not this row |
| Session cookie set without `HttpOnly` / `Secure` / `SameSite` in source | Script and cross-site callers can use the cookie | Set those flags on the session cookie |
| Login reuses a caller-supplied session id (fixation) | The attacker keeps the id the victim authenticates into | Mint a new session id after credential success |
| Password or email change with no session revoke / no re-auth step-up | Stolen session keeps working; email becomes the reset target | Invalidate other sessions; require current password for email change |
| Logout clears only the cookie and leaves the server session row | The id still works if replayed | Delete or expire the server session on logout |
| JWT accepted without verifying the signature, or with `alg` taken from the token (`none` included) | The caller chooses the identity | Verify with a server-side secret or public key and an allowlist of algorithms that excludes `none` |
| JWT `verify` without an algorithm allowlist when the key material is asymmetric or mislabeled | Algorithm confusion or the wrong key type is accepted | Pass `{ algorithms: [...] }` that matches the key |

**Not access:** a health or login route that is intentionally public; a handler that calls one shared `requireOwner` helper visible in the same file; a bearer-token API with no cookie session; a privileged export that intentionally returns the whole tenant after a real server-side capability check (file the broken check, not “too many rows” alone).

## injection — Injection

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| SQL or NoSQL text built with request input | The query structure changes with the input | Bound parameters or the query builder's parameter API |
| “Allowlist” that uses `includes` / substring and then splices the raw value into SQL | The value still changes the statement | Map input to a fixed identifier from a closed set |
| `exec`, `spawn` with `shell: true`, or a shell string from input | The shell parses the input | An argument array and a fixed executable |
| Path built with `../` from input (`join(root, req.query.file)` without a root check) | The read can leave the intended directory | A basename allowlist, or resolve and require the result to stay under the root |
| `innerHTML`, `document.write`, or `dangerouslySetInnerHTML` of request or stored HTML | The browser parses attacker markup | Text content, or a sanitizer used on a documented HTML subset |
| `postMessage` / `message` handler that writes HTML without checking `event.origin` | Any frame can inject markup | Check `origin` against an allowlist, then use text or a sanitizer |
| `eval`, `new Function`, or deserializing input into a call (`__fn`, dynamic `import(userModule)`) | Input becomes code | A parser for the data shape you expect; allowlisted module ids only |
| XML parser that resolves external entities or DTDs on untrusted XML | The parser reads or sends data the caller named | Disable DTDs and external entities. Prefer a format that has no entity expansion |
| `yaml.load` / unsafe YAML load on untrusted text (when `safeLoad` or JSON exists beside it) | The loader builds unexpected objects or code paths | `safeLoad` / JSON schema; never treat user YAML as a program |
| User string passed as the template source to a template engine | The engine runs the caller’s template | Pass a fixed template and the user value as data |
| Archive entry path joined onto the extract directory with no root check | The entry writes outside the intended directory | Resolve the entry and require it to stay under the extract root |
| LDAP filter or mail/HTTP header built with raw user text (CR/LF or filter metacharacters) | The directory or header structure changes | Escape or strip; use the library’s parameter API |
| `new RegExp` from request input used on attacker-controlled text | The pattern becomes a ReDoS or match oracle | Allowlist a fixed pattern, or cap length and reject nested quantifiers |
| Upload or download that sets `Content-Type` from the client filename (for example `.svg` → `image/svg+xml`) and returns the bytes | The browser may execute the payload as that type | Server-chosen type from an allowlist; serve untrusted files as attachment/octet-stream |
| CSV / spreadsheet cell that escapes quotes but not leading `=`, `+`, `-`, `@` | Spreadsheet apps treat the cell as a formula | Prefix risky cells or force a text type |

**Not injection:** a React or JSX text node (`{name}`); a SQL call that passes values separately from the statement; a constant HTML string the author wrote; XML or a template whose source is a file the repo owns; `innerHTML` of a plain number you stringified.

## secrets — Secrets and weak crypto

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| API key, password, private key (`.pem`), or connection string with a live-looking value in source, seed, or committed `.env` | The repo is a secret store | Environment or secret store; rotate the leaked value |
| `console.log` / logger of `password`, `authorization`, `cookie`, or the raw token | Logs become the secret store | Log a request id. Do not log the credential |
| Password stored or compared as plain text, MD5, or SHA-1 | The hash is reversible at guessing speed | A password hash made for passwords (slow, salted) |
| Secret written into a frontend bundle or a `NEXT_PUBLIC_` / `VITE_` variable | The browser receives the secret | A server-only read |
| Access or refresh token kept in `localStorage` | Any XSS reads the session | HttpOnly cookie or a memory store the app already uses for sessions |
| Session / reset token from `Math.random` or a short predictable OTP | The value is guessable | `crypto.randomBytes` (or platform CSPRNG); longer OTPs |
| Hard-coded encryption key or a fixed/zero IV for AES-CBC of secrets | One leak decrypts every record | Key from a secret store; random IV per seal (prefer AEAD) |
| Secret or API key compared with `startsWith`, prefix match, or non-constant-time `===` on digests | Prefix or timing teaches the secret | Length check then `timingSafeEqual` on full values |
| JWT HMAC secret falling back to `""` or another empty default | Anyone can forge tokens | Fail closed when the env secret is missing |

**Not secrets:** `.env.example` or fixtures whose values are `changeme`, `example`, or empty; a test double that is obviously fake; a public tile or CDN URL in `NEXT_PUBLIC_*`.

## exposure — Sensitive data exposure

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| `catch` sends `err.stack`, SQL, or a filesystem path to the client | The error teaches the internals | A stable error code. The stack stays in the server log |
| Debug / stack branch gated on a non-production token that never matches real prod (`NODE_ENV === "prod"`) | The verbose branch stays on | Gate on the real production value; default to the stable code |
| Response DTO spreads the whole database row (`{ ...user }`) | Hidden columns (password hash, other users' fields) leave the server | An explicit list of fields that caller may see |
| Token, session secret, or reset link rendered into HTML or a query string that is then logged | The value leaks via the page or the access log | A one-time server-side token, not a secret in the URL the access log stores |
| PII (SSN, pan) in a signed but unencrypted JWT payload | Anyone with the token reads the field | Omit PII from the token; keep it server-side |
| `Cache-Control: public` (or shared CDN cache) on a response with private or tenant data | Caches serve one user's body to another | `private, no-store` for authenticated or personal responses |
| `postMessage` of a token with `targetOrigin` `*` | Any listener receives the secret | Explicit target origin |
| Production browser source maps enabled, or a debug route that returns `process.env` | Internals and secrets ship to the client | Disable prod source maps; remove or strongly gate env dumps |
| Framing / CSP only on a marketing path while the authenticated app has none (`X-Frame-Options` / `frame-ancestors` missing on `/desk`-class routes; `script-src` with `unsafe-inline` + `unsafe-eval`) | Clickjacking or script injection is easier on the real app | Apply frame denial and a tight CSP where the session lives |

**Not exposure:** a validation message that names the field; a public display name; a health body that is only `{ ok: true }`.

## request — SSRF and open redirect

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| `fetch(req.body.url)` or an HTTP client whose host comes from the caller | The server requests internal addresses | Allowlist of hosts, then fetch |
| Host “blocklist” of a few names plus `redirect: "follow"` | DNS aliases and redirects bypass the list | Allowlist of resolved hosts; re-check after redirects or disable redirects |
| `redirect(req.query.next)` or `Location` from input; “safe” check that only requires a leading `/` | Protocol-relative `//evil` and open redirects remain | Allow relative paths you own (reject `//`), or an allowlist of hosts |
| Link or callback URL whose host comes from `Host` / `X-Forwarded-Host` | The email or redirect points at an attacker host | Fixed public origin from config |
| JWKS / `jku` / `x5u` URL taken from the token header and fetched | The server fetches attacker-chosen keys | Pin issuer JWKS URL in config |
| Webhook URL stored from the user and called later with no host check | The same forge, delayed | Check the host at save time and again at call time |
| TLS verification turned off on an outbound client (`rejectUnauthorized: false`, a custom check that always accepts, or verification disabled in the process) | The server will talk to whoever answers | Leave verification on. Pin a certificate only when the host is fixed and the pin is in source |

**Not request:** a fixed URL written in source; a host checked against an allowlist in the same function before the call; TLS verification left at the platform default.

## failopen — Fail-open controls

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| `catch { return true }` or `catch { return resource }` around auth, signature, payment, or malware scan | The failure is an allow | Deny on error |
| Rate limit / auth middleware `catch` that calls `next()` or invents an admin principal | The failure is an allow | Deny or 503; never synthesize a privileged user |
| Missing or empty signature treated as valid | The check is optional in practice | Reject when the signature is absent |
| Signature present but no freshness window / nonce (replay of a valid old body) | An old event is accepted forever | Reject stale timestamps; store nonce or event id |
| Default `switch` branch grants access | The unknown case is privileged | Default denies |
| JWT `verify` error or a missing signature still accepts the token | The failed check is an allow | Deny when verification throws or the signature is absent |
| Missing OTP / missing `exp` treated as success | The optional field disables the control | Require the field; deny when absent |

**Not failopen:** a catch that logs and returns 401/403; a catch that rethrows; an optional analytics call that ignores its own failure.

## logic — Unsafe business rules

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| Payout / charge / credit amount taken from the client and written as the ledger amount | The caller picks how much money moves | Server recomputes or caps from the claim/order row; ignore or bound the body amount |
| Adjustment / transfer that adds a client `amountCents` with no reject of `<= 0` or other illegal sign | The caller drains or inflates balances with a negative or unbounded value | Reject non-positive (or out-of-policy) amounts before write |
| Read balance/stock, compare in memory, then `update` with the computed value and no row predicate | Two requests pass the check (TOCTOU) and overspend | Single atomic update: `WHERE id = ? AND balance >= ?`, or a version/lock column |
| Idempotency key ignored on a money-moving POST (same body applied twice as two rows) | Replay doubles the effect | Store and enforce an idempotency key or unique event id |

**Not logic:** pure display math; a handler whose only defect is missing allow/deny (**access**); auth/signature `catch` that allows (**failopen**); trusting `body.role` (**access**).

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
- A privileged bulk export after a real capability check (file the broken check instead)
- Display-only formulas or constants with no durable balance/inventory write
- An update that already includes `balance >= amount` (or equivalent) in the same statement

Escalate when the source shows a state change without a check, untrusted data in a sink, live secret material, a caller-controlled URL, an allow-on-error path, or a money/inventory rule the caller can bend.

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
- `seed`, `keys/`, committed `.env`, or `scripts/` existed and were never opened on a package audit
- A denylist or `startsWith("/")` redirect helper was trusted without reading the body
