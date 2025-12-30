-- =====================================================
-- MovieForU Database Backup
-- Generated: 2024-12-30
-- =====================================================

-- =====================================================
-- PART 1: Schema (Structure)
-- =====================================================

-- Drop tables if exist (for clean restore)
DROP TABLE IF EXISTS public.favorites CASCADE;
DROP TABLE IF EXISTS public.episodes CASCADE;
DROP TABLE IF EXISTS public.dramas CASCADE;

-- Create dramas table
CREATE TABLE public.dramas (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    title_en TEXT,
    description TEXT,
    poster_url TEXT NOT NULL,
    episodes INTEGER DEFAULT 1,
    category TEXT[] DEFAULT '{}',
    section TEXT DEFAULT 'general',
    view_count INTEGER DEFAULT 0,
    rating NUMERIC DEFAULT 0,
    year INTEGER,
    is_featured BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create episodes table
CREATE TABLE public.episodes (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    drama_id UUID NOT NULL REFERENCES public.dramas(id) ON DELETE CASCADE,
    episode_number INTEGER NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    thumbnail_url TEXT,
    duration INTEGER DEFAULT 0,
    is_free BOOLEAN DEFAULT false,
    video_url TEXT,
    view_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create favorites table
CREATE TABLE public.favorites (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL,
    drama_id UUID NOT NULL REFERENCES public.dramas(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create indexes
CREATE INDEX idx_episodes_drama_id ON public.episodes(drama_id);
CREATE INDEX idx_favorites_user_id ON public.favorites(user_id);
CREATE INDEX idx_favorites_drama_id ON public.favorites(drama_id);
CREATE INDEX idx_dramas_section ON public.dramas(section);
CREATE INDEX idx_dramas_is_featured ON public.dramas(is_featured);

-- =====================================================
-- PART 2: Enable Row Level Security (RLS)
-- =====================================================

ALTER TABLE public.dramas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.episodes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;

-- Dramas policies (public read, authenticated write)
CREATE POLICY "Anyone can view dramas" ON public.dramas FOR SELECT USING (true);
CREATE POLICY "Authenticated users can insert dramas" ON public.dramas FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);
CREATE POLICY "Authenticated users can update dramas" ON public.dramas FOR UPDATE USING (auth.uid() IS NOT NULL);
CREATE POLICY "Authenticated users can delete dramas" ON public.dramas FOR DELETE USING (auth.uid() IS NOT NULL);

-- Episodes policies (public read, authenticated write)
CREATE POLICY "Anyone can view episodes" ON public.episodes FOR SELECT USING (true);
CREATE POLICY "Authenticated users can insert episodes" ON public.episodes FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);
CREATE POLICY "Authenticated users can update episodes" ON public.episodes FOR UPDATE USING (auth.uid() IS NOT NULL);
CREATE POLICY "Authenticated users can delete episodes" ON public.episodes FOR DELETE USING (auth.uid() IS NOT NULL);

-- Favorites policies (user-specific)
CREATE POLICY "Users can view their own favorites" ON public.favorites FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can add their own favorites" ON public.favorites FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete their own favorites" ON public.favorites FOR DELETE USING (auth.uid() = user_id);

-- =====================================================
-- PART 3: Seed Data - Dramas
-- =====================================================

INSERT INTO public.dramas (title, title_en, description, poster_url, episodes, category, section, view_count, rating, year, is_featured) VALUES
-- Featured Dramas
('See Her Again', 'See Her Again', 'เรื่องราวของ หยางกวงเย่า นายตำรวจที่ไล่ล่าตามหาความจริงเกี่ยวกับคดีฆาตกรรมต่อเนื่องที่ยาวนานกว่า 25 ปี ที่มีจุดเริ่มต้นมาจากเหตุเพลิงไหม้อาคารตอนปี 1990 ร่วมมือสืบหาความจริงกับ เฉินข่ายฉิง และเจ้าหน้าที่ตำรวจทีมหน่วยอาชญากรรม', 'https://m.media-amazon.com/images/M/MV5BYjlmNDcyNDYtM2VjMy00MTgyLWIxYzgtZGZjMWRjMjhiYjI3XkEyXkFqcGc@._V1_.jpg', 24, ARRAY['สืบสวน', 'ดราม่า', 'ระทึกขวัญ'], 'recommended', 2000000, 8.8, 2024, true),

('ปรมาจารย์ลัทธิเต๋ากับแมวสาวพลังปีศาจ', 'Moonlit Reunion', 'เรื่องราวของ "อู๋เจิน" ธิดาของดยุกแห่งเหอหนาน ผู้มีนิสัยเสรีและกล้าหาญ สามารถมองเห็นวิญญาณได้ตั้งแต่เด็ก และได้รับพลังปีศาจจากอาจารย์แมว ทำให้เธอกลายเป็นผู้ดูแลเมืองปีศาจฉางอันในยามค่ำคืน ร่วมมือกับ "เม่ยจู่อวี่" หลานชายของสนมเอก ผู้มีพรสวรรค์ในด้านเต๋า เพื่อปกป้องความสงบสุขของเมืองฉางอัน', 'https://scontent.fbkk5-5.fna.fbcdn.net/v/t39.30808-6/480806523_122172988118269934_8582820195932546267_n.jpg', 24, ARRAY['ย้อนยุค', 'แฟนตาซี', 'โรแมนติก', 'เหนือธรรมชาติ'], 'featured', 2500000, 8.9, 2025, true),

('กิน วิ่ง และความรัก', 'Eat Run Love', 'ความรักที่เกิดขึ้นระหว่างกานหยาง หนุ่มหล่อจากครอบครัวร่ำรวย และติงจือถง หญิงสาวที่แบกรับภาระหนี้สินและไม่เคยคิดจะมีความรัก ทั้งสองต้องเผชิญกับอุปสรรคมากมายทั้งในด้านความสัมพันธ์และการเงิน', 'https://m.media-amazon.com/images/M/MV5BZjFmMDNkYzQtNjJmYy00ODVkLTk5ZjgtNzg0MjU0ZjFjOTY4XkEyXkFqcGc@._V1_.jpg', 30, ARRAY['โรแมนติก', 'ดราม่า', 'คอมเมดี้'], 'general', 1800000, 8.0, 2025, false),

-- Trending Dramas
('ปลูกรักพักใจ ใต้ต้นมะกอกขาว', 'Under the White Olive Tree', 'ความรักที่เบ่งบานใต้ต้นมะกอกขาว', 'https://m.media-amazon.com/images/M/MV5BNWNiOTczYzEtYTg5OC00YWRmLWI1MjctMDZjYzJkMjg0ZTBiXkEyXkFqcGc@._V1_.jpg', 32, ARRAY['โรแมนติก', 'ดราม่า'], 'trending', 88000, 8.7, 2024, false),

('รักเธอที่สุดเลย', 'Love You the Most', 'เรื่องราวความรักที่ไม่มีวันลืม', 'https://m.media-amazon.com/images/M/MV5BNjE3ZmU1YWMtMjMyMS00NWVhLThkMjYtMTk4ZTAxMjE5OTlhXkEyXkFqcGc@._V1_.jpg', 28, ARRAY['โรแมนติก'], 'trending', 82000, 8.4, 2024, false),

('วันนี้ วันไหน ยังไงก็เธอ', 'Any Day With You', 'ความรักที่ไม่ว่าวันไหนก็ยังคงเป็นเธอ', 'https://m.media-amazon.com/images/M/MV5BYTA4Y2QzOGYtMjJlMi00YmI5LTg2MTktMjk3OTY0YmQxMzYyXkEyXkFqcGc@._V1_.jpg', 30, ARRAY['โรแมนติก', 'ดราม่า'], 'trending', 78000, 8.6, 2023, false),

-- Must-See Dramas
('พรห้าประการ', 'The Five Wishes', 'การเดินทางเพื่อค้นหาพรห้าประการแห่งชีวิต', 'https://m.media-amazon.com/images/M/MV5BODJjZTEyMDItZTZlNy00YzRiLWFjYWUtMmM5ZjU2NTBkODNjXkEyXkFqcGc@._V1_.jpg', 36, ARRAY['แฟนตาซี', 'ดราม่า'], 'must-see', 110000, 9.0, 2024, false),

('Love''s Ambition', 'Love''s Ambition', 'ความทะเยอทะยานในความรักและการงาน', 'https://m.media-amazon.com/images/M/MV5BNGMxMjVmM2UtM2I3Mi00OGM5LThkZTAtNGRmYjY2NWU5NGJkXkEyXkFqcGc@._V1_.jpg', 40, ARRAY['โรแมนติก', 'ดราม่า'], 'must-see', 105000, 8.9, 2024, false),

('งามบุปผาสกุณา', 'Beautiful Flower Bird', 'ตำนานรักของดอกไม้และนกสวรรค์', 'https://m.media-amazon.com/images/M/MV5BMTMxNjM1MzE1OV5BMl5BanBnXkFtZTcwMjI3NzY4NQ@@._V1_.jpg', 40, ARRAY['ย้อนยุค', 'โรแมนติก'], 'must-see', 98000, 8.8, 2023, false),

('ยามดอกท้อผลิบาน', 'When Peach Blossoms Bloom', 'ความรักที่เบ่งบานยามดอกท้อผลิบาน', 'https://m.media-amazon.com/images/M/MV5BZjNkZjQ1ZjItMDdmMy00NjdhLThhYzItYTlhMDI0MGNhMjc2XkEyXkFqcGc@._V1_.jpg', 36, ARRAY['ย้อนยุค', 'โรแมนติก'], 'must-see', 92000, 8.7, 2023, false),

('อาจารย์มารหวนภพ', 'The Devil Teacher Returns', 'การกลับมาของอาจารย์มารในโลกยุคใหม่', 'https://m.media-amazon.com/images/M/MV5BY2ZhZDVhNGUtMjJhZi00ZTQ5LTg1ZjYtMDI3NzRhMDkzZTY2XkEyXkFqcGc@._V1_.jpg', 40, ARRAY['แฟนตาซี', 'แอคชั่น'], 'must-see', 88000, 8.6, 2024, false),

('ตำนานรักสวรรค์จันทรา', 'Moon Goddess Legend', 'ตำนานรักของเทพธิดาแห่งดวงจันทร์', 'https://m.media-amazon.com/images/M/MV5BOTY2MWVjNjAtMDEyOC00ZWZjLThiYjctNjBmY2M1N2E4NGEzXkEyXkFqcGc@._V1_.jpg', 40, ARRAY['แฟนตาซี', 'ย้อนยุค'], 'must-see', 85000, 8.5, 2023, false),

-- Hidden Gems
('ล้างบ่วงบาป', 'Cleansing Sins', 'การไถ่บาปและการให้อภัย', 'https://m.media-amazon.com/images/M/MV5BMTkzMmM4ZWUtY2M0Yi00M2M0LTlmNDMtM2VhNWZlMTg0ZWEzXkEyXkFqcGc@._V1_.jpg', 36, ARRAY['ดราม่า', 'แอคชั่น'], 'hidden-gems', 65000, 8.4, 2024, false),

('สตรีเช่นข้าหาได้ยากยิ่ง', 'A Rare Woman Like Me', 'เรื่องราวของสตรีผู้เข้มแข็งในยุคโบราณ', 'https://m.media-amazon.com/images/M/MV5BNjY4ZDc1NjctNmZmNy00ODA3LWI2YzEtN2EzNTFkZTFlYTgyXkEyXkFqcGc@._V1_.jpg', 40, ARRAY['ย้อนยุค', 'ดราม่า'], 'hidden-gems', 58000, 8.3, 2024, false),

('ทะยานสกีสู่รัก', 'Skiing Into Love', 'ความรักที่เกิดขึ้นบนลานสกี', 'https://m.media-amazon.com/images/M/MV5BMzYyNDY4ZjAtMDU1Yi00ZDg3LWExNTktYWMwMDBjMGRhZmU0XkEyXkFqcGc@._V1_.jpg', 30, ARRAY['โรแมนติก', 'ดราม่า'], 'hidden-gems', 52000, 8.2, 2024, false),

('บทเรียนรักฉบับนายเพลย์บอย', 'Playboy''s Love Lesson', 'เมื่อนายเพลย์บอยต้องเรียนรู้เรื่องรักแท้', 'https://m.media-amazon.com/images/M/MV5BNDM4ZjE1YTgtYzc3YS00ZTRjLTg1OTQtY2Q2MmZhYmQxNzYzXkEyXkFqcGc@._V1_.jpg', 24, ARRAY['โรแมนติก'], 'hidden-gems', 48000, 8.1, 2024, false),

('A Romance of the Little Forest', 'A Romance of the Little Forest', 'ความรักที่เบ่งบานในป่าเล็กๆ', 'https://m.media-amazon.com/images/M/MV5BYjNjMGE4OWItZDIwOC00NjlkLThiYjktYTc1ZmQxZGFkMzhjXkEyXkFqcGc@._V1_.jpg', 35, ARRAY['โรแมนติก', 'ดราม่า'], 'hidden-gems', 45000, 8.0, 2022, false),

('ทาสปีศาจ', 'Demon Slave', 'การผจญภัยของทาสที่มีพลังปีศาจ', 'https://m.media-amazon.com/images/M/MV5BMjIzNDY0NjU4MV5BMl5BanBnXkFtZTgwNjgzMjE3NjM@._V1_.jpg', 40, ARRAY['แฟนตาซี', 'แอคชั่น'], 'hidden-gems', 42000, 7.9, 2023, false),

-- General Dramas
('เทียบท้าปฐพี', 'Challenge Heaven and Earth', 'การต่อสู้เพื่อพิชิตฟ้าและดิน', 'https://m.media-amazon.com/images/M/MV5BMTg2NTEzNTk0M15BMl5BanBnXkFtZTgwNjgzMjE3NjM@._V1_.jpg', 40, ARRAY['แฟนตาซี', 'แอคชั่น'], 'general', 38000, 7.8, 2023, false),

('Frozen Surface', 'Frozen Surface', 'ความลับที่ซ่อนอยู่ใต้พื้นผิวน้ำแข็ง', 'https://m.media-amazon.com/images/M/MV5BZjIyNTUyNTAtZjJmNy00ZDRkLTkzMzMtMjQ4NWI3ZjZhM2IzXkEyXkFqcGc@._V1_.jpg', 30, ARRAY['ดราม่า'], 'general', 35000, 7.7, 2024, false),

('กับดักรักบอสตัวร้าย', 'Love Trap of the Evil Boss', 'เมื่อเลขาสาวติดกับดักรักของบอสตัวร้าย', 'https://m.media-amazon.com/images/M/MV5BZTRjNzQ0MjUtM2I5ZS00NjU2LWE1MWUtNGYwYTQ3NGIyMTRjXkEyXkFqcGc@._V1_.jpg', 30, ARRAY['โรแมนติก'], 'general', 32000, 7.6, 2024, false),

('วุ่นรักนักแปล', 'Translator''s Love Story', 'ความวุ่นวายของนักแปลสาวกับหนุ่มหล่อ', 'https://m.media-amazon.com/images/M/MV5BOGVjZmI4MTEtNDc4Ny00MTk0LTg4MTctZjRjOTMyMjM5YjE3XkEyXkFqcGc@._V1_.jpg', 30, ARRAY['โรแมนติก'], 'general', 25000, 7.4, 2024, false),

('จันทราอัสดง', 'Moon Sets', 'เมื่อพระจันทร์ลับขอบฟ้า ความรักก็เริ่มต้น', 'https://m.media-amazon.com/images/M/MV5BN2FjN2UxYjQtNDM5NS00YzYxLTg3NjAtNmQwNzQ4MDk0OTE1XkEyXkFqcGc@._V1_.jpg', 32, ARRAY['ย้อนยุค', 'โรแมนติก'], 'general', 22000, 7.3, 2024, false),

('Men in Love', 'Men in Love', 'เรื่องราวของชายหนุ่มที่ตกหลุมรัก', 'https://m.media-amazon.com/images/M/MV5BZmMxMzA0OTctNmU0OC00YjQ4LWI5MjYtZGNhMjUyN2FmNzMxXkEyXkFqcGc@._V1_.jpg', 30, ARRAY['โรแมนติก', 'ดราม่า'], 'general', 18000, 7.1, 2024, false),

('รักแรกของสาวใหญ่', 'First Love of the Older Woman', 'รักแรกที่มาช้าแต่หวานชื่น', 'https://m.media-amazon.com/images/M/MV5BZTMxYzM1ZjktZjE2Ni00MTBkLTg5ZjItYjYyZDE2YzQxMmMzXkEyXkFqcGc@._V1_.jpg', 24, ARRAY['โรแมนติก'], 'general', 16000, 7.0, 2024, false),

('ชิวเยียน ยอดหญิงพลิกชะตา', 'Qiu Yan: Destiny Changer', 'เรื่องราวของหญิงสาวที่พลิกชะตาชีวิต', 'https://m.media-amazon.com/images/M/MV5BNTg2MDg2OTAtMmM4YS00NTJmLTljMmUtODM0OTgxN2FlZjVhXkEyXkFqcGc@._V1_.jpg', 40, ARRAY['ย้อนยุค', 'ดราม่า'], 'general', 14000, 6.9, 2024, false),

('พิชิตรักนักแม่นปืน', 'Sharpshooter''s Love', 'ความรักของนักแม่นปืนสาว', 'https://m.media-amazon.com/images/M/MV5BYjY5NzM1MzEtZjBmYy00ZGFmLWJmNDAtNWY0NmY3MTJkMGEzXkEyXkFqcGc@._V1_.jpg', 24, ARRAY['โรแมนติก', 'แอคชั่น'], 'general', 12000, 6.8, 2024, false),

('ขอโทษที ฉันไม่ใช่เลขาคุณแล้ว', 'Sorry, I''m Not Your Secretary Anymore', 'เมื่อเลขาลาออกแล้วกลับมาพบกันใหม่', 'https://m.media-amazon.com/images/M/MV5BYjQ1NjEwZDctNDllMS00NjQwLWI4ZjEtMTA1NTFmMzE1OGU5XkEyXkFqcGc@._V1_.jpg', 28, ARRAY['โรแมนติก'], 'general', 10000, 6.7, 2024, false),

('บล็อกเกอร์สาวทะลุมิติ', 'Blogger Travels Through Dimensions', 'การผจญภัยของบล็อกเกอร์สาวที่ทะลุมิติ', 'https://m.media-amazon.com/images/M/MV5BMDk0MjQ3NzMtM2E4ZS00NmQ4LTg4YjMtNmViMzJkMGU5YjMxXkEyXkFqcGc@._V1_.jpg', 32, ARRAY['แฟนตาซี', 'โรแมนติก'], 'general', 8000, 6.6, 2024, false),

('เปลวไฟสีน้ำเงิน', 'Blue Flame', 'ความรักที่ร้อนแรงดั่งเปลวไฟสีน้ำเงิน', 'https://m.media-amazon.com/images/M/MV5BZTk0YTk3YzItNmEwNC00NjM3LWFlNWMtMDkxMzhhMTNmMGJiXkEyXkFqcGc@._V1_.jpg', 36, ARRAY['โรแมนติก', 'ดราม่า'], 'general', 6000, 6.5, 2024, false),

('ล่าหัวใจมังกร', 'Hunting the Dragon''s Heart', 'การล่าหัวใจของมังกรผู้ลึกลับ', 'https://m.media-amazon.com/images/M/MV5BYjMwMDI2YTItMjlhNi00MGE3LTg3MTgtOTM2NjYxYTNhYzliXkEyXkFqcGc@._V1_.jpg', 40, ARRAY['แฟนตาซี', 'โรแมนติก'], 'general', 5000, 6.4, 2024, false),

('สายลมแห่งหลงซี', 'Wind of Long Xi', 'สายลมที่พัดพาความรักมายังหลงซี', 'https://m.media-amazon.com/images/M/MV5BMmE4OWMzZjUtYTI3Ny00NTUwLWI0YTQtYmQ0MDAxMWY5MDFjXkEyXkFqcGc@._V1_.jpg', 40, ARRAY['ย้อนยุค', 'ดราม่า'], 'general', 4500, 6.3, 2023, false),

('หัตถานางใน', 'Palace Lady''s Hands', 'เรื่องราวของนางในผู้ลึกลับในวังหลวง', 'https://m.media-amazon.com/images/M/MV5BNmQzYzU3ZjMtOTIxMC00ZjEzLTg3ZGUtMTNhZTk0YzFmNGI1XkEyXkFqcGc@._V1_.jpg', 40, ARRAY['ย้อนยุค', 'ดราม่า'], 'general', 4000, 6.2, 2023, false),

('เวยเวย เธอยิ้มโลกละลาย', 'Love O2O', 'ความรักในโลกเกมออนไลน์', 'https://m.media-amazon.com/images/M/MV5BOTFkMTIzNDQtNDdiYi00ZTZjLWE0ZjctODRjN2QyYzliM2FkXkEyXkFqcGc@._V1_.jpg', 30, ARRAY['โรแมนติก'], 'general', 3500, 9.1, 2016, false),

('ปรมาจารย์ลัทธิมาร', 'The Untamed', 'ตำนานของปรมาจารย์ลัทธิมาร', 'https://m.media-amazon.com/images/M/MV5BZTEzZDkxMWMtM2I4YS00ZGU3LThkNzAtOTUwZDk4YjY3MWI0XkEyXkFqcGc@._V1_.jpg', 50, ARRAY['แฟนตาซี', 'แอคชั่น'], 'general', 3000, 9.5, 2019, false),

('ดาบมังกรหยก 2019', 'The Heaven Sword and Dragon Saber 2019', 'ตำนานดาบมังกรหยกฉบับใหม่', 'https://m.media-amazon.com/images/M/MV5BZGM0OGEwMDEtZTEzMy00NTBkLTg5ZjMtYzBmMzU4ZDQ1ZjM2XkEyXkFqcGc@._V1_.jpg', 50, ARRAY['แอคชั่น', 'ย้อนยุค'], 'general', 2500, 8.0, 2019, false),

('วีรสตรี นักสู้กู้แผ่นดิน', 'Princess Agents', 'เรื่องราวของวีรสตรีผู้กล้าหาญ', 'https://m.media-amazon.com/images/M/MV5BMTk0NzA5NjM0NV5BMl5BanBnXkFtZTgwNTEzMzkyMDI@._V1_.jpg', 54, ARRAY['แอคชั่น', 'ย้อนยุค'], 'general', 2000, 8.3, 2017, false),

('ฉู่เฉียว จอมใจจารชน', 'Princess Wei Young', 'ตำนานของเจ้าหญิงผู้เข้มแข็ง', 'https://m.media-amazon.com/images/M/MV5BNGQxNTI4ZDQtYmFjMC00MTMwLWI4MjYtNGJlNWQ1OGI4MmY0XkEyXkFqcGc@._V1_.jpg', 58, ARRAY['ย้อนยุค', 'ดราม่า'], 'general', 1500, 8.4, 2016, false),

('ตำนานรักเหนือภพ', 'The Journey of Flower', 'ความรักที่ข้ามภพข้ามชาติ', 'https://m.media-amazon.com/images/M/MV5BMTg5NzU0NjM2MV5BMl5BanBnXkFtZTgwNjQxNjY5NjE@._V1_.jpg', 58, ARRAY['แฟนตาซี', 'โรแมนติก'], 'general', 1000, 8.6, 2015, false),

('เจาะมิติพิชิตบัลลังก์', 'Scarlet Heart', 'การเจาะมิติสู่ราชวงศ์ชิง', 'https://m.media-amazon.com/images/M/MV5BMjIzNDUyNjc0N15BMl5BanBnXkFtZTgwMjUyMjE0MjE@._V1_.jpg', 35, ARRAY['ย้อนยุค', 'โรแมนติก'], 'general', 500, 9.0, 2011, false),

-- Drama สงคราม
('แรงพิษรัก', 'Lethal Devotion', 'เรื่องราวของ "ซ่งหร่าน" นักข่าวหญิงที่เดินทางไปทำข่าวในประเทศตงกั๋วซึ่งกำลังเผชิญกับความไม่สงบ', 'https://m.media-amazon.com/images/M/MV5BOTVmYTQ0YzEtMzNiNy00OTE4LThkNWUtMzI1YzAzOTk5ODI5XkEyXkFqcGc@._V1_.jpg', 40, ARRAY['โรแมนติก', 'ดราม่า', 'สงคราม', 'ชีวิต'], 'general', 1500000, 9.0, 2024, false);

-- =====================================================
-- PART 4: Seed Data - Episodes (Sample)
-- =====================================================

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

-- =====================================================
-- PART 5: Update Trigger Function
-- =====================================================

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SET search_path = public;

-- Create triggers
CREATE TRIGGER update_dramas_updated_at
    BEFORE UPDATE ON public.dramas
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_episodes_updated_at
    BEFORE UPDATE ON public.episodes
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

-- =====================================================
-- END OF BACKUP
-- =====================================================
