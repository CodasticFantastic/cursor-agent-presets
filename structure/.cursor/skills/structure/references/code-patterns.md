# Code Patterns for Structure

Implementation shapes. Add a shape here, not in `SKILL.md`, the rule, or `structure-reviewer`. Examples are TypeScript. Adapt the syntax to the file. `languages` in `structure.config.json` does not limit which files these shapes apply to, and a new language does not need a new file.

Prefer named steps at one level. Prefer reuse when copies share a change reason. Do not build a framework for two call sites.

## slap — One level per function

```typescript
// ❌ BAD — high-level story mixed with low-level I/O and HTML
async function closeDay(storeId: string) {
  const rows = await db.query(`SELECT * FROM orders WHERE store_id = '${storeId}' AND open = 1`);
  let total = 0;
  for (const row of rows) {
    total += Number(row.amount_cents) / 100;
  }
  const html = `<h1>Close</h1><p>${total}</p>`;
  await smtp.send(storeId, html);
}

// ✅ GOOD — orchestrator at one level
async function closeDay(storeId: string) {
  const open = await loadOpenOrders(storeId);
  const total = sumOrderTotals(open);
  await sendCloseReport(storeId, total);
}
```

```typescript
// ✅ STILL GOOD — a function whose only job is low-level
function parseAmountCents(raw: string): number {
  return Number.parseInt(raw, 10);
}
```

```typescript
// ❌ BAD — comments fake SLAP
function checkout(cart: Cart) {
  // validate
  if (!cart.lines.length) throw new Error("empty");
  // price
  const total = cart.lines.reduce((s, l) => s + l.price, 0);
  // charge
  stripe.charges.create({ amount: total });
}

// ✅ GOOD — same grain of named steps (or keep pricing/charge as injected ports)
function checkout(cart: Cart) {
  assertNonEmpty(cart);
  const total = priceCart(cart);
  charge(total);
}
```

## dry — Search before invent; parameterize twins

```typescript
// ❌ BAD — three near-copies
function rushFee(miles: number) {
  return miles < 5 ? 10 : 10 + (miles - 5) * 2;
}
function overnightFee(miles: number) {
  return miles < 5 ? 20 : 20 + (miles - 5) * 3;
}
function economyFee(miles: number) {
  return miles < 5 ? 5 : 5 + (miles - 5) * 1;
}

// ✅ GOOD — one rule, differences as data
const FEE = {
  rush: { base: 10, perMile: 2 },
  overnight: { base: 20, perMile: 3 },
  economy: { base: 5, perMile: 1 },
} as const;

function deliveryFee(kind: keyof typeof FEE, miles: number) {
  const { base, perMile } = FEE[kind];
  return miles < 5 ? base : base + (miles - 5) * perMile;
}
```

```typescript
// ❌ BAD — new helper pasted beside an existing one
function activeMembers(list: Member[]) {
  return list.filter((m) => m.status === "active" && !m.deletedAt);
}
function currentMembers(list: Member[]) {
  return list.filter((m) => m.status === "active" && !m.deletedAt);
}

// ✅ GOOD — reuse after search
function activeMembers(list: Member[]) {
  return list.filter((m) => m.status === "active" && !m.deletedAt);
}
```

```typescript
// ✅ Generation habit — before adding `calculateWidgetTax`:
// 1. Search for tax / widget / calculate*tax
// 2. If a twin exists with the same rule, extend or parameterize
// 3. If the rule must diverge (different legal basis), keep a separate function and say why
```

## False DRY — do not do this

```typescript
// ❌ Speculative shared module (KISS yagni — not a structure win)
function processThing(opts: {
  mode: "a" | "b" | "c" | "future";
  hooks?: Partial<Record<string, () => void>>;
}) {
  /* one caller uses mode "a" only */
}

// ❌ Collapsing divergent rules into flag soup
function fee(kind: string, miles: number, legacy: boolean, promo?: boolean) {
  /* every tenant branch in one function */
}
```

## Reads that are not dry failures

```typescript
// similar shape, different contract — OK at pragmatic
function toUserDto(row: UserRow) {
  return { id: row.id, email: row.email };
}
function toAdminDto(row: AdminRow) {
  return { id: row.id, role: row.role, email: row.email };
}

// edge adapter may intentionally duplicate a thin map
```
