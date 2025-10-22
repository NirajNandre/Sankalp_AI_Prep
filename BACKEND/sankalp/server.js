const express = require('express');
const authRoutes = require('./routes/auth');
const studentRoutes = require('./routes/students');
const mentorRoutes = require('./routes/mentors');
const courseRoutes = require('./routes/courses');
const contentRoutes = require('./routes/content');
const practiceRoutes = require('./routes/practice');
const progressRoutes = require('./routes/progress');
const queryRoutes = require('./routes/queries');
const sessionRoutes = require('./routes/sessions');

const app = express();
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/students', studentRoutes);
app.use('/api/mentors', mentorRoutes);
app.use('/api/courses', courseRoutes);
app.use('/api/content', contentRoutes);
app.use('/api/practice', practiceRoutes);
app.use('/api/progress', progressRoutes);
app.use('/api/queries', queryRoutes);
app.use('/api/sessions', sessionRoutes);

app.listen(5000, () => console.log('Server running on port 5000'));