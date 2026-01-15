/**
 * @digitoimistodude/code-quality-checks
 *
 * Exports the path to husky hooks for direct reference.
 *
 * Usage in your project's package.json:
 *   "prepare": "dude-code-quality-setup"
 *
 * Or import the path:
 *   const { huskyPath } = require('@digitoimistodude/code-quality-checks');
 */

const path = require('path');
const { execSync } = require('child_process');

const huskyPath = path.join(__dirname, '.husky');
const huskyInternalPath = path.join(__dirname, '.husky', '_');

/**
 * Setup husky with absolute path to hooks
 * This ensures hooks work from anywhere in the git repository
 */
function setup() {
  try {
    // Get the git root directory
    const gitRoot = execSync('git rev-parse --show-toplevel', { encoding: 'utf8' }).trim();

    // Set core.hooksPath to absolute path
    execSync(`git config core.hooksPath "${huskyInternalPath}"`, { cwd: gitRoot });

    console.log(`✅ Husky hooks configured at: ${huskyInternalPath}`);
  } catch (error) {
    console.error('❌ Failed to setup husky hooks:', error.message);
    process.exit(1);
  }
}

module.exports = {
  huskyPath,
  huskyInternalPath,
  preCommitPath: path.join(__dirname, '.husky', 'pre-commit'),
  preCommitConfigPath: path.join(__dirname, '.husky', 'pre-commit-config'),
  commitMsgPath: path.join(__dirname, '.husky', 'commit-msg'),
  setup
};
