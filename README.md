# Claude Code Skills Collection

A curated collection of reusable skills for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Each skill is a self-contained automation module that can be installed into any project to extend Claude Code's capabilities.

## Available Skills

### Project Scaffolding

| Skill | Description |
|-------|-------------|
| **create-next-app** | Scaffold a Next.js app with App Router, TypeScript, Tailwind CSS, and ESLint |
| **create-vue-app** | Scaffold a Vue 3 app with Vite, TypeScript, Vue Router, Pinia, and ESLint |
| **create-express-app** | Scaffold an Express.js REST API with TypeScript, routing, middleware, and error handling |
| **create-electron-app** | Scaffold an Electron desktop app with TypeScript and React/Vue/Vanilla renderer |
| **create-flutter-app** | Scaffold a Flutter app for iOS/Android/web with Riverpod, go_router, and a feature-first layout |
| **create-fastapi-app** | Scaffold a FastAPI service with uv, SQLAlchemy, Alembic migrations, pytest, and ruff |
| **create-project-with-skills** | Create a new project pre-populated with skills from this repository |

### Development Workflow

| Skill | Description |
|-------|-------------|
| **create-plan** | Create a structured implementation plan with task breakdown and dependencies |
| **execute-plan** | Execute an existing plan step-by-step with progress tracking and validation |
| **create-pr** | Commit changes, update CHANGELOG.md, and create a GitHub pull request |
| **review-pr** | Review a PR as a senior developer, with optional GitHub comments and auto-fix |
| **update-changelog** | Analyze git history and update CHANGELOG.md in Keep a Changelog format |
| **create-readme** | Generate a README.md by analyzing project code and configuration |
| **initialize-git** | Initialize a git repo with .gitignore and optional GitHub remote creation |

### Code Quality

| Skill | Description |
|-------|-------------|
| **refactor-code** | Analyze code for refactoring opportunities and apply targeted improvements |
| **check-for-security-issues** | Scan changed files for security vulnerabilities, secrets, and insecure patterns |

### Infrastructure

| Skill | Description |
|-------|-------------|
| **dockerize-project** | Detect the stack and generate a multi-stage Dockerfile, .dockerignore, and docker-compose.yml |

### Skills Management

| Skill | Description |
|-------|-------------|
| **setup-skills** | Install this skills collection into a project's `.claude/skills/` directory |
| **update-skills** | Pull the latest skills from the main branch into a project's `.claude/skills/` |
| **add-skill-to-repo** | Create a new versioned, shareable skill at the repository root level |
| **create-skill** | Scaffold a new Claude Code skill with SKILL.md and supporting files |

### Agent & Research

| Skill | Description |
|-------|-------------|
| **create-agent** | Create a custom Claude Code sub-agent with configuration and system prompt |
| **research** | Execute structured research on a topic and accumulate findings into a report |

## Getting Started

### Install skills into an existing project

Copy the skills you need into your project's `.claude/skills/` directory:

```bash
# Clone this repository
git clone git@github.com:r2rka1/skills.git

# Copy a specific skill into your project
cp -r skills/create-plan /path/to/your-project/.claude/skills/
```

Or use the **setup-skills** skill to automate the installation.

### Use a skill

Once installed, invoke a skill in Claude Code using its slash command:

```
/create-plan
/create-pr
/research
```

## Skill Structure

Each skill follows a standard layout:

```
skill-name/
├── SKILL.md       # Skill definition and instructions
├── resources/     # Persistent output and data files
└── scripts/       # Reusable scripts for the skill's operations
```

The `SKILL.md` file defines the skill's behavior, workflow steps, and quality rules that Claude Code follows when the skill is invoked.

## Contributing

To add a new skill:

1. Create a directory at the repository root with your skill name
2. Add a `SKILL.md` following the existing skills as templates
3. Document the `resources/` and `scripts/` layout in the SKILL.md body. Git does
   not track empty directories, so create them at runtime with `mkdir -p` rather
   than trying to commit them; commit them only once they contain a real file
4. Run the checks below, then submit a pull request

### Before submitting

- Every path in a `SKILL.md` must be relative or resolved at runtime. Never hardcode
  an absolute path such as `/home/<user>/...` — it breaks on every other machine
- Skills with outward-facing side effects (pushing branches, opening PRs, creating
  directories) should set `disable-model-invocation: true` so they only run when
  explicitly asked for
- Never `rm -rf` a skill directory that may contain user data under `resources/`

## License

This project is unlicensed. See individual skill files for details.
