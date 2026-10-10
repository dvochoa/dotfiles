# start-task — create a herdr worktree workspace and launch an agent in it.

# _start-task-help — print start-task usage/help
_start-task-help() {
  cat <<'EOF'
start-task — create a herdr worktree workspace and launch claude in it

USAGE
  start-task <branch> ["<task>"] [-m|--mode plan|auto] [-a|--agent claude|codex]

ARGUMENTS
  <branch>        Name of the new branch and worktree (required, first arg).
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

Must be run inside herdr. The worktree lands in herdr's [worktrees] directory and
opens as its own workspace split into three panes: nvim (left), the agent
(top-right), and a terminal (bottom-right). Focus moves to the agent.
EOF
}

# start-task <branch> ["<task>"] [-m plan|auto] [-a claude|codex] — worktree workspace + agent
#   -m, --mode   task mode: "auto" (default) or "plan"
#   -a, --agent  which agent to launch: "claude" (default) or "codex"
#   -h, --help   show usage and exit
start-task() {
  # Show help before any guards, so `start-task --help` works outside herdr
  case "$1" in
    -h|--help)
      _start-task-help
      return 0
      ;;
  esac

  # Bail if not inside a herdr pane
  if [[ "$HERDR_ENV" != 1 ]]; then
    echo "start-task: must be run inside herdr"
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

  # Translate (agent, mode) into native agent args.
  # claude takes one --permission-mode; codex splits the same idea across
  # --sandbox (what it can touch) and --ask-for-approval (when it pauses).
  local agent_args=()
  case "$agent" in
    claude)
      [[ "$mode" == "plan" ]] && agent_args=(--permission-mode plan) || agent_args=(--permission-mode acceptEdits)
      ;;
    codex)
      if [[ "$mode" == "plan" ]]; then
        # read-only: codex can analyze but not edit — mirrors "plan first"
        agent_args=(--sandbox read-only)
      else
        # workspace-write + on-request: edits freely, asks before escalating
        agent_args=(--sandbox workspace-write --ask-for-approval on-request)
      fi
      ;;
    *)
      echo "start-task: invalid agent '$agent' (expected 'claude' or 'codex')"
      return 1
      ;;
  esac
  # Append the task as a positional prompt if one was provided (both agents accept this)
  [[ -n "$task" ]] && agent_args+=("$task")

  local repo_root
  repo_root=$(_get_repo_root) || return 1

  # Let herdr create the git worktree + branch and open it as a new workspace.
  # --no-focus keeps us here until the panes are ready; we switch at the end.
  local created
  created=$(herdr worktree create --cwd "$repo_root" --branch "$branch" --label "$branch" --no-focus) || return 1

  local worktree_path workspace_id vim_pane
  worktree_path=$(jq -r '.result.worktree.path' <<<"$created")
  workspace_id=$(jq -r '.result.workspace.workspace_id' <<<"$created")
  vim_pane=$(jq -r '.result.root_pane.pane_id' <<<"$created")

  # Right column takes 40% of the width (--ratio is the share the original pane keeps)
  local agent_pane
  agent_pane=$(herdr pane split "$vim_pane" --direction right --ratio 0.6 --cwd "$worktree_path" --no-focus \
    | jq -r '.result.pane.pane_id') || return 1
  # Bottom terminal takes 1/3 of the right column, the agent keeps 2/3
  herdr pane split "$agent_pane" --direction down --ratio 0.67 --cwd "$worktree_path" --no-focus >/dev/null || return 1

  herdr pane run "$vim_pane" "nvim ."

  # Agent names must match [a-z][a-z0-9_-]{0,31}: lowercase, swap other chars for -, cap at 32
  local agent_name="${${branch:l}//[^a-z0-9_-]/-}"
  [[ "$agent_name" == [a-z]* ]] || agent_name="t-$agent_name"
  agent_name="${agent_name[1,32]}"

  # agent start blocks until herdr detects the agent and it's ready for input
  herdr agent start "$agent_name" --kind "$agent" --pane "$agent_pane" -- "${agent_args[@]}" >/dev/null || return 1

  # Switch to the new workspace with the agent pane focused
  herdr workspace focus "$workspace_id" >/dev/null
  herdr agent focus "$agent_name" >/dev/null
  echo "Spawned '$branch' → $worktree_path"
}
