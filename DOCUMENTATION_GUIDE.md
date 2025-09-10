# 📚 Cache Manager Lite - Complete Documentation Guide

## 🎯 ภาพรวมการใช้งาน

Cache Manager Lite เป็น Flutter package ที่ออกแบบมาเพื่อจัดการแคชแบบครบครันและยืดหยุ่น พร้อมด้วยระบบเอกสารที่ละเอียดครบถ้วนเพื่อให้ใกล้ชิดกับผู้ใช้ทุกระดับ

---

## 🏗️ โครงสร้างของ Classes หลัก

### 1. 🎯 **CacheManagerLite** - คลาสหลัก

**การใช้งาน:** เป็นคลาสหลักสำหรับการจัดการแคชทั้งหมด

**ตัวแปรหลักและการ Custom:**

#### 📋 **ตัวแปรที่สามารถ Custom ได้:**

- **`config`** (CacheConfig): การกำหนดค่าแบบมาตรฐาน
- **`scalableConfig`** (ScalableCacheConfig): การกำหนดค่าแบบขยายได้

#### 🔧 **ตัวแปรภายในที่ไม่สามารถ Custom ได้:**

- **`_hiveDataSource`**: ตัวจัดการฐานข้อมูล Hive
- **`_dioDataSource`**: ตัวจัดการ HTTP requests
- **`_repository`**: Repository สำหรับการจัดการข้อมูล
- **`_getCacheUseCase`**: Use case สำหรับการดึงข้อมูล
- **`_putCacheUseCase`**: Use case สำหรับการเก็บข้อมูล
- **`_clearCacheUseCase`**: Use case สำหรับการล้างข้อมูล

---

## 🏭 Factory Constructors และตัวอย่าง

### 🟢 **สำหรับผู้เริ่มต้น (Beginner)**

```dart
// ใช้งานง่าย ไม่ซับซ้อน
final cacheManager = CacheManagerLite.forBeginner();

// เก็บข้อมูลง่ายๆ
await cacheManager.putForHours(
  key: 'user_data',
  value: userData,
  hours: 24,
);

// ดึงข้อมูลกลับมา
final data = await cacheManager.get('user_data');
```

**ตัวแปรที่ custom ได้:**

- `appType`: ประเภทแอป (utility, social)
- `cacheSize`: ขนาดแคช (small, medium)

### 🔵 **สำหรับผู้ใช้ระดับกลาง (Intermediate)**

```dart
// มีฟีเจอร์เพิ่มเติม
final cacheManager = CacheManagerLite.forIntermediate(
  appType: AppType.social,
  cacheSize: CacheSize.medium,
  performanceLevel: PerformanceLevel.high,
  enableEncryption: true,
);

// เก็บข้อมูลพร้อมเข้ารหัส
await cacheManager.putForDays(
  key: 'profile_${userId}',
  value: profileData,
  days: 7,
  encryptionKey: 'profile-key-2024',
);

// ตรวจสอบสถานะ
final info = await cacheManager.getEntryInfo('profile_${userId}');
print('เหลือเวลา: ${info?.remainingTime}');
```

**ตัวแปรที่ custom ได้:**

- `appType`: ประเภทแอป
- `cacheSize`: ขนาดแคช
- `performanceLevel`: ระดับประสิทธิภาพ
- `enableEncryption`: เปิดใช้การเข้ารหัส

### 🟠 **สำหรับผู้ใช้ระดับสูง (Advanced)**

```dart
// ควบคุมได้ครบถ้วน
final customPolicy = CachePolicy.expiresAt(
  expirationTime: DateTime(2024, 12, 31, 23, 59, 59),
  encryptionKey: 'advanced-key-2024',
);

final cacheManager = CacheManagerLite.forAdvanced(
  appType: AppType.ecommerce,
  cacheSize: CacheSize.large,
  performanceLevel: PerformanceLevel.high,
  enableEncryption: true,
  encryptionKey: 'master-key-2024',
  memoryCacheRatio: 0.2, // ใช้ RAM 20%
  customPolicy: customPolicy,
);

// การใช้งานขั้นสูง
await cacheManager.put(
  key: 'product_${productId}',
  value: productData,
  policy: CachePolicy.endOfMonth(
    encryptionKey: 'product-specific-key',
  ),
);

// ขยายเวลาหมดอายุ
await cacheManager.extendExpiration(
  key: 'product_${productId}',
  additionalTime: Duration(days: 7),
);
```

**ตัวแปรที่ custom ได้:**

- `appType`: ประเภทแอป
- `cacheSize`: ขนาดแคช
- `performanceLevel`: ระดับประสิทธิภาพ
- `enableEncryption`: เปิดใช้การเข้ารหัส
- `encryptionKey`: คีย์เข้ารหัสแบบกำหนดเอง
- `memoryCacheRatio`: อัตราส่วน RAM
- `customPolicy`: นโยบายแคชแบบกำหนดเอง

### 🔴 **สำหรับผู้เชี่ยวชาญ (Expert)**

```dart
// ควบคุมทุกอย่างได้
final expertCache = CacheManagerLite.forExpert(
  cacheSize: CacheSize.enterprise,
  performanceLevel: PerformanceLevel.ultra,
  appType: AppType.ecommerce,
  customSizeBytes: 1024 * 1024 * 1024, // 1GB custom
  enableEncryption: true,
  encryptionKey: 'ultra-secure-key-2024',
  enableBackgroundCleanup: true,
  memoryCacheRatio: 0.05, // ใช้ RAM เพียง 5%
  customPolicy: CachePolicy.inMinutes(15),
);

// Real-time monitoring
Timer.periodic(Duration(seconds: 30), (timer) async {
  final stats = await expertCache.getCacheStats();
  print('Cache Usage: ${stats.usedPercentage}%');

  if (stats.usedPercentage > 90) {
    await expertCache.performMaintenance();
  }
});
```

**ตัวแปรที่ custom ได้ทั้งหมด:**

- `cacheSize`: ขนาดแคชตามมาตรฐาน (required)
- `performanceLevel`: ระดับประสิทธิภาพ (required)
- `appType`: ประเภทแอป (required)
- `customSizeBytes`: ขนาดแคชแบบกำหนดเอง
- `enableEncryption`: เปิดใช้การเข้ารหัส
- `encryptionKey`: คีย์เข้ารหัสแบบกำหนดเอง
- `enableBackgroundCleanup`: การทำความสะอาดอัตโนมัติ
- `memoryCacheRatio`: อัตราส่วน RAM
- `customPolicy`: นโยบายแคชแบบกำหนดเอง

### ⚙️ **สำหรับการ Custom ทั้งหมด**

```dart
// สำหรับ Research Application
final researchPolicy = CachePolicy.expiresAt(
  expirationTime: DateTime.now().add(Duration(days: 30)),
  encryptionKey: 'research-data-encryption-2024',
);

final researchCache = CacheManagerLite.custom(
  customSizeBytes: 5 * 1024 * 1024 * 1024, // 5GB
  customPolicy: researchPolicy,
  appType: AppType.utility,
  enableEncryption: true,
  encryptionKey: 'research-master-key',
  memoryCacheRatio: 0.4, // ใช้ RAM 40%
);

// สำหรับ IoT Application
final iotCache = CacheManagerLite.custom(
  customSizeBytes: 10 * 1024 * 1024, // 10MB เท่านั้น
  customPolicy: CachePolicy.inMinutes(5),
  memoryCacheRatio: 0.05, // ใช้ RAM เพียง 5%
  enableBackgroundCleanup: false,
);
```

**ตัวแปรที่ต้อง custom (required):**

- `customSizeBytes`: ขนาดแคชแบบไบต์
- `customPolicy`: นโยบายแคชแบบกำหนดเอง

**ตัวแปรเสริมที่ custom ได้:**

- `appType`: ประเภทแอป
- `enableEncryption`: เปิดใช้การเข้ารหัส
- `encryptionKey`: คีย์เข้ารหัสหลัก
- `enableBackgroundCleanup`: การทำความสะอาดอัตโนมัติ
- `memoryCacheRatio`: อัตราส่วน RAM

---

## 📋 **CachePolicy** - การจัดการนโยบายแคช

### **ตัวแปรที่สามารถ Custom ได้:**

#### 🕐 **maxAge** (Duration?)

```dart
maxAge: Duration(minutes: 15),     // 15 นาที
maxAge: Duration(hours: 2),        // 2 ชั่วโมง
maxAge: Duration(days: 30),        // 30 วัน
maxAge: Duration(seconds: 30),     // 30 วินาที
```

#### 📅 **expiresAt** (DateTime?)

```dart
// หมดอายุเมื่อสิ้นปี
expiresAt: DateTime(2024, 12, 31, 23, 59, 59),

// หมดอายุเวลา 18:00 วันนี้
expiresAt: DateTime.now().copyWith(hour: 18, minute: 0),

// หมดอายุใน 3 วันข้างหน้า
expiresAt: DateTime.now().add(Duration(days: 3)),
```

#### 🔐 **encryptionKey** (String?)

```dart
encryptionKey: 'my-secret-key-2024',
encryptionKey: 'user-${userId}-private-key',
encryptionKey: 'banking-grade-security-key-2024',
```

#### 📏 **maxSize** (int?)

```dart
maxSize: 1024,                    // 1KB
maxSize: 1024 * 1024,             // 1MB
maxSize: 10 * 1024 * 1024,        // 10MB
maxSize: null,                    // ไม่จำกัดขนาด
```

### **Factory Methods สำหรับความสะดวก:**

```dart
// ตามหน่วยเวลา
CachePolicy.inMinutes(30)
CachePolicy.inHours(6)
CachePolicy.inDays(7)

// ตามช่วงเวลาธรรมชาติ
CachePolicy.endOfDay()      // 23:59:59 วันนี้
CachePolicy.endOfWeek()     // วันอาทิตย์
CachePolicy.endOfMonth()    // วันสุดท้ายของเดือน
CachePolicy.never()         // ไม่หมดอายุ
```

---

## 📄 **CacheEntry** - รายการแคชหลัก

### **ตัวแปรที่ไม่สามารถ Custom หลังสร้าง:**

#### 🔑 **key** (String)

```dart
key: 'user_profile_${userId}',           // โปรไฟล์ผู้ใช้
key: 'product_${productId}',             // ข้อมูลสินค้า
key: 'api_response_${endpoint}_${hash}', // Response จาก API
```

#### 💾 **value** (dynamic)

```dart
value: 'Simple string data',                    // String
value: {'name': 'John', 'age': 30},            // Map
value: [1, 2, 3, 4, 5],                       // List
value: userObject,                             // Custom Object
```

#### 🕐 **createdAt** (DateTime)

```dart
createdAt: DateTime.now(),                     // เวลาปัจจุบัน
createdAt: DateTime.utc(2024, 6, 15, 10, 0),  // เวลา UTC เฉพาะ
```

#### 🔒 **isEncrypted** (bool)

```dart
isEncrypted: false,  // ข้อมูลไม่ได้เข้ารหัส
isEncrypted: true,   // ข้อมูลถูกเข้ารหัส
```

### **ตัวแปรที่สามารถ Custom ได้:**

#### ⏰ **expiresAt** (DateTime?)

```dart
expiresAt: null,                                    // ไม่หมดอายุ
expiresAt: DateTime.now().add(Duration(hours: 1)), // หมดอายุใน 1 ชั่วโมง
expiresAt: DateTime(2024, 12, 31, 23, 59, 59),    // หมดอายุเฉพาะวันที่
```

---

## 🎯 **Methods หลักและการ Custom**

### **การเก็บข้อมูล (Put Methods):**

#### 🔧 **put()** - พื้นฐาน (ปรับแต่งได้ทุกอย่าง)

```dart
await cacheManager.put(
  key: 'custom_data',
  value: myData,
  policy: customPolicy,        // customizable
  maxAge: Duration(hours: 2),  // customizable
  expiresAt: specificTime,     // customizable
  encryptionKey: 'custom-key', // customizable
);
```

#### ⏰ **Convenience Methods** (customizable เฉพาะ encryptionKey)

```dart
// ตามหน่วยเวลา
await cacheManager.putForMinutes(key: 'data', value: data, minutes: 30);
await cacheManager.putForHours(key: 'data', value: data, hours: 6);
await cacheManager.putForDays(key: 'data', value: data, days: 7);

// ตามช่วงเวลาธรรมชาติ
await cacheManager.putUntilEndOfDay(key: 'data', value: data);
await cacheManager.putUntilEndOfWeek(key: 'data', value: data);
await cacheManager.putUntilEndOfMonth(key: 'data', value: data);
await cacheManager.putPermanent(key: 'data', value: data);
```

### **การดึงข้อมูล (Get Methods):**

```dart
// ดึงข้อมูลพื้นฐาน
final data = await cacheManager.get('key');

// ดึงข้อมูลรายละเอียด
final info = await cacheManager.getEntryInfo('key');

// ดึงข้อมูลที่หมดอายุแล้ว
final expiredData = await cacheManager.getExpired('key');

// ตรวจสอบการมีอยู่
final exists = await cacheManager.exists('key');
final existsAny = await cacheManager.existsAny('key');
```

### **การจัดการเวลา (Time Management):**

```dart
// ดูเวลาที่เหลือ
final remaining = await cacheManager.getRemainingTime('key');

// ขยายเวลาหมดอายุ
await cacheManager.extendExpiration(
  key: 'key',
  additionalTime: Duration(hours: 2),     // customizable
  newExpirationTime: specificDateTime,   // customizable
);
```

---

## 📊 **ตัวอย่างการใช้งานตามสถานการณ์**

### 🎮 **Gaming Application**

```dart
final gameCache = CacheManagerLite.forExpert(
  cacheSize: CacheSize.large,
  performanceLevel: PerformanceLevel.ultra,
  appType: AppType.gaming,
  memoryCacheRatio: 0.25, // ใช้ RAM 25%
);

// ข้อมูลผู้เล่น
await gameCache.putForHours(
  key: 'player_${playerId}',
  value: playerStats,
  hours: 2,
);

// Leaderboard รายวัน
await gameCache.putUntilEndOfDay(
  key: 'daily_leaderboard',
  value: leaderboardData,
);
```

### 🛒 **E-commerce Application**

```dart
final ecommerceCache = CacheManagerLite.forAdvanced(
  appType: AppType.ecommerce,
  cacheSize: CacheSize.large,
  enableEncryption: true,
  encryptionKey: 'ecommerce-master-key-2024',
);

// ข้อมูลสินค้า
await ecommerceCache.putForHours(
  key: 'product_${productId}',
  value: productData,
  hours: 6,
);

// ตะกร้าสินค้า
await ecommerceCache.putForMinutes(
  key: 'cart_${userId}',
  value: cartData,
  minutes: 30,
  encryptionKey: 'cart-secure-key',
);
```

### 🏦 **Banking Application**

```dart
final bankingCache = CacheManagerLite.forExpert(
  cacheSize: CacheSize.enterprise,
  performanceLevel: PerformanceLevel.ultra,
  appType: AppType.ecommerce,
  enableEncryption: true,
  encryptionKey: 'ultra-secure-banking-key-2024',
  memoryCacheRatio: 0.05, // ใช้ RAM เพียง 5%
);

// ข้อมูลบัญชี
await bankingCache.putForMinutes(
  key: 'account_${accountId}',
  value: accountData,
  minutes: 15, // หมดอายุเร็วเพื่อความปลอดภัย
);
```

### 🔬 **Research Application**

```dart
final researchCache = CacheManagerLite.custom(
  customSizeBytes: 5 * 1024 * 1024 * 1024, // 5GB
  customPolicy: CachePolicy.never(), // ไม่หมดอายุ
  memoryCacheRatio: 0.4, // ใช้ RAM 40%
);

// Dataset ขนาดใหญ่
await researchCache.put(
  key: 'ml_dataset_v1',
  value: massiveDataset,
  policy: CachePolicy.never(),
);
```

---

## 🎯 **สรุปการ Customization**

### ✅ **สิ่งที่สามารถ Custom ได้:**

1. **ขนาดแคช:** ตั้งแต่ 10MB ถึง unlimited
2. **เวลาหมดอายุ:** Duration, DateTime, หรือไม่หมดอายุ
3. **การเข้ารหัส:** AES encryption ด้วยคีย์กำหนดเอง
4. **ประสิทธิภาพ:** 5 ระดับตั้งแต่ low ถึง ultra
5. **ประเภทแอป:** utility, social, ecommerce, gaming
6. **อัตราส่วน RAM:** 5% ถึง 40%
7. **นโยบายแคช:** Custom policies แบบเต็มรูปแบบ

### ❌ **สิ่งที่ไม่สามารถ Custom ได้:**

1. **Internal Architecture:** Repository pattern, Use cases
2. **Storage Backend:** Hive NoSQL (แต่ซ่อนความซับซ้อน)
3. **HTTP Client:** Dio (แต่มี interceptor แคชอัตโนมัติ)
4. **Encryption Algorithm:** AES (แต่คีย์กำหนดเองได้)

---

## 🔍 **การ Debug และ Monitoring**

```dart
// ตรวจสอบสถานะแคช
final info = await cacheManager.getEntryInfo('key');
print('สถานะ: ${info?.statusDescription}');
print('เหลือเวลา: ${info?.remainingTime}');
print('อายุแคช: ${info?.age}');

// Real-time monitoring
Timer.periodic(Duration(seconds: 10), (timer) async {
  final stats = await cacheManager.getCacheStats();
  print('Cache Usage: ${stats.usedPercentage}%');
  print('Total Entries: ${stats.entryCount}');
});
```

---

## 🚀 **Best Practices**

1. **เลือก Constructor ตามระดับความเชี่ยวชาญ**
2. **ใช้ Factory Methods สำหรับเวลาหมดอายุ**
3. **เข้ารหัสข้อมูลสำคัญเสมอ**
4. **ตั้งเวลาหมดอายุให้เหมาะสมกับการใช้งาน**
5. **ใช้ Real-time monitoring สำหรับแอปสำคัญ**
6. **ปรับ memoryCacheRatio ตามฮาร์ดแวร์เป้าหมาย**

---

🎊 **Cache Manager Lite พร้อมเอกสารครบครันสำหรับผู้ใช้ทุกระดับ!**
