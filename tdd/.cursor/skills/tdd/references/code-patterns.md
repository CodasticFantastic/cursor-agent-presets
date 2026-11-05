# Code Patterns for TDD

Plan and test shapes. Add a shape here, not in `SKILL.md`, the rule, or `tdd-reviewer`. Examples are TypeScript with Vitest/Jest style APIs. Adapt the syntax to the file. `languages` in `tdd.config.json` does not limit which files these shapes apply to, and a new language does not need a new file.

The skill and reviewer **describe** these shapes in plans and fix guidance. They do not write the files.

Prefer a failing behavioral case first. Prefer public outcomes. Prefer deterministic seams. Prefer one reason to fail.

## cycle — Failing case before green

```typescript
// ❌ BAD — implement first, invent a passing test later
export function hullPremium(cents: number): number {
  if (cents < 100_00) return Math.round(cents * 0.08);
  return Math.round(cents * 0.05);
}
// test added afterward that only mirrors the implementation

// ✅ GOOD — plan (and then parent writes) a red case first
it("applies the low-band hull rate under 100_00", () => {
  expect(hullPremium(50_00)).toBe(400);
});
// red: hullPremium missing or wrong → green: minimum implementation → refactor
```

Plan language (no file edit from the skill):

```
### Red
1. Test: packages/ledger/src/hull-premium.test.ts::applies the low-band hull rate under 100_00
   Assert: hullPremium(50_00) === 400
   Why red: function missing or returns 0
```

## behavior — Public contract, not private spies

```typescript
// ❌ BAD — locks internals
it("calls normalize then rate", () => {
  const normalize = jest.spyOn(svc as any, "normalize");
  const rate = jest.spyOn(svc as any, "rate");
  svc.quote(50_00);
  expect(normalize).toHaveBeenCalledBefore(rate as any);
});

// ✅ GOOD — locks the outcome
it("quotes the low-band hull premium", () => {
  expect(svc.quote(50_00)).toEqual({ premiumCents: 400 });
});
```

```typescript
// ✅ STILL GOOD — exported pure helper is the API
it("bands under 100_00 as low", () => {
  expect(bandFor(50_00)).toBe("low");
});
```

## focus — One reason to fail

```typescript
// ❌ BAD — kitchen sink
it("handles payouts", async () => {
  await login(admin);
  const claim = await openClaim();
  await pay(claim.id, 100);
  expect(await balance(claim.id)).toBe(0);
  expect(page.landingHtml).toContain("<h1>");
  expect(mailer.sent[0].subject).toMatch(/paid/i);
});

// ✅ GOOD — split by rule
it("reduces claim reserve to zero after a full payout", async () => {
  const claim = await openClaim({ reserveCents: 100 });
  await pay(claim.id, 100);
  expect(await reserveCents(claim.id)).toBe(0);
});
```

```typescript
// ✅ STILL GOOD — table for the same rule
it.each([
  [50_00, 400],
  [99_99, 800],
])("low-band hullPremium(%i) → %i", (input, expected) => {
  expect(hullPremium(input)).toBe(expected);
});
```

## oracle — Concrete outcome

```typescript
// ❌ BAD — weak / tautological
it("works", () => {
  const result = quote(50_00);
  expect(result).toBeDefined();
  expect(result).toEqual(result);
});

it("does not throw", () => {
  expect(() => quote(50_00)).not.toThrow();
});

// ✅ GOOD — names the rule
it("returns 400 cents for a 50_00 low-band reserve", () => {
  expect(quote(50_00).premiumCents).toBe(400);
});
```

```typescript
// ✅ STILL GOOD — boundary interaction when send is the behavior
it("sends the paid notice to the broker inbox", async () => {
  await notifyPaid({ claimId: "c1", to: "broker@example.com" });
  expect(mailer.send).toHaveBeenCalledWith(
    expect.objectContaining({ to: "broker@example.com", template: "paid" }),
  );
});
```

## isolation — Seams and fresh arrange

```typescript
// ❌ BAD — live clock / shared mutable bleed
let now = Date.now();
it("expires after 60s", async () => {
  const t = issue(now);
  await new Promise((r) => setTimeout(r, 61_000));
  expect(live(t, Date.now())).toBe(false);
});

it("reuses the same ledger", () => {
  ledger.debit(10);
  expect(ledger.balance).toBe(90); // depends on previous tests
});

// ✅ GOOD — injected clock; fresh state
it("expires after 60s", () => {
  const t = issue(1_000);
  expect(live(t, 1_000 + 61_000)).toBe(false);
});

it("debits the ledger", () => {
  const ledger = new Ledger(100);
  ledger.debit(10);
  expect(ledger.balance).toBe(90);
});
```

## arrange — Visible AAA

```typescript
// ❌ BAD — act hidden in setup
beforeEach(async () => {
  await seedEverything();
  await runPayoutFlow(); // act buried
});
it("is settled", async () => {
  expect(await status("c1")).toBe("settled");
});

// ✅ GOOD — arrange visible; act in the test
it("marks the claim settled after a full payout", async () => {
  const claim = await seedClaim({ reserveCents: 100 }); // arrange
  await pay(claim.id, 100); // act
  expect(await status(claim.id)).toBe("settled"); // assert
});
```

## Green and refactor (guidance only)

- **Green:** the smallest production change that passes the current red. Do not add the next band, a cache, or a plugin host in the same step.
- **Refactor:** rename, extract, or flatten only while tests stay green. New requirements become new reds.

## Anti-patterns to avoid in plans

- Pasting a full production implementation in the plan "so the parent can apply it blindly" without ordered reds
- Planning one mega-test that covers the whole feature
- Planning spies on private methods as the primary oracle
- Planning real network calls for a unit-level rule
