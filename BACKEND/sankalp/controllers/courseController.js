const pool = require('../config/database');
const { handleError } = require('../utils/errors');

const createCourse = async (req, res) => {
  try {
    const { course_name } = req.body;
    const result = await pool.query(
      'INSERT INTO courses (course_name, mentor_id) VALUES ($1, $2) RETURNING *',
      [course_name, req.user.user_id]
    );
    res.json(result.rows[0]);
  } catch (e) {
    handleError(res, 500, 'Failed to create course');
  }
};

const getCourse = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM courses WHERE course_id = $1', [req.params.id]);
    res.json(result.rows[0]);
  } catch (e) {
    handleError(res, 500, 'Failed to fetch course');
  }
};

const createChapter = async (req, res) => {
  try {
    const { course_id, chapter_number, title } = req.body;
    const result = await pool.query(
      'INSERT INTO chapters (course_id, chapter_number, title) VALUES ($1, $2, $3) RETURNING *',
      [course_id, chapter_number, title]
    );
    res.json(result.rows[0]);
  } catch (e) {
    handleError(res, 500, 'Failed to create chapter');
  }
};

const getChapters = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM chapters WHERE course_id = $1', [req.params.course_id]);
    res.json(result.rows);
  } catch (e) {
    handleError(res, 500, 'Failed to fetch chapters');
  }
};

module.exports = { createCourse, getCourse, createChapter, getChapters };