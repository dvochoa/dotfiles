#!/usr/bin/env bash

# Errors should exit the program immeditately
set -euo pipefail

# List of Homebrew formulae to install
packages=(
  git bat zsh-syntax-highlighting fd fzf
  gh neovim maccy tmux
)

echo "Updating Homebrew..."
brew update

echo "Checking packages..."

for pkg in "${packages[@]}"; do
  if brew list --formula --versions "$pkg" > /dev/null 2>&1; then
    echo "$pkg is already installed."
  else
    echo "Installing $pkg..."
    brew install "$pkg"
  fi
done

echo "All packages installed or already present!"

