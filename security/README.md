# Security Preset for Cursor

Production-ready security preset for Cursor IDE.

It helps apply source-level security controls using the level and dimensions in `security.config.json`. The shipped file is **pragmatic** with all seven dimensions: `access`, `injection`, `secrets`, `exposure`, `request`, `failopen`, `logic`.
Change `level` to `strict` or `educational`, or narrow `dimensions`, in that file. A request in chat overrides the file for that turn.

A review of these files is not a penetration test. The agent must not claim that a package is "secure" or "OWASP compliant", and it must not write exploit steps.

## What this preset includes

| Layer | File / Folder | Purpose |
|-------|---------------|---------|
| **Rules** | `.cursor/rules/security.mdc` | Applied on source files. Short reminders only. The skill owns the procedure. |
| **Config** | `.cursor/skills/security/security.config.json` | Default `level`, `languages`, and `dimensions`. Read on every run. |
| **Skill** | `.cursor/skills/security/` | The procedure: scope filter, evidence rules, and the report format. Catalogs stay in `references/`. |
| **Subagent** | `.cursor/agents/security-reviewer.md` | Readonly auditor. Runs when asked, reads the skill, and returns a report to the parent. It does not keep its own template. |
| **References** | `.cursor/skills/security/references/` | Working catalogs, loaded on demand. Each file owns one kind of change. |

### Key reference files

Each catalog has one owner. A new smell, layer, or code shape goes in that file. It does not get pasted into the rule or the subagent.

- `references/owasp-top-10.md` — the only copy of the OWASP Top 10:2025 list (ten rows) and which dimension each risk maps to. Loaded on every run. Do not search the web for the ten
- `references/principles-table.md` — working source for the seven dimensions: meaning, pass/fail, severity
- `references/code-patterns.md` — implementation shapes (TypeScript examples; adapt the syntax)
- `references/anti-patterns.md` — smell catalog, including sinks that are not findings
- `references/audit-coverage.md` — the only copy of the package/app layer sweep and coverage gate
- `security.config.json` — default level, example languages, and enabled dimensions
- `SKILL.md` — the only copy of the scope filter, the evidence rules, and the report format

```json
{
  "level": "pragmatic",
  "languages": ["typescript", "javascript"],
  "dimensions": ["access", "injection", "secrets", "exposure", "request", "failopen", "logic"]
}
```

## Levels

Aligned with the level table in `SKILL.md`:

- **pragmatic** — shipped default. File sinks and missing checks the source can already abuse. Leave clearly public routes and placeholder examples alone.
- **strict** — every state-changing handler and every sink in scope needs a visible control. Every enabled dimension applies.
- **educational** — same technical bar as pragmatic, plus an explicit rationale for each enabled dimension on every material control or sink.

The agent reads `security.config.json` before it generates or reviews security-sensitive code. Chat can override that file for one request.

`languages` picks example syntax only. Rule `globs` attach reminders when matching files are edited. Skill `paths` scopes auto-surfacing of the skill for the same extensions. `/security` and `/security-reviewer` still work when invoked explicitly.

## Dimensions

| Id | Focus |
|----|--------|
| `access` | Broken access control — caller checked against the resource, not a client-supplied role; session cookie/CSRF/fixation and exact role checks |
| `injection` | SQL, command, path, HTML/XSS, eval, unsafe YAML/XML, upload Content-Type, CSV formula sinks |
| `secrets` | Secrets out of source, seed, logs, and the browser; slow password hashes; timing-safe compares |
| `exposure` | No stack traces, PII leakage, public cache on private data, or prod source maps / env dumps |
| `request` | SSRF and open redirects — allowlist before fetch or redirect; no Host-built reset links |
| `failopen` | A failed auth, signature, scan, or rate-limit check denies |
| `logic` | Unsafe business rules — client-trusted amounts, missing sign/bounds checks, TOCTOU on balance/stock |

Session, misconfiguration, and integrity smells map into `access` / `exposure` / `injection` / `failopen` / `request`. Money and inventory rule abuse is `logic`. Do not invent an eighth dimension id. Outdated packages are not a finding unless the repo or the user names an advisory. Do not invent a CVE.

## How the layers relate

The skill is the procedure. The parent agent and `security-reviewer` both read it. The skill does not call the subagent.

- The **parent** writes code and can do a review in the same chat.
- **`security-reviewer`** is for an audit in a separate context. It returns notes and does not edit. The parent decides the next task and applies fixes.
- Do not expect the subagent to start on its own after every edit. Invoke it with `/security-reviewer` or an explicit review request.

When the guidance changes, edit the owner and leave the procedure alone:

| Change | Edit |
|--------|------|
| Defaults | `security.config.json` |
| What a dimension means | `references/principles-table.md` |
| The ten OWASP risk names | `references/owasp-top-10.md` |
| A smell | `references/anti-patterns.md` |
| A code shape | `references/code-patterns.md` |
| A layer or a coverage check | `references/audit-coverage.md` |
| The workflow, the filter, or the report | `SKILL.md` |

## How to install

1. Copy the entire `.cursor/` folder from this preset into the **root** of your project.
2. The structure must stay exactly like this (do not rename or flatten folders):

```
your-project/
├── .cursor/
│   ├── rules/
│   ├── skills/
│   └── agents/
├── ... (your source code)
```

3. Restart Cursor or reload the window.

```bash
# From your project root
cp -r /path/to/security/.cursor ./
```

This preset does not include a hook. Adding `hooks.json` later is optional and is not required for the rule, the skill, or the subagent to load.

### Combining with other presets

If you already use [`solid`](../solid), [`kiss`](../kiss), [`coupling`](../coupling), [`structure`](../structure), or [`wcag-2.2`](../wcag-2.2), merge the contents of each preset’s `.cursor/` folders into one project `.cursor/`.
Only `kiss` ships a hook. Keep that `hooks.json` as-is when merging.

A missing port is SOLID. A focus ring is WCAG. Untrusted HTML in an HTML sink is security. Product error-code catalogs and framework layout stay in the project's own rules.

## How to use

### Automatic (recommended)
Just write or generate application code. The rules are applied automatically on TypeScript, JavaScript, Python, Java, Kotlin, C#, Go, HTML, and SQL files.

### Manual / deeper review
You can invoke the skill or subagent at any time:

```
/security
/security-reviewer
```

Or simply ask in chat:
- “Check this handler for missing ownership checks”
- “Review outbound webhooks for SSRF”
- “Stop logging the session token”

### Example prompts

**Generation**
```
Add a cancel-order handler. Compare the session user to the order owner. Bind every query parameter. Do not claim the route is secure.
```

**Audit**
```
/security-reviewer Review the billing routes and the webhook worker.
```

**Fix**
```
This query concatenates the email from the request. Bind the parameter and update the code.
```

**Strict / educational**
```
Audit this package at security strict level and list every state change that has no visible allow/deny.
```

```
Explain each security dimension you apply while closing this fail-open catch (educational).
```

## What the agent knows by default

- Apply the enabled dimensions from `security.config.json` at the resolved level
- Do not file health routes, placeholders, React text nodes, or bound parameters at `pragmatic`
- Do not invent a CVE. Do not write exploit steps
- Concrete smells and layer hunts live in `references/` — open them on review or package/app audit
- Use `/security-reviewer` for a readonly audit in a separate context; the parent applies fixes

## Source

Based on the OWASP Top 10 categories that are visible in application source (broken access control, injection, cryptographic failures, sensitive data exposure, SSRF) plus controls that fail open. Working tables and patterns are markdown. This preset does not certify conformance.

---

Copy the `.cursor/` folder as-is.
The structure is required for Cursor to load the rules, skill and agent correctly.
