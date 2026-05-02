#!/usr/bin/env bash

# Errors should exit the program immeditately
set -euo pipefail

# List of Homebrew formulae to install
packages=(
  bat fd fzf gh git maccy neovim ripgrep tmux zsh-syntax-highlighting
)

# List of Homebrew casks to install
casks=(
  rectangle hamed-elfayome/claude-usage/claude-usage-tracker
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

echo "Checking casks..."

for cask in "${casks[@]}"; do
  if brew list --cask --versions "$cask" > /dev/null 2>&1; then
    echo "$cask is already installed."
  else
    echo "Installing $cask..."
    brew install --cask "$cask"
  fi
done

echo "All packages installed or already present!"

