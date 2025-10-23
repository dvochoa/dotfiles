# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Zsh configuration
# Theme to load, see https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Tab autocompletion shows all files include hidden ones
zstyle ':completion:*' file-patterns '*(D)'

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

## Plugins
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/

# Run the following to ensure plugins are made available to oh-my-zsh
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

plugins=(
  git
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

## Aliases
alias vim=nvim
alias vi=nvim

## Vim setup
# Enable vi mode in the terminal
bindkey -v

# Remap _ to beginning of line like in vim
bindkey -M vicmd _ beginning-of-line

# Configure the timeout for multi-input commands
export KEYTIMEOUT=1

## Functions
# Navigate files recursively within the current directory with preview and open selected file in nvim
vif() {
  local file
  file=$(fzf --preview="bat --style=numbers --color=always {}")
  if [[ -n "$file" ]]; then
    nvim "$file"
  fi
}

# Make and then cd into a directory
mkcd() {
  \mkdir -p "$1"
  cd "$1"
}

## Dependencies
# golang
export PATH=$PATH:$(go env GOPATH)/bin

# postgrad
export PATH="/usr/local/opt/postgresql@14/bin:$PATH"

# fzf
# Configure fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Use fd as default to respect .gitignore
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

### Lazy load dependencies to speed up zsh load time
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

node() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  node "$@"
}

npm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  npm "$@"
}

npx() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  npx "$@"
}

