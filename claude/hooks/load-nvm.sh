#!/bin/bash
# SessionStart hook to load nvm and make it available to all Bash commands

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Exit early if no env file to write to
[ -z "$CLAUDE_ENV_FILE" ] && exit 0

# Helper to append exports to Claude's environment file
add_env() { echo "export $1=\"$2\"" >> "$CLAUDE_ENV_FILE"; }

# Export NVM environment variables
add_env NVM_DIR "$NVM_DIR"
[ -n "$NVM_BIN" ] && add_env NVM_BIN "$NVM_BIN"
[ -n "$NVM_INC" ] && add_env NVM_INC "$NVM_INC"

# Add node bin path to PATH if using an nvm-managed version
NODE_VERSION=$(nvm current 2>/dev/null)
if [ -n "$NODE_VERSION" ] && [ "$NODE_VERSION" != "none" ] && [ "$NODE_VERSION" != "system" ]; then
  add_env PATH "$NVM_DIR/versions/node/$NODE_VERSION/bin:\$PATH"
fi

# Remove lazy-loading stub functions that may shadow the real binaries in PATH
# These stubs are commonly defined in .zshrc to speed up shell startup
echo "unset -f node npm npx pnpm nvm claude _load_nvm 2>/dev/null" >> "$CLAUDE_ENV_FILE"

exit 0
