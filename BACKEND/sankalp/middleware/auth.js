const pool = require('../config/database');
const { handleError } = require('../utils/errors');

const auth = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    
    if (!email || !password) {
      return handleError(res, 400, 'Email and password required');
    }
    
    const user = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
    
    if (!user.rows[0]) {
      return handleError(res, 401, 'Invalid credentials');
    }
    
    if (password !== user.rows[0].password) {
      return handleError(res, 401, 'Invalid credentials');
    }
    
    req.user = { user_id: user.rows[0].user_id, email: user.rows[0].email };
    next();
  } catch (e) {
    handleError(res, 500, 'Auth failed');
  }
};

module.exports = auth;