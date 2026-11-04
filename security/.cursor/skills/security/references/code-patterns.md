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
// The client does not choose the role.
const role = req.session.role;
if (role !== "admin") {
  res.status(403).end();
  return;
}
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

## exposure — Stable errors, explicit fields

```typescript
res.status(500).json({ error: "internal" });
```

```typescript
return { id: user.id, displayName: user.displayName };
```

Keep `err.stack` on the server log, not in the response body.

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

Redirect only to a relative path you own, or to a host on that same kind of list. Leave TLS certificate verification at the platform default. Do not set `rejectUnauthorized: false`.

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

Do not `return true` from that `catch`.
