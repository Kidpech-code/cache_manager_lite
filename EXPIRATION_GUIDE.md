# 🕒 Cache Manager Lite - Advanced Expiration & Time Management

## 🎯 ระบบจัดการเวลาหมดอายุแบบครบครัน

Cache Manager Lite รองรับการจัดการเวลาหมดอายุแบบยืดหยุ่นและครอบคลุม สามารถกำหนดเวลาหมดอายุได้หลากหลายรูปแบบ:

### 📋 วิธีการกำหนดเวลาหมดอายุ

#### 1. 🕐 การใช้ Duration (ระยะเวลาจากเวลาปัจจุบัน)

```dart
// วิธีพื้นฐาน
await cacheManager.put(
  key: 'my_data',
  value: myData,
  maxAge: Duration(hours: 2),
);

// หรือใช้ method เฉพาะ
await cacheManager.putWithDuration(
  key: 'my_data',
  value: myData,
  duration: Duration(minutes: 30),
);
```

#### 2. 📅 การกำหนดเวลาเฉพาะ (Specific DateTime)

```dart
// กำหนดเวลาแน่นอน
final expireTime = DateTime(2024, 12, 31, 23, 59, 59);
await cacheManager.putWithExpirationTime(
  key: 'new_year_data',
  value: myData,
  expirationTime: expireTime,
);

// หรือใช้ expiresAt parameter
await cacheManager.put(
  key: 'my_data',
  value: myData,
  expiresAt: DateTime.now().add(Duration(days: 7)),
);
```

### 🚀 Convenience Methods (วิธีที่สะดวก)

#### ⏰ ตามหน่วยเวลา

```dart
// นาที
await cacheManager.putForMinutes(
  key: 'temp_data',
  value: myData,
  minutes: 15,
);

// ชั่วโมง
await cacheManager.putForHours(
  key: 'session_data',
  value: myData,
  hours: 24,
);

// วัน
await cacheManager.putForDays(
  key: 'weekly_data',
  value: myData,
  days: 7,
);
```

#### 📆 ตามช่วงเวลาธรรมชาติ

```dart
// สิ้นวัน (23:59:59)
await cacheManager.putUntilEndOfDay(
  key: 'daily_summary',
  value: todayData,
);

// สิ้นสุปดาห์ (วันอาทิตย์)
await cacheManager.putUntilEndOfWeek(
  key: 'weekly_report',
  value: weeklyData,
);

// สิ้นเดือน
await cacheManager.putUntilEndOfMonth(
  key: 'monthly_stats',
  value: monthlyData,
);

// ไม่หมดอายุ (จริงๆ แล้วคือ 100 ปี)
await cacheManager.putPermanent(
  key: 'app_config',
  value: configData,
);
```

### 🛠️ CachePolicy Factory Methods

#### 📝 การสร้าง CachePolicy แบบต่างๆ

```dart
// Duration-based
final policy1 = CachePolicy.duration(
  duration: Duration(hours: 6),
  encryptionKey: 'secure_key',
);

// Specific expiration time
final policy2 = CachePolicy.expiresAt(
  expirationTime: DateTime(2024, 6, 15, 12, 0, 0),
  encryptionKey: 'secure_key',
);

// Convenience methods
final policy3 = CachePolicy.inMinutes(30);
final policy4 = CachePolicy.inHours(12);
final policy5 = CachePolicy.inDays(3);
final policy6 = CachePolicy.endOfDay();
final policy7 = CachePolicy.endOfWeek();
final policy8 = CachePolicy.endOfMonth();
final policy9 = CachePolicy.never(); // ไม่หมดอายุ
```

### 📊 การตรวจสอบสถานะแคช

#### 🔍 ข้อมูลรายละเอียด

```dart
// ข้อมูลสถานะครบถ้วน
final info = await cacheManager.getEntryInfo('my_key');
if (info != null) {
  print('สถานะ: ${info.statusDescription}');
  print('หมดอายุ: ${info.expiresAt}');
  print('เวลาที่เหลือ: ${info.remainingTime}');
  print('อายุแคช: ${info.age}');
  print('เข้ารหัส: ${info.isEncrypted}');
}
```

#### ⏱️ เวลาที่เหลือ

```dart
// ตรวจสอบเวลาที่เหลือ
final remaining = await cacheManager.getRemainingTime('my_key');
if (remaining != null) {
  if (remaining.inHours > 0) {
    print('เหลือ ${remaining.inHours} ชั่วโมง');
  } else if (remaining.inMinutes > 0) {
    print('เหลือ ${remaining.inMinutes} นาที');
  } else {
    print('เหลือ ${remaining.inSeconds} วินาที');
  }
}
```

#### ✅ การตรวจสอบการมีอยู่

```dart
// ตรวจสอบว่ามีและยังไม่หมดอายุ
final exists = await cacheManager.exists('my_key');

// ตรวจสอบว่ามีอยู่ (ไม่สนใจการหมดอายุ)
final existsAny = await cacheManager.existsAny('my_key');

// ดึงข้อมูลแม้หมดอายุแล้ว (สำหรับ recovery)
final expiredData = await cacheManager.getExpired('my_key');
```

### 🔄 การจัดการเวลาหมดอายุขั้นสูง

#### ⏰ การขยายเวลา

```dart
// ขยายเวลาเพิ่ม 1 ชั่วโมง
await cacheManager.extendExpiration(
  key: 'my_key',
  additionalTime: Duration(hours: 1),
);

// กำหนดเวลาหมดอายุใหม่
await cacheManager.extendExpiration(
  key: 'my_key',
  newExpirationTime: DateTime.now().add(Duration(days: 2)),
);
```

#### 🎯 CachePolicy ขั้นสูง

```dart
// สร้าง Policy ที่ซับซ้อน
final advancedPolicy = CachePolicy(
  expiresAt: DateTime.now().add(Duration(hours: 6)),
  encryptionKey: 'my_secure_key_2024',
  maxSize: 1024 * 1024, // 1MB
);

// ใช้งาน
await cacheManager.put(
  key: 'complex_data',
  value: largeData,
  policy: advancedPolicy,
);

// ตรวจสอบคุณสมบัติของ Policy
final expirationTime = advancedPolicy.getExpirationTime();
final remainingTime = advancedPolicy.getRemainingTime();
final willExpire = advancedPolicy.isExpiredAt(
  DateTime.now().add(Duration(hours: 8))
);
```

### 🎮 ตัวอย่างการใช้งานจริง

#### 📱 Social Media App

```dart
// โพสต์หมดอายุเมื่อสิ้นวัน
await cacheManager.putUntilEndOfDay(
  key: 'daily_posts',
  value: posts,
);

// Story หมดอายุใน 24 ชั่วโมง
await cacheManager.putForHours(
  key: 'user_story_${userId}',
  value: storyData,
  hours: 24,
);
```

#### 🛒 E-commerce App

```dart
// ราคาสินค้าหมดอายุใน 15 นาที
await cacheManager.putForMinutes(
  key: 'product_price_${productId}',
  value: priceData,
  minutes: 15,
);

// ตะกร้าสินค้าหมดอายุใน 30 นาที
await cacheManager.putForMinutes(
  key: 'shopping_cart_${userId}',
  value: cartItems,
  minutes: 30,
);
```

#### 🎮 Gaming App

```dart
// Player session หมดอายุใน 2 ชั่วโมง
await cacheManager.putForHours(
  key: 'player_session_${playerId}',
  value: sessionData,
  hours: 2,
);

// Leaderboard ใหม่ทุกสิ้นวัน
await cacheManager.putUntilEndOfDay(
  key: 'daily_leaderboard',
  value: leaderboardData,
);
```

#### 📊 Analytics App

```dart
// รายงานรายวันหมดอายุเมื่อสิ้นวัน
await cacheManager.putUntilEndOfDay(
  key: 'daily_analytics',
  value: dailyStats,
);

// รายงานรายเดือนหมดอายุเมื่อสิ้นเดือน
await cacheManager.putUntilEndOfMonth(
  key: 'monthly_report',
  value: monthlyReport,
);
```

### 🔄 Real-time Monitoring

```dart
// ตรวจสอบสถานะแบบเรียลไทม์
Timer.periodic(Duration(seconds: 5), (timer) async {
  final info = await cacheManager.getEntryInfo('important_data');
  if (info != null && info.remainingTime != null) {
    final remaining = info.remainingTime!;
    if (remaining.inMinutes < 5) {
      // แจ้งเตือนว่าใกล้หมดอายุ
      print('⚠️ Cache จะหมดอายุใน ${remaining.inMinutes} นาที');

      // อาจจะต่ออายุหรือโหลดข้อมูลใหม่
      await cacheManager.extendExpiration(
        key: 'important_data',
        additionalTime: Duration(hours: 1),
      );
    }
  }
});
```

## 🎯 ข้อดีของระบบใหม่

- ✅ **ยืดหยุ่น**: รองรับทั้ง Duration และ DateTime
- ✅ **สะดวก**: มี convenience methods สำหรับทุกสถานการณ์
- ✅ **ชัดเจน**: ตรวจสอบสถานะได้ละเอียด
- ✅ **ขยายได้**: สามารถขยายเวลาหมดอายุได้
- ✅ **เรียลไทม์**: ตรวจสอบและแจ้งเตือนได้
- ✅ **ปลอดภัย**: รองรับการเข้ารหัสในทุก method

---

🚀 **ระบบการจัดการเวลาหมดอายุที่ครบครันและใช้งานง่ายที่สุด!**
