-- Drama Streaming Database Initialization
-- This file runs automatically when MySQL container starts

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- Users table
CREATE TABLE IF NOT EXISTS `users` (
  `id` VARCHAR(36) NOT NULL PRIMARY KEY,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `password_hash` VARCHAR(255) NOT NULL,
  `nickname` VARCHAR(100) DEFAULT NULL,
  `avatar_url` VARCHAR(500) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dramas table
CREATE TABLE IF NOT EXISTS `dramas` (
  `id` VARCHAR(36) NOT NULL PRIMARY KEY,
  `title` VARCHAR(255) NOT NULL,
  `title_en` VARCHAR(255) DEFAULT NULL,
  `description` TEXT,
  `poster_url` VARCHAR(500) NOT NULL,
  `year` INT DEFAULT NULL,
  `episodes` INT DEFAULT NULL,
  `rating` DECIMAL(3,1) DEFAULT NULL,
  `view_count` INT DEFAULT 0,
  `category` JSON DEFAULT NULL,
  `section` VARCHAR(50) DEFAULT NULL,
  `is_featured` BOOLEAN DEFAULT FALSE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_section` (`section`),
  INDEX `idx_featured` (`is_featured`),
  INDEX `idx_year` (`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Episodes table
CREATE TABLE IF NOT EXISTS `episodes` (
  `id` VARCHAR(36) NOT NULL PRIMARY KEY,
  `drama_id` VARCHAR(36) NOT NULL,
  `episode_number` INT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT,
  `duration` INT DEFAULT NULL,
  `video_url` VARCHAR(500) DEFAULT NULL,
  `thumbnail_url` VARCHAR(500) DEFAULT NULL,
  `is_free` BOOLEAN DEFAULT FALSE,
  `view_count` INT DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`drama_id`) REFERENCES `dramas`(`id`) ON DELETE CASCADE,
  INDEX `idx_drama_episode` (`drama_id`, `episode_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Favorites table
CREATE TABLE IF NOT EXISTS `favorites` (
  `id` VARCHAR(36) NOT NULL PRIMARY KEY,
  `user_id` VARCHAR(36) NOT NULL,
  `drama_id` VARCHAR(36) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`drama_id`) REFERENCES `dramas`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `unique_user_drama` (`user_id`, `drama_id`),
  INDEX `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed Drama Data
INSERT INTO `dramas` (`id`, `title`, `title_en`, `description`, `poster_url`, `year`, `episodes`, `rating`, `view_count`, `category`, `section`, `is_featured`) VALUES
('d1', '花千骨', 'The Journey of Flower', 'เรื่องราวของหญิงสาวที่กลายเป็นศิษย์ของอาจารย์ผู้เป็นเทพ', 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400', 2015, 50, 8.5, 1500000, '["โรแมนติก", "แฟนตาซี"]', 'recommended', TRUE),
('d2', '三生三世十里桃花', 'Eternal Love', 'ตำนานรักข้ามภพชาติของเทพธิดาจิ้งจอกขาว', 'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?w=400', 2017, 58, 9.0, 2500000, '["โรแมนติก", "แฟนตาซี", "ดราม่า"]', 'recommended', TRUE),
('d3', '琅琊榜', 'Nirvana in Fire', 'การแก้แค้นและยุทธศาสตร์ในราชสำนัก', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400', 2015, 54, 9.5, 3000000, '["ดราม่า", "ประวัติศาสตร์", "แอคชั่น"]', 'popular', TRUE),
('d4', '甄嬛传', 'Empresses in the Palace', 'การต่อสู้ในวังหลังของจักรพรรดิ', 'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=400', 2011, 76, 9.2, 4000000, '["ดราม่า", "ประวัติศาสตร์"]', 'popular', FALSE),
('d5', '陈情令', 'The Untamed', 'มิตรภาพและการผจญภัยของสองศิษย์พี่น้อง', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400', 2019, 50, 9.1, 5000000, '["แฟนตาซี", "แอคชั่น", "มิตรภาพ"]', 'new', TRUE),
('d6', '知否知否应是绿肥红瘦', 'The Story of Ming Lan', 'เรื่องราวของหญิงสาวในราชวงศ์ซ่ง', 'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?w=400', 2018, 73, 8.8, 1800000, '["โรแมนติก", "ประวัติศาสตร์"]', 'new', FALSE),
('d7', '楚乔传', 'Princess Agents', 'ทาสสาวที่กลายเป็นนักรบหญิงผู้ยิ่งใหญ่', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400', 2017, 58, 8.3, 2200000, '["แอคชั่น", "โรแมนติก", "ประวัติศาสตร์"]', 'action', FALSE),
('d8', '庆余年', 'Joy of Life', 'ชายหนุ่มที่เกิดใหม่ในโลกต่างมิติ', 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400', 2019, 46, 8.9, 3500000, '["แฟนตาซี", "คอมเมดี้", "แอคชั่น"]', 'comedy', TRUE);

-- Seed Episodes Data
INSERT INTO `episodes` (`id`, `drama_id`, `episode_number`, `title`, `description`, `duration`, `video_url`, `thumbnail_url`, `is_free`, `view_count`) VALUES
('e1-1', 'd1', 1, 'ตอนที่ 1: จุดเริ่มต้น', 'กำเนิดของหญิงสาวผู้มีพรสวรรค์พิเศษ', 45, 'https://example.com/video1.mp4', 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=200', TRUE, 500000),
('e1-2', 'd1', 2, 'ตอนที่ 2: พบอาจารย์', 'การพบกันครั้งแรกกับอาจารย์ไป๋จื่อหัว', 45, 'https://example.com/video2.mp4', 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=200', TRUE, 450000),
('e1-3', 'd1', 3, 'ตอนที่ 3: เริ่มฝึกวิชา', 'การฝึกฝนพลังภายใน', 45, 'https://example.com/video3.mp4', 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=200', FALSE, 400000),
('e2-1', 'd2', 1, 'ตอนที่ 1: ตำนานจิ้งจอกขาว', 'เรื่องราวของเทพธิดาไป๋เชี่ยน', 45, 'https://example.com/video4.mp4', 'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?w=200', TRUE, 800000),
('e2-2', 'd2', 2, 'ตอนที่ 2: รักแรกพบ', 'การพบกันในสวนลูกท้อ', 45, 'https://example.com/video5.mp4', 'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?w=200', TRUE, 750000),
('e3-1', 'd3', 1, 'ตอนที่ 1: การกลับมา', 'เหมยฉางซูกลับสู่เมืองหลวง', 45, 'https://example.com/video6.mp4', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200', TRUE, 1000000),
('e3-2', 'd3', 2, 'ตอนที่ 2: วางแผน', 'เริ่มต้นแผนการล้างแค้น', 45, 'https://example.com/video7.mp4', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200', TRUE, 950000),
('e5-1', 'd5', 1, 'ตอนที่ 1: อดีตที่หายไป', 'เว่ยอู๋เซี่ยนกลับมาอีกครั้ง', 45, 'https://example.com/video8.mp4', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200', TRUE, 1500000),
('e5-2', 'd5', 2, 'ตอนที่ 2: ความทรงจำ', 'ย้อนรำลึกอดีตในสำนักกูซู', 45, 'https://example.com/video9.mp4', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200', TRUE, 1400000);
