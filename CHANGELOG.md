### 2.0.0: 2025-12-03

* Restructure as npm package @digitoimistodude/code-quality-checks
* Add context detection for standalone theme vs Bedrock project
* Merge improvements from air-light husky configuration
* Convert all scripts to 2-space indentation
* Add automatic context-aware checks
* Bedrock mode: Full project checks (composer, WP version, multi-theme, CHANGELOG date validation)
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
