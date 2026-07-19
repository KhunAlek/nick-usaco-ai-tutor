import test from "node:test";
import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";

const migrationUrl = new URL("../migrations/0001_initial.sql", import.meta.url);

async function migration() {
  return readFile(migrationUrl, "utf8");
}

test("verified learner state preserves Session 10 full credit", async () => {
  const sql = await migration();
  assert.match(sql, /'S10-reactor-pairing'/);
  assert.match(sql, /"student_credit":"full"/);
  assert.match(sql, /"solution_technique":"Counter frequency counting"/);
  assert.match(sql, /"independence_rating":3/);
  assert.match(sql, /"repair_required":false/);
  assert.match(sql, /"retest_required":false/);
});

test("no placeholder or active lesson is seeded", async () => {
  const sql = await migration();
  assert.doesNotMatch(sql, /bootstrap-next-lesson/);
  assert.doesNotMatch(sql, /INSERT INTO learning_days/i);
  assert.match(sql, /'WAITING_FOR_LESSON'/);
  assert.match(sql, /"next_lesson_authorized":false/);
});

test("withdrawn Session 11 is blocked from reuse and cannot penalize Nick", async () => {
  const sql = await migration();
  assert.match(sql, /'S11-sum-of-three-values'/);
  assert.match(sql, /'none',\n  1,/);
  assert.match(sql, /"student_penalty_allowed":false/);
  assert.match(sql, /"can_affect_progress":false/);
});

test("next curriculum stage cannot skip unverified rebuild", async () => {
  const sql = await migration();
  assert.match(sql, /'sorting_opposite_end_two_pointer_reconstruction'/);
  assert.match(sql, /'REBUILD'/);
  assert.match(sql, /"expected_two_pointer_rebuild_verified":false/);
});
