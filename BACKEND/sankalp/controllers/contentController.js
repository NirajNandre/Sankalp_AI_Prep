const pool = require('../config/database');
const { handleError } = require('../utils/errors');

const createContentUnit = async (req, res) => {
  try {
    const { chapter_id, unit_type, s3_url, duration_minutes } = req.body;
    const result = await pool.query(
      'INSERT INTO content_units (chapter_id, unit_type, s3_url, duration_minutes) VALUES ($1, $2, $3, $4) RETURNING *',
      [chapter_id, unit_type, s3_url, duration_minutes]
    );
    res.json(result.rows[0]);
  } catch (e) {
    handleError(res, 500, 'Failed to create content unit');
  }
};

const getContentUnits = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM content_units WHERE chapter_id = $1', [req.params.chapter_id]);
    res.json(result.rows);
  } catch (e) {
    handleError(res, 500, 'Failed to fetch content units');
  }
};

const createCurrentAffairs = async (req, res) => {
  try {
    const { title, content } = req.body;
    const result = await pool.query(
      'INSERT INTO current_affairs (title, content, date_published) VALUES ($1, $2, NOW()) RETURNING *',
      [title, content]
    );
    res.json(result.rows[0]);
  } catch (e) {
    handleError(res, 500, 'Failed to create current affairs');
  }
};

const getCurrentAffairs = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM current_affairs ORDER BY date_published DESC');
    res.json(result.rows);
  } catch (e) {
    handleError(res, 500, 'Failed to fetch current affairs');
  }
};

module.exports = { createContentUnit, getContentUnits, createCurrentAffairs, getCurrentAffairs };
