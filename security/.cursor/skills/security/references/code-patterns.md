# Code Patterns for Security

Implementation shapes. Add a shape here, not in `SKILL.md`, the rule, or `security-reviewer`. Examples are TypeScript. Adapt the syntax to the file. `languages` in `security.config.json` does not limit which files these shapes apply to, and a new language does not need a new file.

Prefer the smallest control that closes the abuse path. Do not add a second framework for one check.

## access — Check the caller against the resource

```typescript
app.post("/orders/:id/cancel", async (req, res) => {
  const order = await orders.findById(req.params.id);
  if (!order || order.ownerId !== req.session.userId) {
    res.status(404).end();
    return;
  }
  await orders.cancel(order.id);
  res.status(204).end();
});
```

```typescript
// The client does not choose the role. Exact match — not includes/substring.
const role = req.session.role;
if (role !== "admin") {
  res.status(403).end();
  return;
}
```

```typescript
// After password login, mint a new session id (no fixation).
const sessionId = crypto.randomBytes(32).toString("hex");
res.setHeader(
  "Set-Cookie",
  `sid=${sessionId}; Path=/; HttpOnly; Secure; SameSite=Lax`,
);
```

```typescript
// On password change: update the hash, then revoke other sessions.
await users.setPassword(userId, await hash(nextPassword, 12));
await sessions.deleteMany({ userId });
```

## injection — Bind and encode

```typescript
await db.query("select id from users where email = $1", [email]);
```

```typescript
import { spawn } from "node:child_process";

spawn("convert", [inputPath, outputPath], { shell: false });
```

```tsx
export function Name({ name }: { name: string }) {
  return <p>{name}</p>;
}
```

```typescript
import { verify } from "jsonwebtoken";

const payload = verify(token, publicKey, { algorithms: ["RS256"] });
```

Do not decode a JWT and trust it. Do not allow `none`. On verify failure, deny.

Disable external entities when the XML is untrusted. Pass user text as template data, not as the template string. When extracting an archive, resolve each entry and reject it when the path leaves the extract root.

Do not assign request data to `innerHTML` or `dangerouslySetInnerHTML`. If a stored HTML subset is a real product requirement, sanitize that subset in one place and treat anything else as text.

```typescript
// Prefer JSON for untrusted input. If YAML is required, use the library's safe loader (js-yaml 3: safeLoad), not load.
const doc = JSON.parse(text) as unknown;
```

```typescript
const ORDER = { opened_at: "opened_at", number: "number" } as const;
const orderBy = ORDER[sort as keyof typeof ORDER] ?? "opened_at";
// orderBy is a fixed identifier — never splice the raw query string into SQL.
```

Serve untrusted uploads with a server-chosen `Content-Type` (or `application/octet-stream`). Escape CSV cells and neutralize leading `= + - @`.

## secrets — Environment, slow password hash

```typescript
const apiKey = process.env.PAYMENTS_API_KEY;
if (!apiKey) throw new Error("PAYMENTS_API_KEY is required");
```

```typescript
import { hash } from "bcrypt";

const passwordHash = await hash(password, 12);
```

Log a request id. Do not log `password`, `authorization`, `cookie`, or the raw token.

```typescript
import { timingSafeEqual } from "node:crypto";

function apiKeyOk(presented: string, stored: string): boolean {
  const a = Buffer.from(presented);
  const b = Buffer.from(stored);
  return a.length === b.length && timingSafeEqual(a, b);
}
```

Do not compare secrets with `startsWith`. Do not fall back JWT secrets to `""`. Do not keep access tokens in `localStorage` when an HttpOnly session cookie exists.

## exposure — Stable errors, explicit fields

```typescript
res.status(500).json({ error: "internal" });
```

```typescript
return { id: user.id, displayName: user.displayName };
```

Keep `err.stack` on the server log, not in the response body.

```typescript
res.setHeader("Cache-Control", "private, no-store");
return { id: row.id, name: row.name };
```

Do not put PII in JWT claims. Do not `postMessage(token, "*")`. Prefer `frame-ancestors 'none'` / `X-Frame-Options: DENY` on authenticated routes.

## request — Allowlist before the call

```typescript
const ALLOWED = new Set(["hooks.example.com"]);

function hostOf(raw: string): string | null {
  try {
    return new URL(raw).host;
  } catch {
    return null;
  }
}

export async function deliver(raw: string, body: string) {
  const host = hostOf(raw);
  if (!host || !ALLOWED.has(host)) throw new Error("host not allowed");
  await fetch(raw, { method: "POST", body });
}
```

```typescript
function safeNext(next: string): string {
  if (!next.startsWith("/") || next.startsWith("//")) return "/desk";
  return next;
}
```

Redirect only to a relative path you own (reject `//`), or to a host on that same kind of list. Prefer an allowlist over a short host denylist; if redirects are followed, re-check the host. Build reset/OAuth links from a configured public origin — not `req.headers.host`. Leave TLS certificate verification at the platform default. Do not set `rejectUnauthorized: false`.

## failopen — Deny when the check fails

```typescript
async function requireAdmin(req: Request): Promise<void> {
  try {
    const session = await loadSession(req);
    if (session.role !== "admin") throw new Error("forbidden");
  } catch {
    throw new Error("forbidden");
  }
}
```

Do not `return true` from that `catch`. Do not invent an admin principal when load fails. Do not call `next()` from a rate-limit or auth failure path. Reject missing signatures; when a signature is present, also reject stale timestamps / replayed event ids. Treat a down malware scanner as unclean, not clean.

## logic — Server-owned amounts, atomic writes

```typescript
export async function reserveFunds(db: AccountDb, accountId: string, amountCents: number) {
  if (amountCents <= 0) throw new Error("amount");
  // One statement: check and use together (no TOCTOU window).
  const updated = await db.account.updateMany({
    where: { id: accountId, balanceCents: { gte: amountCents } },
    data: { balanceCents: { decrement: amountCents } },
  });
  if (updated.count !== 1) throw new Error("insufficient");
}
```

```typescript
export async function postPayout(db: PayoutDb, claimId: string) {
  const claim = await db.claim.findUnique({ where: { id: claimId } });
  if (!claim) throw new Error("missing");
  // Amount comes from the server row, not from the request body.
  return db.payout.create({
    data: { claimId, amountCents: claim.reserveCents, status: "sent" },
  });
}
```

Do not write `balanceCents: account.balanceCents - amount` after a separate read when two callers can interleave. Do not accept a negative adjustment unless the product explicitly allows it and caps the floor.
