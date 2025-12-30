const express = require('express');
const pool = require('../config/database');

const router = express.Router();

// GET /api/dramas - Get all dramas with optional filters
router.get('/', async (req, res) => {
  try {
    const { section, category, featured, search, limit = 50 } = req.query;

    let query = 'SELECT * FROM dramas WHERE 1=1';
    const params = [];

    if (section) {
      query += ' AND section = ?';
      params.push(section);
    }

    if (featured === 'true') {
      query += ' AND is_featured = 1';
    }

    if (category) {
      query += ' AND JSON_CONTAINS(category, ?)';
      params.push(JSON.stringify(category));
    }

    if (search) {
      query += ' AND (title LIKE ? OR title_en LIKE ? OR description LIKE ?)';
      const searchTerm = `%${search}%`;
      params.push(searchTerm, searchTerm, searchTerm);
    }

    query += ' ORDER BY created_at DESC LIMIT ?';
    params.push(parseInt(limit));

    const [dramas] = await pool.query(query, params);

    // Parse category JSON for each drama
    const parsedDramas = dramas.map(drama => ({
      ...drama,
      category: typeof drama.category === 'string' ? JSON.parse(drama.category) : drama.category,
      is_featured: Boolean(drama.is_featured)
    }));

    res.json({
      success: true,
      data: parsedDramas,
      total: parsedDramas.length
    });

  } catch (error) {
    console.error('Error fetching dramas:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch dramas'
    });
  }
});

// GET /api/dramas/:id - Get single drama by ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const [dramas] = await pool.query(
      'SELECT * FROM dramas WHERE id = ?',
      [id]
    );

    if (dramas.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Drama not found'
      });
    }

    const drama = dramas[0];
    drama.category = typeof drama.category === 'string' ? JSON.parse(drama.category) : drama.category;
    drama.is_featured = Boolean(drama.is_featured);

    res.json({
      success: true,
      data: drama
    });

  } catch (error) {
    console.error('Error fetching drama:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch drama'
    });
  }
});

// GET /api/dramas/:id/episodes - Get episodes for a drama
router.get('/:id/episodes', async (req, res) => {
  try {
    const { id } = req.params;

    const [episodes] = await pool.query(
      'SELECT * FROM episodes WHERE drama_id = ? ORDER BY episode_number ASC',
      [id]
    );

    const parsedEpisodes = episodes.map(ep => ({
      ...ep,
      is_free: Boolean(ep.is_free)
    }));

    res.json({
      success: true,
      data: parsedEpisodes,
      total: parsedEpisodes.length
    });

  } catch (error) {
    console.error('Error fetching episodes:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch episodes'
    });
  }
});

module.exports = router;
