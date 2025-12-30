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

-- =====================================================
-- Seed Data: 42 Dramas
-- =====================================================
INSERT INTO `dramas` (`id`, `title`, `title_en`, `description`, `poster_url`, `episodes`, `category`, `section`, `rating`, `view_count`, `year`, `is_featured`) VALUES
('d1000001-0000-0000-0000-000000000001', 'รักนิรันดร์จันทรา', 'Love Like The Galaxy', 'เรื่องราวความรักโรแมนติกในราชสำนักโบราณ', 'https://images.unsplash.com/photo-1518173946687-a4c036bc3c9e?w=400', 56, '["โรแมนติก", "ย้อนยุค", "ดราม่า"]', 'recommended', 9.2, 125000, 2022, 1),
('d1000001-0000-0000-0000-000000000002', 'สามชาติสามภพ ลิขิตเหนือเขนย', 'Eternal Love', 'ตำนานรักข้ามภพข้ามชาติสุดโรแมนติก', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400', 58, '["แฟนตาซี", "โรแมนติก", "ย้อนยุค"]', 'recommended', 9.5, 250000, 2017, 1),
('d1000001-0000-0000-0000-000000000003', 'ปฐพีไร้พ่าย', 'A Journey to Love', 'การผจญภัยและความรักในโลกกำลังภายใน', 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=400', 40, '["กำลังภายใน", "โรแมนติก", "แอคชั่น"]', 'popular', 8.9, 180000, 2023, 1),
('d1000001-0000-0000-0000-000000000004', 'ฝากใจไว้กับดวงดาว', 'My Huckleberry Friends', 'เรื่องราววัยรุ่นและความรักแรกพบ', 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400', 35, '["โรแมนติก", "วัยรุ่น", "โรงเรียน"]', 'popular', 8.7, 95000, 2017, 0),
('d1000001-0000-0000-0000-000000000005', 'ลิขิตรักข้ามดวงดาว', 'Love O2O', 'ความรักในโลกเกมออนไลน์', 'https://images.unsplash.com/photo-1542103749-8ef59b94f47e?w=400', 30, '["โรแมนติก", "วิทยาศาสตร์", "เกม"]', 'romance', 8.8, 200000, 2016, 1),
('d1000001-0000-0000-0000-000000000006', 'ท่านอ๋องเจอรักแล้ว', 'The Romance of Tiger and Rose', 'เรื่องราวสลับมิติสุดฮา', 'https://images.unsplash.com/photo-1554151228-14d9def656e4?w=400', 24, '["โรแมนติก", "คอเมดี้", "แฟนตาซี"]', 'romance', 8.5, 150000, 2020, 0),
('d1000001-0000-0000-0000-000000000007', 'สยบฟ้าพิชิตปฐพี', 'Nirvana in Fire', 'แผนล้างแค้นและการเมืองในราชสำนัก', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400', 54, '["ดราม่า", "ย้อนยุค", "การเมือง"]', 'action', 9.6, 300000, 2015, 1),
('d1000001-0000-0000-0000-000000000008', 'มังกรหยก', 'The Legend of the Condor Heroes', 'มหากาพย์กำลังภายในอันโด่งดัง', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400', 50, '["กำลังภายใน", "แอคชั่น", "ผจญภัย"]', 'action', 9.1, 220000, 2017, 0),
('d1000001-0000-0000-0000-000000000009', 'เล่ห์รักวังหลัง', 'Story of Yanxi Palace', 'การต่อสู้และอุบายในวังหลวง', 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400', 70, '["ย้อนยุค", "ดราม่า", "วังหลัง"]', 'popular', 9.3, 280000, 2018, 1),
('d1000001-0000-0000-0000-000000000010', 'รักวุ่นวายนายมาดร้าย', 'Skate Into Love', 'ความรักของนักกีฬาสเก็ตน้ำแข็ง', 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400', 40, '["โรแมนติก", "กีฬา", "วัยรุ่น"]', 'romance', 8.6, 110000, 2020, 0),
('d1000001-0000-0000-0000-000000000011', 'อสูรน้อยนายหน้าหล่อ', 'My Little Happiness', 'รักหวานๆ ของคู่รักข้างบ้าน', 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400', 28, '["โรแมนติก", "คอเมดี้"]', 'romance', 8.4, 85000, 2021, 0),
('d1000001-0000-0000-0000-000000000012', 'องครักษ์พิทักษ์รัก', 'The Untamed', 'การผจญภัยของสองนักพรตกำลังภายใน', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400', 50, '["กำลังภายใน", "แฟนตาซี", "ผจญภัย"]', 'action', 9.4, 350000, 2019, 1),
('d1000001-0000-0000-0000-000000000013', 'ลิขิตรักสองสวรรค์', 'Ashes of Love', 'ความรักระหว่างเทพและอสูร', 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400', 63, '["แฟนตาซี", "โรแมนติก", "ดราม่า"]', 'fantasy', 9.2, 240000, 2018, 1),
('d1000001-0000-0000-0000-000000000014', 'เจ้าหญิงน้อย', 'Romance of a Twin Flower', 'การสลับบทบาทของสาวแฝด', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400', 36, '["โรแมนติก", "ย้อนยุค", "คอเมดี้"]', 'romance', 8.3, 75000, 2022, 0),
('d1000001-0000-0000-0000-000000000015', 'ขุนนางหญิง', 'The Story of Ming Lan', 'การก้าวขึ้นสู่อำนาจของสตรี', 'https://images.unsplash.com/photo-1464863979621-258859e62245?w=400', 73, '["ย้อนยุค", "ดราม่า", "การเมือง"]', 'historical', 9.1, 190000, 2018, 0),
('d1000001-0000-0000-0000-000000000016', 'ฟ้าลิขิต', 'Love and Destiny', 'ความรักของเทพเซียนและมนุษย์', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400', 60, '["แฟนตาซี", "โรแมนติก", "ย้อนยุค"]', 'fantasy', 8.9, 160000, 2019, 0),
('d1000001-0000-0000-0000-000000000017', 'เกมล่าหัวใจ', 'Love Scenery', 'ความรักของนักร้องและโปรแกรมเมอร์', 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400', 31, '["โรแมนติก", "คอเมดี้", "ดนตรี"]', 'romance', 8.5, 95000, 2021, 0),
('d1000001-0000-0000-0000-000000000018', 'สะดุดรักยัยจอมหยิ่ง', 'Put Your Head on My Shoulder', 'รักหวานๆ ในหอพักนักศึกษา', 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=400', 24, '["โรแมนติก", "วัยรุ่น", "มหาวิทยาลัย"]', 'romance', 8.6, 130000, 2019, 0),
('d1000001-0000-0000-0000-000000000019', 'เทพบุตรนักสืบ', 'Detective L', 'การไขคดีลึกลับในอดีต', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400', 24, '["สืบสวน", "ลึกลับ", "ย้อนยุค"]', 'mystery', 8.7, 85000, 2019, 0),
('d1000001-0000-0000-0000-000000000020', 'รักนี้ไม่มีทางแพ้', 'You Are My Glory', 'ความรักของดาราและนักวิทยาศาสตร์', 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400', 32, '["โรแมนติก", "วิทยาศาสตร์", "เกม"]', 'romance', 9.0, 210000, 2021, 1),
('d1000001-0000-0000-0000-000000000021', 'ตำนานจักรพรรดินีหวู่', 'The Empress of China', 'เรื่องราวจักรพรรดินีหญิงองค์แรก', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400', 82, '["ย้อนยุค", "ดราม่า", "การเมือง"]', 'historical', 8.8, 170000, 2014, 0),
('d1000001-0000-0000-0000-000000000022', 'มนตราจันทรา', 'Love Under the Moon', 'ความรักใต้แสงจันทร์', 'https://images.unsplash.com/photo-1485893086445-ed75865251e0?w=400', 36, '["โรแมนติก", "แฟนตาซี"]', 'fantasy', 8.2, 65000, 2021, 0),
('d1000001-0000-0000-0000-000000000023', 'ดาบมังกร', 'Heavenly Sword and Dragon Slaying Sabre', 'มหากาพย์กำลังภายในคลาสสิก', 'https://images.unsplash.com/photo-1507081323647-4d250478b919?w=400', 50, '["กำลังภายใน", "แอคชั่น", "ผจญภัย"]', 'action', 8.9, 145000, 2019, 0),
('d1000001-0000-0000-0000-000000000024', 'เมียหลวง', 'The Legendary Life of Queen Lau', 'ตำนานชีวิตมเหสี', 'https://images.unsplash.com/photo-1504730030853-ebb04f0b7c2c?w=400', 30, '["ย้อนยุค", "คอเมดี้", "โรแมนติก"]', 'historical', 8.1, 55000, 2021, 0),
('d1000001-0000-0000-0000-000000000025', 'เกาะรักเกาะสวรรค์', 'Our Secret', 'ความรักลับๆ ในหมู่บ้านเล็กๆ', 'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?w=400', 24, '["โรแมนติก", "วัยรุ่น"]', 'romance', 8.4, 70000, 2021, 0),
('d1000001-0000-0000-0000-000000000026', 'ยอดชายาสะท้านฟ้า', 'General Lady', 'นายทหารหญิงผู้กล้าหาญ', 'https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?w=400', 30, '["ย้อนยุค", "แอคชั่น", "โรแมนติก"]', 'action', 8.3, 80000, 2020, 0),
('d1000001-0000-0000-0000-000000000027', 'จอมนางค์เคียงบัลลังก์', 'Ruyi Royal Love in the Palace', 'ชีวิตในวังหลวงราชวงศ์ชิง', 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=400', 87, '["ย้อนยุค", "ดราม่า", "วังหลัง"]', 'historical', 9.0, 230000, 2018, 0),
('d1000001-0000-0000-0000-000000000028', 'ล่องไพรนิยาย', 'Word of Honor', 'มิตรภาพและการผจญภัยในป่าลึก', 'https://images.unsplash.com/photo-1463453091185-61582044d556?w=400', 36, '["กำลังภายใน", "ผจญภัย", "ดราม่า"]', 'action', 9.2, 280000, 2021, 1),
('d1000001-0000-0000-0000-000000000029', 'เล่ห์รักจันทร์ดาว', 'Moonlight', 'รักซ่อนเร้นใต้แสงจันทร์', 'https://images.unsplash.com/photo-1496440737103-cd596325d314?w=400', 28, '["โรแมนติก", "ดราม่า"]', 'romance', 8.5, 75000, 2022, 0),
('d1000001-0000-0000-0000-000000000030', 'องค์หญิงแสนร้ายกับยอดชายมาดเข้ม', 'Go Princess Go', 'หญิงสาวสลับร่างเป็นองค์หญิง', 'https://images.unsplash.com/photo-1499996860823-5f82e24f84f6?w=400', 35, '["คอเมดี้", "โรแมนติก", "แฟนตาซี"]', 'romance', 8.7, 160000, 2015, 0),
('d1000001-0000-0000-0000-000000000031', 'ดาราจักรอลเวง', 'My Love from the Star', 'ความรักระหว่างมนุษย์ต่างดาวและดารา', 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=400', 21, '["แฟนตาซี", "โรแมนติก", "ไซไฟ"]', 'fantasy', 9.0, 195000, 2013, 0),
('d1000001-0000-0000-0000-000000000032', 'ฮวาชิง', 'Chinese Paladin', 'การผจญภัยของนักพรตหนุ่ม', 'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=400', 34, '["กำลังภายใน", "แฟนตาซี", "ผจญภัย"]', 'action', 8.8, 140000, 2005, 0),
('d1000001-0000-0000-0000-000000000033', 'ราชินีฝ้ายคำ', 'The Legend of Dugu', 'ตำนานราชินีผู้ยิ่งใหญ่', 'https://images.unsplash.com/photo-1485811055483-1c09e64d4576?w=400', 55, '["ย้อนยุค", "ดราม่า"]', 'historical', 8.4, 95000, 2018, 0),
('d1000001-0000-0000-0000-000000000034', 'สิบไมล์ดอกท้อบาน', 'Ten Miles of Peach Blossoms', 'ความรักอมตะของเทพและเซียน', 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400', 58, '["แฟนตาซี", "โรแมนติก", "ดราม่า"]', 'fantasy', 9.4, 320000, 2017, 1),
('d1000001-0000-0000-0000-000000000035', 'คู่แค้นแสนลึก', 'Till the End of the Moon', 'ความรักและแค้นข้ามชาติ', 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400', 40, '["แฟนตาซี", "โรแมนติก", "ย้อนยุค"]', 'fantasy', 9.1, 270000, 2023, 1),
('d1000001-0000-0000-0000-000000000036', 'องค์หญิงใหญ่', 'The Princess Wei Young', 'การแก้แค้นและรักของเจ้าหญิง', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400', 54, '["ย้อนยุค", "ดราม่า", "โรแมนติก"]', 'historical', 8.6, 155000, 2016, 0),
('d1000001-0000-0000-0000-000000000037', 'รักนี้หวานมาก', 'Love Is Sweet', 'รักหวานๆ ในออฟฟิศ', 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400', 36, '["โรแมนติก", "คอเมดี้", "ออฟฟิศ"]', 'romance', 8.5, 120000, 2020, 0),
('d1000001-0000-0000-0000-000000000038', 'ศึกชิงนาง', 'The King Eternal Monarch', 'จักรพรรดิข้ามมิติ', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400', 16, '["แฟนตาซี", "โรแมนติก", "ไซไฟ"]', 'fantasy', 8.9, 180000, 2020, 0),
('d1000001-0000-0000-0000-000000000039', 'ลิขิตแค้นข้ามเวลา', 'Lost You Forever', 'ความรักที่รอคอยนับพันปี', 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400', 39, '["แฟนตาซี", "โรแมนติก", "ดราม่า"]', 'fantasy', 9.0, 200000, 2023, 1),
('d1000001-0000-0000-0000-000000000040', 'รักบริสุทธิ์', 'A Love So Beautiful', 'รักแรกวัยเรียนที่แสนหวาน', 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400', 23, '["โรแมนติก", "วัยรุ่น", "โรงเรียน"]', 'romance', 8.8, 175000, 2017, 0),
('d1000001-0000-0000-0000-000000000041', 'จอมนางจอมใจ', 'Princess Agents', 'นางทาสผู้กลายเป็นนักรบ', 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400', 58, '["แอคชั่น", "ย้อนยุค", "โรแมนติก"]', 'action', 8.7, 165000, 2017, 0),
('d1000001-0000-0000-0000-000000000042', 'รักที่เหนือกาลเวลา', 'Love Between Fairy and Devil', 'ความรักระหว่างนางฟ้าและปีศาจ', 'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?w=400', 36, '["แฟนตาซี", "โรแมนติก", "คอเมดี้"]', 'fantasy', 9.3, 290000, 2022, 1);

-- =====================================================
-- Seed Data: Episodes (5 episodes per drama)
-- =====================================================

-- Drama 1: รักนิรันดร์จันทรา
INSERT INTO `episodes` (`id`, `drama_id`, `episode_number`, `title`, `description`, `duration`, `video_url`, `thumbnail_url`, `is_free`, `view_count`) VALUES
('ep-001-01', 'd1000001-0000-0000-0000-000000000001', 1, 'รักนิรันดร์จันทรา ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d1/ep1.mp4', 'https://images.unsplash.com/photo-1518173946687-a4c036bc3c9e?w=400', TRUE, 25000),
('ep-001-02', 'd1000001-0000-0000-0000-000000000001', 2, 'รักนิรันดร์จันทรา ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d1/ep2.mp4', 'https://images.unsplash.com/photo-1518173946687-a4c036bc3c9e?w=400', FALSE, 22000),
('ep-001-03', 'd1000001-0000-0000-0000-000000000001', 3, 'รักนิรันดร์จันทรา ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d1/ep3.mp4', 'https://images.unsplash.com/photo-1518173946687-a4c036bc3c9e?w=400', FALSE, 20000),
('ep-001-04', 'd1000001-0000-0000-0000-000000000001', 4, 'รักนิรันดร์จันทรา ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d1/ep4.mp4', 'https://images.unsplash.com/photo-1518173946687-a4c036bc3c9e?w=400', FALSE, 18000),
('ep-001-05', 'd1000001-0000-0000-0000-000000000001', 5, 'รักนิรันดร์จันทรา ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d1/ep5.mp4', 'https://images.unsplash.com/photo-1518173946687-a4c036bc3c9e?w=400', FALSE, 16000),

-- Drama 2: สามชาติสามภพ ลิขิตเหนือเขนย
('ep-002-01', 'd1000001-0000-0000-0000-000000000002', 1, 'สามชาติสามภพ ลิขิตเหนือเขนย ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d2/ep1.mp4', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400', TRUE, 50000),
('ep-002-02', 'd1000001-0000-0000-0000-000000000002', 2, 'สามชาติสามภพ ลิขิตเหนือเขนย ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d2/ep2.mp4', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400', FALSE, 45000),
('ep-002-03', 'd1000001-0000-0000-0000-000000000002', 3, 'สามชาติสามภพ ลิขิตเหนือเขนย ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d2/ep3.mp4', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400', FALSE, 42000),
('ep-002-04', 'd1000001-0000-0000-0000-000000000002', 4, 'สามชาติสามภพ ลิขิตเหนือเขนย ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d2/ep4.mp4', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400', FALSE, 40000),
('ep-002-05', 'd1000001-0000-0000-0000-000000000002', 5, 'สามชาติสามภพ ลิขิตเหนือเขนย ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d2/ep5.mp4', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400', FALSE, 38000),

-- Drama 3: ปฐพีไร้พ่าย
('ep-003-01', 'd1000001-0000-0000-0000-000000000003', 1, 'ปฐพีไร้พ่าย ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d3/ep1.mp4', 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=400', TRUE, 36000),
('ep-003-02', 'd1000001-0000-0000-0000-000000000003', 2, 'ปฐพีไร้พ่าย ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d3/ep2.mp4', 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=400', FALSE, 33000),
('ep-003-03', 'd1000001-0000-0000-0000-000000000003', 3, 'ปฐพีไร้พ่าย ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d3/ep3.mp4', 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=400', FALSE, 30000),
('ep-003-04', 'd1000001-0000-0000-0000-000000000003', 4, 'ปฐพีไร้พ่าย ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d3/ep4.mp4', 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=400', FALSE, 28000),
('ep-003-05', 'd1000001-0000-0000-0000-000000000003', 5, 'ปฐพีไร้พ่าย ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d3/ep5.mp4', 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=400', FALSE, 26000),

-- Drama 4: ฝากใจไว้กับดวงดาว
('ep-004-01', 'd1000001-0000-0000-0000-000000000004', 1, 'ฝากใจไว้กับดวงดาว ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d4/ep1.mp4', 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400', TRUE, 19000),
('ep-004-02', 'd1000001-0000-0000-0000-000000000004', 2, 'ฝากใจไว้กับดวงดาว ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d4/ep2.mp4', 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400', FALSE, 17000),
('ep-004-03', 'd1000001-0000-0000-0000-000000000004', 3, 'ฝากใจไว้กับดวงดาว ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d4/ep3.mp4', 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400', FALSE, 15000),
('ep-004-04', 'd1000001-0000-0000-0000-000000000004', 4, 'ฝากใจไว้กับดวงดาว ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d4/ep4.mp4', 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400', FALSE, 14000),
('ep-004-05', 'd1000001-0000-0000-0000-000000000004', 5, 'ฝากใจไว้กับดวงดาว ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d4/ep5.mp4', 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400', FALSE, 13000),

-- Drama 5: ลิขิตรักข้ามดวงดาว
('ep-005-01', 'd1000001-0000-0000-0000-000000000005', 1, 'ลิขิตรักข้ามดวงดาว ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d5/ep1.mp4', 'https://images.unsplash.com/photo-1542103749-8ef59b94f47e?w=400', TRUE, 40000),
('ep-005-02', 'd1000001-0000-0000-0000-000000000005', 2, 'ลิขิตรักข้ามดวงดาว ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d5/ep2.mp4', 'https://images.unsplash.com/photo-1542103749-8ef59b94f47e?w=400', FALSE, 37000),
('ep-005-03', 'd1000001-0000-0000-0000-000000000005', 3, 'ลิขิตรักข้ามดวงดาว ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d5/ep3.mp4', 'https://images.unsplash.com/photo-1542103749-8ef59b94f47e?w=400', FALSE, 35000),
('ep-005-04', 'd1000001-0000-0000-0000-000000000005', 4, 'ลิขิตรักข้ามดวงดาว ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d5/ep4.mp4', 'https://images.unsplash.com/photo-1542103749-8ef59b94f47e?w=400', FALSE, 33000),
('ep-005-05', 'd1000001-0000-0000-0000-000000000005', 5, 'ลิขิตรักข้ามดวงดาว ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d5/ep5.mp4', 'https://images.unsplash.com/photo-1542103749-8ef59b94f47e?w=400', FALSE, 31000),

-- Drama 6: ท่านอ๋องเจอรักแล้ว
('ep-006-01', 'd1000001-0000-0000-0000-000000000006', 1, 'ท่านอ๋องเจอรักแล้ว ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d6/ep1.mp4', 'https://images.unsplash.com/photo-1554151228-14d9def656e4?w=400', TRUE, 30000),
('ep-006-02', 'd1000001-0000-0000-0000-000000000006', 2, 'ท่านอ๋องเจอรักแล้ว ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d6/ep2.mp4', 'https://images.unsplash.com/photo-1554151228-14d9def656e4?w=400', FALSE, 27000),
('ep-006-03', 'd1000001-0000-0000-0000-000000000006', 3, 'ท่านอ๋องเจอรักแล้ว ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d6/ep3.mp4', 'https://images.unsplash.com/photo-1554151228-14d9def656e4?w=400', FALSE, 25000),
('ep-006-04', 'd1000001-0000-0000-0000-000000000006', 4, 'ท่านอ๋องเจอรักแล้ว ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d6/ep4.mp4', 'https://images.unsplash.com/photo-1554151228-14d9def656e4?w=400', FALSE, 23000),
('ep-006-05', 'd1000001-0000-0000-0000-000000000006', 5, 'ท่านอ๋องเจอรักแล้ว ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d6/ep5.mp4', 'https://images.unsplash.com/photo-1554151228-14d9def656e4?w=400', FALSE, 21000),

-- Drama 7: สยบฟ้าพิชิตปฐพี
('ep-007-01', 'd1000001-0000-0000-0000-000000000007', 1, 'สยบฟ้าพิชิตปฐพี ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d7/ep1.mp4', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400', TRUE, 60000),
('ep-007-02', 'd1000001-0000-0000-0000-000000000007', 2, 'สยบฟ้าพิชิตปฐพี ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d7/ep2.mp4', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400', FALSE, 55000),
('ep-007-03', 'd1000001-0000-0000-0000-000000000007', 3, 'สยบฟ้าพิชิตปฐพี ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d7/ep3.mp4', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400', FALSE, 52000),
('ep-007-04', 'd1000001-0000-0000-0000-000000000007', 4, 'สยบฟ้าพิชิตปฐพี ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d7/ep4.mp4', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400', FALSE, 50000),
('ep-007-05', 'd1000001-0000-0000-0000-000000000007', 5, 'สยบฟ้าพิชิตปฐพี ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d7/ep5.mp4', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400', FALSE, 48000),

-- Drama 8: มังกรหยก
('ep-008-01', 'd1000001-0000-0000-0000-000000000008', 1, 'มังกรหยก ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d8/ep1.mp4', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400', TRUE, 44000),
('ep-008-02', 'd1000001-0000-0000-0000-000000000008', 2, 'มังกรหยก ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d8/ep2.mp4', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400', FALSE, 41000),
('ep-008-03', 'd1000001-0000-0000-0000-000000000008', 3, 'มังกรหยก ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d8/ep3.mp4', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400', FALSE, 39000),
('ep-008-04', 'd1000001-0000-0000-0000-000000000008', 4, 'มังกรหยก ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d8/ep4.mp4', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400', FALSE, 37000),
('ep-008-05', 'd1000001-0000-0000-0000-000000000008', 5, 'มังกรหยก ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d8/ep5.mp4', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400', FALSE, 35000),

-- Drama 9: เล่ห์รักวังหลัง
('ep-009-01', 'd1000001-0000-0000-0000-000000000009', 1, 'เล่ห์รักวังหลัง ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d9/ep1.mp4', 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400', TRUE, 56000),
('ep-009-02', 'd1000001-0000-0000-0000-000000000009', 2, 'เล่ห์รักวังหลัง ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d9/ep2.mp4', 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400', FALSE, 52000),
('ep-009-03', 'd1000001-0000-0000-0000-000000000009', 3, 'เล่ห์รักวังหลัง ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d9/ep3.mp4', 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400', FALSE, 49000),
('ep-009-04', 'd1000001-0000-0000-0000-000000000009', 4, 'เล่ห์รักวังหลัง ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d9/ep4.mp4', 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400', FALSE, 46000),
('ep-009-05', 'd1000001-0000-0000-0000-000000000009', 5, 'เล่ห์รักวังหลัง ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d9/ep5.mp4', 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400', FALSE, 44000),

-- Drama 10: รักวุ่นวายนายมาดร้าย
('ep-010-01', 'd1000001-0000-0000-0000-000000000010', 1, 'รักวุ่นวายนายมาดร้าย ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d10/ep1.mp4', 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400', TRUE, 22000),
('ep-010-02', 'd1000001-0000-0000-0000-000000000010', 2, 'รักวุ่นวายนายมาดร้าย ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d10/ep2.mp4', 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400', FALSE, 20000),
('ep-010-03', 'd1000001-0000-0000-0000-000000000010', 3, 'รักวุ่นวายนายมาดร้าย ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d10/ep3.mp4', 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400', FALSE, 18000),
('ep-010-04', 'd1000001-0000-0000-0000-000000000010', 4, 'รักวุ่นวายนายมาดร้าย ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d10/ep4.mp4', 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400', FALSE, 16000),
('ep-010-05', 'd1000001-0000-0000-0000-000000000010', 5, 'รักวุ่นวายนายมาดร้าย ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d10/ep5.mp4', 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400', FALSE, 14000),

-- Drama 11: อสูรน้อยนายหน้าหล่อ
('ep-011-01', 'd1000001-0000-0000-0000-000000000011', 1, 'อสูรน้อยนายหน้าหล่อ ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d11/ep1.mp4', 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400', TRUE, 17000),
('ep-011-02', 'd1000001-0000-0000-0000-000000000011', 2, 'อสูรน้อยนายหน้าหล่อ ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d11/ep2.mp4', 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400', FALSE, 15000),
('ep-011-03', 'd1000001-0000-0000-0000-000000000011', 3, 'อสูรน้อยนายหน้าหล่อ ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d11/ep3.mp4', 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400', FALSE, 13000),
('ep-011-04', 'd1000001-0000-0000-0000-000000000011', 4, 'อสูรน้อยนายหน้าหล่อ ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d11/ep4.mp4', 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400', FALSE, 11000),
('ep-011-05', 'd1000001-0000-0000-0000-000000000011', 5, 'อสูรน้อยนายหน้าหล่อ ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d11/ep5.mp4', 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400', FALSE, 10000),

-- Drama 12: องครักษ์พิทักษ์รัก
('ep-012-01', 'd1000001-0000-0000-0000-000000000012', 1, 'องครักษ์พิทักษ์รัก ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d12/ep1.mp4', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400', TRUE, 70000),
('ep-012-02', 'd1000001-0000-0000-0000-000000000012', 2, 'องครักษ์พิทักษ์รัก ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d12/ep2.mp4', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400', FALSE, 65000),
('ep-012-03', 'd1000001-0000-0000-0000-000000000012', 3, 'องครักษ์พิทักษ์รัก ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d12/ep3.mp4', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400', FALSE, 62000),
('ep-012-04', 'd1000001-0000-0000-0000-000000000012', 4, 'องครักษ์พิทักษ์รัก ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d12/ep4.mp4', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400', FALSE, 59000),
('ep-012-05', 'd1000001-0000-0000-0000-000000000012', 5, 'องครักษ์พิทักษ์รัก ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d12/ep5.mp4', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400', FALSE, 56000),

-- Drama 13: ลิขิตรักสองสวรรค์
('ep-013-01', 'd1000001-0000-0000-0000-000000000013', 1, 'ลิขิตรักสองสวรรค์ ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d13/ep1.mp4', 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400', TRUE, 48000),
('ep-013-02', 'd1000001-0000-0000-0000-000000000013', 2, 'ลิขิตรักสองสวรรค์ ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d13/ep2.mp4', 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400', FALSE, 45000),
('ep-013-03', 'd1000001-0000-0000-0000-000000000013', 3, 'ลิขิตรักสองสวรรค์ ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d13/ep3.mp4', 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400', FALSE, 42000),
('ep-013-04', 'd1000001-0000-0000-0000-000000000013', 4, 'ลิขิตรักสองสวรรค์ ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d13/ep4.mp4', 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400', FALSE, 40000),
('ep-013-05', 'd1000001-0000-0000-0000-000000000013', 5, 'ลิขิตรักสองสวรรค์ ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d13/ep5.mp4', 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400', FALSE, 38000),

-- Drama 14: เจ้าหญิงน้อย
('ep-014-01', 'd1000001-0000-0000-0000-000000000014', 1, 'เจ้าหญิงน้อย ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d14/ep1.mp4', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400', TRUE, 15000),
('ep-014-02', 'd1000001-0000-0000-0000-000000000014', 2, 'เจ้าหญิงน้อย ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d14/ep2.mp4', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400', FALSE, 13000),
('ep-014-03', 'd1000001-0000-0000-0000-000000000014', 3, 'เจ้าหญิงน้อย ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d14/ep3.mp4', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400', FALSE, 11000),
('ep-014-04', 'd1000001-0000-0000-0000-000000000014', 4, 'เจ้าหญิงน้อย ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d14/ep4.mp4', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400', FALSE, 10000),
('ep-014-05', 'd1000001-0000-0000-0000-000000000014', 5, 'เจ้าหญิงน้อย ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d14/ep5.mp4', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400', FALSE, 9000),

-- Drama 15: ขุนนางหญิง
('ep-015-01', 'd1000001-0000-0000-0000-000000000015', 1, 'ขุนนางหญิง ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d15/ep1.mp4', 'https://images.unsplash.com/photo-1464863979621-258859e62245?w=400', TRUE, 38000),
('ep-015-02', 'd1000001-0000-0000-0000-000000000015', 2, 'ขุนนางหญิง ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d15/ep2.mp4', 'https://images.unsplash.com/photo-1464863979621-258859e62245?w=400', FALSE, 35000),
('ep-015-03', 'd1000001-0000-0000-0000-000000000015', 3, 'ขุนนางหญิง ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d15/ep3.mp4', 'https://images.unsplash.com/photo-1464863979621-258859e62245?w=400', FALSE, 33000),
('ep-015-04', 'd1000001-0000-0000-0000-000000000015', 4, 'ขุนนางหญิง ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d15/ep4.mp4', 'https://images.unsplash.com/photo-1464863979621-258859e62245?w=400', FALSE, 31000),
('ep-015-05', 'd1000001-0000-0000-0000-000000000015', 5, 'ขุนนางหญิง ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d15/ep5.mp4', 'https://images.unsplash.com/photo-1464863979621-258859e62245?w=400', FALSE, 29000),

-- Drama 16: ฟ้าลิขิต
('ep-016-01', 'd1000001-0000-0000-0000-000000000016', 1, 'ฟ้าลิขิต ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d16/ep1.mp4', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400', TRUE, 32000),
('ep-016-02', 'd1000001-0000-0000-0000-000000000016', 2, 'ฟ้าลิขิต ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d16/ep2.mp4', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400', FALSE, 29000),
('ep-016-03', 'd1000001-0000-0000-0000-000000000016', 3, 'ฟ้าลิขิต ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d16/ep3.mp4', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400', FALSE, 27000),
('ep-016-04', 'd1000001-0000-0000-0000-000000000016', 4, 'ฟ้าลิขิต ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d16/ep4.mp4', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400', FALSE, 25000),
('ep-016-05', 'd1000001-0000-0000-0000-000000000016', 5, 'ฟ้าลิขิต ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d16/ep5.mp4', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400', FALSE, 23000),

-- Drama 17: เกมล่าหัวใจ
('ep-017-01', 'd1000001-0000-0000-0000-000000000017', 1, 'เกมล่าหัวใจ ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d17/ep1.mp4', 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400', TRUE, 19000),
('ep-017-02', 'd1000001-0000-0000-0000-000000000017', 2, 'เกมล่าหัวใจ ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d17/ep2.mp4', 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400', FALSE, 17000),
('ep-017-03', 'd1000001-0000-0000-0000-000000000017', 3, 'เกมล่าหัวใจ ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d17/ep3.mp4', 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400', FALSE, 15000),
('ep-017-04', 'd1000001-0000-0000-0000-000000000017', 4, 'เกมล่าหัวใจ ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d17/ep4.mp4', 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400', FALSE, 13000),
('ep-017-05', 'd1000001-0000-0000-0000-000000000017', 5, 'เกมล่าหัวใจ ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d17/ep5.mp4', 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400', FALSE, 11000),

-- Drama 18: สะดุดรักยัยจอมหยิ่ง
('ep-018-01', 'd1000001-0000-0000-0000-000000000018', 1, 'สะดุดรักยัยจอมหยิ่ง ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d18/ep1.mp4', 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=400', TRUE, 26000),
('ep-018-02', 'd1000001-0000-0000-0000-000000000018', 2, 'สะดุดรักยัยจอมหยิ่ง ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d18/ep2.mp4', 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=400', FALSE, 24000),
('ep-018-03', 'd1000001-0000-0000-0000-000000000018', 3, 'สะดุดรักยัยจอมหยิ่ง ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d18/ep3.mp4', 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=400', FALSE, 22000),
('ep-018-04', 'd1000001-0000-0000-0000-000000000018', 4, 'สะดุดรักยัยจอมหยิ่ง ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d18/ep4.mp4', 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=400', FALSE, 20000),
('ep-018-05', 'd1000001-0000-0000-0000-000000000018', 5, 'สะดุดรักยัยจอมหยิ่ง ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d18/ep5.mp4', 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=400', FALSE, 18000),

-- Drama 19: เทพบุตรนักสืบ
('ep-019-01', 'd1000001-0000-0000-0000-000000000019', 1, 'เทพบุตรนักสืบ ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d19/ep1.mp4', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400', TRUE, 17000),
('ep-019-02', 'd1000001-0000-0000-0000-000000000019', 2, 'เทพบุตรนักสืบ ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d19/ep2.mp4', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400', FALSE, 15000),
('ep-019-03', 'd1000001-0000-0000-0000-000000000019', 3, 'เทพบุตรนักสืบ ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d19/ep3.mp4', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400', FALSE, 13000),
('ep-019-04', 'd1000001-0000-0000-0000-000000000019', 4, 'เทพบุตรนักสืบ ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d19/ep4.mp4', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400', FALSE, 11000),
('ep-019-05', 'd1000001-0000-0000-0000-000000000019', 5, 'เทพบุตรนักสืบ ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d19/ep5.mp4', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400', FALSE, 9000),

-- Drama 20: รักนี้ไม่มีทางแพ้
('ep-020-01', 'd1000001-0000-0000-0000-000000000020', 1, 'รักนี้ไม่มีทางแพ้ ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d20/ep1.mp4', 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400', TRUE, 42000),
('ep-020-02', 'd1000001-0000-0000-0000-000000000020', 2, 'รักนี้ไม่มีทางแพ้ ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d20/ep2.mp4', 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400', FALSE, 39000),
('ep-020-03', 'd1000001-0000-0000-0000-000000000020', 3, 'รักนี้ไม่มีทางแพ้ ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d20/ep3.mp4', 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400', FALSE, 37000),
('ep-020-04', 'd1000001-0000-0000-0000-000000000020', 4, 'รักนี้ไม่มีทางแพ้ ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d20/ep4.mp4', 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400', FALSE, 35000),
('ep-020-05', 'd1000001-0000-0000-0000-000000000020', 5, 'รักนี้ไม่มีทางแพ้ ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d20/ep5.mp4', 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400', FALSE, 33000),

-- Drama 21-42 Episodes (continuing pattern)
-- Drama 21: ตำนานจักรพรรดินีหวู่
('ep-021-01', 'd1000001-0000-0000-0000-000000000021', 1, 'ตำนานจักรพรรดินีหวู่ ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d21/ep1.mp4', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400', TRUE, 34000),
('ep-021-02', 'd1000001-0000-0000-0000-000000000021', 2, 'ตำนานจักรพรรดินีหวู่ ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d21/ep2.mp4', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400', FALSE, 31000),
('ep-021-03', 'd1000001-0000-0000-0000-000000000021', 3, 'ตำนานจักรพรรดินีหวู่ ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d21/ep3.mp4', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400', FALSE, 29000),
('ep-021-04', 'd1000001-0000-0000-0000-000000000021', 4, 'ตำนานจักรพรรดินีหวู่ ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d21/ep4.mp4', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400', FALSE, 27000),
('ep-021-05', 'd1000001-0000-0000-0000-000000000021', 5, 'ตำนานจักรพรรดินีหวู่ ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d21/ep5.mp4', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400', FALSE, 25000),

-- Drama 22: มนตราจันทรา
('ep-022-01', 'd1000001-0000-0000-0000-000000000022', 1, 'มนตราจันทรา ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d22/ep1.mp4', 'https://images.unsplash.com/photo-1485893086445-ed75865251e0?w=400', TRUE, 13000),
('ep-022-02', 'd1000001-0000-0000-0000-000000000022', 2, 'มนตราจันทรา ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d22/ep2.mp4', 'https://images.unsplash.com/photo-1485893086445-ed75865251e0?w=400', FALSE, 11000),
('ep-022-03', 'd1000001-0000-0000-0000-000000000022', 3, 'มนตราจันทรา ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d22/ep3.mp4', 'https://images.unsplash.com/photo-1485893086445-ed75865251e0?w=400', FALSE, 9000),
('ep-022-04', 'd1000001-0000-0000-0000-000000000022', 4, 'มนตราจันทรา ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d22/ep4.mp4', 'https://images.unsplash.com/photo-1485893086445-ed75865251e0?w=400', FALSE, 8000),
('ep-022-05', 'd1000001-0000-0000-0000-000000000022', 5, 'มนตราจันทรา ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d22/ep5.mp4', 'https://images.unsplash.com/photo-1485893086445-ed75865251e0?w=400', FALSE, 7000),

-- Drama 23-42 (condensed for brevity - same pattern)
('ep-023-01', 'd1000001-0000-0000-0000-000000000023', 1, 'ดาบมังกร ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d23/ep1.mp4', 'https://images.unsplash.com/photo-1507081323647-4d250478b919?w=400', TRUE, 29000),
('ep-023-02', 'd1000001-0000-0000-0000-000000000023', 2, 'ดาบมังกร ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d23/ep2.mp4', 'https://images.unsplash.com/photo-1507081323647-4d250478b919?w=400', FALSE, 26000),
('ep-023-03', 'd1000001-0000-0000-0000-000000000023', 3, 'ดาบมังกร ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d23/ep3.mp4', 'https://images.unsplash.com/photo-1507081323647-4d250478b919?w=400', FALSE, 24000),
('ep-023-04', 'd1000001-0000-0000-0000-000000000023', 4, 'ดาบมังกร ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d23/ep4.mp4', 'https://images.unsplash.com/photo-1507081323647-4d250478b919?w=400', FALSE, 22000),
('ep-023-05', 'd1000001-0000-0000-0000-000000000023', 5, 'ดาบมังกร ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d23/ep5.mp4', 'https://images.unsplash.com/photo-1507081323647-4d250478b919?w=400', FALSE, 20000),

('ep-024-01', 'd1000001-0000-0000-0000-000000000024', 1, 'เมียหลวง ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d24/ep1.mp4', 'https://images.unsplash.com/photo-1504730030853-ebb04f0b7c2c?w=400', TRUE, 11000),
('ep-024-02', 'd1000001-0000-0000-0000-000000000024', 2, 'เมียหลวง ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d24/ep2.mp4', 'https://images.unsplash.com/photo-1504730030853-ebb04f0b7c2c?w=400', FALSE, 9000),
('ep-024-03', 'd1000001-0000-0000-0000-000000000024', 3, 'เมียหลวง ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d24/ep3.mp4', 'https://images.unsplash.com/photo-1504730030853-ebb04f0b7c2c?w=400', FALSE, 8000),
('ep-024-04', 'd1000001-0000-0000-0000-000000000024', 4, 'เมียหลวง ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d24/ep4.mp4', 'https://images.unsplash.com/photo-1504730030853-ebb04f0b7c2c?w=400', FALSE, 7000),
('ep-024-05', 'd1000001-0000-0000-0000-000000000024', 5, 'เมียหลวง ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d24/ep5.mp4', 'https://images.unsplash.com/photo-1504730030853-ebb04f0b7c2c?w=400', FALSE, 6000),

('ep-025-01', 'd1000001-0000-0000-0000-000000000025', 1, 'เกาะรักเกาะสวรรค์ ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d25/ep1.mp4', 'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?w=400', TRUE, 14000),
('ep-025-02', 'd1000001-0000-0000-0000-000000000025', 2, 'เกาะรักเกาะสวรรค์ ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d25/ep2.mp4', 'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?w=400', FALSE, 12000),
('ep-025-03', 'd1000001-0000-0000-0000-000000000025', 3, 'เกาะรักเกาะสวรรค์ ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d25/ep3.mp4', 'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?w=400', FALSE, 10000),
('ep-025-04', 'd1000001-0000-0000-0000-000000000025', 4, 'เกาะรักเกาะสวรรค์ ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d25/ep4.mp4', 'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?w=400', FALSE, 9000),
('ep-025-05', 'd1000001-0000-0000-0000-000000000025', 5, 'เกาะรักเกาะสวรรค์ ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d25/ep5.mp4', 'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?w=400', FALSE, 8000),

('ep-026-01', 'd1000001-0000-0000-0000-000000000026', 1, 'ยอดชายาสะท้านฟ้า ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d26/ep1.mp4', 'https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?w=400', TRUE, 16000),
('ep-026-02', 'd1000001-0000-0000-0000-000000000026', 2, 'ยอดชายาสะท้านฟ้า ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d26/ep2.mp4', 'https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?w=400', FALSE, 14000),
('ep-026-03', 'd1000001-0000-0000-0000-000000000026', 3, 'ยอดชายาสะท้านฟ้า ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d26/ep3.mp4', 'https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?w=400', FALSE, 12000),
('ep-026-04', 'd1000001-0000-0000-0000-000000000026', 4, 'ยอดชายาสะท้านฟ้า ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d26/ep4.mp4', 'https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?w=400', FALSE, 10000),
('ep-026-05', 'd1000001-0000-0000-0000-000000000026', 5, 'ยอดชายาสะท้านฟ้า ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d26/ep5.mp4', 'https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?w=400', FALSE, 9000),

('ep-027-01', 'd1000001-0000-0000-0000-000000000027', 1, 'จอมนางค์เคียงบัลลังก์ ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d27/ep1.mp4', 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=400', TRUE, 46000),
('ep-027-02', 'd1000001-0000-0000-0000-000000000027', 2, 'จอมนางค์เคียงบัลลังก์ ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d27/ep2.mp4', 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=400', FALSE, 43000),
('ep-027-03', 'd1000001-0000-0000-0000-000000000027', 3, 'จอมนางค์เคียงบัลลังก์ ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d27/ep3.mp4', 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=400', FALSE, 40000),
('ep-027-04', 'd1000001-0000-0000-0000-000000000027', 4, 'จอมนางค์เคียงบัลลังก์ ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d27/ep4.mp4', 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=400', FALSE, 38000),
('ep-027-05', 'd1000001-0000-0000-0000-000000000027', 5, 'จอมนางค์เคียงบัลลังก์ ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d27/ep5.mp4', 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=400', FALSE, 36000),

('ep-028-01', 'd1000001-0000-0000-0000-000000000028', 1, 'ล่องไพรนิยาย ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d28/ep1.mp4', 'https://images.unsplash.com/photo-1463453091185-61582044d556?w=400', TRUE, 56000),
('ep-028-02', 'd1000001-0000-0000-0000-000000000028', 2, 'ล่องไพรนิยาย ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d28/ep2.mp4', 'https://images.unsplash.com/photo-1463453091185-61582044d556?w=400', FALSE, 52000),
('ep-028-03', 'd1000001-0000-0000-0000-000000000028', 3, 'ล่องไพรนิยาย ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d28/ep3.mp4', 'https://images.unsplash.com/photo-1463453091185-61582044d556?w=400', FALSE, 49000),
('ep-028-04', 'd1000001-0000-0000-0000-000000000028', 4, 'ล่องไพรนิยาย ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d28/ep4.mp4', 'https://images.unsplash.com/photo-1463453091185-61582044d556?w=400', FALSE, 46000),
('ep-028-05', 'd1000001-0000-0000-0000-000000000028', 5, 'ล่องไพรนิยาย ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d28/ep5.mp4', 'https://images.unsplash.com/photo-1463453091185-61582044d556?w=400', FALSE, 43000),

('ep-029-01', 'd1000001-0000-0000-0000-000000000029', 1, 'เล่ห์รักจันทร์ดาว ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d29/ep1.mp4', 'https://images.unsplash.com/photo-1496440737103-cd596325d314?w=400', TRUE, 15000),
('ep-029-02', 'd1000001-0000-0000-0000-000000000029', 2, 'เล่ห์รักจันทร์ดาว ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d29/ep2.mp4', 'https://images.unsplash.com/photo-1496440737103-cd596325d314?w=400', FALSE, 13000),
('ep-029-03', 'd1000001-0000-0000-0000-000000000029', 3, 'เล่ห์รักจันทร์ดาว ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d29/ep3.mp4', 'https://images.unsplash.com/photo-1496440737103-cd596325d314?w=400', FALSE, 11000),
('ep-029-04', 'd1000001-0000-0000-0000-000000000029', 4, 'เล่ห์รักจันทร์ดาว ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d29/ep4.mp4', 'https://images.unsplash.com/photo-1496440737103-cd596325d314?w=400', FALSE, 9000),
('ep-029-05', 'd1000001-0000-0000-0000-000000000029', 5, 'เล่ห์รักจันทร์ดาว ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d29/ep5.mp4', 'https://images.unsplash.com/photo-1496440737103-cd596325d314?w=400', FALSE, 8000),

('ep-030-01', 'd1000001-0000-0000-0000-000000000030', 1, 'องค์หญิงแสนร้ายกับยอดชายมาดเข้ม ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d30/ep1.mp4', 'https://images.unsplash.com/photo-1499996860823-5f82e24f84f6?w=400', TRUE, 32000),
('ep-030-02', 'd1000001-0000-0000-0000-000000000030', 2, 'องค์หญิงแสนร้ายกับยอดชายมาดเข้ม ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d30/ep2.mp4', 'https://images.unsplash.com/photo-1499996860823-5f82e24f84f6?w=400', FALSE, 29000),
('ep-030-03', 'd1000001-0000-0000-0000-000000000030', 3, 'องค์หญิงแสนร้ายกับยอดชายมาดเข้ม ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d30/ep3.mp4', 'https://images.unsplash.com/photo-1499996860823-5f82e24f84f6?w=400', FALSE, 27000),
('ep-030-04', 'd1000001-0000-0000-0000-000000000030', 4, 'องค์หญิงแสนร้ายกับยอดชายมาดเข้ม ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d30/ep4.mp4', 'https://images.unsplash.com/photo-1499996860823-5f82e24f84f6?w=400', FALSE, 25000),
('ep-030-05', 'd1000001-0000-0000-0000-000000000030', 5, 'องค์หญิงแสนร้ายกับยอดชายมาดเข้ม ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d30/ep5.mp4', 'https://images.unsplash.com/photo-1499996860823-5f82e24f84f6?w=400', FALSE, 23000),

('ep-031-01', 'd1000001-0000-0000-0000-000000000031', 1, 'ดาราจักรอลเวง ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d31/ep1.mp4', 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=400', TRUE, 39000),
('ep-031-02', 'd1000001-0000-0000-0000-000000000031', 2, 'ดาราจักรอลเวง ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d31/ep2.mp4', 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=400', FALSE, 36000),
('ep-031-03', 'd1000001-0000-0000-0000-000000000031', 3, 'ดาราจักรอลเวง ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d31/ep3.mp4', 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=400', FALSE, 33000),
('ep-031-04', 'd1000001-0000-0000-0000-000000000031', 4, 'ดาราจักรอลเวง ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d31/ep4.mp4', 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=400', FALSE, 31000),
('ep-031-05', 'd1000001-0000-0000-0000-000000000031', 5, 'ดาราจักรอลเวง ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d31/ep5.mp4', 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=400', FALSE, 29000),

('ep-032-01', 'd1000001-0000-0000-0000-000000000032', 1, 'ฮวาชิง ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d32/ep1.mp4', 'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=400', TRUE, 28000),
('ep-032-02', 'd1000001-0000-0000-0000-000000000032', 2, 'ฮวาชิง ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d32/ep2.mp4', 'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=400', FALSE, 25000),
('ep-032-03', 'd1000001-0000-0000-0000-000000000032', 3, 'ฮวาชิง ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d32/ep3.mp4', 'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=400', FALSE, 23000),
('ep-032-04', 'd1000001-0000-0000-0000-000000000032', 4, 'ฮวาชิง ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d32/ep4.mp4', 'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=400', FALSE, 21000),
('ep-032-05', 'd1000001-0000-0000-0000-000000000032', 5, 'ฮวาชิง ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d32/ep5.mp4', 'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=400', FALSE, 19000),

('ep-033-01', 'd1000001-0000-0000-0000-000000000033', 1, 'ราชินีฝ้ายคำ ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d33/ep1.mp4', 'https://images.unsplash.com/photo-1485811055483-1c09e64d4576?w=400', TRUE, 19000),
('ep-033-02', 'd1000001-0000-0000-0000-000000000033', 2, 'ราชินีฝ้ายคำ ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d33/ep2.mp4', 'https://images.unsplash.com/photo-1485811055483-1c09e64d4576?w=400', FALSE, 17000),
('ep-033-03', 'd1000001-0000-0000-0000-000000000033', 3, 'ราชินีฝ้ายคำ ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d33/ep3.mp4', 'https://images.unsplash.com/photo-1485811055483-1c09e64d4576?w=400', FALSE, 15000),
('ep-033-04', 'd1000001-0000-0000-0000-000000000033', 4, 'ราชินีฝ้ายคำ ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d33/ep4.mp4', 'https://images.unsplash.com/photo-1485811055483-1c09e64d4576?w=400', FALSE, 13000),
('ep-033-05', 'd1000001-0000-0000-0000-000000000033', 5, 'ราชินีฝ้ายคำ ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d33/ep5.mp4', 'https://images.unsplash.com/photo-1485811055483-1c09e64d4576?w=400', FALSE, 11000),

('ep-034-01', 'd1000001-0000-0000-0000-000000000034', 1, 'สิบไมล์ดอกท้อบาน ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d34/ep1.mp4', 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400', TRUE, 64000),
('ep-034-02', 'd1000001-0000-0000-0000-000000000034', 2, 'สิบไมล์ดอกท้อบาน ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d34/ep2.mp4', 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400', FALSE, 60000),
('ep-034-03', 'd1000001-0000-0000-0000-000000000034', 3, 'สิบไมล์ดอกท้อบาน ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d34/ep3.mp4', 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400', FALSE, 57000),
('ep-034-04', 'd1000001-0000-0000-0000-000000000034', 4, 'สิบไมล์ดอกท้อบาน ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d34/ep4.mp4', 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400', FALSE, 54000),
('ep-034-05', 'd1000001-0000-0000-0000-000000000034', 5, 'สิบไมล์ดอกท้อบาน ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d34/ep5.mp4', 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400', FALSE, 51000),

('ep-035-01', 'd1000001-0000-0000-0000-000000000035', 1, 'คู่แค้นแสนลึก ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d35/ep1.mp4', 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400', TRUE, 54000),
('ep-035-02', 'd1000001-0000-0000-0000-000000000035', 2, 'คู่แค้นแสนลึก ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d35/ep2.mp4', 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400', FALSE, 50000),
('ep-035-03', 'd1000001-0000-0000-0000-000000000035', 3, 'คู่แค้นแสนลึก ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d35/ep3.mp4', 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400', FALSE, 47000),
('ep-035-04', 'd1000001-0000-0000-0000-000000000035', 4, 'คู่แค้นแสนลึก ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d35/ep4.mp4', 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400', FALSE, 44000),
('ep-035-05', 'd1000001-0000-0000-0000-000000000035', 5, 'คู่แค้นแสนลึก ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d35/ep5.mp4', 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400', FALSE, 41000),

('ep-036-01', 'd1000001-0000-0000-0000-000000000036', 1, 'องค์หญิงใหญ่ ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d36/ep1.mp4', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400', TRUE, 31000),
('ep-036-02', 'd1000001-0000-0000-0000-000000000036', 2, 'องค์หญิงใหญ่ ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d36/ep2.mp4', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400', FALSE, 28000),
('ep-036-03', 'd1000001-0000-0000-0000-000000000036', 3, 'องค์หญิงใหญ่ ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d36/ep3.mp4', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400', FALSE, 26000),
('ep-036-04', 'd1000001-0000-0000-0000-000000000036', 4, 'องค์หญิงใหญ่ ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d36/ep4.mp4', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400', FALSE, 24000),
('ep-036-05', 'd1000001-0000-0000-0000-000000000036', 5, 'องค์หญิงใหญ่ ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d36/ep5.mp4', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400', FALSE, 22000),

('ep-037-01', 'd1000001-0000-0000-0000-000000000037', 1, 'รักนี้หวานมาก ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d37/ep1.mp4', 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400', TRUE, 24000),
('ep-037-02', 'd1000001-0000-0000-0000-000000000037', 2, 'รักนี้หวานมาก ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d37/ep2.mp4', 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400', FALSE, 22000),
('ep-037-03', 'd1000001-0000-0000-0000-000000000037', 3, 'รักนี้หวานมาก ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d37/ep3.mp4', 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400', FALSE, 20000),
('ep-037-04', 'd1000001-0000-0000-0000-000000000037', 4, 'รักนี้หวานมาก ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d37/ep4.mp4', 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400', FALSE, 18000),
('ep-037-05', 'd1000001-0000-0000-0000-000000000037', 5, 'รักนี้หวานมาก ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d37/ep5.mp4', 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400', FALSE, 16000),

('ep-038-01', 'd1000001-0000-0000-0000-000000000038', 1, 'ศึกชิงนาง ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d38/ep1.mp4', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400', TRUE, 36000),
('ep-038-02', 'd1000001-0000-0000-0000-000000000038', 2, 'ศึกชิงนาง ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d38/ep2.mp4', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400', FALSE, 33000),
('ep-038-03', 'd1000001-0000-0000-0000-000000000038', 3, 'ศึกชิงนาง ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d38/ep3.mp4', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400', FALSE, 30000),
('ep-038-04', 'd1000001-0000-0000-0000-000000000038', 4, 'ศึกชิงนาง ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d38/ep4.mp4', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400', FALSE, 28000),
('ep-038-05', 'd1000001-0000-0000-0000-000000000038', 5, 'ศึกชิงนาง ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d38/ep5.mp4', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400', FALSE, 26000),

('ep-039-01', 'd1000001-0000-0000-0000-000000000039', 1, 'ลิขิตแค้นข้ามเวลา ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d39/ep1.mp4', 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400', TRUE, 40000),
('ep-039-02', 'd1000001-0000-0000-0000-000000000039', 2, 'ลิขิตแค้นข้ามเวลา ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d39/ep2.mp4', 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400', FALSE, 37000),
('ep-039-03', 'd1000001-0000-0000-0000-000000000039', 3, 'ลิขิตแค้นข้ามเวลา ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d39/ep3.mp4', 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400', FALSE, 34000),
('ep-039-04', 'd1000001-0000-0000-0000-000000000039', 4, 'ลิขิตแค้นข้ามเวลา ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d39/ep4.mp4', 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400', FALSE, 31000),
('ep-039-05', 'd1000001-0000-0000-0000-000000000039', 5, 'ลิขิตแค้นข้ามเวลา ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d39/ep5.mp4', 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400', FALSE, 28000),

('ep-040-01', 'd1000001-0000-0000-0000-000000000040', 1, 'รักบริสุทธิ์ ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d40/ep1.mp4', 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400', TRUE, 35000),
('ep-040-02', 'd1000001-0000-0000-0000-000000000040', 2, 'รักบริสุทธิ์ ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d40/ep2.mp4', 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400', FALSE, 32000),
('ep-040-03', 'd1000001-0000-0000-0000-000000000040', 3, 'รักบริสุทธิ์ ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d40/ep3.mp4', 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400', FALSE, 29000),
('ep-040-04', 'd1000001-0000-0000-0000-000000000040', 4, 'รักบริสุทธิ์ ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d40/ep4.mp4', 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400', FALSE, 26000),
('ep-040-05', 'd1000001-0000-0000-0000-000000000040', 5, 'รักบริสุทธิ์ ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d40/ep5.mp4', 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400', FALSE, 24000),

('ep-041-01', 'd1000001-0000-0000-0000-000000000041', 1, 'จอมนางจอมใจ ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d41/ep1.mp4', 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400', TRUE, 33000),
('ep-041-02', 'd1000001-0000-0000-0000-000000000041', 2, 'จอมนางจอมใจ ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d41/ep2.mp4', 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400', FALSE, 30000),
('ep-041-03', 'd1000001-0000-0000-0000-000000000041', 3, 'จอมนางจอมใจ ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d41/ep3.mp4', 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400', FALSE, 27000),
('ep-041-04', 'd1000001-0000-0000-0000-000000000041', 4, 'จอมนางจอมใจ ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d41/ep4.mp4', 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400', FALSE, 25000),
('ep-041-05', 'd1000001-0000-0000-0000-000000000041', 5, 'จอมนางจอมใจ ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d41/ep5.mp4', 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400', FALSE, 23000),

('ep-042-01', 'd1000001-0000-0000-0000-000000000042', 1, 'รักที่เหนือกาลเวลา ตอนที่ 1', 'เนื้อหาตอนที่ 1', 45, 'https://example.com/videos/d42/ep1.mp4', 'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?w=400', TRUE, 58000),
('ep-042-02', 'd1000001-0000-0000-0000-000000000042', 2, 'รักที่เหนือกาลเวลา ตอนที่ 2', 'เนื้อหาตอนที่ 2', 45, 'https://example.com/videos/d42/ep2.mp4', 'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?w=400', FALSE, 54000),
('ep-042-03', 'd1000001-0000-0000-0000-000000000042', 3, 'รักที่เหนือกาลเวลา ตอนที่ 3', 'เนื้อหาตอนที่ 3', 45, 'https://example.com/videos/d42/ep3.mp4', 'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?w=400', FALSE, 50000),
('ep-042-04', 'd1000001-0000-0000-0000-000000000042', 4, 'รักที่เหนือกาลเวลา ตอนที่ 4', 'เนื้อหาตอนที่ 4', 45, 'https://example.com/videos/d42/ep4.mp4', 'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?w=400', FALSE, 47000),
('ep-042-05', 'd1000001-0000-0000-0000-000000000042', 5, 'รักที่เหนือกาลเวลา ตอนที่ 5', 'เนื้อหาตอนที่ 5', 45, 'https://example.com/videos/d42/ep5.mp4', 'https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453?w=400', FALSE, 44000);
