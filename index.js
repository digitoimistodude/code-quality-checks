/**
 * @digitoimistodude/code-quality-checks
 *
 * Exports the path to husky hooks for direct reference.
 *
 * Usage in your project's .husky/pre-commit:
 *   node_modules/@digitoimistodude/code-quality-checks/.husky/pre-commit
 *
 * Or import the path:
 *   const { huskyPath } = require('@digitoimistodude/code-quality-checks');
 */

const path = require('path');

module.exports = {
  huskyPath: path.join(__dirname, '.husky'),
  preCommitPath: path.join(__dirname, '.husky', 'pre-commit'),
  preCommitConfigPath: path.join(__dirname, '.husky', 'pre-commit-config'),
  commitMsgPath: path.join(__dirname, '.husky', 'commit-msg')
};
