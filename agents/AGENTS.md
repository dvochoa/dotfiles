# AGENTS.md

Start: say hi + 1 motivating line.
Work style: loose grammar; minimize tokens; educational but casual tone;
Personal relationship: Call me king

## Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.
- After implementation is complete, run the available simplification workflow.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## Agent Protocol
- “Make a note” => edit the active repository's `AGENTS.md`.
- Bugs: add regression test when it fits.
- Keep files <~500 LOC; split/refactor as needed.
- New deps: quick health check (recent releases/commits, adoption).
- Web: search early; quote exact errors; prefer sources from within the last 2 years
- Shell: ONE logical action per Bash call. Do NOT bundle multiple commands into a single call —
  this
  means no `&&`/`||`/`;` chains, no newline-joined sequences, and no `echo "=== label ==="`
  headers used to glue several `grep`/`ls`/`find`/`cat` inspections into one call for tidy output.
  Chaining is only acceptable for genuinely dependent steps that must share one shell (e.g.
  `cd x && build`). For
  several independent read-only checks, emit each as its OWN Bash call (send them in parallel in one
  message) so individually pre-approved commands skip the approval prompt and we move faster.
- Plan `.md` files: always write to `.agents/plans/` in the active project, never to `~/.agents/`.
- Markdown files: wrap prose lines at 100 characters; leave code blocks unwrapped.

## Critical Thinking
- Fix root cause (not band-aid).
- Unsure: read more code; if still stuck, ask w/ short options.
- Conflicts: call out; pick safer path.

## Evidence & Claims
- Do NOT make factual claims about third-party APIs, libraries, or services without citing
  documentation.
- When asked a technical question, verify with docs/source before asserting behavior (e.g., Supabase
  field normalization, Resend sender addresses).
- When giving a response that references documentation, provide a link to said documentation
- If unsure, say so explicitly rather than guessing

## Screenshots (“use a screenshot”)
- Pick newest PNG or JPG in `~/Desktop` or `~/Desktop`.
- Verify it’s the right UI (ignore filename).

## Imports
- Prefer absolute imports over relative imports unless the target is a sibling of the importing
  file.

## Docs
- Keep notes short; update docs when behavior/API changes (no ship w/o docs).

## Git Commits & PRs
- **The human decides what becomes a commit.** Not every finished piece of work is its own commit,
  and that call is not the agent's to make. Leave the work in the working tree, say what changed,
  and stop.
- **Never run `git commit`, `git push`, `git rebase`, or open a PR unless asked directly, in that
  message.** Not because a task looks done, not because a project's definition of done lists it,
  not because you were asked to commit something earlier in the session. "Commit this", "ship it",
  or `/ship` is the ask — a finished task is not. When in doubt, stop and say the work is ready.

Everything below is _how_ to do it once you have been asked. It is not a licence to do it
unprompted.

- One commit per PR. A task's implementation is a single commit — one _task_, not one commit per
  file touched.
- Commit subject: short imperative line (≤72 chars)
- PR title: short (≤70 chars)
- PR body: always include `## Description` (what + why) and `## Change Summary` mentioning affected
  files/components and their changes.
- After a push you were asked to make: if no PR exists for the branch, open one with the standard
  title + body. If a PR exists, update its description when the new commits materially change
  what's shipping.
- When you have been asked to ship review feedback, it goes in as a fixup commit
  (`git commit --fixup=<sha-of-the-PR's-commit>`), never a new standalone commit. Feedback
  arriving is not itself an ask — it changes what the code should be, not whether to publish it.
  Fixups stay separate on the branch so the reviewer can see what changed since their last look,
  then collapse on **squash and merge**. Do not rewrite or force-push a branch that is under
  review — the fixups are the audit trail until merge.
- When squash-merging, clear the `fixup!` lines out of GitHub's auto-generated commit message body;
  the merged commit should read as the original message alone.
- Do not append `claude.ai/code/session_*` backlinks (e.g. a `Claude-Session:` trailer or a bare
  session URL) to commit messages or PR bodies.

## Frontend Design
- Avoid “AI slop” UI. Be opinionated + distinctive.
- Unless starting from scratch, keep design consistent with the existing asthetic
- Typography: pick a real font; avoid Inter/Roboto/Arial/system defaults.
- Theme: commit to a palette; use CSS vars; bold accents > timid gradients.
- Motion: 1–2 high-impact moments (staggered reveal beats random micro-anim).
- Background: add depth (gradients/patterns), not flat default.
