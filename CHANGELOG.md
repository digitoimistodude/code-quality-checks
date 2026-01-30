### 2.1.8: 2026-01-30

* Fix Friday notification box alignment padding for emoji display width

### 2.1.7: 2026-01-16

* Fix uncommitted files count box alignment padding calculation
* Read version and date dynamically from CHANGELOG.md in pre-commit

### 2.1.6: 2026-01-15

* Enforce zero stylelint warnings with --max-warnings 0
* Fix uncommitted files count box alignment in success message

### 2.1.5: 2026-01-15

* Fix missing `.husky/_` wrapper scripts in npm package

### 2.1.4: 2026-01-15

* Add postinstall script for plug-and-play setup with absolute paths
* Fix hooks not working when committing from git root in dudestack projects
* Move `_` folder inside `.husky/` for proper husky structure

### 2.1.3: 2026-01-09

* Fix stylelint to run from theme directory for dudestack projects, Ref: DEV-567

### 2.1.2: 2026-01-09

* Fix theme name validation to only check for proper capitalization, Ref: DEV-567

### 2.1.1: 2026-01-09

* Use local stylelint from theme node_modules instead of npx, Ref: DEV-567

### 2.1.0: 2026-01-08

* Add Parcel build system support, auto-detect from package.json, Ref: DEV-673

### 2.0.3: 2025-12-15

* Fix spacing in success box changelog date reminder line
* Ref: DEV-647

### 2.0.2: 2025-12-04

* Skip gulpfile.js check if no themes exist yet (fresh dudestack template)
* Ref: DEV-177

### 2.0.1: 2025-12-03

* Fix gulpfile.js check for dudestack projects (check in themes, not root)
* Rename "bedrock" context to "dudestack" for clarity
* Ref: DEV-177

### 2.0.0: 2025-12-03

* Restructure as npm package @digitoimistodude/code-quality-checks
* Add context detection for standalone theme vs dudestack project
* Merge improvements from air-light husky configuration
* Convert all scripts to 2-space indentation
* Add automatic context-aware checks
* Dudestack mode: Full project checks (composer, WP version, multi-theme, CHANGELOG date validation)
* Standalone mode: Theme-only checks (stylelint, dependencies, basic validations)
* Add scissor marks detection to both contexts
* Improve stylelint config detection for both contexts
* Add flexible config loading (local project config or package default)
* Ref: DEV-177, DEV-373, DEV-623

### 1.0.1: 2025-08-08

* Add commit message validation hook with Linear integration
* Include ASCII art progress indicator for visual feedback
* Fix spacing issues in success box display
* Add support for both single and double-digit uncommitted file counts
* Strip whitespace from git status output to prevent formatting issues

### 1.0.0: 2025-08-06

* First version
