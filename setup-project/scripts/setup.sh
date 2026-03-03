#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="${1:?Usage: setup.sh <project-name>}"

# Validate project name (alphanumeric, hyphens, underscores)
if [[ ! "$PROJECT_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo "Error: Project name must contain only letters, numbers, hyphens, and underscores."
  exit 1
fi

# Check if directory already exists
if [[ -d "$PROJECT_NAME" ]]; then
  echo "Error: Directory '$PROJECT_NAME' already exists."
  exit 1
fi

echo "Creating project: $PROJECT_NAME"

# Create project directory
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Initialize git repo
git init

# Clone skills into .claude
echo "Cloning skills repository into .claude..."
git clone git@github.com:r2rka1/skills.git .claude

# Create .gitignore
cat > .gitignore << 'GITIGNORE'
# Dependencies
node_modules/
vendor/
.venv/
venv/
env/
__pycache__/
*.pyc

# Build output
dist/
build/
out/
*.o
*.so
*.dylib

# IDE / Editor
.idea/
.vscode/
*.swp
*.swo
*~
.project
.settings/

# OS files
.DS_Store
Thumbs.db
desktop.ini

# Environment / secrets
.env
.env.local
.env.*.local
*.pem
*.key

# Logs
*.log
logs/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Coverage / test
coverage/
.nyc_output/
*.lcov

# Claude skills (managed separately)
.claude/
GITIGNORE

echo ""
echo "Project '$PROJECT_NAME' created successfully!"
echo "  - Git repository initialized"
echo "  - Skills cloned into .claude/"
echo "  - .gitignore configured"
