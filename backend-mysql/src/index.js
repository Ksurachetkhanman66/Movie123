const express = require('express');
const cors = require('cors');
const session = require('express-session');
require('dotenv').config();

// Import routes
const authRoutes = require('./routes/auth');
const dramasRoutes = require('./routes/dramas');
const episodesRoutes = require('./routes/episodes');
const favoritesRoutes = require('./routes/favorites');

const app = express();
const PORT = process.env.PORT || 3001;

// CORS configuration
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  credentials: true
}));

// Body parser
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Session configuration
app.use(session({
  secret: process.env.SESSION_SECRET || 'your-secret-key',
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: process.env.NODE_ENV === 'production',
    httpOnly: true,
    maxAge: 7 * 24 * 60 * 60 * 1000 // 7 days
  }
}));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/dramas', dramasRoutes);
app.use('/api/episodes', episodesRoutes);
app.use('/api/favorites', favoritesRoutes);

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: 'Endpoint not found'
  });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Server error:', err);
  res.status(500).json({
    success: false,
    error: 'Internal server error'
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  console.log(`📚 API Documentation:`);
  console.log(`   - Auth: POST /api/auth/signup, /login, /logout, GET /me`);
  console.log(`   - Dramas: GET /api/dramas, /api/dramas/:id`);
  console.log(`   - Episodes: GET /api/dramas/:id/episodes, /api/episodes/:id`);
  console.log(`   - Favorites: GET/POST/DELETE /api/favorites`);
});
