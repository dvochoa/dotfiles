Review feedback on the current PR, incorporate it, then ship the changes.

Steps:
1. Run `gh pr view --comments` and `gh pr view --json reviews` to collect all review comments and inline feedback.
2. Read the current diff (`git diff main...HEAD`) to understand what's already changed.
3. For each piece of feedback, make the necessary code changes. Group related changes into logical commits.
4. Once all feedback is addressed, use /ship to commit, push, and update the PR.

Notes:
- If feedback is ambiguous or contradictory, flag it and ask before changing code.
- Do not close or merge the PR.
