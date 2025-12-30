# DramaBox Database

## ไฟล์ในโฟลเดอร์นี้

| ไฟล์ | คำอธิบาย |
|------|----------|
| `schema.sql` | โครงสร้างฐานข้อมูลทั้งหมด (tables, functions, triggers, RLS policies, indexes) |
| `seed_dramas.sql` | ข้อมูลตัวอย่างสำหรับตาราง dramas |
| `seed_episodes.sql` | ข้อมูลตัวอย่างสำหรับตาราง episodes |

## วิธีใช้งาน

### สำหรับ Supabase

1. **สร้าง Supabase Project ใหม่**
   - ไปที่ [supabase.com](https://supabase.com)
   - สร้าง project ใหม่

2. **รัน Schema**
   ```bash
   # ไปที่ SQL Editor ใน Supabase Dashboard
   # คัดลอกเนื้อหาจาก schema.sql และรัน
   ```

3. **เพิ่มข้อมูลตัวอย่าง**
   ```bash
   # รัน seed_dramas.sql ก่อน
   # จากนั้นรัน seed_episodes.sql
   ```

### สำหรับ PostgreSQL ทั่วไป

```bash
# สร้าง database
createdb dramabox

# รัน schema
psql -d dramabox -f schema.sql

# เพิ่มข้อมูลตัวอย่าง
psql -d dramabox -f seed_dramas.sql
psql -d dramabox -f seed_episodes.sql
```

## โครงสร้างตาราง

### dramas
| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary Key |
| title | TEXT | ชื่อซีรีส์ (ไทย) |
| title_en | TEXT | ชื่อซีรีส์ (อังกฤษ) |
| description | TEXT | คำอธิบาย |
| poster_url | TEXT | URL รูปโปสเตอร์ |
| episodes | INTEGER | จำนวนตอน |
| category | TEXT[] | หมวดหมู่ |
| section | TEXT | ส่วนที่แสดง (trending, must-see, hidden-gems, general) |
| view_count | INTEGER | จำนวนการดู |
| rating | NUMERIC | คะแนน |
| year | INTEGER | ปีที่ออกอากาศ |
| is_featured | BOOLEAN | แนะนำหรือไม่ |

### episodes
| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary Key |
| drama_id | UUID | FK ไปยัง dramas |
| episode_number | INTEGER | ลำดับตอน |
| title | TEXT | ชื่อตอน |
| description | TEXT | คำอธิบาย |
| video_url | TEXT | URL วิดีโอ |
| thumbnail_url | TEXT | URL รูป thumbnail |
| duration | INTEGER | ความยาว (นาที) |
| is_free | BOOLEAN | ฟรีหรือไม่ |

### favorites
| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary Key |
| user_id | UUID | FK ไปยัง auth.users |
| drama_id | UUID | FK ไปยัง dramas |

## Environment Variables

```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=your-anon-key
```

## หมายเหตุ

- RLS Policies ถูกตั้งค่าให้:
  - ทุกคนสามารถดูข้อมูล dramas และ episodes ได้
  - ผู้ใช้ที่ login แล้วสามารถเพิ่ม/แก้ไข/ลบ dramas และ episodes ได้
  - ผู้ใช้สามารถจัดการ favorites ของตัวเองเท่านั้น
