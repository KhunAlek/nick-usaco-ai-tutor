# Nick USACO AI Tutor

A deliberately small, single-student tutoring system for Nick's USACO preparation.

## Product goal

Each learning day:

1. Nick opens today's lesson.
2. Nick submits his Python code, written answers, tests, and judge evidence.
3. AI evaluates the actual submission.
4. The system saves one of three outcomes:
   - `PASSED` — close the day and prepare the next normal lesson.
   - `SMALL_CORRECTION` — generate same-day targeted support, keep the day open, and require resubmission.
   - `REPAIR_NEEDED` — close the day without passing the skill and make a generated repair lesson the next learning day's lesson.

## v0.1 boundary

Build only the complete vertical slice:

`today's lesson -> submission -> AI evaluation -> saved outcome -> correct next action`

No curriculum fingerprints, reconciliation system, candidate workflow, release machinery, or lesson-unlock engine.

## Starting learner record

- Session 9 — Ferris Wheel: completed and accepted.
- Session 10: completed; exact evidence will be imported from the verified historical record.
- Session 11: withdrawn because of material/curriculum failure, with no negative learner record.

This repository starts clean and reuses only the useful technical patterns from `KhunAlek/nick-worldmaker`: server-side OpenAI evaluation, structured responses, D1 persistence, learner login, submission history, and parent view.
