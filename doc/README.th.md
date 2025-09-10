# cache_manager_lite

ระบบจัดการแคชที่มีประสิทธิภาพสูง ใช้งานง่าย และปลอดภัยสำหรับ Flutter – ออกแบบมาเพื่อความยืดหยุ่นสูงสุดและเพิ่มประสิทธิภาพการพัฒนา

## 🌐 Language / ภาษา

- [🇺🇸 English](../README.md)
- [🇹🇭 ไทย / Thai](README.th.md) (Current)
- [🇨🇳 中文 / Chinese](README.cn.md)
- [🇲🇲 မြန်မာ / Myanmar](README.mm.md)
- [🇸🇬 Melayu / Singapore](README.sg.md)
- [🇱🇦 ລາວ / Lao](README.la.md)

## คุณสมบัติ

- ⚡ **ประสิทธิภาพสูง**: ปรับปรุงเพื่อความเร็วและประสิทธิภาพ
- 🧠 **การแคชอัจฉริยะ**: การจัดการแคชอัจฉริยะพร้อมการล้างข้อมูลอัตโนมัติ
- 🔒 **ปลอดภัย**: เข้ารหัส AES สำหรับข้อมูลสำคัญ (ตัวเลือก)
- 📱 **ปรับปรุงสำหรับ Flutter**: สร้างขึ้นเฉพาะสำหรับแอปพลิเคชัน Flutter
- 🎯 **ใช้งานง่าย**: ระดับการใช้งานหลายระดับสำหรับนักพัฒนาทุกทักษะ
- 🛠️ **ปรับแต่งได้**: ตัวเลือกการกำหนดค่าอย่างกว้างขวาง
- 🔧 **สถาปัตยกรรมสะอาด**: ปฏิบัติตามหลักการ Domain-Driven Design
- 🕒 **การหมดอายุขั้นสูง**: การหมดอายุแบบครอบคลุมตามเวลาพร้อมตัวนับถอยหลัง
- ⏰ **การควบคุมเวลาที่ยืดหยุ่น**: Duration, DateTime, วิธีการสะดวก และการตรวจสอบแบบเรียลไทม์

## 🛠️ การติดตั้ง

เพิ่มสิ่งนี้ไปยังไฟล์ `pubspec.yaml` ของแพ็คเกจของคุณ:

```yaml
dependencies:
  cache_manager_lite: ^0.1.0
```

จากนั้นรัน:

```bash
flutter pub get
```

## 📚 เอกสารประกอบ

- 📖 [คู่มือเอกสารครบถ้วน](../DOCUMENTATION_GUIDE.md) - เอกสารครอบคลุมสำหรับผู้ใช้ทุกระดับ
- 🎯 [คู่มือระดับผู้ใช้](../USER_LEVEL_GUIDE.md) - คู่มือการใช้งานตามระดับทักษะ
- 🕒 [คู่มือการจัดการการหมดอายุ](../EXPIRATION_GUIDE.md) - คู่มือการจัดการการหมดอายุขั้นสูง
- 💡 [ตัวอย่าง](../example/) - ตัวอย่างการใช้งานครบถ้วน
- 📝 [บันทึกการเปลี่ยนแปลง](../CHANGELOG.md) - ประวัติการอัปเดต

## 🚀 เริ่มต้นใช้งานอย่างรวดเร็ว

### 📱 ขั้นตอนที่ 1: สร้างโปรเจค Flutter ใหม่

```bash
# สร้างโปรเจคใหม่
flutter create my_cache_app
cd my_cache_app
```

### 📦 ขั้นตอนที่ 2: เพิ่ม Cache Manager Lite

แก้ไขไฟล์ `pubspec.yaml` ของคุณ:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cache_manager_lite: ^0.1.0 # เพิ่มบรรทัดนี้

dev_dependencies:
  flutter_test:
    sdk: flutter
```

จากนั้นรัน:

```bash
flutter pub get
```

### 🎯 ขั้นตอนที่ 3: การใช้งานพื้นฐานสำหรับผู้เริ่มต้น

สร้าง `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:cache_manager_lite/cache_manager_lite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cache Manager Demo',
      home: CacheDemo(),
    );
  }
}

class CacheDemo extends StatefulWidget {
  @override
  _CacheDemoState createState() => _CacheDemoState();
}

class _CacheDemoState extends State<CacheDemo> {
  // เริ่มต้น Cache Manager ด้วยการตั้งค่าที่เป็นมิตรกับผู้เริ่มต้น
  final cacheManager = CacheManagerLite.forBeginner();

  String _cachedData = '';
  String _inputText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cache Manager Demo'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ช่องป้อนข้อมูล
            TextField(
              decoration: InputDecoration(
                labelText: 'ป้อนข้อมูลที่ต้องการแคช',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _inputText = value;
              },
            ),
            SizedBox(height: 16),

            // ปุ่มบันทึกข้อมูล
            ElevatedButton(
              onPressed: _saveData,
              child: Text('บันทึกข้อมูล (หมดอายุใน 1 ชั่วโมง)'),
            ),
            SizedBox(height: 16),

            // ปุ่มโหลดข้อมูล
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('โหลดข้อมูลจากแคช'),
            ),
            SizedBox(height: 16),

            // ปุ่มล้างข้อมูล
            ElevatedButton(
              onPressed: _clearData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('ล้างข้อมูลทั้งหมด'),
            ),
            SizedBox(height: 24),

            // แสดงข้อมูลที่แคช
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ข้อมูลที่แคช:',
                       style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(_cachedData.isEmpty ? 'ไม่มีข้อมูล' : _cachedData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // บันทึกข้อมูลลงแคช
  Future<void> _saveData() async {
    if (_inputText.isNotEmpty) {
      // บันทึกข้อมูลโดยหมดอายุใน 1 ชั่วโมง
      await cacheManager.putForHours(
        key: 'user_data',
        value: _inputText,
        hours: 1,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('บันทึกข้อมูลสำเร็จ!')),
      );
    }
  }

  // โหลดข้อมูลจากแคช
  Future<void> _loadData() async {
    final data = await cacheManager.get('user_data');
    setState(() {
      _cachedData = data ?? 'ไม่พบข้อมูลหรือข้อมูลหมดอายุแล้ว';
    });
  }

  // ล้างข้อมูลทั้งหมดที่แคชไว้
  Future<void> _clearData() async {
    await cacheManager.clear();
    setState(() {
      _cachedData = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ล้างข้อมูลทั้งหมดแล้ว!')),
    );
  }
}
```

### 🏃‍♂️ ขั้นตอนที่ 4: รันแอปพลิเคชัน

```bash
flutter run
```

## 🎯 ผลลัพธ์ที่คาดหวัง

1. **ช่องป้อนข้อมูล**: ป้อนข้อมูลที่จะแคช
2. **ปุ่มบันทึก**: เก็บข้อมูลโดยหมดอายุใน 1 ชั่วโมง
3. **ปุ่มโหลด**: ดึงข้อมูลที่แคชไว้
4. **ปุ่มล้าง**: ลบข้อมูลทั้งหมดที่แคชไว้

## 💡 เคล็ดลับสำหรับผู้เริ่มต้น

- **เริ่มต้นด้วย `.forBeginner()`** - ใช้งานง่ายที่สุด
- **ใช้ `.putForHours()`** - การตั้งเวลาหมดอายุแบบง่าย
- **ลอง Custom `AppType`** - เปลี่ยนตามประเภทแอปของคุณ
- **ปรับ `CacheSize`** - เพิ่มขนาดแคชตามความต้องการ

## 🎯 การใช้งานขั้นสูง

### 1. การแคชพื้นฐาน

```dart
import 'package:cache_manager_lite/cache_manager_lite.dart';

// เริ่มต้น cache manager
final cacheManager = CacheManagerLite();

// เก็บข้อมูลโดยหมดอายุใน 1 ชั่วโมง
await cacheManager.putForHours(
  key: 'user_profile',
  value: userProfile,
  hours: 1,
);

// ดึงข้อมูล
final cachedProfile = await cacheManager.get<UserProfile>('user_profile');
```

### 2. การควบคุมการหมดอายุขั้นสูง

```dart
// เก็บจนสิ้นวัน
await cacheManager.putUntilEndOfDay(
  key: 'daily_summary',
  value: summaryData,
);

// เก็บโดยกำหนดเวลาหมดอายุเฉพาะ
await cacheManager.putWithExpirationTime(
  key: 'limited_offer',
  value: offerData,
  expirationTime: DateTime(2024, 12, 31, 23, 59, 59),
);

// ตรวจสอบเวลาที่เหลือ
final remainingTime = await cacheManager.getRemainingTime('limited_offer');
print('หมดอายุใน: ${remainingTime?.inHours} ชั่วโมง');
```

### 3. การตรวจสอบแบบเรียลไทม์

```dart
// ตรวจสอบสถานะแคช
final info = await cacheManager.getEntryInfo('important_data');
if (info != null) {
  print('สถานะ: ${info.statusDescription}');
  print('เวลาที่เหลือ: ${info.remainingTime}');
  print('อายุแคช: ${info.age}');
}
```

### 4. การกำหนดค่าขั้นสูง

```dart
final cacheManager = CacheManagerLite(
  config: CacheConfig(
    maxCacheSize: 100 * 1024 * 1024, // 100MB
    defaultPolicy: CachePolicy(
      maxAge: Duration(hours: 2),
      encryptionKey: 'your-secret-key', // การเข้ารหัสเสริม
    ),
  ),
);
```

## 📖 เอกสารอ้างอิง API

### CacheManagerLite

คลาสหลักสำหรับการดำเนินการแคช

#### เมธอดหลัก

- `put({required String key, required dynamic value, CachePolicy? policy, Duration? maxAge, DateTime? expiresAt})` - เก็บข้อมูลในแคช
- `get<T>(String key)` - ดึงข้อมูลจากแคชตาม key
- `exists(String key)` - ตรวจสอบว่า key มีอยู่และยังไม่หมดอายุ
- `delete(String key)` - ลบรายการเฉพาะ
- `clear()` - ล้างข้อมูลทั้งหมดที่แคชไว้

#### เมธอดตามเวลา

- `putWithDuration({required String key, required dynamic value, required Duration duration})` - เก็บตามระยะเวลา
- `putWithExpirationTime({required String key, required dynamic value, required DateTime expirationTime})` - เก็บจนถึงเวลาที่กำหนด
- `putForMinutes({required String key, required dynamic value, required int minutes})` - เก็บเป็น X นาที
- `putForHours({required String key, required dynamic value, required int hours})` - เก็บเป็น X ชั่วโมง
- `putForDays({required String key, required dynamic value, required int days})` - เก็บเป็น X วัน
- `putUntilEndOfDay({required String key, required dynamic value})` - เก็บจนถึง 23:59:59
- `putUntilEndOfWeek({required String key, required dynamic value})` - เก็บจนสิ้นสัปดาห์
- `putUntilEndOfMonth({required String key, required dynamic value})` - เก็บจนสิ้นเดือน
- `putPermanent({required String key, required dynamic value})` - เก็บไม่มีการหมดอายุ

#### เมธอดการตรวจสอบ

- `getEntryInfo(String key)` - รับข้อมูลรายละเอียดของรายการแคช
- `getRemainingTime(String key)` - รับเวลาจนหมดอายุ
- `extendExpiration({required String key, Duration? additionalTime, DateTime? newExpirationTime})` - ขยายเวลาหมดอายุ

#### เมธอดเครือข่าย

- `getJson(String url, {CachePolicy? policy})` - ดึงและแคช JSON จาก URL
- `getBytes(String url, {CachePolicy? policy})` - ดึงและแคช bytes จาก URL

### เมธอด Factory ของ CachePolicy

```dart
// ตามระยะเวลา
CachePolicy.duration({required Duration duration, String? encryptionKey})
CachePolicy.inMinutes(int minutes, {String? encryptionKey})
CachePolicy.inHours(int hours, {String? encryptionKey})
CachePolicy.inDays(int days, {String? encryptionKey})

// ตามเวลา
CachePolicy.expiresAt({required DateTime expirationTime, String? encryptionKey})
CachePolicy.endOfDay({String? encryptionKey})
CachePolicy.endOfWeek({String? encryptionKey})
CachePolicy.endOfMonth({String? encryptionKey})
CachePolicy.never({String? encryptionKey}) // ไม่มีการหมดอายุ
```

## 🎨 ตัวอย่าง

### 1. การแคชตามเวลา

```dart
// เก็บเซสชันผู้ใช้เป็นเวลา 2 ชั่วโมง
await cacheManager.putForHours(
  key: 'user_session',
  value: sessionData,
  hours: 2,
);

// เก็บรายงานประจำวันจนสิ้นวัน
await cacheManager.putUntilEndOfDay(
  key: 'daily_report',
  value: reportData,
);

// เก็บโดยกำหนดเวลาหมดอายุเฉพาะ
await cacheManager.putWithExpirationTime(
  key: 'limited_offer',
  value: offerData,
  expirationTime: DateTime(2024, 12, 31, 23, 59, 59),
);
```

### 2. การตรวจสอบแบบเรียลไทม์

```dart
// ตรวจสอบสถานะแคช
final info = await cacheManager.getEntryInfo('important_data');
if (info != null) {
  print('สถานะ: ${info.statusDescription}');
  print('หมดอายุที่: ${info.expiresAt}');
  print('เวลาที่เหลือ: ${info.remainingTime}');
  print('อายุแคช: ${info.age}');
}

// ตรวจสอบเวลาที่เหลือ
final remaining = await cacheManager.getRemainingTime('user_session');
if (remaining != null && remaining.inMinutes < 10) {
  // ขยายการหมดอายุอีก 1 ชั่วโมง
  await cacheManager.extendExpiration(
    key: 'user_session',
    additionalTime: Duration(hours: 1),
  );
}
```

### 3. การแคช REST API

```dart
final posts = await cacheManager.getJson(
  'https://jsonplaceholder.typicode.com/posts',
  policy: CachePolicy.inHours(1),
);
```

### 4. การแคชรูปภาพ

```dart
final imageBytes = await cacheManager.getBytes(
  'https://example.com/image.jpg',
  policy: CachePolicy.inDays(1),
);
```

### 5. การจัดเก็บข้อมูลที่ปลอดภัย

```dart
// เก็บข้อมูลที่เข้ารหัส
await cacheManager.put(
  key: 'sensitive_data',
  value: userData,
  policy: CachePolicy.inHours(
    6,
    encryptionKey: 'your-secret-key-2024',
  ),
);
```

### 6. ตัวอย่างแอปพลิเคชันเกม

```dart
// เซสชันผู้เล่นหมดอายุใน 2 ชั่วโมง
await cacheManager.putForHours(
  key: 'player_${playerId}',
  value: playerData,
  hours: 2,
);

// กระดานคะแนนประจำวันรีเซ็ตเมื่อสิ้นวัน
await cacheManager.putUntilEndOfDay(
  key: 'daily_leaderboard',
  value: leaderboardData,
);

// ข้อมูลการแข่งขันหมดอายุเวลาที่กำหนด
await cacheManager.putWithExpirationTime(
  key: 'tournament_brackets',
  value: tournamentData,
  expirationTime: DateTime(2024, 6, 15, 18, 0, 0), // 6 PM
);
```

## 📱 การรองรับแพลตฟอร์ม

- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Windows
- ✅ Linux
- ✅ Web

## 📄 สัญญาอนุญาต

สัญญาอนุญาต MIT - ดูรายละเอียดใน [LICENSE](../LICENSE)
