# Code quality checks

[![husky](https://img.shields.io/badge/husky-a8b1ff?style=for-the-badge)](#) [![npm](https://img.shields.io/npm/v/@digitoimistodude/code-quality-checks?style=for-the-badge)](https://www.npmjs.com/package/@digitoimistodude/code-quality-checks)

Dude's comprehensive code quality definitions and pre-commit hooks for WordPress projects.

## Features

* Pre-commit hooks with comprehensive code quality checks
* Automatic context detection (standalone theme vs dudestack project)
* Build system detection (Parcel or Gulp)
* PHP CodeSniffer validation
* Stylelint for SCSS files
* WordPress version checks (dudestack mode)
* Dependency validation for Composer and npm
* Merge conflict and scissor mark detection
* Commit message validation with Linear integration

## Installation

```bash
npm install @digitoimistodude/code-quality-checks husky --save-dev
```

Initialize husky:

```bash
npx husky init
```

## Setup

Create wrapper scripts in your project's `.husky/` directory that reference the package hooks.

### .husky/pre-commit

```sh
node_modules/@digitoimistodude/code-quality-checks/.husky/pre-commit
```

### .husky/commit-msg

```sh
node_modules/@digitoimistodude/code-quality-checks/.husky/commit-msg "$1"
```

Make them executable:

```bash
chmod +x .husky/pre-commit .husky/commit-msg
```

## Context detection

The hooks automatically detect whether they're running in:

* **dudestack project**: Has `content/themes/` directory and `composer.json`
* **Standalone theme**: Everything else

### dudestack mode checks

* WordPress version in composer.json
* Composer dependencies
* CHANGELOG.md format and freshness
* Theme style.css validation
* Multi-theme dependency checks
* Root stylelintrc should not exist

### Standalone mode checks

* Basic file requirements (.nvmrc, phpcs.xml)
* Build system config (Parcel: .parcelrc or Gulp: gulpfile.js)
* npm dependencies
* Stylelint config in current directory
* PHP syntax validation
* SCSS linting

## Configuration

Create `.husky/pre-commit-config` in your project to override defaults:

```bash
# Directories to exclude
EXCLUDE_DIRS=".husky|node_modules|vendor|.git|uploads|cache"

# Files to exclude (glob patterns)
EXCLUDE_FILES="*.min.js|*.min.css|*.map|*.lock|*.log"

# File extensions to exclude
EXCLUDE_EXTENSIONS=".jpg|.jpeg|.png|.gif|.svg|.ico|.pdf"

# Check only changed files (true) or entire codebase (false)
CHECK_CHANGED_ONLY=true
```

## Requirements

* Node.js >= 18.0.0
* PHP >= 8.1
* Composer (for dudestack projects)
* husky >= 9.1.7

## Updating

Simply update the package to get the latest hooks:

```bash
npm update @digitoimistodude/code-quality-checks
```

No need to re-copy files - your wrapper scripts always use the latest version from node_modules.
