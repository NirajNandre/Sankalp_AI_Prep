const pool = require('../config/database');
const { handleError } = require('../utils/errors');

const createQuestion = async (req, res) => {
  try {
    const { chapter_id, text, correct_option, difficulty, is_pyq } = req.body;
    const result = await pool.query(
      'INSERT INTO questions (chapter_id, text, correct_option, difficulty, is_pyq) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [chapter_id, text, correct_option, difficulty, is_pyq]
    );
    res.json(result.rows[0]);
  } catch (e) {
    handleError(res, 500, 'Failed to create question');
  }
};

const getQuestions = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM questions WHERE chapter_id = $1', [req.params.chapter_id]);
    res.json(result.rows);
  } catch (e) {
    handleError(res, 500, 'Failed to fetch questions');
  }
};

const createQuizAttempt = async (req, res) => {
  try {
    const { quiz_type, source_unit_id, score, time_taken } = req.body;
    const result = await pool.query(
      'INSERT INTO quiz_attempts (user_id, quiz_type, source_unit_id, score, time_taken, completed_at) VALUES ($1, $2, $3, $4, $5, NOW()) RETURNING *',
      [req.user.user_id, quiz_type, source_unit_id, score, time_taken]
    );
    res.json(result.rows[0]);
  } catch (e) {
    handleError(res, 500, 'Failed to create quiz attempt');
  }
};

const getQuizAttempts = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM quiz_attempts WHERE user_id = $1', [req.user.user_id]);
    res.json(result.rows);
  } catch (e) {
    handleError(res, 500, 'Failed to fetch quiz attempts');
  }
};

const createAttemptDetail = async (req, res) => {
  try {
    const { attempt_id, question_id, user_answer, is_correct } = req.body;
    const result = await pool.query(
      'INSERT INTO attempt_details (attempt_id, question_id, user_answer, is_correct) VALUES ($1, $2, $3, $4) RETURNING *',
      [attempt_id, question_id, user_answer, is_correct]
    );
    res.json(result.rows[0]);
  } catch (e) {
    handleError(res, 500, 'Failed to create attempt detail');
  }
};

const getAttemptDetails = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM attempt_details WHERE attempt_id = $1', [req.params.attempt_id]);
    res.json(result.rows);
  } catch (e) {
    handleError(res, 500, 'Failed to fetch attempt details');
  }
};

module.exports = { createQuestion, getQuestions, createQuizAttempt, getQuizAttempts, createAttemptDetail, getAttemptDetails };
