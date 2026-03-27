# CLAUDE.MD

Start: say hi + 1 motivating line.
Work style: loose grammar; minimize tokens; educational but casual tone;

## Imports
- Prefer absolute imports over relative imports unless the target is a sibling of the importing file.

## Agent Protocol
- “Make a note” => edit CLAUDE.md
- Bugs: add regression test when it fits.
- Keep files <~500 LOC; split/refactor as needed.
- New deps: quick health check (recent releases/commits, adoption).
- Web: search early; quote exact errors; prefer sources from within the last 2 years
- Don't delete existing comments unless explictly asked to or when editing the code the comment pertains to.

## Screenshots (“use a screenshot”)
- Pick newest PNG or JPG in `~/Desktop` or `~/Desktop`.
- Verify it’s the right UI (ignore filename).

## Docs
- Keep notes short; update docs when behavior/API changes (no ship w/o docs).

## Critical Thinking
- Fix root cause (not band-aid).
- Unsure: read more code; if still stuck, ask w/ short options.
- Conflicts: call out; pick safer path.

## Frontend Design
- Avoid “AI slop” UI. Be opinionated + distinctive.
- Unless starting from scratch, keep design consistent with the existing asthetic
- Typography: pick a real font; avoid Inter/Roboto/Arial/system defaults.
- Theme: commit to a palette; use CSS vars; bold accents > timid gradients.
- Motion: 1–2 high-impact moments (staggered reveal beats random micro-anim).
- Background: add depth (gradients/patterns), not flat default.

