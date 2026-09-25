#!/usr/bin/env bash

# Errors should exit the program immediately
set -euo pipefail

# List of Herdr plugins to install (owner/repo on GitHub)
plugins=(
  kryptamine/herdr-auto-title
)

echo "Installing Herdr plugins..."
for plugin in "${plugins[@]}"; do
  # --yes: required when stdin isn't interactive, and makes re-running this
  # script safe by auto-confirming the replace-existing-install prompt.
  herdr plugin install "$plugin" --yes
done

echo "Installing Herdr's Claude Code integration..."
herdr integration install claude

# Plugins only start when the server restores a session, and there is no
# `herdr server start`/`restart` subcommand — stop it here, then run `herdr`
# yourself afterward to bring it back up with the plugins active.
echo "Stopping the Herdr server so plugins load on the next launch..."
herdr server stop
echo "Run 'herdr' to bring the session back with the new plugins active."
