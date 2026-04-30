# --- Parallel Claude task workflow ---

# _get_repo_root — prints the main repo root (not a worktree) or returns 1
# Uses --git-common-dir to always resolve back to the main repo, even when
# called from inside a worktree where --show-toplevel would return the worktree path.
_get_repo_root() {
  local git_common_dir
  git_common_dir=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || {
    echo "${FUNCNAME[1]}: not in a git repo" >&2
    return 1
  }
  # --git-common-dir returns the .git directory; dirname gives us the repo root
  dirname "$git_common_dir"
}

# _get_worktree_path <repo_root> <branch> — prints the sibling worktree path
# e.g. ~/code/myapp + feature-x → ~/code/myapp-feature-x
_get_worktree_path() {
  local repo_root="$1"
  local branch="$2"
  echo "$(dirname "$repo_root")/$(basename "$repo_root")-${branch}"
}

# start-task <branch> ["<task>"] — create worktree + tmux window + launch claude
start-task() {
  # Store the two positional arguments into named variables
  local branch="$1"
  local task="$2"

  # Bail early if branch is missing
  if [[ -z "$branch" ]]; then
    echo "Usage: start-task <branch-name> [\"<task description>\"]"
    return 1
  fi

  # Bail if not inside a tmux session
  if [[ -z "$TMUX" ]]; then
    echo "start-task: must be run inside a tmux session"
    return 1
  fi

  local repo_root
  repo_root=$(_get_repo_root) || return 1

  local worktree_path
  worktree_path=$(_get_worktree_path "$repo_root" "$branch")

  # Create a new git worktree at that path on a new branch.
  # A worktree is a second checkout of the repo — same .git, separate files.
  git -C "$repo_root" worktree add "$worktree_path" -b "$branch" || return 1

  # Open a new tmux window named after the branch, cd'd into the worktree
  command tmux new-window -n "$branch" -c "$worktree_path"
  # Split the window with a right column taking 40% of the width (pane 1)
  command tmux split-window -t ":${branch}.0" -h -p 40 -c "$worktree_path"
  # Split the right column in half vertically to make the bottom terminal pane (pane 2)
  command tmux split-window -t ":${branch}.1" -v -p 50 -c "$worktree_path"
  # Wait for shells to initialize (oh-my-zsh, etc.) before sending keystrokes
  sleep 2
  # Type "vim ." into the left pane and press Enter
  command tmux send-keys -t ":${branch}.0" "vim ." Enter
  # Build the claude command — include the task only if one was provided
  local claude_cmd="claude --permission-mode dontAsk"
  [[ -n "$task" ]] && claude_cmd+=" $(printf '%q' "$task")"
  # Type the claude command into the top-right pane
  command tmux send-keys -t ":${branch}.1" "$claude_cmd" Enter
  # Move focus to the claude pane
  command tmux select-pane -t ":${branch}.1"
  echo "Spawned '$branch' → $worktree_path"
}

# list-tasks — show all active worktrees
list-tasks() {
  local repo_root
  repo_root=$(_get_repo_root) || return 1
  # Print all worktrees for this repo (path, HEAD commit, branch name)
  git -C "$repo_root" worktree list
}

# kill-task <branch> — remove worktree + close tmux window
kill-task() {
  local branch="$1"
  # Bail if no branch name given
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

# --- Zsh tab completions ---

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
