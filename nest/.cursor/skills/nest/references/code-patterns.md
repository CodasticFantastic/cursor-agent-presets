# Code Patterns for Nest

Implementation shapes. Add a shape here, not in `SKILL.md`, the rule, or `nest-reviewer`. Examples are TypeScript. `languages` in `nest.config.json` does not limit which files these shapes apply to.

Prefer the smallest change that restores the rule.

## controller — Delegate

```typescript
@Controller("orders")
export class OrdersController {
  constructor(private readonly orders: OrdersService) {}

  @Post(":id/cancel")
  cancel(@Param() params: CancelParams, @CurrentUser() user: UserSession) {
    return this.orders.cancel(params.id, user.id);
  }
}
```

Return the value. Do not inject `@Res()` for this JSON response.

## validation — Schema before the body is used

```typescript
export class CancelParams {
  @IsUUID()
  id!: string;
}
```

Register `ValidationPipe` once, in `main.ts` or on the route. A Zod schema passed through a pipe is the same rule: the check runs before the handler body.

The service receives `id` and `userId` and applies the domain rule. It does not ask whether `id` is a string.

## di — Constructor, module factory for process-wide objects

```typescript
@Module({
  controllers: [OrdersController],
  providers: [OrdersService],
  exports: [OrdersService],
})
export class OrdersModule {}
```

```typescript
@Injectable()
export class OrdersService {
  constructor(private readonly repo: OrdersRepository) {}
}
```

```typescript
{
  provide: PrismaClient,
  useFactory: () => new PrismaClient(),
}
```

Another feature imports `OrdersModule`. It does not list `OrdersService` in its own `providers`.

## exceptions — Map at the filter

```typescript
export class InsufficientFunds extends Error {}
```

```typescript
@Catch(InsufficientFunds)
export class InsufficientFundsFilter implements ExceptionFilter {
  catch(_error: InsufficientFunds, host: ArgumentsHost) {
    host.switchToHttp().getResponse().status(422).json({ error: "insufficient_funds" });
  }
}
```

The service throws `InsufficientFunds`. It does not import `HttpException`.
