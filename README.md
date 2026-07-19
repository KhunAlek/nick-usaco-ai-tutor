# Nick USACO AI Tutor

A deliberately small, single-student tutoring system for Nick's USACO preparation.

## Product goal

Each learning day:

1. Nick opens today's lesson.
2. Nick submits his Python code, written answers, tests, and judge evidence.
3. AI evaluates the actual submission.
4. The system saves one of three outcomes:
   - `PASSED` — close the day; the next normal lesson is selected separately from verified learning evidence.
   - `SMALL_CORRECTION` — generate same-day targeted support, keep the day open, and require resubmission.
   - `REPAIR_NEEDED` — close the day without passing the skill and make a generated repair lesson the next learning day's lesson.

## v0.1 boundary

Build only the complete vertical slice:

`today's lesson -> submission -> AI evaluation -> saved outcome -> correct next action`

No curriculum fingerprints, reconciliation system, candidate workflow, release machinery, or lesson-unlock engine.

## Verified starting learner state

- Session 10 — `Reactor Pairing`: completed with full credit.
- Nick independently used an efficient `Counter` frequency-counting solution.
- Independence rating: 3 — Independent.
- The intended sorting plus opposite-end two-pointer reconstruction remains unverified because Nick used a valid alternative.
- No Session 10 repair or retest is required.
- Session 11 — `S11-sum-of-three-values`: withdrawn and invalidated after a material/curriculum failure.
- Nick has no responsibility or penalty for the withdrawn lesson.
- No current lesson is scheduled or invented by this repository.
- The maximum academically permitted next stage is `REBUILD` for independent sorting plus opposite-end two-pointer reconstruction.

Until a real lesson is deliberately selected and added, `/api/today` returns a truthful waiting state and the learner page hides the submission form.

## Technical foundation

This repository reuses only useful technical patterns from `KhunAlek/nick-worldmaker`:

- server-side OpenAI evaluation;
- strict structured responses;
- D1 persistence;
- learner history;
- the learner submission interface.

It does not inherit Worldmaker's mission content, fixed unlock sequence, release manifests, state-reconciliation machinery, or governance archive.
