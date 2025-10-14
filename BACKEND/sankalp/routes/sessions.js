const express = require('express');
const auth = require('../middleware/auth');
const { createSession, getSessions, addParticipant, getParticipants, createSessionResult, getSessionResult } = require('../controllers/sessionController');
const router = express.Router();

router.post('/sessions', auth, createSession);
router.get('/sessions', getSessions);
router.post('/session-participants', auth, addParticipant);
router.get('/session-participants/:schedule_id', getParticipants);
router.post('/session-results', auth, createSessionResult);
router.get('/session-results/:schedule_id', getSessionResult);

module.exports = router;