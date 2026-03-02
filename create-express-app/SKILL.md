---
name: create-express-app
description: Scaffolds a new Express.js REST API application with TypeScript, structured routing, middleware, and error handling. Guides through project creation, configuration, and initial setup. Use when the user wants to create, start, or scaffold a new Express server, API, or backend project.
disable-model-invocation: true
argument-hint: "[project-name]"
---

# Create Express App

Scaffolds a new Express.js application with sensible defaults and walks the user through initial configuration.

## Usage

```
/create-express-app my-api
```

If no project name is provided, ask the user for one.

## Workflow

### 1. Validate Input

- [ ] Ensure a project name was provided. If not, ask the user.
- [ ] Confirm the target directory (`~/projects/<project-name>`) does not already exist.

### 2. Ask Preferences

Ask the user which options they want (defaults shown):

| Option | Default | Choices |
|--------|---------|---------|
| TypeScript | Yes | Yes, No |
| Package manager | npm | npm, yarn, pnpm |
| Database | None | None, PostgreSQL (Prisma), MongoDB (Mongoose) |
| Authentication | None | None, JWT |
| Docker | No | Yes, No |

### 3. Create the Project

Since there is no official `create-express-app` CLI, scaffold manually:

```bash
mkdir -p ~/projects/<project-name>
cd ~/projects/<project-name>
npm init -y
```

Install core dependencies:

```bash
npm install express cors helmet dotenv
npm install --save-dev typescript ts-node @types/node @types/express @types/cors nodemon
```

### 4. Generate Project Structure

Create the following file structure:

```
<project-name>/
├── src/
│   ├── app.ts
│   ├── server.ts
│   ├── routes/
│   │   └── index.ts
│   ├── controllers/
│   │   └── health.controller.ts
│   ├── middleware/
│   │   └── error-handler.ts
│   └── config/
│       └── env.ts
├── .env
├── .env.example
├── .gitignore
├── tsconfig.json
├── nodemon.json
└── package.json
```

**src/app.ts** — Express app setup (middleware, routes):

```typescript
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import { router } from './routes';
import { errorHandler } from './middleware/error-handler';

const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());

app.use('/api', router);
app.use(errorHandler);

export { app };
```

**src/server.ts** — Entry point (starts listening):

```typescript
import { app } from './app';
import { env } from './config/env';

app.listen(env.PORT, () => {
  console.log(`Server running on port ${env.PORT}`);
});
```

**src/config/env.ts** — Environment variable loader:

```typescript
import dotenv from 'dotenv';
dotenv.config();

export const env = {
  PORT: parseInt(process.env.PORT || '3000', 10),
  NODE_ENV: process.env.NODE_ENV || 'development',
};
```

**src/routes/index.ts** — Route aggregator:

```typescript
import { Router } from 'express';
import { healthCheck } from '../controllers/health.controller';

const router = Router();

router.get('/health', healthCheck);

export { router };
```

**src/controllers/health.controller.ts** — Sample controller:

```typescript
import { Request, Response } from 'express';

export const healthCheck = (_req: Request, res: Response) => {
  res.json({ status: 'ok' });
};
```

**src/middleware/error-handler.ts** — Global error handler:

```typescript
import { Request, Response, NextFunction } from 'express';

export const errorHandler = (
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction
) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Internal Server Error' });
};
```

**tsconfig.json:**

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

**nodemon.json:**

```json
{
  "watch": ["src"],
  "ext": "ts",
  "exec": "ts-node src/server.ts"
}
```

Update **package.json** scripts:

```json
{
  "scripts": {
    "dev": "nodemon",
    "build": "tsc",
    "start": "node dist/server.js",
    "lint": "eslint src/"
  }
}
```

**.gitignore:**

```
node_modules/
dist/
.env
```

**.env.example:**

```
PORT=3000
NODE_ENV=development
```

### 5. Optional: Add Database (if selected)

**PostgreSQL (Prisma):**

```bash
npm install @prisma/client
npm install --save-dev prisma
npx prisma init
```

**MongoDB (Mongoose):**

```bash
npm install mongoose
npm install --save-dev @types/mongoose
```

Create `src/config/database.ts` with the appropriate connection setup.

### 6. Optional: Add JWT Authentication (if selected)

```bash
npm install jsonwebtoken bcryptjs
npm install --save-dev @types/jsonwebtoken @types/bcryptjs
```

Create `src/middleware/auth.ts` with JWT verification middleware.

### 7. Optional: Add Docker (if selected)

Create a `Dockerfile` and `docker-compose.yml` with Node.js and any selected database service.

### 8. Verify Setup

After creation, verify:

- [ ] `package.json` exists with `express` dependency
- [ ] `tsconfig.json` exists
- [ ] `src/app.ts` and `src/server.ts` exist
- [ ] Dev server starts without errors: `npm run dev` (start and quickly stop)
- [ ] Health endpoint responds: `curl http://localhost:3000/api/health`

### 9. Post-Setup Summary

Report to the user:

- Project location: `~/projects/<project-name>`
- Available commands:
  - `npm run dev` — start development server with hot reload (http://localhost:3000)
  - `npm run build` — compile TypeScript to `dist/`
  - `npm start` — start production server from compiled output
  - `npm run lint` — run linter
- Key directories:
  - `src/routes/` — route definitions
  - `src/controllers/` — request handlers
  - `src/middleware/` — Express middleware
  - `src/config/` — configuration and environment
- API endpoint: `GET /api/health` — health check

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
