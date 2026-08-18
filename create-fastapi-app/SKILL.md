---
name: create-fastapi-app
description: Scaffolds a new FastAPI backend with uv or venv dependency management, SQLAlchemy models, Alembic migrations, Pydantic settings, pytest, and ruff. Guides through database selection and project layout. Use when the user wants to create, start, or scaffold a new Python API, FastAPI service, or Python backend.
disable-model-invocation: true
argument-hint: "<project-name>"
---

# Create FastAPI App

Scaffolds a new FastAPI service with a layered structure, typed settings, database migrations, and a working test suite.

## Usage

```
/create-fastapi-app my-api
```

## Workflow

### 1. Preflight

- [ ] Confirm Python 3.11+ is available: `python3 --version`
- [ ] Prefer `uv` if installed (`uv --version`) — it resolves and installs far faster than pip. Fall back to `python -m venv` + pip otherwise.
- [ ] Confirm the target directory does not already exist

### 2. Ask the User

| Question | Options | Default |
|----------|---------|---------|
| Database | PostgreSQL, SQLite, none | PostgreSQL |
| Async or sync | async (asyncpg), sync (psycopg) | async |
| Include Docker | yes, no | yes |

### 3. Create the Project

With `uv`:

```bash
uv init --package <project-name>
cd <project-name>
uv add fastapi "uvicorn[standard]" pydantic-settings
uv add sqlalchemy alembic asyncpg        # if PostgreSQL + async
uv add --dev pytest pytest-asyncio httpx ruff mypy
```

Without `uv`:

```bash
mkdir <project-name> && cd <project-name>
python3 -m venv .venv
source .venv/bin/activate
pip install fastapi "uvicorn[standard]" pydantic-settings sqlalchemy alembic asyncpg
pip install pytest pytest-asyncio httpx ruff mypy
pip freeze > requirements.txt
```

### 4. Establish Directory Structure

```
<project-name>/
├── app/
│   ├── __init__.py
│   ├── main.py               # FastAPI instance, router registration, lifespan
│   ├── config.py             # Pydantic BaseSettings, env-driven
│   ├── database.py           # engine, session factory, get_db dependency
│   ├── api/
│   │   ├── __init__.py
│   │   ├── deps.py           # shared route dependencies
│   │   └── routes/
│   │       ├── __init__.py
│   │       └── health.py
│   ├── models/               # SQLAlchemy ORM models
│   ├── schemas/              # Pydantic request/response models
│   └── services/             # business logic, kept out of route handlers
├── alembic/
├── tests/
│   ├── conftest.py
│   └── test_health.py
├── .env.example
├── alembic.ini
├── pyproject.toml
└── README.md
```

Keep business logic in `services/`. Route handlers should parse input, call a
service, and shape the response — nothing more.

### 5. Core Files

`app/config.py` — settings must come from the environment, never hardcoded:

```python
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    app_name: str = "my-api"
    debug: bool = False
    database_url: str
    cors_origins: list[str] = []


settings = Settings()  # type: ignore[call-arg]
```

`app/main.py`:

```python
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.routes import health
from app.config import settings


@asynccontextmanager
async def lifespan(app: FastAPI):
    yield


app = FastAPI(title=settings.app_name, lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(health.router, prefix="/api")
```

Write a matching `.env.example` listing every setting with placeholder values,
and ensure `.env` itself is gitignored.

### 6. Configure Tooling

In `pyproject.toml`:

```toml
[tool.ruff]
line-length = 100
target-version = "py313"

[tool.ruff.lint]
select = ["E", "F", "I", "N", "UP", "B", "SIM"]

[tool.pytest.ini_options]
asyncio_mode = "auto"
testpaths = ["tests"]

[tool.mypy]
strict = true
ignore_missing_imports = true
```

### 7. Initialize Migrations

If a database was selected:

```bash
alembic init -t async alembic     # async; omit -t async for sync
```

Point `alembic/env.py` at `settings.database_url` and the models' `Base.metadata`
rather than leaving the URL in `alembic.ini`, so credentials stay in the environment.

### 8. Verify

- [ ] `ruff check .` passes
- [ ] `pytest` passes with the health-endpoint test
- [ ] The server boots: `uvicorn app.main:app --reload`
- [ ] `GET /docs` renders the OpenAPI UI

### 9. Report

Show the user the structure, then how to run it:

```bash
uv run uvicorn app.main:app --reload    # or: uvicorn app.main:app --reload
uv run pytest
uv run ruff check --fix .
alembic revision --autogenerate -m "message"
alembic upgrade head
```

## Notes

- Do not commit `.env`. Commit `.env.example` instead.
- `pytest-asyncio` with `asyncio_mode = "auto"` avoids decorating every async test.
- If the user also wants a container, invoke `/dockerize-project` rather than duplicating Dockerfile logic here.

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
