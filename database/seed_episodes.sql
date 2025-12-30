-- =====================================================
-- DramaBox Seed Data - Episodes
-- หมายเหตุ: ต้องรัน seed_dramas.sql ก่อน
-- =====================================================

-- ดึง drama_id จาก title เพื่อใช้ในการ insert episodes
-- ตัวอย่างนี้ใช้ subquery เพื่อดึง drama_id

-- Episodes สำหรับ See Her Again
INSERT INTO public.episodes (drama_id, episode_number, title, description, thumbnail_url, duration, is_free, video_url)
SELECT d.id, ep.episode_number, ep.title, ep.description, d.poster_url, 45, ep.is_free, 'https://www.youtube.com/embed/dQw4w9WgXcQ'
FROM public.dramas d
CROSS JOIN (
    VALUES 
    (1, 'ตอนที่ 1', 'จุดเริ่มต้นของเรื่องราว', true),
    (2, 'ตอนที่ 2', 'การพบกันครั้งใหม่', true),
    (3, 'ตอนที่ 3', 'ความทรงจำที่หายไป', false),
    (4, 'ตอนที่ 4', 'เส้นทางแห่งความจริง', false),
    (5, 'ตอนที่ 5', 'การตัดสินใจครั้งสำคัญ', false)
) AS ep(episode_number, title, description, is_free)
WHERE d.title = 'See Her Again';

-- Episodes สำหรับ ปรมาจารย์ลัทธิเต๋ากับแมวสาวพลังปีศาจ
INSERT INTO public.episodes (drama_id, episode_number, title, description, thumbnail_url, duration, is_free, video_url)
SELECT d.id, ep.episode_number, ep.title, ep.description, d.poster_url, 42, ep.is_free, 'https://www.youtube.com/embed/dQw4w9WgXcQ'
FROM public.dramas d
CROSS JOIN (
    VALUES 
    (1, 'ตอนที่ 1', 'การพบกันของปรมาจารย์และแมวสาว', true),
    (2, 'ตอนที่ 2', 'พลังปีศาจที่ซ่อนเร้น', true),
    (3, 'ตอนที่ 3', 'บททดสอบครั้งแรก', false),
    (4, 'ตอนที่ 4', 'ความลับของลัทธิเต๋า', false),
    (5, 'ตอนที่ 5', 'ศึกปีศาจครั้งใหญ่', false)
) AS ep(episode_number, title, description, is_free)
WHERE d.title = 'ปรมาจารย์ลัทธิเต๋ากับแมวสาวพลังปีศาจ';

-- Episodes สำหรับ กิน วิ่ง และความรัก
INSERT INTO public.episodes (drama_id, episode_number, title, description, thumbnail_url, duration, is_free, video_url)
SELECT d.id, ep.episode_number, ep.title, ep.description, d.poster_url, 45, ep.is_free, 'https://www.youtube.com/embed/dQw4w9WgXcQ'
FROM public.dramas d
CROSS JOIN (
    VALUES 
    (1, 'ตอนที่ 1', 'จุดเริ่มต้นของนักวิ่ง', true),
    (2, 'ตอนที่ 2', 'ความฝันที่ไม่มีวันหยุด', true),
    (3, 'ตอนที่ 3', 'การแข่งขันครั้งแรก', false),
    (4, 'ตอนที่ 4', 'คู่แข่งที่น่าเกรงขาม', false),
    (5, 'ตอนที่ 5', 'ความรักที่ก่อตัว', false)
) AS ep(episode_number, title, description, is_free)
WHERE d.title = 'กิน วิ่ง และความรัก';

-- Episodes สำหรับ ปรมาจารย์ลัทธิมาร (The Untamed)
INSERT INTO public.episodes (drama_id, episode_number, title, description, thumbnail_url, duration, is_free, video_url)
SELECT d.id, ep.episode_number, ep.title, ep.description, d.poster_url, 45, ep.is_free, 'https://www.youtube.com/embed/dQw4w9WgXcQ'
FROM public.dramas d
CROSS JOIN (
    VALUES 
    (1, 'ตอนที่ 1', 'การกลับมาของปรมาจารย์', true),
    (2, 'ตอนที่ 2', 'ความทรงจำในอดีต', true),
    (3, 'ตอนที่ 3', 'สหายเก่า', false),
    (4, 'ตอนที่ 4', 'การไขปริศนา', false),
    (5, 'ตอนที่ 5', 'ลัทธิมารที่ซ่อนเร้น', false)
) AS ep(episode_number, title, description, is_free)
WHERE d.title = 'ปรมาจารย์ลัทธิมาร';

-- Episodes สำหรับ เวยเวย เธอยิ้มโลกละลาย (Love O2O)
INSERT INTO public.episodes (drama_id, episode_number, title, description, thumbnail_url, duration, is_free, video_url)
SELECT d.id, ep.episode_number, ep.title, ep.description, d.poster_url, 45, ep.is_free, 'https://www.youtube.com/embed/dQw4w9WgXcQ'
FROM public.dramas d
CROSS JOIN (
    VALUES 
    (1, 'ตอนที่ 1', 'เวยเวยในเกมออนไลน์', true),
    (2, 'ตอนที่ 2', 'การพบกันในโลกเสมือน', true),
    (3, 'ตอนที่ 3', 'รักที่เกิดขึ้น', false),
    (4, 'ตอนที่ 4', 'จากเกมสู่ความจริง', false),
    (5, 'ตอนที่ 5', 'ยิ้มที่ทำให้โลกละลาย', false)
) AS ep(episode_number, title, description, is_free)
WHERE d.title = 'เวยเวย เธอยิ้มโลกละลาย';

-- สามารถเพิ่ม episodes สำหรับซีรีส์อื่นๆ ได้ตามรูปแบบเดียวกัน
