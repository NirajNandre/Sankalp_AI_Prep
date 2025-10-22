const pool = require('../config/database');
const { handleError } = require('../utils/errors');

const register = async (req, res) => {
  try {
    const { email, password, full_name, role } = req.body;
    
    const result = await pool.query(
      'INSERT INTO users (email, password, full_name, role) VALUES ($1, $2, $3, $4) RETURNING user_id, email',
      [email, password, full_name, role]
    );
    
    const userId = result.rows[0].user_id;
    
    if (role === 'Student') {
      await pool.query(
        'INSERT INTO student_profiles (user_id, target_exam, current_xp, current_level, current_streak) VALUES ($1, $2, $3, $4, $5)',
        [userId, null, 0, 1, 0]
      );
    } else if (role === 'Mentor') {
      await pool.query(
        'INSERT INTO mentor_profiles (user_id, specialization, bio) VALUES ($1, $2, $3)',
        [userId, null, null]
      );
    }
    
    res.json({ user_id: userId, email: result.rows[0].email });
  } catch (e) {
    handleError(res, 400, 'Registration failed');
  }
};

const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
    
    if (!user.rows[0]) return handleError(res, 401, 'Invalid credentials');
    if (password !== user.rows[0].password) return handleError(res, 401, 'Invalid credentials');
    
    res.json({ user_id: user.rows[0].user_id, email: user.rows[0].email });
  } catch (e) {
    handleError(res, 500, 'Login failed');
  }
};

module.exports = { register, login };