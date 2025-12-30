-- =====================================================
-- MySQL Schema for Chinese Drama Streaming Website
-- =====================================================
-- Compatible with MySQL 8.0+ / MariaDB 10.5+
-- =====================================================

-- Create database
CREATE DATABASE IF NOT EXISTS drama_streaming
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE drama_streaming;

-- =====================================================
-- Users table (for authentication)
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
  id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_users_email (email)
) ENGINE=InnoDB;

-- =====================================================
-- Sessions table (for session-based authentication)
-- =====================================================
CREATE TABLE IF NOT EXISTS sessions (
  id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  user_id CHAR(36) NOT NULL,
  token VARCHAR(255) NOT NULL UNIQUE,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_sessions_token (token),
  INDEX idx_sessions_user (user_id),
  INDEX idx_sessions_expires (expires_at)
) ENGINE=InnoDB;

-- =====================================================
-- Dramas table
-- =====================================================
CREATE TABLE IF NOT EXISTS dramas (
  id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  title VARCHAR(255) NOT NULL,
  title_en VARCHAR(255) DEFAULT NULL,
  description TEXT DEFAULT NULL,
  poster_url TEXT NOT NULL,
  episodes INT DEFAULT 1,
  category JSON DEFAULT ('[]'),
  section VARCHAR(100) DEFAULT 'general',
  rating DECIMAL(3,1) DEFAULT 0.0,
  view_count INT DEFAULT 0,
  year INT DEFAULT NULL,
  is_featured TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_dramas_section (section),
  INDEX idx_dramas_featured (is_featured),
  INDEX idx_dramas_rating (rating DESC),
  INDEX idx_dramas_view_count (view_count DESC),
  FULLTEXT INDEX idx_dramas_search (title, title_en, description)
) ENGINE=InnoDB;

-- =====================================================
-- Episodes table
-- =====================================================
CREATE TABLE IF NOT EXISTS episodes (
  id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  drama_id CHAR(36) NOT NULL,
  episode_number INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT DEFAULT NULL,
  video_url TEXT DEFAULT NULL,
  thumbnail_url TEXT DEFAULT NULL,
  duration INT DEFAULT 0,
  is_free TINYINT(1) DEFAULT 0,
  view_count INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (drama_id) REFERENCES dramas(id) ON DELETE CASCADE,
  UNIQUE KEY unique_drama_episode (drama_id, episode_number),
  INDEX idx_episodes_drama (drama_id),
  INDEX idx_episodes_number (episode_number)
) ENGINE=InnoDB;

-- =====================================================
-- Favorites table
-- =====================================================
CREATE TABLE IF NOT EXISTS favorites (
  id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  user_id CHAR(36) NOT NULL,
  drama_id CHAR(36) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (drama_id) REFERENCES dramas(id) ON DELETE CASCADE,
  UNIQUE KEY unique_user_drama (user_id, drama_id),
  INDEX idx_favorites_user (user_id),
  INDEX idx_favorites_drama (drama_id)
) ENGINE=InnoDB;

-- =====================================================
-- Watch History table (optional enhancement)
-- =====================================================
CREATE TABLE IF NOT EXISTS watch_history (
  id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  user_id CHAR(36) NOT NULL,
  episode_id CHAR(36) NOT NULL,
  watched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  watch_duration INT DEFAULT 0,
  progress_percent DECIMAL(5,2) DEFAULT 0.00,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (episode_id) REFERENCES episodes(id) ON DELETE CASCADE,
  INDEX idx_history_user (user_id),
  INDEX idx_history_watched (watched_at DESC)
) ENGINE=InnoDB;
