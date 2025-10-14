const pool = require('../config/database');
const { handleError } = require('../utils/errors');

const getProfile = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM mentor_profiles WHERE user_id = $1', [req.params.id]);
    res.json(result.rows[0] || null);
  } catch (e) {
    handleError(res, 500, 'Failed to fetch profile');
  }
};

const updateProfile = async (req, res) => {
  try {
    const { specialization, bio } = req.body;
    const result = await pool.query(
      'UPDATE mentor_profiles SET specialization = $1, bio = $2 WHERE user_id = $3 RETURNING *',
      [specialization, bio, req.user.user_id]
    );
    res.json(result.rows[0]);
  } catch (e) {
    handleError(res, 500, 'Failed to update profile');
  }
};