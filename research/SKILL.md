---
name: research
description: Executes research on a topic and accumulates findings into a structured research file. Use when investigating technologies, APIs, libraries, architecture patterns, or any topic requiring deep exploration.
disable-model-invocation: false
argument-hint: "[topic or question]"
---

# Research

Research the topic: `$ARGUMENTS`

Findings are stored in `.claude/skills/research/resources/`.

## Directory Structure

- `resources/` — research files with accumulated findings
- `scripts/` — reusable scripts for research operations

## Steps

1. **Initialize directories**: `mkdir -p .claude/skills/research/resources .claude/skills/research/scripts`

2. **Check existing research**: List files in `.claude/skills/research/resources/` to see if this topic has been researched before. If a relevant file exists, read it and build on previous findings rather than starting fresh.

3. **Create or update the research file** at `.claude/skills/research/resources/<topic-slug>.md` using this template for new files:

```markdown
# Research: <Topic>

Created: <date>
Last updated: <date>
Status: in-progress

## Summary
<2-3 sentence overview of key findings — update as research progresses>

## Findings

### <Finding 1 Title>
- **Source**: <URL, file path, or documentation reference>
- **Details**: <what was discovered>
- **Relevance**: <why this matters for the project>

### <Finding 2 Title>
- **Source**: <source>
- **Details**: <details>
- **Relevance**: <relevance>

## Open Questions
- <questions that still need answers>

## Conclusions
<actionable conclusions drawn from the findings>
```

4. **Conduct the research** using all available methods:
   - **Codebase exploration**: Grep, Glob, Read to find relevant code and patterns
   - **Web search**: WebSearch and WebFetch for external documentation, articles, and references
   - **Existing files**: Check project docs, READMEs, config files for context

5. **Accumulate findings incrementally**: Add each finding as a new section under `## Findings` as you discover it. Update the summary and conclusions as the picture becomes clearer.

6. **When research is complete**:
   - Update `Status:` to `done`
   - Update `Last updated:` date
   - Write a final `## Conclusions` section with actionable takeaways
   - List any remaining `## Open Questions`

7. **Present a summary** to the user with key findings and recommendations.

## Research Statuses

- `in-progress` — actively being researched
- `done` — research complete, findings documented

## Guidelines

- Cite sources for every finding (URLs, file paths, doc references)
- Distinguish facts from opinions or assumptions
- Note conflicting information when found
- Keep findings atomic — one concept per section
- Update the summary section to reflect the current state of knowledge

## Script Management

When performing an operation that can be scripted (e.g., scraping structured data, parsing API responses, aggregating findings):
1. Check `scripts/` for an existing script that handles this operation
2. If a script exists, execute it instead of doing the work inline
3. If no script exists and the operation is reusable, create one in `scripts/`, make it executable, then execute it
4. Reference any new scripts below under "Available Scripts"
5. Update this SKILL.md to call the script in the relevant step

## Available Scripts

_No scripts yet. Scripts will be added here as they are created._
