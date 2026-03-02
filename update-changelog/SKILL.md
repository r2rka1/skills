---
name: update-changelog
description: Analyzes recent git changes and updates CHANGELOG.md following the Keep a Changelog format. Use after completing a feature, fix, or any notable change to the project.
disable-model-invocation: false
argument-hint: "[version or description]"
---

# Update Changelog

Analyze recent changes and update CHANGELOG.md.

## Directory Structure

- `resources/` — changelog drafts and version history snapshots
- `scripts/` — reusable scripts for changelog operations

## Steps

1. **Gather changes**: Run `git log --oneline` and `git diff` to understand what changed since the last changelog entry. If `$ARGUMENTS` is provided, use it as context for the version or change description.

2. **Create CHANGELOG.md** if it doesn't exist, using this template:

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]
```

3. **Read existing CHANGELOG.md** to understand the current format and last version.

4. **Categorize changes** into these sections (only include sections with actual changes):

   - **Added** — new features
   - **Changed** — changes to existing functionality
   - **Deprecated** — features that will be removed
   - **Removed** — removed features
   - **Fixed** — bug fixes
   - **Security** — vulnerability fixes

5. **Write changelog entries**:
   - Each entry is a single bullet point
   - Start with a verb (Add, Change, Fix, Remove, etc.)
   - Be specific: reference what changed, not commit messages
   - Group related changes into a single entry
   - Order by importance within each section

6. **Add entries under `[Unreleased]`** unless the user specifies a version number. If a version is provided, create a new version section:

```markdown
## [1.2.0] - 2025-01-15

### Added
- Add user authentication with JWT tokens
```

7. **Show the updated changelog** to the user for review.

## Entry Style Guide

Good entries:
- "Add dark mode toggle to settings page"
- "Fix crash when uploading files larger than 10MB"
- "Change API response format to include pagination metadata"

Bad entries:
- "Update code" (too vague)
- "Fix bug" (no context)
- "Misc changes" (not informative)

## Script Management

When performing an operation that can be scripted (e.g., extracting git log since last tag, formatting changelog entries, detecting version bumps):
1. Check `scripts/` for an existing script that handles this operation
2. If a script exists, execute it instead of doing the work inline
3. If no script exists and the operation is reusable, create one in `scripts/`, make it executable, then execute it
4. Reference any new scripts below under "Available Scripts"
5. Update this SKILL.md to call the script in the relevant step

## Available Scripts

_No scripts yet. Scripts will be added here as they are created._
