const express = require('express');
const auth = require('../middleware/auth');
const { createQuery, getQueries, createQueryResponse, getQueryResponses } = require('../controllers/queryController');
const router = express.Router();

router.post('/queries', auth, createQuery);
router.get('/queries', auth, getQueries);
router.post('/query-responses', auth, createQueryResponse);
router.get('/query-responses/:query_id', getQueryResponses);