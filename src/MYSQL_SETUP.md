# Frontend สำหรับ MySQL Backend

## วิธีใช้งาน

### 1. เปลี่ยน App.tsx
แทนที่ไฟล์ `src/main.tsx` ให้ import จาก `AppMySQL`:

```tsx
// src/main.tsx
import App from './AppMySQL.tsx'  // เปลี่ยนจาก './App.tsx'
```

### 2. ตั้งค่า Environment
สร้างไฟล์ `.env` ใน root ของ frontend:

```env
VITE_API_URL=http://localhost:3001
```

### 3. รัน Backend
```bash
cd backend-mysql
npm install
npm run dev
```

### 4. รัน Frontend
```bash
npm run dev
```

## ไฟล์ที่สร้างใหม่

| ไฟล์ | คำอธิบาย |
|------|----------|
| `src/services/api.ts` | API Client สำหรับเรียก REST API |
| `src/hooks/useAuthMySQL.tsx` | Auth hook สำหรับ session-based auth |
| `src/pages/HomeMySQL.tsx` | หน้าแรก |
| `src/pages/DramaDetailMySQL.tsx` | หน้ารายละเอียดละคร |
| `src/pages/FavoritesMySQL.tsx` | หน้ารายการโปรด |
| `src/pages/AuthMySQL.tsx` | หน้า Login/Signup |
| `src/AppMySQL.tsx` | App router สำหรับ MySQL |

## หมายเหตุ
- ไฟล์เดิมยังคงอยู่เพื่อใช้กับ Lovable Cloud
- ไฟล์ใหม่ลงท้ายด้วย `MySQL` สำหรับใช้กับ local MySQL backend
