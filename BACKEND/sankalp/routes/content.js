const express = require('express');
const auth = require('../middleware/auth');
const { createContentUnit, getContentUnits, createCurrentAffairs, getCurrentAffairs } = require('../controllers/contentController');
const router = express.Router();

router.post('/content-units', auth, createContentUnit);
router.get('/content-units/:chapter_id', getContentUnits);
router.post('/current-affairs', auth, createCurrentAffairs);
router.get('/current-affairs', getCurrentAffairs);

module.exports = router;
