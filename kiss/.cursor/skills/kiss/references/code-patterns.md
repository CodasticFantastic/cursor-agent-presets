# Code Patterns for KISS

Implementation shapes. Add a shape here, not in `SKILL.md`, the rule, or `kiss-reviewer`. Examples are TypeScript. Adapt the syntax to the file. `languages` in `kiss.config.json` does not limit which files these shapes apply to, and a new language does not need a new file.

Prefer the smallest structure that meets the current requirement.

## clarity — Prefer boring and explicit

```typescript
// ❌ BAD — clever, hard to scan
const label = users.filter(u => u.a).map(u => u.n).join(",") || "—";

// ✅ GOOD — named steps
const activeUsers = users.filter((user) => user.active);
const names = activeUsers.map((user) => user.name);
const label = names.length > 0 ? names.join(", ") : "—";
```

```typescript
// ❌ BAD — nested ternaries
const status = ready ? (paid ? "ship" : "pay") : "wait";

// ✅ GOOD — early returns
function nextStatus(ready: boolean, paid: boolean): string {
  if (!ready) return "wait";
  if (!paid) return "pay";
  return "ship";
}
```

## yagni — Ship the path you need

```typescript
// ❌ BAD — speculative providers nobody uses
type MailProvider = "smtp" | "ses" | "mailgun" | "postmark";

function sendMail(provider: MailProvider, message: Message) {
  switch (provider) {
    case "smtp":
      return sendSmtp(message);
    case "ses":
      throw new Error("not implemented");
    case "mailgun":
      throw new Error("not implemented");
    case "postmark":
      throw new Error("not implemented");
  }
}

// ✅ GOOD — the one provider you actually run
function sendMail(message: Message) {
  return sendSmtp(message);
}
```

When a second provider is real, introduce a small port or map — not before.

## abstraction — Concrete until the second need

```typescript
// ❌ BAD — ceremony for one implementation
interface ReportRenderer {
  render(data: ReportData): string;
}
abstract class BaseReportRenderer implements ReportRenderer {
  abstract render(data: ReportData): string;
}
class HtmlReportRenderer extends BaseReportRenderer {
  render(data: ReportData) {
    return `<h1>${data.title}</h1>`;
  }
}
class ReportRendererFactory {
  static create(): ReportRenderer {
    return new HtmlReportRenderer();
  }
}

// ✅ GOOD — one function until a second format appears
function renderHtmlReport(data: ReportData): string {
  return `<h1>${data.title}</h1>`;
}
```

```typescript
// ✅ STILL GOOD — port justified by real infra / tests
interface Clock {
  now(): Date;
}
class SystemClock implements Clock {
  now() {
    return new Date();
  }
}
```

## surface — Narrow APIs

```typescript
// ❌ BAD — kitchen-sink options
type FetchUserOptions = {
  includePosts?: boolean;
  includeFriends?: boolean;
  includeBilling?: boolean;
  includeAudit?: boolean;
  includePreferences?: boolean;
  locale?: string;
  debug?: boolean;
};

// ✅ GOOD — required input only; split when needs diverge
type FetchUserInput = { userId: string };

function fetchUser({ userId }: FetchUserInput): Promise<User> {
  return db.users.findById(userId);
}

function fetchUserWithPosts(userId: string): Promise<UserWithPosts> {
  // separate path when that product need is real
}
```

## deps — Prefer stdlib / existing stack

```typescript
// ❌ BAD — new dependency for a trivial helper
import { isEmpty } from "some-utils-pack";
if (isEmpty(list)) { /* ... */ }

// ✅ GOOD
if (list.length === 0) { /* ... */ }
```

Add a dependency when it replaces substantial, error-prone code (crypto, date timezones, battle-tested parsers) — not for one-liners.

## flow — Guard clauses and direct calls

```typescript
// ❌ BAD — nesting pyramid
function charge(user?: User, order?: Order) {
  if (user) {
    if (user.active) {
      if (order) {
        if (order.total > 0) {
          return payments.charge(order.total);
        }
      }
    }
  }
  return null;
}

// ✅ GOOD — shallow happy path
function charge(user: User, order: Order) {
  if (!user.active) return null;
  if (order.total <= 0) return null;
  return payments.charge(order.total);
}
```

```typescript
// ❌ BAD — pure forwarding layers
function createOrder(input: OrderInput) {
  return orderService.createOrder(input);
}
// orderService.createOrder only calls orderRepo.insert

// ✅ GOOD — call the meaningful boundary
function createOrder(input: OrderInput) {
  return orderRepo.insert(normalize(input));
}
```

## When simple means “split”, not “merge”

```typescript
// ❌ FALSE SIMPLE — one file owns HTTP + pricing + email
async function checkout(req: Request) {
  const prices = await fetch("/api/prices");
  const total = /* rules */;
  await sendEmail(/* ... */);
  return Response.json({ total });
}

// ✅ ACTUALLY SIMPLE — each unit does one obvious job
function priceOrder(items: LineItem[], catalog: PriceCatalog): number { /* ... */ }

async function checkout(input: CheckoutInput, deps: CheckoutDeps) {
  const total = priceOrder(input.items, deps.catalog);
  await deps.mailer.sendReceipt(input.email, total);
  return { total };
}
```

## Functional style (same dimensions)

```typescript
// Prefer small pure functions over a configurable mega-pipeline
const withTax = (rate: number) => (amount: number) => amount * (1 + rate);

// ❌ speculative pipeline stages
// pipe(normalize, validate, enrich, score, rank, explain, cache, …)

// ✅ only stages you need today
const total = withTax(0.23)(subtotal);
```
