#!/bin/bash
# Tests for SKIP_CHECKS, the per-check escape hatch.
#
# The point of the feature is that skipping one check keeps the others, so the
# two failure modes worth testing are opposites: a named check that refuses to
# step aside, and an unnamed one that steps aside anyway. A silent skip is the
# worse of the two, which is why the SKIPPED notice is asserted rather than
# just the exit status.
#
# Ref: DEV-1565

set -u

REPO_ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
PRE_COMMIT="$REPO_ROOT/.husky/pre-commit"
COMMIT_MSG="$REPO_ROOT/.husky/commit-msg"
WORK=$( mktemp -d )
FAILED=0

pass() { echo "ok       $1"; }
fail() { echo "FAIL     $1"; FAILED=1; }

cleanup() { cd / && rm -rf "$WORK"; }
trap cleanup EXIT

# ---------------------------------------------------------------------------
# A project that passes every check, so a failure in these tests is the skip
# machinery and not the fixture
# ---------------------------------------------------------------------------
PROJECT="$WORK/project"
mkdir -p "$PROJECT/.github/workflows"
cd "$PROJECT"
git init -q .
git config user.email 'test@dude.fi'
git config user.name 'Test'
printf 'v20\n' > .nvmrc
printf '<?xml version="1.0"?>\n<ruleset name="test"></ruleset>\n' > phpcs.xml
printf '{}\n' > .stylelintrc.json
printf '### 1.0.0: %s\n\n* Init\n' "$( date +%Y-%m-%d )" > CHANGELOG.md
printf '<?php\n' > placeholder.php
git add -A

run_pre_commit() {
  env SKIP_CHECKS="$1" sh "$PRE_COMMIT" > "$WORK/out" 2>&1
  echo $?
}

run_commit_msg() {
  printf '%b' "$2" > "$WORK/msg"
  env SKIP_CHECKS="$1" sh "$COMMIT_MSG" "$WORK/msg" > "$WORK/out" 2>&1
  echo $?
}

# ---------------------------------------------------------------------------
# The fixture itself must pass, otherwise the rest proves nothing
# ---------------------------------------------------------------------------
if [ "$( run_pre_commit "" )" = "0" ]; then
  pass "compliant project passes with nothing skipped"
else
  fail "fixture project does not pass a clean run"
  sed 's/^/         /' "$WORK/out"
fi

# ---------------------------------------------------------------------------
# A named check steps aside and says so
# ---------------------------------------------------------------------------
rm .nvmrc

if [ "$( run_pre_commit "" )" != "0" ]; then
  pass "missing .nvmrc is rejected when nothing is skipped"
else
  fail "missing .nvmrc was allowed through"
fi

if [ "$( run_pre_commit "required-files" )" = "0" ]; then
  pass "required-files skip lets the commit through"
else
  fail "required-files skip did not take effect"
  sed 's/^/         /' "$WORK/out"
fi

if grep -q 'SKIPPED (disabled)' "$WORK/out"; then
  pass "a skipped check announces itself"
else
  fail "a skipped check was silent, a partial run reads as a clean one"
fi

if grep -q 'Skipping on request: required-files' "$WORK/out"; then
  pass "the header names what was skipped"
else
  fail "the header did not name the skipped checks"
fi

printf 'v20\n' > .nvmrc
git add -A

# ---------------------------------------------------------------------------
# Skipping one check must not disable the rest, which is the whole point
# ---------------------------------------------------------------------------
printf '<?php\nfunction broken( {\n' > broken.php
git add broken.php

if [ "$( run_pre_commit "merge-conflicts" )" != "0" ] && grep -q 'PHP syntax errors found' "$WORK/out"; then
  pass "skipping one check leaves the others enforcing"
else
  fail "skipping merge-conflicts also let a PHP syntax error through"
  sed 's/^/         /' "$WORK/out"
fi

git rm -q -f --cached broken.php
rm broken.php

# ---------------------------------------------------------------------------
# Separators and unknown names
# ---------------------------------------------------------------------------
if [ "$( run_pre_commit "merge-conflicts,scissors" )" = "0" ] &&
   [ "$( grep -c 'SKIPPED (disabled)' "$WORK/out" )" -ge 2 ]; then
  pass "a comma separated list skips every name in it"
else
  fail "comma separated names were not all honoured"
fi

run_pre_commit "nosuchcheck" > /dev/null
if grep -q "Unknown check 'nosuchcheck'" "$WORK/out"; then
  pass "an unknown name is reported rather than ignored"
else
  fail "an unknown name passed silently, a typo reads as a working skip"
fi

# ---------------------------------------------------------------------------
# The config file holds a skip, and the environment adds to it rather than
# replacing it
# ---------------------------------------------------------------------------
mkdir -p .husky
cp "$REPO_ROOT/.husky/pre-commit-config" .husky/pre-commit-config
sed -i.bak 's/^SKIP_CHECKS=.*/SKIP_CHECKS="merge-conflicts"/' .husky/pre-commit-config
rm -f .husky/pre-commit-config.bak

run_pre_commit "" > /dev/null
if grep -q 'Skipping on request: merge-conflicts' "$WORK/out"; then
  pass "pre-commit-config holds a skip on its own"
else
  fail "SKIP_CHECKS in pre-commit-config was not read"
fi

run_pre_commit "scissors" > /dev/null
if grep -q 'Skipping on request: merge-conflicts scissors' "$WORK/out"; then
  pass "the environment adds to the config rather than replacing it"
else
  fail "config and environment did not merge"
  sed 's/^/         /' "$WORK/out"
fi

rm -rf .husky

# ---------------------------------------------------------------------------
# commit-msg: the Linear reference may be skipped, AI attribution may not
# ---------------------------------------------------------------------------
if [ "$( run_commit_msg "" "Just a message with no reference\n" )" != "0" ]; then
  pass "a message with no task ID is rejected"
else
  fail "a message with no task ID was allowed"
fi

if [ "$( run_commit_msg "commit-msg-linear" "Just a message with no reference\n" )" = "0" ]; then
  pass "commit-msg-linear skip allows a message with no task ID"
else
  fail "commit-msg-linear skip did not take effect"
  sed 's/^/         /' "$WORK/out"
fi

attribution="Fix navigation bug, Ref: DEV-123\n\nCo-Authored-By: Claude <noreply@anthropic.com>\n"

if [ "$( run_commit_msg "commit-msg-ai-attribution" "$attribution" )" != "0" ] &&
   grep -q 'AI attribution' "$WORK/out"; then
  pass "AI attribution cannot be skipped"
else
  fail "AI attribution was bypassed by naming it in SKIP_CHECKS"
  sed 's/^/         /' "$WORK/out"
fi

if grep -q 'cannot be disabled' "$WORK/out"; then
  pass "the attempt to disable it is reported"
else
  fail "naming a non-skippable check said nothing"
fi

echo ""
if [ "$FAILED" = "1" ]; then
  echo "SKIP_CHECKS is broken."
  exit 1
fi

echo "All SKIP_CHECKS tests passed."
