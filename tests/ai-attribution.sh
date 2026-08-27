#!/bin/bash
# Tests for the AI attribution check in the commit-msg hook.
#
# Our git history is a record of human decisions, so a commit may never be
# signed by an assistant. The check has to be strict enough to catch the
# trailers and footers tools add on their own, and loose enough that ordinary
# English does not trip it. Both halves are tested here.
#
# Ref: DEV-1291

set -u

REPO_ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
HOOK="$REPO_ROOT/.husky/commit-msg"
WORK=$( mktemp -d )
FAILED=0

pass() { echo "ok       $1"; }
fail() { echo "FAIL     $1"; FAILED=1; }

cleanup() { cd / && rm -rf "$WORK"; }
trap cleanup EXIT

cd "$REPO_ROOT"

# Run the hook against a message and report its exit status
run_hook() {
  printf '%b' "$1" > "$WORK/msg"
  sh "$HOOK" "$WORK/msg" > "$WORK/out" 2>&1
  echo $?
}

reject() {
  local name="$1" msg="$2"
  if [ "$( run_hook "$msg" )" != "0" ] && grep -q 'AI attribution' "$WORK/out"; then
    pass "rejects $name"
  else
    fail "allowed $name"
  fi
}

accept() {
  local name="$1" msg="$2"
  if [ "$( run_hook "$msg" )" = "0" ]; then
    pass "accepts $name"
  else
    fail "rejected $name"
    sed 's/^/         /' "$WORK/out"
  fi
}

# ---------------------------------------------------------------------------
# Must be rejected
# ---------------------------------------------------------------------------
reject "Claude co-author trailer" \
  "Fix navigation bug, Ref: DEV-123\n\nCo-Authored-By: Claude <noreply@anthropic.com>\n"

reject "Copilot co-author trailer" \
  "Fix navigation bug, Ref: DEV-123\n\nCo-authored-by: Copilot <copilot@github.com>\n"

reject "generated with line" \
  "Fix navigation bug, Ref: DEV-123\n\nGenerated with Claude Code\n"

reject "vendor footer link" \
  "Fix navigation bug, Ref: DEV-123\n\n\xf0\x9f\xa4\x96 Generated with [Claude Code](https://claude.com/claude-code)\n"

reject "session URL" \
  "Fix navigation bug, Ref: DEV-123\n\nhttps://claude.ai/code/session_abc123\n"

reject "written by an AI" \
  "Fix navigation bug, Ref: DEV-123\n\nWritten by ChatGPT\n"

# A merge commit skips the rest of the validation, so the AI check has to run
# before that escape hatch or the rule is one word away from being bypassed.
reject "attribution on a merge commit" \
  "Merge branch 'feature' into master\n\nCo-Authored-By: Claude <noreply@anthropic.com>\n"

# ---------------------------------------------------------------------------
# Must be accepted
# ---------------------------------------------------------------------------
accept "a plain compliant message" \
  "Fix navigation bug, Ref: DEV-123\n"

accept "a human co-author trailer" \
  "Fix navigation bug, Ref: DEV-123\n\nCo-Authored-By: Matti Meikalainen <matti@dude.fi>\n"

accept "the word cursor in ordinary use" \
  "Fix cursor position in the editor, Ref: DEV-123\n"

accept "generated with a non-AI tool" \
  "Update sitemap generated with gulp, Ref: DEV-123\n"

accept "the word codex in ordinary use" \
  "Add codex of error codes to docs, Ref: DEV-123\n"

echo ""
if [ "$FAILED" = "1" ]; then
  echo "AI attribution check is broken."
  exit 1
fi

echo "All AI attribution tests passed."
