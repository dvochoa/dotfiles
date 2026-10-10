# kill-task — remove a worktree + close its herdr workspace, plus its <TAB> completion.

# _kill-task-help — print kill-task usage/help
_kill-task-help() {
  cat <<'EOF'
kill-task — remove a task's git worktree, its branch, and its herdr workspace

USAGE
  kill-task [<branch>]

ARGUMENTS
  <branch>   Branch/worktree to tear down. Defaults to the current git branch
             when omitted. Tab-completion suggests active task worktrees.

OPTIONS
  -h, --help Show this help and exit.

Force-removes the worktree (even with uncommitted changes), deletes the local
branch, and closes the matching herdr workspace. Must be run inside herdr.
EOF
}

# kill-task <branch> — remove worktree + close herdr workspace
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

  # Bail if not inside a herdr pane
  if [[ "$HERDR_ENV" != 1 ]]; then
    echo "kill-task: must be run inside herdr"
    return 1
  fi

  local repo_root
  repo_root=$(_get_repo_root) || return 1

  # Ask herdr where the branch's worktree lives and which workspace has it open
  local list worktree worktree_path workspace_id source_ws
  list=$(herdr worktree list --cwd "$repo_root") || return 1
  worktree=$(jq -c --arg b "$branch" '.result.worktrees[] | select(.branch == $b and .is_linked_worktree)' <<<"$list")
  if [[ -z "$worktree" ]]; then
    echo "kill-task: no worktree for branch '$branch'"
    return 1
  fi
  worktree_path=$(jq -r '.path' <<<"$worktree")
  workspace_id=$(jq -r '.open_workspace_id // empty' <<<"$worktree")
  # The main checkout's workspace, if it's open — where we land after closing
  source_ws=$(jq -r '.result.source.source_workspace_id // empty' <<<"$list")

  # Delete the worktree from disk and git's tracking.
  # --force removes it even if there are uncommitted changes.
  git -C "$repo_root" worktree remove "$worktree_path" --force \
    && echo "Removed worktree: $worktree_path"

  # Delete the local branch
  git -C "$repo_root" branch -D "$branch" 2>/dev/null \
    && echo "Deleted branch: $branch"

  # Close the workspace last: if we're running inside it, this kills our own shell
  if [[ -n "$workspace_id" ]]; then
    # If the task workspace is on screen, hop to the main repo first so herdr
    # doesn't pick an arbitrary neighbor once it closes
    if [[ -n "$source_ws" && $(herdr workspace get "$workspace_id" | jq -r '.result.workspace.focused') == true ]]; then
      herdr workspace focus "$source_ws" >/dev/null
    fi
    echo "Closing herdr workspace: $workspace_id"
    herdr workspace close "$workspace_id" >/dev/null
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
