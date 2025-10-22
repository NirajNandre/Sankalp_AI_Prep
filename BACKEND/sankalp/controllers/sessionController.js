const pool = require('../config/database');
const { handleError } = require('../utils/errors');

const createSession = async (req, res) => {
  try {
    const { session_type, topic, related_chapter_id, scheduled_time } = req.body;
    const result = await pool.query(
      'INSERT INTO scheduled_sessions (session_type, host_user_id, topic, related_chapter_id, scheduled_time, session_status) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [session_type, req.user.user_id, topic, related_chapter_id, scheduled_time, 'scheduled']
    );
    res.json(result.rows[0]);
  } catch (e) {
    handleError(res, 500, 'Failed to create session');
  }
};

const getSessions = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM scheduled_sessions ORDER BY scheduled_time DESC');
    res.json(result.rows);
  } catch (e) {
    handleError(res, 500, 'Failed to fetch sessions');
  }
};

const addParticipant = async (req, res) => {
  try {
    const { schedule_id, is_mentor } = req.body;
    const result = await pool.query(
      'INSERT INTO session_participants (schedule_id, participant_user_id, is_mentor) VALUES ($1, $2, $3) RETURNING *',
      [schedule_id, req.user.user_id, is_mentor]
    );
    res.json(result.rows[0]);
  } catch (e) {
    handleError(res, 500, 'Failed to add participant');
  }
};

const getParticipants = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM session_participants WHERE schedule_id = $1', [req.params.schedule_id]);
    res.json(result.rows);
  } catch (e) {
    handleError(res, 500, 'Failed to fetch participants');
  }
};

const createSessionResult = async (req, res) => {
  try {
    const { schedule_id, audio_s3_url, transcript_s3_url, ai_assessment, mentor_notes } = req.body;
    const result = await pool.query(
      'INSERT INTO session_results (schedule_id, audio_s3_url, transcript_s3_url, ai_assessment, mentor_notes, completed_at) VALUES ($1, $2, $3, $4, $5, NOW()) RETURNING *',
      [schedule_id, audio_s3_url, transcript_s3_url, JSON.stringify(ai_assessment), mentor_notes]
    );
    res.json(result.rows[0]);
  } catch (e) {
    handleError(res, 500, 'Failed to create session result');
  }
};

const getSessionResult = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM session_results WHERE schedule_id = $1', [req.params.schedule_id]);
    res.json(result.rows[0]);
  } catch (e) {
    handleError(res, 500, 'Failed to fetch session result');
  }
};

module.exports = { createSession, getSessions, addParticipant, getParticipants, createSessionResult, getSessionResult };
