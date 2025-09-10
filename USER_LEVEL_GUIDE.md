# 🚀 Cache Manager Lite - User Level & Custom Configuration Guide

## 🎯 ระดับผู้ใช้งาน (User Levels)

Cache Manager Lite รองรับผู้ใช้งาน 4 ระดับ ตั้งแต่ผู้เริ่มต้นจนถึงผู้เชี่ยวชาญ:

### 1. 🌱 ระดับเริ่มต้น (Beginner)

**สำหรับ:** ผู้เพิ่งเริ่มเรียนรู้ ต้องการความง่าย

```dart
final cacheManager = CacheManagerLite.forBeginner(
  appType: AppType.utility,
  cacheSize: CacheSize.small,
);
```

**คุณสมบัติ:**

- ✅ ค่าเริ่มต้นอัตโนมัติ
- ✅ การตั้งค่าน้อยที่สุด
- ✅ การทำงานง่าย
- ✅ เหมาะสำหรับผู้เริ่มต้น

### 2. ⚖️ ระดับกลาง (Intermediate)

**สำหรับ:** ผู้มีพื้นฐาน สามารถปรับแต่งได้บ้าง

```dart
final cacheManager = CacheManagerLite.forIntermediate(
  appType: AppType.social,
  cacheSize: CacheSize.medium,
  performanceLevel: PerformanceLevel.balanced,
  enableEncryption: false,
);
```

**คุณสมบัติ:**

- ✅ ตัวเลือกการปรับแต่งบางส่วน
- ✅ ประสิทธิภาพสมดุล
- ✅ ค่าเริ่มต้นที่ดี
- ✅ เหมาะสำหรับผู้ใช้ทั่วไป

### 3. 🔧 ระดับสูง (Advanced)

**สำหรับ:** ผู้มีความชำนาญ ต้องการการควบคุมมากขึ้น

```dart
final cacheManager = CacheManagerLite.forAdvanced(
  appType: AppType.ecommerce,
  cacheSize: CacheSize.large,
  performanceLevel: PerformanceLevel.high,
  enableEncryption: true,
  encryptionKey: 'my_secure_key',
  memoryCacheRatio: 0.15,
  customPolicy: customCachePolicy,
);
```

**คุณสมบัติ:**

- ✅ การควบคุมเต็มรูปแบบ
- ✅ ตัวเลือกขั้นสูง
- ✅ รองรับนโยบายกำหนดเอง
- ✅ เหมาะสำหรับนักพัฒนาที่มีประสบการณ์

### 4. 🎓 ระดับผู้เชี่ยวชาญ (Expert)

**สำหรับ:** ผู้เชี่ยวชาญ ต้องการการปรับแต่งสมบูรณ์

```dart
final cacheManager = CacheManagerLite.forExpert(
  cacheSize: CacheSize.enterprise,
  performanceLevel: PerformanceLevel.realtime,
  appType: AppType.gaming,
  customSizeBytes: 1024 * 1024 * 1024, // 1GB
  enableEncryption: true,
  encryptionKey: 'expert_encryption_key',
  enableBackgroundCleanup: true,
  memoryCacheRatio: 0.1,
  customPolicy: expertCachePolicy,
);
```

**คุณสมบัติ:**

- ✅ การปรับแต่งสมบูรณ์
- ✅ ฟีเจอร์ขั้นสูงทั้งหมด
- ✅ การปรับจูนละเอียด
- ✅ เหมาะสำหรับผู้เชี่ยวชาญ

## 🛠️ การกำหนดค่าแบบกำหนดเอง (Custom Configuration)

สำหรับผู้ที่ต้องการการควบคุมที่สมบูรณ์ที่สุด:

```dart
// สร้าง Custom Cache Policy
final customPolicy = CachePolicy(
  maxAge: Duration(hours: 12),
  encryptionKey: 'my_custom_encryption_key',
);

// สร้าง Custom Cache Manager
final customCacheManager = CacheManagerLite.custom(
  customSizeBytes: 50 * 1024 * 1024, // 50MB
  customPolicy: customPolicy,
  appType: AppType.social,
  enableEncryption: true,
  encryptionKey: 'my_custom_encryption_key',
  enableBackgroundCleanup: true,
  memoryCacheRatio: 0.25,
);
```

**พารามิเตอร์ที่ปรับแต่งได้:**

- `customSizeBytes`: ขนาดแคชในไบต์
- `customPolicy`: นโยบายแคชกำหนดเอง
- `appType`: ประเภทแอปพลิเคชัน
- `enableEncryption`: เปิด/ปิดการเข้ารหัส
- `encryptionKey`: คีย์การเข้ารหัส
- `enableBackgroundCleanup`: การล้างข้อมูลพื้นหลัง
- `memoryCacheRatio`: อัตราส่วนแคชในหน่วยความจำ

## 📊 ตัวอย่างการใช้งานจริง

### สำหรับแอป Social Media

```dart
final socialCache = CacheManagerLite.forIntermediate(
  appType: AppType.social,
  cacheSize: CacheSize.medium,
  performanceLevel: PerformanceLevel.balanced,
);

// Cache โพสต์
await socialCache.put(
  key: 'post_123',
  value: {
    'content': 'Hello World!',
    'author': 'user123',
    'timestamp': DateTime.now().toIso8601String(),
  },
);

// ดึงโพสต์
final post = await socialCache.get('post_123');
```

### สำหรับแอป E-commerce

```dart
final ecommerceCache = CacheManagerLite.forAdvanced(
  appType: AppType.ecommerce,
  cacheSize: CacheSize.large,
  performanceLevel: PerformanceLevel.high,
  enableEncryption: true,
);

// Cache สินค้า
await ecommerceCache.put(
  key: 'product_456',
  value: {
    'name': 'Smartphone XYZ',
    'price': 15999.00,
    'stock': 50,
  },
  policy: CachePolicy(maxAge: Duration(hours: 2)),
);
```

### สำหรับแอป Gaming

```dart
final gamingCache = CacheManagerLite.forExpert(
  cacheSize: CacheSize.enterprise,
  performanceLevel: PerformanceLevel.realtime,
  appType: AppType.gaming,
  memoryCacheRatio: 0.05, // เพิ่มประสิทธิภาพ
);

// Cache game assets
await gamingCache.put(
  key: 'level_1_assets',
  value: {
    'textures': [...],
    'sounds': [...],
    'models': [...],
  },
);
```

## 🎮 ตัวอย่างแอปพลิเคชัน

ในโฟลเดอร์ `example/` มีตัวอย่างที่สามารถทดลองได้:

1. **`user_level_example.dart`** - ทดสอบระดับผู้ใช้งานต่างๆ
2. **`custom_config_example.dart`** - สร้างการกำหนดค่าแบบกำหนดเอง
3. **`performance_level_example.dart`** - ทดสอบระดับประสิทธิภาพ

## 🚀 เริ่มต้นใช้งาน

1. **เลือกระดับที่เหมาะกับคุณ:**

   - 🌱 เริ่มต้น → `.forBeginner()`
   - ⚖️ กลาง → `.forIntermediate()`
   - 🔧 สูง → `.forAdvanced()`
   - 🎓 ผู้เชี่ยวชาญ → `.forExpert()`

2. **ปรับแต่งตามความต้องการ:**

   - เลือก `AppType` ที่เหมาะสม
   - กำหนด `CacheSize` และ `PerformanceLevel`
   - เปิด/ปิดฟีเจอร์ต่างๆ

3. **ใช้งาน:**
   ```dart
   await cacheManager.put(key: 'data', value: myData);
   final result = await cacheManager.get('data');
   ```

## 💡 เคล็ดลับการใช้งาน

- **เริ่มต้น:** ใช้ `.forBeginner()` ก่อน จากนั้นค่อยเพิ่มความซับซ้อน
- **ประสิทธิภาพ:** ปรับ `memoryCacheRatio` สำหรับข้อมูลที่เข้าถึงบ่อย
- **ความปลอดภัย:** เปิด `enableEncryption` สำหรับข้อมูลสำคัญ
- **การจัดการ:** ใช้ `enableBackgroundCleanup` เพื่อจัดการหน่วยความจำอัตโนมัติ

---

🎉 **ขอแสดงความยินดี!** คุณพร้อมใช้งาน Cache Manager Lite ในระดับที่เหมาะกับคุณแล้ว!
