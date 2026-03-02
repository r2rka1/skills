---
name: check-for-security-issues
description: Scans files changed in the current branch for security vulnerabilities including OWASP Top 10, hardcoded secrets, injection flaws, and insecure patterns. Use when the user wants a security audit, vulnerability check, or security review of their changes.
disable-model-invocation: true
argument-hint: "[file or directory path]"
---

# Check for Security Issues

Acts as a senior security engineer performing a focused audit of files touched in the current branch. Identifies vulnerabilities, insecure patterns, and hardcoded secrets, then reports findings with severity and remediation guidance.

## Usage

```
/check-for-security-issues
/check-for-security-issues src/api/
/check-for-security-issues src/auth/login.ts
```

If no path is provided, scans all files changed in the current branch compared to the base branch.

## Workflow

### 1. Determine Scope

- [ ] If a file or directory path is provided, use that as the scope
- [ ] If no path is provided, identify changed files:
  ```bash
  # Find the base branch
  BASE=$(git merge-base HEAD main 2>/dev/null || echo "HEAD~10")
  # List changed files
  git diff --name-only "$BASE"...HEAD
  ```
- [ ] Filter to code files only (skip images, lockfiles, generated files)
- [ ] If on `main` with no branch diff, scan files changed in the last 5 commits

### 2. Scan for Vulnerabilities

Read each file in scope and check against these categories:

#### Secrets & Credentials

| Pattern | Examples |
|---------|----------|
| Hardcoded API keys | `apiKey = "sk-..."`, `token = "ghp_..."` |
| Passwords in code | `password = "..."`, `secret = "..."` |
| Connection strings | Database URLs with embedded credentials |
| Private keys | PEM blocks, SSH keys committed to repo |
| `.env` files committed | Secrets in tracked `.env` files |

#### Injection Vulnerabilities

| Type | What to Check |
|------|--------------|
| **SQL injection** | String concatenation in queries, missing parameterized queries |
| **XSS** | Unescaped user input in HTML, `innerHTML`, `dangerouslySetInnerHTML` |
| **Command injection** | User input in `exec()`, `spawn()`, `system()`, shell commands |
| **Path traversal** | User input in file paths without sanitization |
| **Template injection** | User input in template engines without escaping |
| **LDAP/NoSQL injection** | Unsanitized input in query objects |

#### Authentication & Authorization

| Issue | What to Check |
|-------|--------------|
| Missing auth checks | Endpoints without authentication middleware |
| Broken access control | Missing authorization for sensitive operations |
| Weak session handling | Predictable tokens, missing expiration, no rotation |
| Insecure password storage | Plaintext or weak hashing (MD5, SHA1 without salt) |

#### Data Exposure

| Issue | What to Check |
|-------|--------------|
| Sensitive data in logs | Logging passwords, tokens, PII |
| Verbose error messages | Stack traces or internal details exposed to users |
| Missing encryption | Sensitive data stored or transmitted without encryption |
| CORS misconfiguration | Overly permissive `Access-Control-Allow-Origin` |

#### Insecure Patterns

| Pattern | What to Check |
|---------|--------------|
| `eval()` usage | Dynamic code execution with user input |
| Disabled security features | `verify=False`, `secure: false`, disabled CSRF |
| Outdated crypto | MD5/SHA1 for security, ECB mode, weak key sizes |
| Unsafe deserialization | `pickle.loads()`, `yaml.load()` without safe loader |
| HTTP instead of HTTPS | Insecure URLs in API calls or redirects |
| Missing rate limiting | Auth endpoints without throttling |

### 3. Classify Findings

Assign each finding a severity:

| Severity | Criteria |
|----------|----------|
| **Critical** | Exploitable immediately — secrets exposed, injection with user input, auth bypass |
| **High** | Likely exploitable — missing auth, weak crypto, unsafe deserialization |
| **Medium** | Exploitable under conditions — CORS issues, verbose errors, missing rate limits |
| **Low** | Defense in depth — informational findings, best practice violations |

### 4. Present Report

Display findings in this format:

```markdown
## Security Audit: <scope>

**Branch:** <current branch>
**Files scanned:** <count>
**Findings:** <count by severity>

### Critical
- **<file>:<line>** — <vulnerability type>
  <description of the issue>
  **Remediation:** <specific fix>

### High
- **<file>:<line>** — <vulnerability type>
  <description>
  **Remediation:** <specific fix>

### Medium
- **<file>:<line>** — <vulnerability type>
  <description>
  **Remediation:** <specific fix>

### Low
- **<file>:<line>** — <description>

### Summary
<overall assessment and top recommendations>
```

### 5. Verify No False Positives

Before reporting:
- [ ] Confirm each finding by reading surrounding code context
- [ ] Check if apparent secrets are actually placeholders or examples
- [ ] Verify injection vectors actually reach user input
- [ ] Check if frameworks already sanitize the flagged patterns

### 6. Offer Fixes

After presenting the report:
- [ ] Ask the user if they want to fix Critical and High findings
- [ ] If yes, apply minimal targeted fixes for each approved finding
- [ ] Do not change unrelated code
- [ ] Run tests after fixes if a test suite exists

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
