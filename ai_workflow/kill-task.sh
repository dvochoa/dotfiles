# kill-task — remove a worktree + close its tmux window, plus its <TAB> completion.

# _kill-task-help — print kill-task usage/help
_kill-task-help() {
  cat <<'EOF'
kill-task — remove a task's git worktree, its branch, and its tmux window

USAGE
  kill-task [<branch>]

ARGUMENTS
  <branch>   Branch/worktree to tear down. Defaults to the current git branch
             when omitted. Tab-completion suggests active task worktrees.

OPTIONS
  -h, --help Show this help and exit.

Force-removes the worktree (even with uncommitted changes), deletes the local
branch, and closes the matching tmux window. Must be run inside a tmux session.
EOF
}

# kill-task <branch> — remove worktree + close tmux window
#   -h, --help  show usage and exit
kill-task() {
  # Show help before any guards or the branch default, so `kill-task --help`
  # never gets mistaken for a branch named "--help"
  case "$1" in
    -h|--help)
      _kill-task-help
      return 0
      ;;
  esac

  local branch="${1:-$(git branch --show-current 2>/dev/null)}"
  # Bail if no branch name given or couldn't detect current branch
  if [[ -z "$branch" ]]; then
    echo "Usage: kill-task <branch-name>"
    return 1
  fi

  # Bail if not inside a tmux session
  if [[ -z "$TMUX" ]]; then
    echo "kill-task: must be run inside a tmux session"
    return 1
  fi

  local repo_root
  repo_root=$(_get_repo_root) || return 1

  local worktree_path
  worktree_path=$(_get_worktree_path "$repo_root" "$branch")

  # Delete the worktree from disk and git's tracking.
  # --force removes it even if there are uncommitted changes.
  # && means the echo only runs if the remove succeeded.
  git -C "$repo_root" worktree remove "$worktree_path" --force \
    && echo "Removed worktree: $worktree_path"

  # Delete the local branch
  git -C "$repo_root" branch -D "$branch" 2>/dev/null \
    && echo "Deleted branch: $branch"

  # Close the tmux window if it still exists.
  # list-windows -F prints just the window names; grep -q checks for an exact match quietly.
  if command tmux list-windows -F '#{window_name}' 2>/dev/null | grep -q "^${branch}$"; then
    command tmux kill-window -t ":$branch"
    echo "Closed tmux window: $branch"
  fi
}

# --- Zsh tab completion for kill-task ---

# _kill_task_complete — zsh calls this on <TAB> after "kill-task" to list candidates
_kill_task_complete() {
  # Silently bail if not in a git repo
  local repo_root
  repo_root=$(_get_repo_root 2>/dev/null) || return

  local branches=()
  # Read each worktree line, skipping the main one (tail -n +2)
  # Process substitution < <(...) avoids a subshell so $branches survives the loop
  while IFS= read -r line; do
    # Regex captures the branch name between [brackets]; zsh stores it in $match[1]
    if [[ "$line" =~ '\[(.+)\]' ]]; then
      branches+=("${match[1]}")
    fi
  done < <(git -C "$repo_root" worktree list | tail -n +2)
  # compadd -a registers the array as completion candidates; zsh handles prefix matching
  compadd -a branches
}
# Wire up _kill_task_complete as the <TAB> handler for kill-task
compdef _kill_task_complete kill-task
