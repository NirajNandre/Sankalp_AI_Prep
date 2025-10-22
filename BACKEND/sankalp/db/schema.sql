CREATE TABLE IF NOT EXISTS users (
  user_id SERIAL PRIMARY KEY,
  email VARCHAR UNIQUE,
  full_name VARCHAR,
  role VARCHAR,
  password VARCHAR
);

CREATE TABLE IF NOT EXISTS student_profiles (
  user_id INT PRIMARY KEY REFERENCES users(user_id),
  target_exam VARCHAR,
  current_xp INT,
  current_level INT,
  current_streak INT
);

CREATE TABLE IF NOT EXISTS mentor_profiles (
  user_id INT PRIMARY KEY REFERENCES users(user_id),
  specialization VARCHAR,
  bio TEXT
);

CREATE TABLE IF NOT EXISTS courses (
  course_id SERIAL PRIMARY KEY,
  course_name VARCHAR,
  mentor_id INT REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS chapters (
  chapter_id SERIAL PRIMARY KEY,
  course_id INT REFERENCES courses(course_id),
  chapter_number INT,
  title VARCHAR
);

CREATE TABLE IF NOT EXISTS content_units (
  unit_id SERIAL PRIMARY KEY,
  chapter_id INT REFERENCES chapters(chapter_id),
  unit_type VARCHAR,
  s3_url VARCHAR,
  duration_minutes INT
);

CREATE TABLE IF NOT EXISTS current_affairs (
  ca_id SERIAL PRIMARY KEY,
  title VARCHAR,
  content TEXT,
  date_published TIMESTAMP
);

CREATE TABLE IF NOT EXISTS questions (
  question_id SERIAL PRIMARY KEY,
  chapter_id INT REFERENCES chapters(chapter_id),
  text TEXT,
  correct_option VARCHAR,
  difficulty VARCHAR,
  is_pyq BOOLEAN
);

CREATE TABLE IF NOT EXISTS quiz_attempts (
  attempt_id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(user_id),
  quiz_type VARCHAR,
  source_unit_id INT,
  score INT,
  time_taken INT,
  completed_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS attempt_details (
  detail_id SERIAL PRIMARY KEY,
  attempt_id INT REFERENCES quiz_attempts(attempt_id),
  question_id INT REFERENCES questions(question_id),
  user_answer VARCHAR,
  is_correct BOOLEAN
);

CREATE TABLE IF NOT EXISTS user_progress (
  progress_id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(user_id),
  chapter_id INT REFERENCES chapters(chapter_id),
  mastery_score INT,
  last_reviewed_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS queries (
  query_id SERIAL PRIMARY KEY,
  student_id INT REFERENCES users(user_id),
  assigned_mentor_id INT REFERENCES users(user_id),
  related_content_unit_id INT REFERENCES content_units(unit_id),
  question_text TEXT,
  status VARCHAR,
  assigned_at TIMESTAMP,
  resolved_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS query_responses (
  response_id SERIAL PRIMARY KEY,
  query_id INT REFERENCES queries(query_id),
  mentor_response TEXT,
  response_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS scheduled_sessions (
  schedule_id SERIAL PRIMARY KEY,
  session_type VARCHAR,
  host_user_id INT REFERENCES users(user_id),
  topic VARCHAR,
  related_chapter_id INT REFERENCES chapters(chapter_id),
  scheduled_time TIMESTAMP,
  session_status VARCHAR
);

CREATE TABLE IF NOT EXISTS session_participants (
  participant_id SERIAL PRIMARY KEY,
  schedule_id INT REFERENCES scheduled_sessions(schedule_id),
  participant_user_id INT REFERENCES users(user_id),
  is_mentor BOOLEAN
);

CREATE TABLE IF NOT EXISTS session_results (
  result_id SERIAL PRIMARY KEY,
  schedule_id INT REFERENCES scheduled_sessions(schedule_id),
  audio_s3_url VARCHAR,
  transcript_s3_url VARCHAR,
  ai_assessment JSON,
  mentor_notes TEXT,
  completed_at TIMESTAMP
);