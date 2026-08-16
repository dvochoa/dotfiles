# start-task — create a git worktree + tmux window and launch an agent in it.

# _start-task-help — print start-task usage/help
_start-task-help() {
  cat <<'EOF'
start-task — create a git worktree + tmux window and launch claude in it

USAGE
  start-task <branch> ["<task>"] [-m|--mode plan|auto] [-a|--agent claude|codex]

ARGUMENTS
  <branch>        Name of the new branch and sibling worktree (required, first arg).
  <task>          Optional initial prompt handed to the agent. Quote if it has spaces.

OPTIONS
  -m, --mode <m>  Task mode (default: auto). Translated per agent:
                    plan   claude: --permission-mode plan
                           codex:  --sandbox read-only
                    auto   claude: --permission-mode acceptEdits
                           codex:  --sandbox workspace-write --ask-for-approval on-request
  -a, --agent <a> Agent to launch (default: claude). One of: claude, codex.
  -h, --help      Show this help and exit.

EXAMPLES
  start-task fix-login
  start-task fix-login "diagnose the 500 on /login"
  start-task fix-login "refactor auth" -m plan
  start-task fix-login "port to codex" -a codex -m plan

Must be run inside a tmux session. Opens a window split into three panes:
vim (left), the agent (top-right), and a terminal (bottom-right).
EOF
}

# start-task <branch> ["<task>"] [-m plan|auto] [-a claude|codex] — worktree + tmux window + agent
#   -m, --mode   task mode: "auto" (default) or "plan"
#   -a, --agent  which agent to launch: "claude" (default) or "codex"
#   -h, --help   show usage and exit
start-task() {
  # Show help before any guards, so `start-task --help` works outside tmux
  case "$1" in
    -h|--help)
      _start-task-help
      return 0
      ;;
  esac

  # Bail if not inside a tmux session
  if [[ -z "$TMUX" ]]; then
    echo "start-task: must be run inside a tmux session"
    return 1
  fi

  # Branch is always the first positional arg
  local branch="$1"

  # Bail early if branch is missing
  if [[ -z "$branch" ]]; then
    echo "Usage: start-task <branch-name> [\"<task>\"] [-m plan|auto] [-a claude|codex]  (see --help)"
    return 1
  fi
  shift

  # Parse the remaining args: an optional task string plus -m/--mode and -a/--agent flags
  local task=""
  local mode="auto"      # default task mode
  local agent="claude"   # default agent
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        _start-task-help
        return 0
        ;;
      -m|--mode)
        mode="$2"
        shift 2
        ;;
      -a|--agent)
        agent="$2"
        shift 2
        ;;
      *)
        task="$1"
        shift
        ;;
    esac
  done

  # Validate the friendly mode name (agent-agnostic)
  case "$mode" in
    plan|auto) ;;
    *)
      echo "start-task: invalid mode '$mode' (expected 'plan' or 'auto')"
      return 1
      ;;
  esac

  # Translate (agent, mode) into the concrete launch command.
  # claude takes one --permission-mode; codex splits the same idea across
  # --sandbox (what it can touch) and --ask-for-approval (when it pauses).
  local launch_cmd
  case "$agent" in
    claude)
      local permission_mode
      [[ "$mode" == "plan" ]] && permission_mode="plan" || permission_mode="acceptEdits"
      launch_cmd="claude --permission-mode $permission_mode"
      ;;
    codex)
      if [[ "$mode" == "plan" ]]; then
        # read-only: codex can analyze but not edit — mirrors "plan first"
        launch_cmd="codex --sandbox read-only"
      else
        # workspace-write + on-request: edits freely, asks before escalating
        launch_cmd="codex --sandbox workspace-write --ask-for-approval on-request"
      fi
      ;;
    *)
      echo "start-task: invalid agent '$agent' (expected 'claude' or 'codex')"
      return 1
      ;;
  esac

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
  # Split the right column so the bottom terminal pane (pane 2) takes 1/3, claude keeps 2/3
  command tmux split-window -t ":${branch}.1" -v -p 33 -c "$worktree_path"
  # Wait for shells to initialize (oh-my-zsh, etc.) before sending keystrokes
  sleep 2
  # Type "vim ." into the left pane and press Enter
  command tmux send-keys -t ":${branch}.0" "vim ." Enter
  # Append the task as a positional prompt if one was provided (both agents accept this)
  [[ -n "$task" ]] && launch_cmd+=" $(printf '%q' "$task")"
  # Type the agent command into the top-right pane
  command tmux send-keys -t ":${branch}.1" "$launch_cmd" Enter
  # Move focus to the agent pane
  command tmux select-pane -t ":${branch}.1"
  echo "Spawned '$branch' → $worktree_path"
}
