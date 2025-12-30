const express = require('express');
const { v4: uuidv4 } = require('uuid');
const pool = require('../config/database');
const { requireAuth } = require('../middleware/auth');

const router = express.Router();

// All favorites routes require authentication
router.use(requireAuth);

// GET /api/favorites - Get user's favorites
router.get('/', async (req, res) => {
  try {
    const userId = req.session.userId;

    const [favorites] = await pool.query(
      `SELECT f.id, f.drama_id, f.created_at, 
              d.id as drama_id, d.title, d.title_en, d.description, 
              d.poster_url, d.episodes, d.category, d.section, 
              d.rating, d.view_count, d.year, d.is_featured
       FROM favorites f
       JOIN dramas d ON f.drama_id = d.id
       WHERE f.user_id = ?
       ORDER BY f.created_at DESC`,
      [userId]
    );

    // Format response to match Supabase structure
    const formattedFavorites = favorites.map(fav => ({
      id: fav.id,
      drama_id: fav.drama_id,
      created_at: fav.created_at,
      dramas: {
        id: fav.drama_id,
        title: fav.title,
        title_en: fav.title_en,
        description: fav.description,
        poster_url: fav.poster_url,
        episodes: fav.episodes,
        category: typeof fav.category === 'string' ? JSON.parse(fav.category) : fav.category,
        section: fav.section,
        rating: parseFloat(fav.rating),
        view_count: fav.view_count,
        year: fav.year,
        is_featured: Boolean(fav.is_featured)
      }
    }));

    res.json({
      success: true,
      data: formattedFavorites,
      total: formattedFavorites.length
    });

  } catch (error) {
    console.error('Error fetching favorites:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch favorites'
    });
  }
});

// GET /api/favorites/check/:dramaId - Check if drama is favorited
router.get('/check/:dramaId', async (req, res) => {
  try {
    const userId = req.session.userId;
    const { dramaId } = req.params;

    const [favorites] = await pool.query(
      'SELECT id FROM favorites WHERE user_id = ? AND drama_id = ?',
      [userId, dramaId]
    );

    res.json({
      success: true,
      isFavorite: favorites.length > 0
    });

  } catch (error) {
    console.error('Error checking favorite:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to check favorite'
    });
  }
});

// POST /api/favorites - Add to favorites
router.post('/', async (req, res) => {
  try {
    const userId = req.session.userId;
    const { drama_id } = req.body;

    if (!drama_id) {
      return res.status(400).json({
        success: false,
        error: 'drama_id is required'
      });
    }

    // Check if already exists
    const [existing] = await pool.query(
      'SELECT id FROM favorites WHERE user_id = ? AND drama_id = ?',
      [userId, drama_id]
    );

    if (existing.length > 0) {
      return res.status(409).json({
        success: false,
        error: 'Already in favorites'
      });
    }

    // Insert favorite
    const favoriteId = uuidv4();
    await pool.query(
      'INSERT INTO favorites (id, user_id, drama_id) VALUES (?, ?, ?)',
      [favoriteId, userId, drama_id]
    );

    res.status(201).json({
      success: true,
      data: {
        id: favoriteId,
        user_id: userId,
        drama_id: drama_id
      }
    });

  } catch (error) {
    console.error('Error adding favorite:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to add favorite'
    });
  }
});

// DELETE /api/favorites/:dramaId - Remove from favorites
router.delete('/:dramaId', async (req, res) => {
  try {
    const userId = req.session.userId;
    const { dramaId } = req.params;

    await pool.query(
      'DELETE FROM favorites WHERE user_id = ? AND drama_id = ?',
      [userId, dramaId]
    );

    res.json({ success: true });

  } catch (error) {
    console.error('Error removing favorite:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to remove favorite'
    });
  }
});

module.exports = router;
