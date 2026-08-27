## Commits and code style

- 2 space indents
- Always commit build and asset files
- One logical change per commit
- Keep commit messages concise (one line), use sentence case
- Reference Linear issues at end: `Fix navigation bug, Ref: DEV-123`
- Update CHANGELOG.md after each change
- Use present tense in commits and CHANGELOG.md
- Use sentence case for headings (not Title Case)
- Never use bold text as headings, use proper heading levels instead
- Always add an empty line after headings
- No formatting in CHANGELOG.md except `inline code` and when absolute necessary
- Use `*` as bullets in CHANGELOG.md
- Never carry AI attribution in commits, commit trailers, PR titles or PR descriptions
- FORBIDDEN: `Co-Authored-By` trailers naming an AI tool or model, generated-with lines such as "Generated with Claude Code", AI vendor footer links, AI session URLs
- `Co-Authored-By` for real people is fine, the rule is about machines
- The `commit-msg` hook in code-quality-checks blocks these, amend the commit instead of bypassing the hook
- No emojis in commits or code
- Keep CHANGELOG.md date up to date when adding entries

## Claude Code workflow

- Always add tasks to the Claude Code to-do list and keep it up to date.
- Review your to-do list and prioritize before starting.
- If new tasks come in, don't jump to them right away—add them to the list in order of urgency and finish your current work first.
- Do not ever guess features, always proof them via looking up official docs, GitHub code, issues, if possible.
- When looking things up, do not use years in search terms like 2024 or 2025.
