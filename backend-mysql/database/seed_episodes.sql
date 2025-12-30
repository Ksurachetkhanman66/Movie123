-- =====================================================
-- Seed Data for Episodes
-- Generate 5 episodes per drama
-- =====================================================

USE drama_streaming;

-- Create stored procedure to generate episodes
DELIMITER //

CREATE PROCEDURE IF NOT EXISTS generate_episodes()
BEGIN
    DECLARE drama_cursor_id CHAR(36);
    DECLARE drama_title VARCHAR(255);
    DECLARE drama_poster TEXT;
    DECLARE drama_count INT;
    DECLARE episode_count INT;
    DECLARE i INT;
    DECLARE done INT DEFAULT FALSE;
    
    DECLARE drama_cursor CURSOR FOR 
        SELECT id, title, poster_url, episodes FROM dramas;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN drama_cursor;
    
    read_loop: LOOP
        FETCH drama_cursor INTO drama_cursor_id, drama_title, drama_poster, drama_count;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Generate 5 episodes or total episodes, whichever is smaller
        SET episode_count = LEAST(5, COALESCE(drama_count, 5));
        SET i = 1;
        
        WHILE i <= episode_count DO
            INSERT IGNORE INTO episodes (
                id,
                drama_id,
                episode_number,
                title,
                description,
                video_url,
                thumbnail_url,
                duration,
                is_free,
                view_count
            ) VALUES (
                UUID(),
                drama_cursor_id,
                i,
                CONCAT(drama_title, ' ตอนที่ ', i),
                CONCAT('เนื้อหาตอนที่ ', i, ' ของ ', drama_title),
                CONCAT('https://example.com/videos/', drama_cursor_id, '/episode-', i, '.mp4'),
                drama_poster,
                FLOOR(30 + (RAND() * 30)),
                IF(i = 1, 1, 0),
                FLOOR(RAND() * 10000)
            );
            SET i = i + 1;
        END WHILE;
    END LOOP;
    
    CLOSE drama_cursor;
END //

DELIMITER ;

-- Execute the procedure
CALL generate_episodes();

-- Drop the procedure after use
DROP PROCEDURE IF EXISTS generate_episodes;
