# Code Patterns for Coupling

Implementation shapes. Add a shape here, not in `SKILL.md`, the rule, or `coupling-reviewer`. Examples are TypeScript. Adapt the syntax to the file. `languages` in `coupling.config.json` does not limit which files these shapes apply to, and a new language does not need a new file.

Prefer a method that owns the rule. Do not add a function that only returns `this.b.c`.

## lod — Stop at a friend

```typescript
// ❌ BAD — domain policy walks a stranger
function shippingCity(order: Order): string {
  return order.customer.address.city;
}

// ✅ GOOD — the order is the friend; it hides the graph
function shippingCity(order: Order): string {
  return order.shipToCity();
}
```

```typescript
class Order {
  constructor(private readonly customer: Customer) {}

  shipToCity(): string {
    return this.customer.city();
  }
}

class Customer {
  constructor(private readonly address: Address) {}

  city(): string {
    return this.address.city;
  }
}
```

Each type talks only to its own field. The original caller never sees `address`.

```typescript
// ❌ BAD — outsider mutates the collection
account.lines.push({ sku, qty });

// ✅ GOOD — the owner keeps the invariant
account.addLine(sku, qty);
```

```typescript
// ✅ STILL GOOD — one hop on a parameter (a friend)
function label(user: User): string {
  return user.email;
}

// ✅ STILL GOOD — object this function created
function clock(): Date {
  return new Date();
}
```

## lod — Edges may walk data

```typescript
// ✅ Mapper — structural read is the job
function toShipmentDto(row: ShipmentRow): ShipmentDto {
  return {
    city: row.customer.address.city,
  };
}

// ❌ Do not push that walk into the pricing policy.
// Pass the city in, or ask the order.
function quote(order: Order, city: string): number {
  return rateFor(city) * order.total();
}
```

```typescript
// ✅ Collection pipeline and same-type fluent API are not train wrecks
const skus = items.map((item) => item.sku).filter(Boolean);
const query = orders.where("open").limit(20);
```

## tda — The owner decides

```typescript
// ❌ BAD — caller asks, then decides
function withdraw(account: Account, amount: number) {
  if (account.balance < amount) {
    throw new Error("insufficient");
  }
  account.balance -= amount;
}

// ✅ GOOD — tell the account
class Account {
  withdraw(amount: number) {
    if (this.balance < amount) {
      throw new Error("insufficient");
    }
    this.balance -= amount;
  }
}
```

```typescript
// ❌ BAD — transition rule copied at every call site
if (order.status === "paid") {
  order.status = "shipped";
}

// ✅ GOOD
order.ship();
```

```typescript
class Money {
  constructor(private readonly amount: number) {}

  times(rate: number): Money {
    return new Money(this.amount * rate);
  }
}

// ❌ caller recomputes the rule: money.amount * rate
// ✅ money.times(rate)
```

## When both show up

```typescript
// ❌ Walks a stranger AND decides outside
if (order.customer.address.country === "US") {
  order.customer.address.city = "…";
}

// ✅ The order owns the policy. Lod also counts if a second hop remains
// after the rule moves — then give Order a method that hides the graph.
order.applyDomesticCityRule();
```

Do not "fix" the chain with:

```typescript
// ❌ pure forwarder — no rule, still a KISS problem
cityOf(order: Order) {
  return order.customer.address.city;
}
```

## Reads that are not Tell, Don't Ask

```typescript
// display
const title = user.displayName;

// pass-through argument
mailer.send(order.id);

// caller's own policy (authz), not Order's rule
if (!token.can("ship")) return;
order.ship();
```
