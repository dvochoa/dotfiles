Commit all changes, push to remote, and create or update the PR description.

Steps:
1. Run `git status` and `git diff` to review what's changed.
2. Stage and commit any unstaged changes using a concise imperative commit message (≤72 chars).
   - Skip if there's nothing to commit.
3. Push the current branch to remote (with `-u` if no upstream is set yet).
4. Check if a PR already exists for this branch (`gh pr view`).
   - If yes: update its title and body with `gh pr edit` to reflect the current diff vs main.
   - If no: create one with `gh pr create` using the standard title + body format.
5. Output the PR URL.

PR body format:
## Description
[what changed and why]

## Change Summary
[bullet list of affected files/components and their changes]
