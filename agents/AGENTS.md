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
- Commit subject: short imperative line (≤72 chars)
- PR title: short (≤70 chars)
- PR body: always include `## Description` (what + why) and `## Change Summary` mentioning affected
  files/components and their changes.
- After pushing: if no PR exists for the branch, open one with the standard title + body. If a PR
  exists, update its description when the new commits materially change what's shipping.

## Frontend Design
- Avoid “AI slop” UI. Be opinionated + distinctive.
- Unless starting from scratch, keep design consistent with the existing asthetic
- Typography: pick a real font; avoid Inter/Roboto/Arial/system defaults.
- Theme: commit to a palette; use CSS vars; bold accents > timid gradients.
- Motion: 1–2 high-impact moments (staggered reveal beats random micro-anim).
- Background: add depth (gradients/patterns), not flat default.
