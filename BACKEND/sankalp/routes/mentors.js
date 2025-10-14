const express = require('express');
const auth = require('../middleware/auth');
const { getProfile, updateProfile } = require('../controllers/mentorController');
const router = express.Router();

router.get('/profile/:id', getProfile);
router.put('/profile', auth, updateProfile);
