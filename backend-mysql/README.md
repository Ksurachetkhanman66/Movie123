# Drama Streaming API (MySQL + Express)

Backend API สำหรับเว็บไซต์สตรีมมิ่งละครจีน

## Tech Stack

- **Runtime:** Node.js
- **Framework:** Express.js
- **Database:** MySQL 8.0+ / MariaDB 10.5+
- **Authentication:** Session-based with bcrypt

## โครงสร้างโปรเจกต์

```
backend-mysql/
├── database/
│   ├── schema.sql          # โครงสร้างตาราง
│   ├── seed_dramas.sql     # ข้อมูลละคร
│   └── seed_episodes.sql   # ข้อมูลตอน
├── src/
│   ├── config/
│   │   └── database.js     # การเชื่อมต่อ MySQL
│   ├── middleware/
│   │   └── auth.js         # Middleware ตรวจสอบ login
│   ├── routes/
│   │   ├── auth.js         # API สมัคร/เข้าสู่ระบบ
│   │   ├── dramas.js       # API ข้อมูลละคร
│   │   ├── episodes.js     # API ข้อมูลตอน
│   │   └── favorites.js    # API รายการโปรด
│   └── index.js            # Entry point
├── .env.example            # ตัวอย่างไฟล์ config
├── package.json
└── README.md
```

## การติดตั้ง

### 1. ติดตั้ง Dependencies

```bash
cd backend-mysql
npm install
```

### 2. ตั้งค่า Environment

```bash
cp .env.example .env
# แก้ไขค่าใน .env ให้ตรงกับระบบของคุณ
```

### 3. สร้างฐานข้อมูล

เข้า MySQL แล้วรันไฟล์ SQL:

```bash
mysql -u root -p < database/schema.sql
mysql -u root -p < database/seed_dramas.sql
mysql -u root -p < database/seed_episodes.sql
```

หรือใช้ phpMyAdmin:
1. Import `database/schema.sql`
2. Import `database/seed_dramas.sql`
3. Import `database/seed_episodes.sql`

### 4. รัน Server

```bash
# Development mode
npm run dev

# Production mode
npm start
```

Server จะรันที่ `http://localhost:3001`

## API Endpoints

### Authentication

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/signup` | สมัครสมาชิก |
| POST | `/api/auth/login` | เข้าสู่ระบบ |
| POST | `/api/auth/logout` | ออกจากระบบ |
| GET | `/api/auth/me` | ดูข้อมูลผู้ใช้ปัจจุบัน |

### Dramas

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/dramas` | ดึงรายการละครทั้งหมด |
| GET | `/api/dramas/:id` | ดึงข้อมูลละครเรื่องเดียว |
| GET | `/api/dramas/:id/episodes` | ดึงรายการตอนของละคร |

Query Parameters สำหรับ `/api/dramas`:
- `section` - กรองตาม section (recommended, popular, etc.)
- `featured` - กรองเฉพาะแนะนำ (true/false)
- `category` - กรองตามหมวดหมู่
- `search` - ค้นหาตามชื่อ
- `limit` - จำกัดจำนวนผลลัพธ์

### Episodes

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/episodes/:id` | ดึงข้อมูลตอนเดียว |
| POST | `/api/episodes/:id/view` | เพิ่มยอดวิว |

### Favorites (ต้อง Login)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/favorites` | ดึงรายการโปรดของผู้ใช้ |
| GET | `/api/favorites/check/:dramaId` | เช็คว่าละครอยู่ในโปรดหรือไม่ |
| POST | `/api/favorites` | เพิ่มเข้ารายการโปรด |
| DELETE | `/api/favorites/:dramaId` | ลบออกจากรายการโปรด |

## ตัวอย่าง Request

### สมัครสมาชิก
```bash
curl -X POST http://localhost:3001/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "123456"}'
```

### เข้าสู่ระบบ
```bash
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -c cookies.txt \
  -d '{"email": "test@example.com", "password": "123456"}'
```

### ดึงรายการละคร
```bash
curl http://localhost:3001/api/dramas?section=recommended&limit=10
```

### เพิ่มรายการโปรด (ต้อง login)
```bash
curl -X POST http://localhost:3001/api/favorites \
  -H "Content-Type: application/json" \
  -b cookies.txt \
  -d '{"drama_id": "d1000001-0000-0000-0000-000000000001"}'
```

## Response Format

ทุก response จะมีรูปแบบ:

```json
{
  "success": true,
  "data": { ... },
  "total": 10
}
```

หรือกรณี error:

```json
{
  "success": false,
  "error": "Error message"
}
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| DB_HOST | MySQL host | localhost |
| DB_PORT | MySQL port | 3306 |
| DB_USER | MySQL username | root |
| DB_PASSWORD | MySQL password | - |
| DB_NAME | Database name | drama_streaming |
| SESSION_SECRET | Session secret key | - |
| PORT | Server port | 3001 |
| CORS_ORIGIN | Allowed CORS origin | http://localhost:3000 |
