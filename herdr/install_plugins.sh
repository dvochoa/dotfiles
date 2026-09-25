#!/usr/bin/env bash

# Errors should exit the program immediately
set -euo pipefail

# List of Herdr plugins to install (owner/repo on GitHub)
plugins=(
  kryptamine/herdr-auto-title
)

echo "Installing Herdr plugins..."
for plugin in "${plugins[@]}"; do
  herdr plugin install "$plugin"
done

echo "Installing Herdr's Claude Code integration..."
herdr integration install claude

echo "Restarting the Herdr server so plugins take effect..."
herdr server stop
