---
name: create-agent
description: Creates a new Claude Code sub-agent (custom agent) by generating a markdown file in the .claude/agents/ directory. Triggered when the user wants to create, scaffold, or add a new agent or sub-agent.
argument-hint: "<agent-name> [--model <model>] <description of what the agent should do>"
---

## Usage

```
/create-agent my-agent --model sonnet Review code for security vulnerabilities
/create-agent test-runner Run tests and report failures
/create-agent db-reader --model haiku Execute read-only database queries
```

### Arguments

- **First argument** (required): Agent name — lowercase letters, numbers, and hyphens only
- **`--model`** (optional): Model to use — `sonnet`, `opus`, `haiku`, or `inherit` (default: `inherit`)
- **Remaining text** (required): Description of what the agent should do. Claude uses this to generate the full agent configuration.

## Workflow

### 1. Parse Arguments

Extract from the arguments:
- `agent_name`: first token (validate: lowercase, hyphens, numbers only, no leading/trailing hyphens)
- `model`: value after `--model` flag if present, otherwise `inherit`
- `purpose`: all remaining text after name and optional model flag

If the agent name or purpose is missing, ask the user.

### 2. Choose Scope

Ask the user where to save the agent:

| Scope   | Location                 | When to use                          |
|---------|--------------------------|--------------------------------------|
| Project | `.claude/agents/`        | Agent is specific to current project |
| User    | `~/.claude/agents/`      | Agent should work across all projects|

Default to **Project** scope unless the user specifies otherwise.

### 3. Determine Tools

Based on the agent's purpose, select appropriate tools from:

| Tool         | Purpose                          |
|--------------|----------------------------------|
| `Read`       | Read files                       |
| `Edit`       | Modify existing files            |
| `Write`      | Create new files                 |
| `Glob`       | Find files by pattern            |
| `Grep`       | Search file contents             |
| `Bash`       | Run shell commands               |
| `WebFetch`   | Fetch web content                |
| `WebSearch`  | Search the web                   |

**Guidelines:**
- Read-only agents (reviewers, analyzers): `Read, Grep, Glob, Bash`
- Agents that modify code: `Read, Edit, Write, Bash, Grep, Glob`
- Research agents: `Read, Grep, Glob, WebFetch, WebSearch`
- If unclear, ask the user

### 4. Ask About Optional Features

Ask the user if they want any of these (briefly explain each):

- **Permission mode**: `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, or `plan`
- **Persistent memory**: `user`, `project`, or `local` scope — lets the agent learn across sessions
- **Background mode**: always run as a background task
- **Max turns**: limit on agentic turns
- **Skills to preload**: inject skill content at startup
- **Hooks**: PreToolUse/PostToolUse validation scripts

Default to skipping all optional features unless the user requests them.

### 5. Generate the Agent File

Create a markdown file with YAML frontmatter and a system prompt body.

**File location:**
- Project scope: `.claude/agents/<agent-name>.md`
- User scope: `~/.claude/agents/<agent-name>.md`

**Template structure:**

```markdown
---
name: <agent-name>
description: <clear description of when Claude should delegate to this agent>
tools: <comma-separated tool list>
model: <model>
# Optional fields only if requested:
# permissionMode: default
# memory: user
# background: false
# maxTurns: 50
# skills:
#   - skill-name
---

<System prompt: detailed instructions for what the agent does,
how it should work, what workflow to follow, and how to format output.
Generated based on the user's description.>
```

**System prompt guidelines:**
- Start with a role statement: "You are a..."
- Include a clear "When invoked:" numbered workflow
- Add specific checklists or criteria relevant to the purpose
- Specify output format expectations
- Keep it focused — one agent, one job
- Be concrete, not abstract

### 6. Show the Result

Display the full generated file to the user and confirm:
- File path where it was saved
- How to use it: `Use the <agent-name> agent to ...` or Claude will auto-delegate based on description
- Remind: agents are loaded at session start; use `/agents` to load immediately or restart the session

## Examples

### Read-only code reviewer
```markdown
---
name: code-reviewer
description: Expert code review specialist. Proactively reviews code for quality, security, and maintainability.
tools: Read, Grep, Glob, Bash
model: sonnet
---

You are a senior code reviewer ensuring high standards of code quality.

When invoked:
1. Run git diff to see recent changes
2. Focus on modified files
3. Begin review immediately

Review checklist:
- Code clarity and readability
- Proper error handling
- No exposed secrets
- Input validation
- Test coverage

Provide feedback by priority: Critical > Warnings > Suggestions.
```

### Test runner
```markdown
---
name: test-runner
description: Runs tests, analyzes failures, and suggests fixes. Use after writing or modifying code.
tools: Read, Edit, Bash, Grep, Glob
model: inherit
---

You are a testing specialist.

When invoked:
1. Identify the test framework in use
2. Run the full test suite or specified tests
3. Analyze any failures
4. Suggest or implement fixes

For each failure provide:
- Test name and location
- Error message and stack trace
- Root cause analysis
- Suggested fix
```

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
