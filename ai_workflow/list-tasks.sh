# list-tasks — show all active worktrees.

# _list-tasks-help — print list-tasks usage/help
_list-tasks-help() {
  cat <<'EOF'
list-tasks — list the active task worktrees for the current repo

USAGE
  list-tasks

OPTIONS
  -h, --help Show this help and exit.

Prints one line per worktree (path, HEAD commit, branch), including the main
checkout. A thin wrapper around `git worktree list`.
EOF
}

# list-tasks — show all active worktrees
#   -h, --help  show usage and exit
list-tasks() {
  case "$1" in
    -h|--help)
      _list-tasks-help
      return 0
      ;;
  esac

  local repo_root
  repo_root=$(_get_repo_root) || return 1
  # Print all worktrees for this repo (path, HEAD commit, branch name)
  git -C "$repo_root" worktree list
}
