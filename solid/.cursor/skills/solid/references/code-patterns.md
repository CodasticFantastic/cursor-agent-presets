# Code Patterns for SOLID

Implementation shapes. Add a shape here, not in `SKILL.md`, the rule, or `solid-reviewer`. Examples are TypeScript. Adapt the syntax to the file. `languages` in `solid.config.json` does not limit which files these shapes apply to, and a new language does not need a new file.

Prefer the smallest structure that restores the enabled letter.

## S — Split reasons to change

```typescript
// ❌ BAD — one class owns HTTP + domain + formatting
class OrderService {
  async place(input: OrderInput) {
    const res = await fetch("/api/prices");
    const total = /* business rules mixed with I/O */;
    return `Order #${total}`;
  }
}

// ✅ GOOD — separate I/O, policy, presentation
interface PriceCatalog {
  getUnitPrice(sku: string): Promise<number>;
}

class OrderPricing {
  constructor(private readonly prices: PriceCatalog) {}
  async total(items: LineItem[]): Promise<number> {
    let sum = 0;
    for (const item of items) {
      sum += (await this.prices.getUnitPrice(item.sku)) * item.qty;
    }
    return sum;
  }
}
```

## O — Extend with strategies, not growing switches

```typescript
// ❌ BAD — every new method edits this function
function fee(method: "card" | "wire" | "crypto", amount: number) {
  switch (method) {
    case "card": return amount * 0.02;
    case "wire": return 5;
    case "crypto": return amount * 0.01;
  }
}

// ✅ GOOD — closed dispatcher, open strategies
interface FeePolicy {
  fee(amount: number): number;
}

class CardFee implements FeePolicy {
  fee(amount: number) { return amount * 0.02; }
}

class WireFee implements FeePolicy {
  fee(_amount: number) { return 5; }
}

function applyFee(policy: FeePolicy, amount: number) {
  return policy.fee(amount);
}
```

At `pragmatic` level, a small stable union with exhaustive `switch` is fine until variants churn. Noting it on a package audit is optional; it is not an automatic OCP violation.

## L — Honor the base contract

```typescript
// ❌ BAD — subtype refuses the base promise
class Bird {
  fly(): void { /* ... */ }
}
class Penguin extends Bird {
  fly(): void {
    throw new Error("cannot fly");
  }
}

// ✅ GOOD — model capabilities accurately
interface Flyer {
  fly(): void;
}
class Sparrow implements Flyer {
  fly() { /* ... */ }
}
class Penguin {
  swim() { /* ... */ }
}
```

## I — Narrow interfaces

```typescript
// ❌ BAD — fat port
interface UserRepository {
  findById(id: string): Promise<User>;
  save(user: User): Promise<void>;
  sendWelcomeEmail(user: User): Promise<void>;
  exportCsv(): Promise<Blob>;
}

// ✅ GOOD — role interfaces
interface UserReader {
  findById(id: string): Promise<User>;
}
interface UserWriter {
  save(user: User): Promise<void>;
}
interface UserMailer {
  sendWelcomeEmail(user: User): Promise<void>;
}
```

## D — Depend on ports; inject adapters

```typescript
// ❌ BAD — domain constructs infrastructure
class Checkout {
  async pay(order: Order) {
    const stripe = new StripeClient(process.env.STRIPE_KEY!);
    await stripe.charge(order.total);
  }
}

// ✅ GOOD — domain depends on abstraction
interface PaymentGateway {
  charge(amount: number): Promise<PaymentResult>;
}

class Checkout {
  constructor(private readonly payments: PaymentGateway) {}
  async pay(order: Order) {
    return this.payments.charge(order.total);
  }
}

class StripePaymentGateway implements PaymentGateway {
  constructor(private readonly client: StripeClient) {}
  charge(amount: number) {
    return this.client.charge(amount);
  }
}
```

## Composition over inheritance (supports O + L)

```typescript
class AuditedGateway implements PaymentGateway {
  constructor(
    private readonly inner: PaymentGateway,
    private readonly log: Logger,
  ) {}
  async charge(amount: number) {
    this.log.info("charge.start", { amount });
    try {
      return await this.inner.charge(amount);
    } finally {
      this.log.info("charge.end", { amount });
    }
  }
}
```

## Functional style (when paradigm is `functional`)

```typescript
type FeePolicy = (amount: number) => number;
const cardFee: FeePolicy = (a) => a * 0.02;
const wireFee: FeePolicy = () => 5;

type Charge = (amount: number) => Promise<PaymentResult>;

const checkout =
  (charge: Charge) =>
  async (order: Order) =>
    charge(order.total);
```
