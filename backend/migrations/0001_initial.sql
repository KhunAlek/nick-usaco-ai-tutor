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

INSERT INTO lessons(id,lesson_type,title,instructions,required_evidence_json,source_lesson_id,scheduled_date,created_at)
VALUES(
  'bootstrap-next-lesson',
  'NORMAL',
  'Next two-pointer transfer lesson',
  'Read the complete problem, state the technique and why before coding, then solve independently. This placeholder must be replaced by the verified next lesson selected from Nick’s current learning record.',
  '["Python code","Technique and reasoning before code","Tests run","Judge result"]',
  NULL,
  date('now'),
  datetime('now')
);

INSERT INTO learning_days(id,learner_id,learning_date,lesson_id,status,outcome,created_at)
VALUES('bootstrap-day','nick',date('now'),'bootstrap-next-lesson','OPEN',NULL,datetime('now'));
