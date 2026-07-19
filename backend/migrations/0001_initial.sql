PRAGMA foreign_keys = ON;

CREATE TABLE learning_days (
  id TEXT PRIMARY KEY,
  learner_id TEXT NOT NULL,
  learning_date TEXT NOT NULL,
  lesson_id TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('OPEN','CLOSED')),
  outcome TEXT CHECK (outcome IN ('PASSED','SMALL_CORRECTION','REPAIR_NEEDED')),
  created_at TEXT NOT NULL,
  closed_at TEXT,
  UNIQUE (learner_id, learning_date)
);

CREATE TABLE lessons (
  id TEXT PRIMARY KEY,
  lesson_type TEXT NOT NULL CHECK (lesson_type IN ('NORMAL','SUPPORT','REPAIR')),
  title TEXT NOT NULL,
  instructions TEXT NOT NULL,
  required_evidence_json TEXT NOT NULL,
  source_lesson_id TEXT,
  scheduled_date TEXT,
  created_at TEXT NOT NULL
);

CREATE TABLE submissions (
  id TEXT PRIMARY KEY,
  learning_day_id TEXT NOT NULL REFERENCES learning_days(id),
  lesson_id TEXT NOT NULL REFERENCES lessons(id),
  attempt_number INTEGER NOT NULL,
  code TEXT NOT NULL,
  explanation TEXT NOT NULL,
  tests TEXT NOT NULL,
  judge_evidence TEXT NOT NULL,
  created_at TEXT NOT NULL,
  UNIQUE (learning_day_id, attempt_number)
);

CREATE TABLE evaluations (
  id TEXT PRIMARY KEY,
  submission_id TEXT NOT NULL UNIQUE REFERENCES submissions(id),
  outcome TEXT NOT NULL CHECK (outcome IN ('PASSED','SMALL_CORRECTION','REPAIR_NEEDED')),
  response_json TEXT NOT NULL,
  evaluator_version TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE learner_history (
  id TEXT PRIMARY KEY,
  learner_id TEXT NOT NULL,
  event_type TEXT NOT NULL,
  lesson_id TEXT,
  learning_day_id TEXT,
  details_json TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE learner_state (
  learner_id TEXT PRIMARY KEY,
  last_valid_completed_session INTEGER NOT NULL,
  last_valid_lesson_id TEXT NOT NULL,
  current_lesson_id TEXT,
  learner_status TEXT NOT NULL CHECK (learner_status IN ('WAITING_FOR_LESSON','LESSON_OPEN')),
  target_skill_id TEXT NOT NULL,
  maximum_next_stage TEXT NOT NULL,
  notes_json TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE invalidated_lessons (
  lesson_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  invalidated_on TEXT NOT NULL,
  failure_classes_json TEXT NOT NULL,
  student_responsibility TEXT NOT NULL,
  blocked_from_reuse INTEGER NOT NULL CHECK (blocked_from_reuse IN (0,1)),
  reason_json TEXT NOT NULL
);

INSERT INTO learner_state(
  learner_id,last_valid_completed_session,last_valid_lesson_id,current_lesson_id,
  learner_status,target_skill_id,maximum_next_stage,notes_json,updated_at
) VALUES(
  'nick',
  10,
  'S10-reactor-pairing',
  NULL,
  'WAITING_FOR_LESSON',
  'sorting_opposite_end_two_pointer_reconstruction',
  'REBUILD',
  '{"session_10_credit":"full","session_10_solution":"Counter frequency counting","independence_rating":3,"expected_two_pointer_rebuild_verified":false,"repair_required":false,"retest_required":false,"next_lesson_authorized":false}',
  '2026-07-18T00:00:00Z'
);

INSERT INTO invalidated_lessons(
  lesson_id,title,invalidated_on,failure_classes_json,student_responsibility,blocked_from_reuse,reason_json
) VALUES(
  'S11-sum-of-three-values',
  'The Three-Signal Search / Sum of Three Values',
  '2026-07-16',
  '["D","E"]',
  'none',
  1,
  '["Advanced to Recognise without verified reconstruction","Introduced an untaught composite three-value model","Material and workflow failure caused frustration","Withdrawn evidence cannot affect progress"]'
);

INSERT INTO learner_history(id,learner_id,event_type,lesson_id,learning_day_id,details_json,created_at)
VALUES
  (
    'history-session-10-completed',
    'nick',
    'SESSION_COMPLETED',
    'S10-reactor-pairing',
    NULL,
    '{"session_number":10,"student_credit":"full","correctness":"verified_correct","solution_technique":"Counter frequency counting","expected_technique":"sorting plus opposite-end two pointers","expected_technique_demonstrated":false,"independence_rating":3,"repair_required":false,"retest_required":false}',
    '2026-07-15T00:00:00Z'
  ),
  (
    'history-session-11-invalidated',
    'nick',
    'LESSON_INVALIDATED',
    'S11-sum-of-three-values',
    NULL,
    '{"student_responsibility":"none","student_penalty_allowed":false,"can_affect_progress":false,"blocked_from_reuse":true}',
    '2026-07-16T00:00:00Z'
  );
