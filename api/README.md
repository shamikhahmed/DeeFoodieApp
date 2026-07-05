# DeeFoodieApp API

NestJS + Prisma + PostGIS REST API for the Karachi Food Archive.

## Setup

```bash
pnpm install
cp .env.example .env   # DATABASE_URL → localhost:5435
pnpm run migrate:dev
pnpm run seed
pnpm run start:dev     # http://localhost:3000
```

`GET /health` — liveness check.

## Auth (dev)

`CurrentUserMiddleware` reads `X-User-Id` header; defaults to first seeded user. Clerk deferred.

## Storage

`STORAGE_DRIVER=local` (default, Docker volume) or `s3` (AWS SDK).

See `.env.example` for `AWS_*` vars when using S3.

## Scripts

| Command | Purpose |
|---------|---------|
| `pnpm run seed` | Taxonomy, users, eateries, demo visits, export mobile archive |
| `pnpm run start:dev` | Watch mode |
| `pnpm run build` | Production compile |

## PostGIS notes

`geo` / `boundary` are Prisma `Unsupported(...)` types — set via `$executeRawUnsafe` after create (see `prisma/seed.ts`).

## Mobile offline bundle

Seed / `api/prisma/scripts/build-mobile-archive.mjs` writes `mobile/assets/demo/archive.json`.

---

Default NestJS boilerplate below (upstream template).

<p align="center">
  <a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo-small.svg" width="120" alt="Nest Logo" /></a>
</p>

## Project setup

```bash
$ pnpm install
```

## Compile and run the project

```bash
# development
$ pnpm run start

# watch mode
$ pnpm run start:dev

# production mode
$ pnpm run start:prod
```

## Run tests

```bash
# unit tests
$ pnpm run test

# e2e tests
$ pnpm run test:e2e

# test coverage
$ pnpm run test:cov
```

## License

Nest is [MIT licensed](https://github.com/nestjs/nest/blob/master/LICENSE).
