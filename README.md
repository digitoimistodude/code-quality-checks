# Code quality checks

 [![husky](https://img.shields.io/badge/🐶%20husky-a8b1ff?style=for-the-badge)](#) ![Version](https://img.shields.io/badge/version-1.0.1-blue?style=for-the-badge) [![javascript](https://img.shields.io/badge/javascript-%23F7DF1E.svg?style=for-the-badge&logo=javascript&logoColor=black)](#) [![node.js](https://img.shields.io/badge/node.js-%23339933.svg?style=for-the-badge&logo=node.js&logoColor=white)](#)

Dude's comprehensive code quality definitions and pre-commit hooks for WordPress projects.

<img width="706" height="688" alt="image" src="https://github.com/user-attachments/assets/1f5495f2-3745-4e6f-827b-460272a4ad96" />

## Features

- **Pre-commit hooks**: Comprehensive code quality checks before commits
- **File validation**: Required configuration files and formats
- **Code linting**: PHP CodeSniffer, Stylelint for SCSS
- **WordPress version checks**: Ensures latest WordPress core
- **Dependency validation**: Composer and npm dependency checks
- **Conflict detection**: Merge conflict and scissor mark detection

## Project requirements

Your project must have these files for the hooks to work:

### Required files
- `.nvmrc` - Node.js version specification
- `phpcs.xml` - PHP CodeSniffer configuration
- `gulpfile.js` - Gulp build configuration
- `CHANGELOG.md` - Project changelog (format: `### x.x.x[-rcx]: yyyy-mm-dd`)
- `.github/workflows/` - GitHub Actions directory
- `composer.json` - PHP dependencies (with WordPress core)
- `package.json` - Node.js dependencies (with Gulp)

### Theme-specific requirements

- `content/themes/*/style.css` - WordPress theme headers
- `content/themes/*/.stylelintrc*` - Stylelint configuration per theme

### Example commands to create required files

```bash
# Create Node version file
node --version > .nvmrc

# Create basic CHANGELOG.md
echo "### 1.0.0: $(date +%Y-%m-%d)" > CHANGELOG.md

# Create GitHub workflows directory
mkdir -p .github/workflows

# Ensure dependencies are installed
composer install
nvm use && npm install
```

## Configuration

### Customizing exclusions

Edit `.husky/pre-commit-config` to customize what files are excluded:

```bash
# Directories to exclude
EXCLUDE_DIRS=".husky|node_modules|vendor|.git|uploads|cache"

# Files to exclude (glob patterns supported)
EXCLUDE_FILES="*.min.js|*.min.css|*.map|*.lock|*.log"

# File extensions to exclude
EXCLUDE_EXTENSIONS=".jpg|.jpeg|.png|.gif|.svg|.ico|.pdf"

# Check only changed files (true) or entire codebase (false)
CHECK_CHANGED_ONLY=true
```

### PHP CodeSniffer setup

Your `phpcs.xml` should follow this pattern:
```xml
<?xml version="1.0"?>
<ruleset name="Project">
    <file>.</file>
    <exclude-pattern>vendor/*</exclude-pattern>
    <exclude-pattern>node_modules/*</exclude-pattern>
    <rule ref="WordPress"/>
</ruleset>
```

## Usage

Once installed, the hooks run automatically:

### Pre-commit hook

Runs on `git commit` and checks:
- Required configuration files
- CHANGELOG.md format and date
- WordPress version currency
- Dependency installation status
- Merge conflicts and scissor marks
- PHP syntax (8.3 compatibility)
- PHP CodeSniffer violations
- Stylelint violations on SCSS files

### Bypassing hooks (not recommended)

```bash
git commit --no-verify -m "Emergency commit"
```

## Troubleshooting

### Hooks not running

1. Check if `.git/hooks/pre-commit` exists and points to Husky
2. Ensure hooks are executable: `chmod +x .husky/*`
3. Verify Husky installation: `npx husky install`

### Common errors

- **"phpcs.xml not found"**: Create PHP CodeSniffer configuration
- **"gulpfile.js missing"**: Add Gulp build configuration
- **"CHANGELOG.md date must be today"**: Update changelog date to current date
- **"WordPress version outdated"**: Update WordPress in composer.json

### Getting help

The hooks provide detailed error messages with suggested fixes. Look for:
- 🔍 File checking messages
- ❌ Failure indicators with explanations  
- 💡 Suggested fix commands in blue

## Requirements

- Node.js >= 18.0.0
- PHP >= 8.1
- Composer
- Git repository
