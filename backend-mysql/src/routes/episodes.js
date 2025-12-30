const express = require('express');
const pool = require('../config/database');

const router = express.Router();

// GET /api/episodes/:id - Get single episode by ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const [episodes] = await pool.query(
      `SELECT e.*, d.title as drama_title, d.poster_url as drama_poster
       FROM episodes e
       JOIN dramas d ON e.drama_id = d.id
       WHERE e.id = ?`,
      [id]
    );

    if (episodes.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Episode not found'
      });
    }

    const episode = episodes[0];
    episode.is_free = Boolean(episode.is_free);

    res.json({
      success: true,
      data: episode
    });

  } catch (error) {
    console.error('Error fetching episode:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch episode'
    });
  }
});

// POST /api/episodes/:id/view - Increment view count
router.post('/:id/view', async (req, res) => {
  try {
    const { id } = req.params;

    await pool.query(
      'UPDATE episodes SET view_count = view_count + 1 WHERE id = ?',
      [id]
    );

    res.json({ success: true });

  } catch (error) {
    console.error('Error updating view count:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to update view count'
    });
  }
});

module.exports = router;
