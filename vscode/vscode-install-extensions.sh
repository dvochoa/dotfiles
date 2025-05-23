#!/usr/bin/env bash

# Errors should exit the program immeditately
set -euo pipefail

# List of VSCode extensions to install
extensions=(
	ahmadalli.vscode-nginx-conf
	bradlc.vscode-tailwindcss
	csstools.postcss
	dbaeumer.vscode-eslint
	docker.docker
	ecmel.vscode-html-css
	esbenp.prettier-vscode
	github.vscode-github-actions
	golang.go
	ms-azuretools.vscode-docker
	vscodevim.vim
)

echo "Checking extensions..."
installed_extensions=$(code --list-extensions)

for extension in "${extensions[@]}"; do
  if echo "$installed_extensions" | grep -q "$extension"; then
    echo "$extension is already installed."
  else
    echo "Installing $extension..."
    code --install-extension "$extension"
  fi
done

echo "All extensions installed or already present!"

