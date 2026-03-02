---
name: create-pr
description: Commits staged and unstaged changes with a descriptive message, updates CHANGELOG.md, updates README.md if needed, and creates a GitHub pull request. Use after completing a feature, fix, or any set of changes ready for review.
argument-hint: "[PR title or description]"
---

# Create PR

Commit current changes, update changelog and README, then open a GitHub pull request.

## Directory Structure

- `resources/` — PR drafts and templates
- `scripts/` — reusable scripts for PR operations

## Steps

### 1. Analyze Current Changes

- [ ] Run `git status` to see all modified, staged, and untracked files
- [ ] Run `git diff` and `git diff --cached` to understand what changed
- [ ] Run `git log --oneline -10` to understand recent commit history and message style
- [ ] Identify the current branch name and the base branch (usually `main`)

If there are no changes to commit, inform the user and stop.

### 2. Determine a Descriptive Commit Message

- Analyze the diff to understand the nature of changes (feature, fix, refactor, docs, etc.)
- Draft a concise commit message: imperative mood, 1-2 sentences, focused on "why" not "what"
- If `$ARGUMENTS` is provided, use it as context for the commit/PR description
- Do NOT commit files that look like secrets (`.env`, credentials, tokens)

### 3. Update CHANGELOG.md

Before committing, update the changelog with the current changes:

- Read existing `CHANGELOG.md`
- Add entries under `[Unreleased]` using Keep a Changelog format
- Categorize into: Added, Changed, Deprecated, Removed, Fixed, Security
- Each entry: single bullet, starts with a verb, specific and descriptive

If `CHANGELOG.md` does not exist, create it:

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]
```

### 4. Update README.md (If Needed)

Check if the changes warrant a README update:

- New features that users need to know about
- New dependencies or setup steps
- Changed commands or configuration
- New project structure

Only update README if the changes are user-facing and significant. Do NOT update for internal refactors, bug fixes, or minor changes.

### 5. Commit Changes

- [ ] Stage all relevant files: `git add <specific-files>` (prefer specific files over `git add -A`)
- [ ] Include the updated CHANGELOG.md and README.md (if changed) in the commit
- [ ] Commit with the drafted message using a HEREDOC:

```bash
git commit -m "$(cat <<'EOF'
<commit message>

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

### 6. Create a Branch (If on Main)

If currently on `main`, create a feature branch before pushing:

```bash
git checkout -b <branch-name>
```

Branch naming: `feature/<short-description>`, `fix/<short-description>`, or `chore/<short-description>`.

If already on a non-main branch, stay on it.

### 7. Push and Create PR

- [ ] Push the branch: `git push -u origin <branch-name>`
- [ ] Create the PR using `gh pr create`:

```bash
gh pr create --title "<PR title>" --body "$(cat <<'EOF'
## Summary
<1-3 bullet points describing what changed and why>

## Changes
<list of specific changes>

## Test Plan
- [ ] <testing steps>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

- Keep the PR title under 70 characters
- The body should summarize the "why", list specific changes, and include a test plan

### 8. Report Results

Display to the user:
- Commit hash and message
- PR URL
- Branch name
- Files changed summary

## Script Management

When performing an operation that can be scripted:
1. Check `scripts/` for an existing script that handles this operation
2. If a script exists, execute it instead of doing the work inline
3. If no script exists and the operation is reusable, create one in `scripts/`, make it executable, then execute it
4. Reference any new scripts in this SKILL.md under "Available Scripts"

## Available Scripts

_No scripts yet. Scripts will be added here as they are created._
