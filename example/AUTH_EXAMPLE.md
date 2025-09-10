# Authentication Example - ตัวอย่างระบบ Authentication

ตัวอย่างการสร้างระบบ Authentication เต็มรูปแบบด้วย Cache Manager Lite

## 🔐 ฟีเจอร์ที่มี

### การจัดการผู้ใช้

- **Login/Logout** - เข้าสู่ระบบและออกจากระบบ
- **Session Management** - จัดการ session อัตโนมัติ
- **Auto Restore** - กู้คืน session เมื่อเปิดแอปใหม่

### การจัดการ Token

- **Access Token** - Token สำหรับการเข้าถึง API (หมดอายุใน 1 ชั่วโมง)
- **Refresh Token** - Token สำหรับต่ออายุ (หมดอายุใน 7 วัน)
- **Auto Refresh** - ต่ออายุ token อัตโนมัติก่อนหมดอายุ
- **Token Status** - แสดงสถานะและเวลาคงเหลือ

### ความปลอดภัย

- **Encrypted Storage** - เข้ารหัสข้อมูล sensitive
- **Secure Cache** - ใช้ Cache Manager Lite เพื่อความปลอดภัย
- **Session Validation** - ตรวจสอบความถูกต้องของ session

## 🧪 บัญชีทดสอบ

| Username | Password | Role          |
| -------- | -------- | ------------- |
| admin    | password | Administrator |
| user     | 123456   | User          |
| demo     | demo     | Demo User     |

## 🚀 วิธีใช้งาน

### 1. เปิดแอป

แอปจะตรวจสอบ session ที่บันทึกไว้อัตโนมัติ

### 2. เข้าสู่ระบบ

- เลือกบัญชีทดสอบจากตารางด้านบน
- กรอก username และ password
- กดปุ่ม "เข้าสู่ระบบ"

### 3. ใช้งาน Dashboard

- ดูข้อมูลผู้ใช้และสถานะ token
- ตรวจสอบ cache status
- ต่ออายุ token หรือล้าง cache

### 4. ออกจากระบบ

กดปุ่ม logout เพื่อล้างข้อมูล authentication

## 💾 การจัดการ Cache

### ข้อมูลที่เก็บ

- `access_token` - Token การเข้าถึง (1 ชั่วโมง)
- `refresh_token` - Token ต่ออายุ (7 วัน)
- `user_profile` - ข้อมูลผู้ใช้ (24 ชั่วโมง)
- `token_expiry` - เวลาหมดอายุ token

### การเข้ารหัส

ข้อมูล authentication ทั้งหมดถูกเข้ารหัสด้วย AES encryption

## 🛠 Implementation Details

### Cache Manager Setup

```dart
cacheManager = CacheManagerLite.forBeginner(
  appType: AppType.ecommerce,
  cacheSize: CacheSize.medium,
);
```

### Token Storage

```dart
// บันทึก access token
await cacheManager.put(
  key: 'access_token',
  value: token,
  policy: CachePolicy(maxAge: Duration(hours: 1)),
);
```

### Session Validation

```dart
// ตรวจสอบ token หมดอายุ
if (_tokenExpiry != null && DateTime.now().isAfter(_tokenExpiry!)) {
  await _refreshAccessToken();
}
```

## 🎯 Use Cases

### 1. Mobile App Authentication

เหมาะสำหรับแอปมือถือที่ต้องการ:

- Login/Logout สะดวก
- Session persist ข้าม app restart
- Token management อัตโนมัติ

### 2. E-commerce App

สำหรับแอป e-commerce ที่ต้องการ:

- ความปลอดภัยสูง
- User experience ที่ดี
- การจัดการ session ที่เสถียร

### 3. Enterprise App

เหมาะสำหรับแอปองกรณ์ที่ต้องการ:

- Security compliance
- Audit trail
- Multi-level user access

## 📊 Features Showcase

- ✅ Complete authentication flow
- ✅ Encrypted token storage
- ✅ Auto session restore
- ✅ Token refresh mechanism
- ✅ Real-time status monitoring
- ✅ Cache management
- ✅ Error handling
- ✅ User-friendly UI

## 🔄 Flow Diagram

```
App Start → Check Session → Login/Dashboard
    ↓              ↓              ↓
Initialize    Has Valid      Show User Info
Cache        Token?         & Token Status
    ↓          ↓ ↓               ↓
    └──────→ No Yes         Logout/Refresh
             ↓   ↓               ↓
         Show Login Dashboard  Clear Cache
```

## 💡 Key Learning Points

1. **Secure Storage**: การเก็บข้อมูล sensitive อย่างปลอดภัย
2. **Token Management**: การจัดการ token lifecycle
3. **User Experience**: UX ที่ดีสำหรับ authentication
4. **Error Handling**: การจัดการข้อผิดพลาดต่างๆ
5. **State Management**: การจัดการ state ของ authentication
