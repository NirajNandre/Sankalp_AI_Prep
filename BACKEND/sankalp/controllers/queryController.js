const pool = require('../config/database');
const { handleError } = require('../utils/errors');

const createQuery = async (req, res) => {
  try {
    const { assigned_mentor_id, related_content_unit_id, question_text } = req.body;
    const result = await pool.query(
      'INSERT INTO queries (student_id, assigned_mentor_id, related_content_unit_id, question_text, status, assigned_at) VALUES ($1, $2, $3, $4, $5, NOW()) RETURNING *',
      [req.user.user_id, assigned_mentor_id, related_content_unit_id, question_text, 'open']
    );
    res.json(result.rows[0]);
  } catch (e) {
    handleError(res, 500, 'Failed to create query');
  }
};

const getQueries = async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM queries WHERE student_id = $1 OR assigned_mentor_id = $1',
      [req.user.user_id]
    );
    res.json(result.rows);
  } catch (e) {
    handleError(res, 500, 'Failed to fetch queries');
  }
};

const createQueryResponse = async (req, res) => {
  try {
    const { query_id, mentor_response } = req.body;
    const result = await pool.query(
      'INSERT INTO query_responses (query_id, mentor_response, response_at) VALUES ($1, $2, NOW()) RETURNING *',
      [query_id, mentor_response]
    );
    res.json(result.rows[0]);
  } catch (e) {
    handleError(res, 500, 'Failed to create response');
  }
};

const getQueryResponses = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM query_responses WHERE query_id = $1', [req.params.query_id]);
    res.json(result.rows);
  } catch (e) {
    handleError(res, 500, 'Failed to fetch responses');
  }
};

module.exports = { createQuery, getQueries, createQueryResponse, getQueryResponses };
