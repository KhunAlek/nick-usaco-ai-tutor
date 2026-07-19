import test from "node:test";
import assert from "node:assert/strict";
import { validateEvaluation } from "../src/index.js";

function base(outcome, failureClass, generatedLesson) {
  return {
    outcome,
    attempt_number: 1,
    headline: "Result",
    explanation: "Explanation",
    next_action: "Next action",
    correctness: "Checked",
    efficiency: "Checked",
    technique_used: "Two pointers",
    technique_intended: "Two pointers",
    independence: 3,
    testing_quality: "Checked",
    debugging: "Checked",
    failure_class: failureClass,
    generated_lesson: generatedLesson
  };
}

const generated = {
  title: "Targeted lesson",
  instructions: "Trace the failing case and correct the decision rule without copying a finished program.",
  required_evidence: ["Corrected code", "Trace", "Retest result"]
};

test("passed closes without generating another lesson", () => {
  assert.doesNotThrow(() => validateEvaluation(base("PASSED", null, null), 1));
});

test("small correction requires same-day support lesson", () => {
  assert.doesNotThrow(() => validateEvaluation(base("SMALL_CORRECTION", "B", generated), 1));
  assert.throws(() => validateEvaluation(base("SMALL_CORRECTION", "B", null), 1), /generated lesson/);
});

test("repair requires a conceptual, material, or overload failure class", () => {
  assert.doesNotThrow(() => validateEvaluation(base("REPAIR_NEEDED", "C", generated), 1));
  assert.throws(() => validateEvaluation(base("REPAIR_NEEDED", "A", generated), 1), /incompatible/);
});

test("passed result cannot silently create a lesson", () => {
  assert.throws(() => validateEvaluation(base("PASSED", null, generated), 1), /cannot generate/);
});

test("attempt number must match server attempt", () => {
  assert.throws(() => validateEvaluation(base("PASSED", null, null), 2), /mismatch/);
});
