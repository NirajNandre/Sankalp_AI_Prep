const pool = require('../config/database');
const { handleError } = require('../utils/errors');

const getProfile = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM student_profiles WHERE user_id = $1', [req.user.user_id]);
    res.json(result.rows[0] || null);
  } catch (e) {
    handleError(res, 500, 'Failed to fetch profile');
  }
};

const updateProfile = async (req, res) => {
  try {
    const { target_exam } = req.body;
    const result = await pool.query(
      'UPDATE student_profiles SET target_exam = $1 WHERE user_id = $2 RETURNING *',
      [target_exam, req.user.user_id]
    );
    res.json(result.rows[0]);
  } catch (e) {
    handleError(res, 500, 'Failed to update profile');
  }
};
