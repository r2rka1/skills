---
name: execute-plan
description: Executes an existing implementation plan step-by-step with progress tracking, validation after each task, and automatic plan file updates. Use when ready to implement an approved plan.
disable-model-invocation: false
argument-hint: "[plan-file-name]"
---

# Execute Implementation Plan

Execute the plan from `.claude/skills/create-plan/resources/$ARGUMENTS`

## Directory Structure

- `resources/` — execution logs and reports
- `scripts/` — reusable scripts for plan execution and validation

## Steps

1. **Load the plan**: Read `.claude/skills/create-plan/resources/$ARGUMENTS`. If the file doesn't exist, list available plans in `.claude/skills/create-plan/resources/` and ask the user which one to execute.

2. **Check plan status**: Only execute plans with status `pending` or `in-progress`. If status is `done`, inform the user it's already completed.

3. **Update status** to `in-progress` in the plan file.

4. **Execute each unchecked task** in order:

   For each task:
   a. Announce which task you're starting
   b. Check if dependencies are completed (all "Depends on" tasks must be checked off)
   c. Implement the changes described in the task
   d. Validate the changes (run tests, lint, type-check as appropriate)
   e. Mark the task as done in the plan file: `- [ ]` → `- [x]`
   f. Report the result before moving to the next task

5. **If a task fails**:
   - Stop execution
   - Report what failed and why
   - Suggest a fix or ask the user for guidance
   - Do NOT proceed to dependent tasks

6. **After all tasks complete**:
   - Run the validation checklist from the plan
   - Update plan status to `done`
   - Summarize what was accomplished

## Progress Tracking

Update the plan file in real-time as tasks complete. The plan file serves as the single source of truth for progress:

```markdown
- [x] Task 1: Completed task description
- [x] Task 2: Another completed task
- [ ] Task 3: Next task to do  ← current
- [ ] Task 4: Future task
```

## Validation Rules

- Always run existing tests after code changes
- If the project has a linter, run it after changes
- If the project uses TypeScript, ensure type-checking passes
- Check that no existing functionality is broken

## Script Management

When performing an operation that can be scripted (e.g., listing available plans, checking task dependencies, running validation suites):
1. Check `scripts/` for an existing script that handles this operation
2. If a script exists, execute it instead of doing the work inline
3. If no script exists and the operation is reusable, create one in `scripts/`, make it executable, then execute it
4. Reference any new scripts below under "Available Scripts"
5. Update this SKILL.md to call the script in the relevant step

## Available Scripts

_No scripts yet. Scripts will be added here as they are created._
