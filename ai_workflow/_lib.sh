# Shared helpers for the AI task workflow.

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
