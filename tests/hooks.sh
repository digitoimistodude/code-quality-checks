#!/bin/bash
# Tests for the hook installation.
#
# The hooks are the only thing between a developer and a bad commit, so an
# install that silently fails is worse than no hooks at all. On 20.8.2026
# createproject reported success while setup.js had died, leaving a project
# with no core.hooksPath and no linting. These tests make that visible.
#
# Note: the pre-commit hook checks project structure (.nvmrc, phpcs.xml,
# CHANGELOG.md and so on), so a bare repository is *expected* to be rejected.
# That rejection is the behaviour under test, not a failure.

set -u

REPO_ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
WORK=$( mktemp -d )
FAILED=0

pass() { echo "ok       $1"; }
fail() { echo "FAIL     $1"; FAILED=1; }

cleanup() { cd / && rm -rf "$WORK"; }
trap cleanup EXIT

# ---------------------------------------------------------------------------
# Hook scripts must be valid shell
# ---------------------------------------------------------------------------
for hook in pre-commit commit-msg; do
  if sh -n "$REPO_ROOT/.husky/$hook" 2> /dev/null; then
    pass "$hook is valid shell"
  else
    fail "$hook has a syntax error"
  fi
done

# ---------------------------------------------------------------------------
# setup.js must configure core.hooksPath in a real repository
# ---------------------------------------------------------------------------
git init -q "$WORK/project"
cd "$WORK/project"
git config user.email 'test@dude.fi'
git config user.name 'Test'

if node "$REPO_ROOT/bin/setup.js" > /dev/null 2>&1; then
  pass "setup.js runs"
else
  fail "setup.js exited non-zero"
fi

HOOKS_PATH=$( git config --get core.hooksPath || true )

if [ -n "$HOOKS_PATH" ]; then
  pass "core.hooksPath is set"
else
  fail "core.hooksPath was not set"
fi

if [ -n "$HOOKS_PATH" ] && [ -d "$HOOKS_PATH" ]; then
  pass "core.hooksPath points at a real directory"
else
  fail "core.hooksPath points nowhere: ${HOOKS_PATH:-empty}"
fi

if [ -n "$HOOKS_PATH" ] && [ -x "$HOOKS_PATH/pre-commit" ]; then
  pass "pre-commit is executable"
else
  fail "pre-commit is missing or not executable"
fi

# ---------------------------------------------------------------------------
# The hook must actually run and must refuse a non-compliant repository.
# A hook that lets everything through is the failure mode we care about.
# ---------------------------------------------------------------------------
printf '<?php\n' > placeholder.php
git add placeholder.php
output=$( git commit -m "Add placeholder" 2>&1 )
status=$?

if [ "$status" != "0" ]; then
  pass "non-compliant repo is rejected"
else
  fail "hook allowed a commit in a repo with no project files"
fi

if echo "$output" | grep -q '➜'; then
  pass "hook produced check output"
else
  fail "hook produced no recognisable output, it may not have run at all"
fi

if echo "$output" | grep -qiE 'FAILED|missing|Please run'; then
  pass "rejection message is actionable"
else
  fail "rejection gave no actionable reason"
fi

# ---------------------------------------------------------------------------
# HUSKY=0 must bypass the hooks, since that is the documented escape hatch
# ---------------------------------------------------------------------------
if HUSKY=0 git commit -q -m "Add placeholder" > /dev/null 2>&1; then
  pass "HUSKY=0 bypasses hooks"
else
  fail "HUSKY=0 did not bypass hooks"
fi

echo ""
if [ "$FAILED" = "1" ]; then
  echo "Hook installation is broken."
  exit 1
fi

echo "All hook tests passed."
