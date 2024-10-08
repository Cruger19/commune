const express = require('express');
const dotenv = require('dotenv');
const authRoutes = require('./routes/authRoutes');
const issueRoutes = require('./routes/issueRoutes');
const db = require('./config/db');

dotenv.config();

const app = express();
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api', issueRoutes);

const PORT = process.env.PORT || 5000;
app.listen(3000, () => console.log(`Server running on port 3000`));
