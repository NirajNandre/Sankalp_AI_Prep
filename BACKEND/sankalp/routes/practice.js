const express = require('express');
const auth = require('../middleware/auth');
const { createQuestion, getQuestions, createQuizAttempt, getQuizAttempts, createAttemptDetail, getAttemptDetails } = require('../controllers/practiceController');
const router = express.Router();

router.post('/questions', auth, createQuestion);
router.get('/questions/:chapter_id', getQuestions);
router.post('/quiz-attempts', auth, createQuizAttempt);
router.get('/quiz-attempts', auth, getQuizAttempts);
router.post('/attempt-details', auth, createAttemptDetail);
router.get('/attempt-details/:attempt_id', getAttemptDetails);

module.exports = router;