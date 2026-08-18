---
name: dockerize-project
description: Analyzes a project's language, framework, and dependencies, then generates a production-ready multi-stage Dockerfile, .dockerignore, and docker-compose.yml with any backing services it needs. Use when the user wants to containerize, dockerize, or add Docker support to a project.
disable-model-invocation: true
argument-hint: "[project path]"
---

# Dockerize Project

Inspects the project, then generates a multi-stage `Dockerfile`, a `.dockerignore`, and a `docker-compose.yml` wired to whatever databases or caches the project actually uses.

## Usage

```
/dockerize-project
/dockerize-project ./services/api
```

Defaults to the current working directory.

## Workflow

### 1. Detect the Stack

Identify the language and framework from manifest files:

| Marker | Stack | Base image |
|--------|-------|-----------|
| `package.json` | Node / TypeScript | `node:22-alpine` |
| `next.config.*` | Next.js | `node:22-alpine` (standalone output) |
| `requirements.txt`, `pyproject.toml` | Python | `python:3.13-slim` |
| `go.mod` | Go | `golang:1.23-alpine` → `gcr.io/distroless/static` |
| `Cargo.toml` | Rust | `rust:1-slim` → `debian:bookworm-slim` |
| `composer.json` | PHP | `php:8.4-fpm-alpine` |
| `pubspec.yaml` | Dart / Flutter web | `dart:stable` → `nginx:alpine` |

- [ ] Read the manifest to get the exact runtime version the project pins, and prefer it over the table's default
- [ ] Identify the package manager from the lockfile (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `uv.lock`, `poetry.lock`)
- [ ] Find the start command (`scripts.start`, `__main__`, `cmd/`, a `Procfile`)
- [ ] Detect the listening port from source or config; ask if it cannot be determined

### 2. Detect Backing Services

Grep the codebase and any `.env.example` for connection strings to decide what
belongs in compose:

| Signal | Service |
|--------|---------|
| `postgres://`, `pg`, `psycopg`, `sqlx` | PostgreSQL |
| `mysql://`, `mysql2` | MySQL |
| `redis://`, `ioredis` | Redis |
| `mongodb://`, `mongoose` | MongoDB |
| `amqp://` | RabbitMQ |

Only add a service the project actually references. Ask before adding anything speculative.

### 3. Write the Dockerfile

Always multi-stage. The runtime stage must contain no build toolchain.

Requirements for every generated Dockerfile:

- [ ] Copy lockfile and manifest first, install dependencies, **then** copy source — so dependency layers cache across source edits
- [ ] Install production dependencies only in the runtime stage
- [ ] Run as a non-root user
- [ ] Pin the base image by minor version, never bare `:latest`
- [ ] Include a `HEALTHCHECK` when the service exposes an HTTP endpoint
- [ ] Set `NODE_ENV=production` / `PYTHONUNBUFFERED=1` / equivalent

Node example shape:

```dockerfile
FROM node:22-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

FROM node:22-alpine AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:22-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production
RUN addgroup -S app && adduser -S app -G app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force
COPY --from=build /app/dist ./dist
USER app
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD wget -qO- http://localhost:3000/health || exit 1
CMD ["node", "dist/main.js"]
```

### 4. Write .dockerignore

Must exclude at minimum — an unignored `.git` or `node_modules` bloats the build
context and can leak secrets into the image:

```
.git
.gitignore
node_modules
__pycache__
*.pyc
.venv
venv
target
dist
build
.next
coverage
.env
.env.*
!.env.example
*.log
.DS_Store
.claude
README.md
Dockerfile
docker-compose*.yml
```

### 5. Write docker-compose.yml

```yaml
services:
  app:
    build:
      context: .
      target: runtime
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgres://app:app@db:5432/app
    depends_on:
      db:
        condition: service_healthy
    restart: unless-stopped

  db:
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: app
      POSTGRES_PASSWORD: app
      POSTGRES_DB: app
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U app"]
      interval: 5s
      retries: 5
    restart: unless-stopped

volumes:
  pgdata:
```

- [ ] Use named volumes for database data so it survives `docker compose down`
- [ ] Gate `depends_on` on `service_healthy`, not merely `service_started`
- [ ] Never hardcode production credentials — reference `${VAR}` and document them in `.env.example`

### 6. Verify

- [ ] `docker build -t <name> .` succeeds
- [ ] Report the final image size: `docker images <name> --format '{{.Size}}'`
- [ ] `docker compose config` parses without error
- [ ] If the user agrees, `docker compose up -d` and confirm containers reach healthy

### 7. Report

Show the user the files created, the image size, and the commands to run it:

```bash
docker compose up -d          # start
docker compose logs -f app    # follow logs
docker compose down           # stop
docker compose down -v        # stop and delete volumes (destroys data)
```

## Notes

- Do not overwrite an existing `Dockerfile` or `docker-compose.yml` without showing the user a diff and getting confirmation.
- On Apple Silicon, images build for `linux/arm64` by default. If the deployment target is x86, add `--platform linux/amd64` and warn that emulated builds are slow.
- OrbStack and Docker Desktop both provide the `docker` CLI but cannot own the socket simultaneously. If `docker` commands fail to connect, check which one is running.

## Directory Structure

- `resources/` — persistent output and data files generated by this skill
- `scripts/` — reusable scripts for this skill's operations

## Script Management

When performing an operation that can be scripted:
1. Check `scripts/` for an existing script that handles this operation
2. If a script exists, execute it instead of doing the work inline
3. If no script exists and the operation is reusable, create one in `scripts/`, make it executable, then execute it
4. Reference any new scripts in this SKILL.md under "Available Scripts"

## Available Scripts

_No scripts yet. Scripts will be added here as they are created._
