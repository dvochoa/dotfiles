# --- Parallel AI task workflow loader ---
# Sourced from ~/.zshrc via the ~/ai_workflow.sh symlink. Finds its own real
# location (following that symlink) and sources the split command files from the
# sibling ai_workflow/ directory.

# Figure out where this file really lives. When a file is sourced, $0 is its
# path — here ~/ai_workflow.sh, which is a symlink into the repo. Two zsh
# modifiers turn that into the directory we want:
#   :A  resolve the symlink to a real, absolute path
#   :h  strip to the containing directory (like `dirname`)
_ai_workflow_repo_dir="${0:A:h}"
_ai_workflow_dir="$_ai_workflow_repo_dir/ai_workflow"

# Source every command file. (N) is a null-glob qualifier: if the directory is
# empty the pattern expands to nothing instead of erroring.
for _ai_workflow_file in "$_ai_workflow_dir"/*.sh(N); do
  source "$_ai_workflow_file"
done
unset _ai_workflow_repo_dir _ai_workflow_dir _ai_workflow_file
