const express = require('express');
const auth = require('../middleware/auth');
const { getUserProgress, updateProgress } = require('../controllers/progressController');
const router = express.Router();

router.get('/progress', auth, getUserProgress);
router.post('/progress', auth, updateProgress);

module.exports = router;