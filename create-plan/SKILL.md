---
name: create-plan
description: Creates a structured implementation plan with task breakdown, dependencies, and progress tracking. Use when planning a feature, refactor, migration, or any multi-step engineering task.
disable-model-invocation: false
argument-hint: "[plan-name or description]"
---

# Create Implementation Plan

Generate a structured plan for: `$ARGUMENTS`

Plans are stored in `.claude/skills/create-plan/resources/`.

## Directory Structure

- `resources/` — plan files with tracked statuses
- `scripts/` — reusable scripts for plan operations

## Steps

1. **Understand the scope**: Analyze the request and explore the codebase to understand what's involved. Use Grep, Glob, and Read to find relevant files.

2. **Initialize directories**: `mkdir -p .claude/skills/create-plan/resources .claude/skills/create-plan/scripts`

3. **Check existing plans**: List files in `.claude/skills/create-plan/resources/` to see all existing plans and their statuses. Avoid duplicate plans for the same objective.

4. **Generate the plan file** at `.claude/skills/create-plan/resources/<plan-name>.md` using a slug derived from the plan title (e.g., `add-user-auth.md`):

```markdown
# Plan: <Title>

Created: <date>
Status: pending

## Objective
<1-2 sentence summary of what this plan achieves>

## Context
<Brief analysis of the current state and why this change is needed>

## Tasks

- [ ] Task 1: <description>
  - Files: `path/to/file.ts`
  - Details: <what needs to change and why>

- [ ] Task 2: <description>
  - Files: `path/to/file.ts`
  - Depends on: Task 1
  - Details: <what needs to change and why>

## Risks & Considerations
- <potential issues, edge cases, breaking changes>

## Validation
- [ ] <how to verify the plan succeeded>
```

5. **Research before planning**:
   - Identify all files that will be modified
   - Check for existing tests that may need updating
   - Look for patterns in the codebase to follow
   - Note any dependencies between tasks

6. **Task breakdown guidelines**:
   - Each task should be independently completable
   - Mark dependencies explicitly ("Depends on: Task N")
   - Include specific file paths that will be touched
   - Order tasks so dependencies come first
   - Keep tasks small enough to verify individually

7. **Present the plan** to the user for review before finalizing.

## Plan Statuses

- `pending` — created, awaiting approval or execution
- `in-progress` — actively being worked on
- `done` — all tasks completed and validated

Update the `Status:` field in the plan file whenever its status changes.

## Script Management

When performing an operation that can be scripted (e.g., listing plans with statuses, validating plan structure):
1. Check `scripts/` for an existing script that handles this operation
2. If a script exists, execute it instead of doing the work inline
3. If no script exists and the operation is reusable, create one in `scripts/`, make it executable, then execute it
4. Reference any new scripts below under "Available Scripts"
5. Update this SKILL.md to call the script in the relevant step

## Available Scripts

_No scripts yet. Scripts will be added here as they are created._
