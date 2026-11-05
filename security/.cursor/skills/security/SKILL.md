---
name: security
description: "Design, implement, and review code for security harm: broken access control, injection (including XSS), secrets and weak crypto, sensitive-data exposure, SSRF and open redirects, controls that fail open, and unsafe business rules (TOCTOU, client-trusted amounts). Defaults come from security.config.json (shipped as pragmatic). Use when writing or reviewing auth, queries, HTML output, logging, outbound requests, payouts/reserves, or when the user asks for security, OWASP, authz, IDOR, injection, XSS, secrets, SSRF, fail-open, or business-logic abuse."
paths: "**/*.{ts,tsx,js,jsx,mjs,cjs,py,java,kt,cs,go,html,sql}"
---

# Security — Access, Injection, Secrets, Exposure, Requests, Fail-open, Logic

Use this skill whenever designing, implementing, refactoring, or reviewing code that can be abused.

**Defaults come from `security.config.json` in this skill folder** (`level`: `pragmatic`, `strict`, or `educational`; `dimensions`: a list of `access`, `injection`, `secrets`, `exposure`, `request`, `failopen`, `logic`). Read that file first on every run. The shipped file is pragmatic with all seven dimensions.
A level or dimension set stated in the chat overrides the file for that request. Do not ask when the file already has a valid combination.
If the file is missing, a level is not one of the tokens above, a dimension id is outside the seven above, or `dimensions` is empty, use pragmatic and all seven dimensions.

`languages` in that file is example syntax only. It does not select files and it does not turn a dimension on or off. Patterns in `references/code-patterns.md` are TypeScript. Adapt the syntax to the file you are editing. Adding a language does not need a new reference file.

**Scope filter.** After level and dimensions are resolved, apply only the enabled dimensions. A dimension absent from `dimensions` is out of scope. Skip its bullets. Do not file it.

Level behavior has one copy: the table under "Level behavior". The rule file may name the three levels in one line so generation works before this skill is opened. It must not grow a second definition. Once this file is loaded, that table wins.

The markdown references are the working catalogs. This file is the procedure. The closed risk list is `references/owasp-top-10.md` (OWASP Top 10:2025, ten rows). Load it on every run. Do not search the web for the ten and do not invent an eleventh item. If a catalog does not settle a case, use that dimension's question in `references/principles-table.md`, then the matching row in the Top 10 file. Do not invent an eighth dimension beyond the seven listed tokens.

A finding is a behavior the source can abuse: a missing allow/deny, untrusted data in a sink, a secret in the repo or a log, sensitive data sent to the wrong party, a user-controlled outbound URL, a check that allows on error, or a money/inventory rule the caller can bend (client-trusted amount, missing sign check, check-then-act without an atomic guard). Security complements SOLID, KISS, coupling, structure, and WCAG. A missing port is SOLID **D**. A focus ring is WCAG. A train wreck is coupling. Do not file a dependency as vulnerable unless the source names the advisory. Do not write exploit steps.

The parent agent implements fixes in its own context. `/security-reviewer` is a separate readonly audit: it returns the report below and does not edit. Do not start it after ordinary generation or editing. Start it when the user asks for an audit or a parent explicitly delegates one.

## Core Workflow

1. **Read defaults** — Load `security.config.json` (same folder as this file; in a project, `.cursor/skills/security/security.config.json`). Use it unless the user overrides it in chat.
2. **Scope the change** — Identify handlers, queries, sinks, and checks in scope. Prefer the smallest change that closes the abuse path.
3. **Apply enabled dimensions** — Load `references/principles-table.md` and `references/owasp-top-10.md`. Cover every enabled dimension and every Top 10 row that maps to one. That table is the working source for meaning, pass/fail, and severity. The Top 10 file is the closed list of risk names. A row marked "not a source finding" is noticed and not filed. Load `references/code-patterns.md` when implementing. Load `references/anti-patterns.md` when reviewing. Skip rows for dimensions that are out of scope.
4. **Package / app reviews** — When the scope is more than one file, or any package/app scope, load `references/audit-coverage.md` and run its layer sweep and coverage gate before finishing. That file owns the trigger and the sweep. Do not stop after the first sink. A pass on one route does not close the dimension for the package. For a single-file review, do not use `audit-coverage.md` — still review that file.
5. **Respect the filter** — Apply the level and the enabled dimensions from the scope filter. Do not re-derive them from memory.
6. **Cite dimensions** — When reporting issues or justifying fixes, reference the dimension id and the full name from the table (for example, "access — Broken access control") and the Top 10 id when a row matches (for example, `A01:2025`). Cite only enabled dimensions. Do not cite an id that is not in `references/owasp-top-10.md`.
7. **Do not overclaim** — Classify every finding as code, hybrid, or manual. A `pass` needs evidence. Use the report format below. Never state that a module, package, or project is "secure" or "OWASP compliant".

## Key Rules

Each bullet is one dimension. Skip it when that dimension is not enabled. The table is the definition. These lines are the generation reminder.

- **access** — Every state-changing or private read checks the caller against the resource. Do not trust a client-supplied role, owner id, or "isAdmin" flag. Exact role match; cookie sessions need CSRF or SameSite; no session fixation.
- **injection** — Keep untrusted data out of SQL, shell, paths, HTML, YAML/XML, headers, and evaluators. Bind parameters. Encode on output. React text nodes are already encoded.
- **secrets** — Load secrets from the environment or a secret store. Do not commit them (including seed/`.pem`/`.env`), log them, ship them to the browser, or hash passwords with a fast hash.
- **exposure** — Do not return stack traces, internal errors, or other people's sensitive fields. Do not publicly cache private responses or ship secrets/session blobs to the client.
- **request** — Do not fetch or redirect to a URL the caller chose unless it is on an allowlist you control. Prefer allowlists over denylists; do not build reset links from `Host`.
- **failopen** — If an auth, signature, scan, or permission check errors, deny. Do not continue, return the protected data, call `next()`, or default to allow.
- **logic** — Money, inventory, and similar state changes enforce server-side rules atomically. Do not trust a client amount when the server owns the figure; reject illegal signs; do not check-then-act without a single guarded write.

## Level behavior

| Level | Behavior |
|-------|----------|
| `pragmatic` | File sinks and missing checks the source can already abuse. Leave clearly public routes (health, login form) and placeholder examples alone. |
| `strict` | Every state-changing handler and every sink in scope needs a visible control. Every enabled dimension applies. |
| `educational` | Same technical bar as `pragmatic`, plus an explicit rationale for each enabled dimension on every material control or sink. |

## Where a change goes

Edit the catalog that owns the change. Do not paste the same body into this procedure, the rule, and the subagent.

| Change | Edit |
|--------|------|
| Default level, example languages, or enabled dimensions | `security.config.json` |
| What a dimension means, a pass/fail signal, or severity | `references/principles-table.md` |
| The ten OWASP risk names or which dimension a risk maps to | `references/owasp-top-10.md` |
| A smell | `references/anti-patterns.md` |
| An implementation shape | `references/code-patterns.md` |
| A layer, a hunt, or a coverage checkbox | `references/audit-coverage.md` |
| A new level or dimension token | The allowed tokens at the top of this file, the level table if it is a level, then a row in `references/principles-table.md` |
| Evidence rules or the report format | This file, in "Audits — what the code can decide" |

A new smell, layer, or code shape does not belong in this file. The rule may keep one reminder per dimension. The subagent reads this file and does not keep a second template.

## When to Load References

- Defaults, every run → `security.config.json`
- Closed OWASP Top 10:2025 list, every run → `references/owasp-top-10.md`
- Dimension meaning, pass/fail, severity → `references/principles-table.md`
- Implementation shapes → `references/code-patterns.md`
- Smell catalog → `references/anti-patterns.md`
- Package or app audit → `references/audit-coverage.md`

## Common failures

Judgment traps only. Concrete smells live in `references/anti-patterns.md`. Layer hunts live in `references/audit-coverage.md`. Do not treat this section as a substitute for those catalogs.

- Do not claim a package or project is "secure", "OWASP compliant", or "free of vulnerabilities".
- Do not stop after the first sink or the first guarded route.
- At `pragmatic`, a public health route or a placeholder example value is not Critical — but a query built from request input, or an auth check that returns allow on error, still escalates.
- Do not invent a CVE for a dependency. Name an advisory only when it is written in the repo or the user supplied it.
- Do not file a missing port, a god class, a train wreck, a contrast failure, or a focus ring as security.
- Do not trust `Secure*`, `Safe*`, `Auth*`, `Guard*`, or `sanitize` names without reading the body.
- Do not write exploit steps, payloads, or bypass procedures. State the violated dimension and the closing control.

Always explain the security rationale when generating or fixing code. Name the dimension.

## Audits — what the code can decide

This section is the only copy of the evidence rules and the report format. The `security-reviewer` subagent reads them from here and returns the report to the parent. The parent applies fixes.

A source review is a security assessment of the scoped files. It is not a penetration test and it is not proof the system is safe. Do not write that a module, package, or project is "secure" or "OWASP compliant".

Evidence rules:

- Status `pass` only with evidence: a repository location `path:line`, or a structural property named with the file that shows it. With no such evidence the status is `needs verification`.
- One guarded handler does not close the dimension for the package. Record the scope of the evidence.
- On a package or app review, a pass on one file does not close the dimension for the package. File the same smell at every in-scope layer where it appears, or mark that layer absent.
- Prefer the smallest change that closes the abuse path. Do not add a second security product "just in case".
- Discuss dimensions that are in the resolved `dimensions` list. A dimension outside that list is out of scope, not a pass.

Dimension disambiguation (before filing):

1. Pick **one primary dimension** per symbol. Add a second only when it is a separate contract (or the catalog explicitly allows “also counts”).
2. Missing allow/deny, IDOR, or a client-trusted role or owner id → **access**. Password hashing and secret material → **secrets**, not access.
3. Untrusted data concatenated into a query, command, path, HTML, or `eval` → **injection**. A React text node and a bound SQL parameter are not injection.
4. A key, password, token, or connection string in source or in a log line → **secrets**. Empty example placeholders are not secrets.
5. Stack traces, internal errors, or someone else's sensitive fields returned to a client → **exposure**. A password written to a log is **secrets**, not exposure.
6. A caller-chosen URL that the server fetches or redirects to → **request**. A fixed URL in source is not request.
7. An auth, signature, or permission check that continues or returns allow when it throws → **failopen**. A catch that logs and denies is not failopen.
8. A client-trusted money/quantity amount, a missing sign/bounds check on that amount, or a read-check-then-write without an atomic predicate (TOCTOU) → **logic**. Missing allow/deny on the same handler is still **access** (file access for authz; logic only when the rule itself is unsafe).
9. Do not stamp SOLID, KISS, coupling, structure, or WCAG onto a security sink. Untrusted HTML in an HTML sink is **injection**. A missing focus style is WCAG, not security.

Put each finding into one class:

- **Code** — the source alone shows a violation or a satisfied check. Examples: SQL built with string concatenation of request input; a handler that loads a row by id and never compares the owner; `innerHTML` assigned from a query parameter; a live-looking API key in source; `catch { return true }` around a permission check; `fetch(req.query.url)`; `update` after a balance check with no `WHERE balance >= amount`.
- **Hybrid** — the source shows a risk; confirmation needs the mount, the middleware, or another module. Examples: a handler with no check in this file that might sit behind a router guard; a log field that might be redacted by a logger wrapper; a redirect target that might be allowlisted in the caller.
- **Manual** — needs a product or threat judgment. Examples: whether a route is intentionally public; whether a field is sensitive in this domain; whether a dependency advisory applies; whether an amount field is intentionally free-form. Do not invent that advisory.

### Report format

Use this structure for every review. The summary counts findings. It does not certify the package.

```
## Review result
Scope: <files or module>
Level: <from security.config.json, unless the user overrode it>
Dimensions: <enabled set>
Verdict: this is a security assessment, not a certification.

### Coverage (package/app audits)
- Layers swept: <routes | services | queries | clients | views | jobs | config>
- Gate: pass | incomplete — <missing hunt or “folder absent”>

### Violations visible in code
- Location: path:line
- Dimension: access | injection | secrets | exposure | request | failopen | logic — <name>
- OWASP: <A0x:2025 — name from owasp-top-10.md> | n/a
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
- What is missing: no path:line, or a guard, logger, or threat judgment outside scope
```

If a section has no items, write "None in this scope." Do not invent a pass. A pass needs `path:line`, or a structural property named with the file that shows it. Otherwise the check goes under "Needs verification".
For a single file, `### Coverage` may say `n/a — file-scoped`. Whenever `audit-coverage.md` was loaded, include `### Coverage`. An incomplete gate means keep searching. Do not close the report on the first sink alone.
