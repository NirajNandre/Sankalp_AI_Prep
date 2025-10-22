const express = require('express');
const auth = require('../middleware/auth');
const { createCourse, getCourse, createChapter, getChapters } = require('../controllers/courseController');
const router = express.Router();

router.post('/courses', auth, createCourse);
router.get('/courses/:id', getCourse);
router.post('/chapters', auth, createChapter);
router.get('/chapters/:course_id', getChapters);

module.exports = router;