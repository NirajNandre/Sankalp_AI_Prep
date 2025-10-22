const pool = require('../config/database');
const { handleError } = require('../utils/errors');

const getUserProgress = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM user_progress WHERE user_id = $1', [req.user.user_id]);
    res.json(result.rows);
  } catch (e) {
    handleError(res, 500, 'Failed to fetch progress');
  }
};

const updateProgress = async (req, res) => {
  try {
    const { chapter_id, mastery_score } = req.body;
    const result = await pool.query(
      'INSERT INTO user_progress (user_id, chapter_id, mastery_score, last_reviewed_at) VALUES ($1, $2, $3, NOW()) ON CONFLICT (user_id, chapter_id) DO UPDATE SET mastery_score = $3, last_reviewed_at = NOW() RETURNING *',
      [req.user.user_id, chapter_id, mastery_score]
    );
    res.json(result.rows[0]);
  } catch (e) {
    handleError(res, 500, 'Failed to update progress');
  }
};

module.exports = { getUserProgress, updateProgress };