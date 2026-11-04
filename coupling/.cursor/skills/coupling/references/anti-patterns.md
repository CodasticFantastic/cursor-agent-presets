# Coupling Anti-Patterns

Smell catalog. Add a smell here, not in `SKILL.md`, the rule, or `coupling-reviewer`. Pair with `principles-table.md`, `code-patterns.md`, and (for package audits) `audit-coverage.md`. Apply a row only when its dimension is enabled.

## lod — Law of Demeter

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| Train wreck `a.getB().getC().doSomething()` | The caller depends on a stranger's shape | Method on the friend that performs the operation |
| Field walk `order.customer.address.city` inside domain policy | Policy breaks when the graph changes | `order.shipToCity()` or pass the city in as a parameter at the edge |
| Mutating a collaborator's collection (`account.lines.push`, `order.items[0].price =`) | Breaks the owner's invariants | Tell the owner: `account.addLine(...)` |
| Util that accepts an aggregate and walks three levels | Hidden coupling in a "helper" | Move the walk onto the owner, or pass the leaf value in |
| Chain used to reach a method that could live on the first friend | Every intermediate type is now API | One method on the friend |

**Not lod:** one call on a field, parameter, or object this function created. `user.name` on a parameter is one hop to a friend. `user.profile.city` is the stranger.

## tda — Tell, Don't Ask

| Smell | Why it fails | Typical fix |
|-------|--------------|-------------|
| Ask then branch: `if (account.balance < amount) account.withdraw(amount)` | The rule lives outside the data | `account.withdraw(amount)` owns the check |
| Feature envy: a function mostly reads another type's getters and decides | That type's policy is copied | Move the decision onto the type |
| External state machine: `if (order.status === "paid") order.ship()` | Transition rules leak to every caller | `order.ship()` refuses or proceeds from its own state |
| Caller sets fields to keep an invariant (`cart.items.push` then `cart.total = …`) | Invariant can be skipped | One command on the owner updates both |
| Service recomputes a value object rule (`money.amount * rate` beside `Money`) | Callers drift | `money.times(rate)` or `money.convert(rate)` |

**Not tda:** reading a value to display it, to log it, or to pass it as an argument (`mailer.send(order.id)`). A null check on a missing collaborator is not a stolen rule.

## False positives (especially at `pragmatic`)

Do **not** treat these as violations:

- Mapper, serializer, `toDto` / `fromRow`, or presenter that reads a plain data record
- Collection pipelines (`map`, `filter`, `reduce`) and stdlib chains on `string` / `array` / `date`
- Fluent builder that returns the **same** type (`query.where().limit()`)
- One-hop getter on a friend (`order.total`, `user.email` on a parameter)
- UI that chooses a label from a view-model field
- Anemic DTO with no rule to steal — asking its fields is the API
- Passing a leaf into a function (`priceCity(order.customer.address.city)` at a **mapping edge**). At `strict`, still prefer the edge to pass `city` in so domain code never sees the chain
- A decision that belongs to the **caller** (HTTP authz on a token, feature flag in the composition root), not to the object being asked

Escalate when domain or service code **mutates** through a chain, or **reimplements** money, auth, inventory, or state-transition rules by asking.

## Review process smells (meta)

Flag the **audit itself** as incomplete when:

- Only the longest chain is cited and services, API, and UI were not opened
- A mapper or presenter read was filed as lod
- `map` / `filter` or a same-type fluent builder was filed as lod
- The suggested fix is a one-line forwarder with no rule behind it
- A missing port or a god class was filed as coupling
- One clean method was treated as a package-wide pass
- "Too coupled" claims have no `path:line`
