# OWASP Top 10:2025 — closed list

Working list of the ten risks. The skill points here. Do not copy this table into `SKILL.md`, the rule, or `security-reviewer`. Do not search the web for the ten. Do not invent an eleventh item.

Source names: https://owasp.org/Top10/2025/ (2025 release). This file is the copy the agent uses. A newer release replaces this file; it does not add a parallel list in the skill.

Each row maps to one primary dimension from `principles-table.md`. File only when that dimension is enabled **and** the source shows the signal. A row marked "not a source finding" is still on the list: notice it, do not file it, do not fetch an advisory to force a hit.

| Id | Name | Primary dimension | File when the source shows | Do not file |
|----|------|-------------------|----------------------------|-------------|
| A01:2025 | Broken Access Control | `access`. SSRF that used to be its own item is `request` (also counts as A01). | Missing allow/deny, IDOR, client-trusted role or owner, CORS credentials with a wildcard origin, cookie-session state change with no CSRF token | A public health or login route. A bearer-token API is not CSRF |
| A02:2025 | Security Misconfiguration | `access` for permissive CORS or a default admin credential in source. `exposure` for debug or stack traces left on in the production path. TLS verification disabled on an outbound client is `request` | That flag, origin, default credential, or `rejectUnauthorized: false` written in the repo | A cloud-console setting that is not in the files |
| A03:2025 | Software Supply Chain Failures | none — not a seventh dimension | A script in the repo that installs or runs a remote payload with no pin or signature (`curl \| sh` of an untrusted URL) → `injection` if the script is the sink, else leave under Needs verification | A package name with no advisory id in the repo. Do not invent a CVE |
| A04:2025 | Cryptographic Failures | `secrets` | Secret in source or logs, password hashed or compared with a fast hash or in plain text, secret shipped to the browser | An empty example value |
| A05:2025 | Injection | `injection` | Untrusted data in SQL, NoSQL, shell, path, HTML, or `eval`. XSS, XML external entities, a user-controlled template, and an archive entry that leaves the extract root are this row | A React text node, a bound parameter, or a template file the repo owns |
| A06:2025 | Insecure Design | none | A missing control that already matches another row. File that row | "No threat model" or "could be abused someday" with no sink |
| A07:2025 | Authentication Failures | `access` for a broken session or login check. `secrets` for a default or hard-coded password. `failopen` when a failed login or JWT verify still allows | The check is missing, trusts the client, accepts a JWT without a signature check or with `alg: none`, or allows on error | The existence of a login form |
| A08:2025 | Software or Data Integrity Failures | `injection` for deserializing untrusted input into a call or object. `failopen` when a missing signature is treated as valid | That sink or that allow-on-missing-signature branch | A CI policy that is not in the files |
| A09:2025 | Security Logging and Alerting Failures | `secrets` when the log line contains a credential. `failopen` when a security failure is swallowed with no deny | The log argument or the empty success path | "No SIEM" or "no alert rule" outside the repo |
| A10:2025 | Mishandling of Exceptional Conditions | `failopen`. A stack or internal error returned to the client is `exposure` (also counts as A10) | `catch` returns allow or the protected resource; the client receives `err.stack` | A catch that logs and denies |

## How to cite

Cite the dimension from `principles-table.md` and the id from this table when the row matches (for example, `access — Broken access control`, `A01:2025`). One primary dimension. A second id only when this table says "also counts".

If nothing in the ten matches, use the dimension question in `principles-table.md`. Do not add `A11`.

## What this file is not

The OWASP Application Security Verification Standard is a larger catalog. It is not loaded here. Do not stop a review to download it. When a case is only an ASVS detail, map it to the row above or leave it under Needs verification with the missing fact. Do not paste ASVS into the report from memory.
