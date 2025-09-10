# cache_manager_lite

ຕົວຈັດການ cache ທີ່ມີປະສິດທິພາບສູງ, ໃຊ້ງ່າຍ ແລະ ປອດໄພສໍາລັບ Flutter – ອອກແບບເພື່ອຄວາມຍືດຫຍຸ່ນສູງສຸດ ແລະ ປະສິດທິພາບການພັດທະນາ

## 🌐 Language / ພາສາ

- [🇺🇸 English](../README.md)
- [🇹🇭 ไทย / Thai](README.th.md)
- [🇨🇳 中文 / Chinese](README.cn.md)
- [🇲🇲 မြန်မာ / Myanmar](README.mm.md)
- [🇸🇬 Melayu / Singapore](README.sg.md)
- [🇱🇦 ລາວ / Lao](README.la.md) (Current)

## ຄຸນສົມບັດ

- ⚡ **ປະສິດທິພາບສູງ**: ປັບປຸງເພື່ອຄວາມໄວ ແລະ ຄວາມມີປະສິດທິພາບ
- 🧠 **Cache ອັດສະລິຍະ**: ການຈັດການ cache ອັດສະລິຍະທີ່ມີການລຶບອັດຕະໂນມັດ
- 🔒 **ປອດໄພ**: ການເຂົ້າລະຫັດ AES ທາງເລືອກສໍາລັບຂໍ້ມູນທີ່ສໍາຄັນ
- 📱 **ປັບປຸງສໍາລັບ Flutter**: ສ້າງຂຶ້ນສະເພາະສໍາລັບແອັບພລິເຄຊັນ Flutter
- 🎯 **ໃຊ້ງ່າຍ**: ຫຼາຍລະດັບການໃຊ້ງານສໍາລັບທັກສະຂອງນັກພັດທະນາທີ່ແຕກຕ່າງກັນ
- 🛠️ **ກໍາຫນົດຄ່າໄດ້**: ຕົວເລືອກການກໍາຫນົດຄ່າທີ່ກວ້າງຂວາງ
- 🔧 **ສະຖາປັດຕະຍະກໍາສະອາດ**: ປະຕິບັດຕາມຫຼັກການ Domain-Driven Design
- 🕒 **ການໝົດອາຍຸຂັ້ນສູງ**: ການໝົດອາຍຸຕາມເວລາທີ່ສົມບູນແບບດ້ວຍຕົວນັບຖອຍຫຼັງ
- ⏰ **ການຄວບຄຸມເວລາທີ່ຍືດຫຍຸ່ນ**: Duration, DateTime, ວິທີການສະດວກ ແລະ ການຕິດຕາມເວລາຈິງ

## 🛠️ ການຕິດຕັ້ງ

ເພີ່ມສິ່ງນີ້ໃສ່ໄຟລ໌ `pubspec.yaml` ຂອງແພັກເກັດຂອງທ່ານ:

```yaml
dependencies:
  cache_manager_lite: ^0.1.1
```

ຈາກນັ້ນແລ່ນ:

```bash
flutter pub get
```

## 📚 ເອກະສານ

- 📖 [ຄູ່ມືເອກະສານສົມບູນ](../DOCUMENTATION_GUIDE.md) - ເອກະສານທີ່ສົມບູນສໍາລັບຜູ້ໃຊ້ທຸກລະດັບ
- 🎯 [ຄູ່ມືລະດັບຜູ້ໃຊ້](../USER_LEVEL_GUIDE.md) - ຄູ່ມືການໃຊ້ງານຕາມລະດັບທັກສະ
- 🕒 [ຄູ່ມືການຈັດການການໝົດອາຍຸ](../EXPIRATION_GUIDE.md) - ຄູ່ມືການຈັດການການໝົດອາຍຸຂັ້ນສູງ
- 💡 [ຕົວຢ່າງ](../example/) - ຕົວຢ່າງການໃຊ້ງານທີ່ສົມບູນ
- 📝 [ບັນທຶກການປ່ຽນແປງ](../CHANGELOG.md) - ປະຫວັດການອັບເດດ

## 🚀 ເລີ່ມຕົ້ນໄວ

### 📱 ຂັ້ນຕອນທີ 1: ສ້າງໂປຣເຈັກ Flutter ໃໝ່

```bash
# ສ້າງໂປຣເຈັກໃໝ່
flutter create my_cache_app
cd my_cache_app
```

### 📦 ຂັ້ນຕອນທີ 2: ເພີ່ມ Cache Manager Lite

ແກ້ໄຂໄຟລ໌ `pubspec.yaml` ຂອງທ່ານ:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cache_manager_lite: ^0.1.1 # ເພີ່ມແຖວນີ້

dev_dependencies:
  flutter_test:
    sdk: flutter
```

ຈາກນັ້ນແລ່ນ:

```bash
flutter pub get
```

### 🎯 ຂັ້ນຕອນທີ 3: ການໃຊ້ງານພື້ນຖານສໍາລັບຜູ້ເລີ່ມຕົ້ນ

ສ້າງ `lib/main.dart`:

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
  // ເລີ່ມຕົ້ນ Cache Manager ດ້ວຍການຕັ້ງຄ່າທີ່ເປັນມິດກັບຜູ້ເລີ່ມຕົ້ນ
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
            // ຊ່ອງໃສ່ຂໍ້ມູນ
            TextField(
              decoration: InputDecoration(
                labelText: 'ໃສ່ຂໍ້ມູນທີ່ຕ້ອງການ cache',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _inputText = value;
              },
            ),
            SizedBox(height: 16),

            // ປຸ່ມບັນທຶກຂໍ້ມູນ
            ElevatedButton(
              onPressed: _saveData,
              child: Text('ບັນທຶກຂໍ້ມູນ (ໝົດອາຍຸໃນ 1 ຊົ່ວໂມງ)'),
            ),
            SizedBox(height: 16),

            // ປຸ່ມໂຫຼດຂໍ້ມູນ
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('ໂຫຼດຂໍ້ມູນຈາກ Cache'),
            ),
            SizedBox(height: 16),

            // ປຸ່ມລຶບຂໍ້ມູນ
            ElevatedButton(
              onPressed: _clearData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('ລຶບຂໍ້ມູນທັງໝົດ'),
            ),
            SizedBox(height: 24),

            // ສະແດງຂໍ້ມູນທີ່ cache ໄວ້
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ຂໍ້ມູນທີ່ Cache ໄວ້:',
                       style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(_cachedData.isEmpty ? 'ບໍ່ມີຂໍ້ມູນ' : _cachedData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ບັນທຶກຂໍ້ມູນລົງ cache
  Future<void> _saveData() async {
    if (_inputText.isNotEmpty) {
      // ບັນທຶກຂໍ້ມູນທີ່ໝົດອາຍຸໃນ 1 ຊົ່ວໂມງ
      await cacheManager.putForHours(
        key: 'user_data',
        value: _inputText,
        hours: 1,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ບັນທຶກຂໍ້ມູນສໍາເລັດ!')),
      );
    }
  }

  // ໂຫຼດຂໍ້ມູນຈາກ cache
  Future<void> _loadData() async {
    final data = await cacheManager.get('user_data');
    setState(() {
      _cachedData = data ?? 'ບໍ່ພົບຂໍ້ມູນ ຫຼື ຂໍ້ມູນໝົດອາຍຸແລ້ວ';
    });
  }

  // ລຶບຂໍ້ມູນ cache ທັງໝົດ
  Future<void> _clearData() async {
    await cacheManager.clear();
    setState(() {
      _cachedData = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ລຶບຂໍ້ມູນທັງໝົດແລ້ວ!')),
    );
  }
}
```

### 🏃‍♂️ ຂັ້ນຕອນທີ 4: ແລ່ນແອັບພລິເຄຊັນ

```bash
flutter run
```

## 🎯 ຜົນລັບທີ່ຄາດຫວັງ

1. **ຊ່ອງໃສ່ຂໍ້ມູນ**: ໃສ່ຂໍ້ມູນທີ່ຈະ cache
2. **ປຸ່ມບັນທຶກ**: ເກັບຂໍ້ມູນທີ່ໝົດອາຍຸໃນ 1 ຊົ່ວໂມງ
3. **ປຸ່ມໂຫຼດ**: ດຶງຂໍ້ມູນທີ່ cache ໄວ້
4. **ປຸ່ມລຶບ**: ລຶບຂໍ້ມູນ cache ທັງໝົດ

## 💡 ຄໍາແນະນໍາສໍາລັບຜູ້ເລີ່ມຕົ້ນ

- **ເລີ່ມຕົ້ນດ້ວຍ `.forBeginner()`** - ໃຊ້ງ່າຍທີ່ສຸດ
- **ໃຊ້ `.putForHours()`** - ການຕັ້ງເວລາໝົດອາຍຸງ່າຍໆ
- **ລອງ Custom `AppType`** - ປ່ຽນຕາມປະເພດແອັບຂອງທ່ານ
- **ປັບ `CacheSize`** - ເພີ່ມຂະໜາດ cache ຕາມຄວາມຕ້ອງການ

## 🎯 ການໃຊ້ງານຂັ້ນສູງ

### 1. Cache ພື້ນຖານ

```dart
import 'package:cache_manager_lite/cache_manager_lite.dart';

// ເລີ່ມຕົ້ນຕົວຈັດການ cache
final cacheManager = CacheManagerLite();

// ເກັບຂໍ້ມູນທີ່ໝົດອາຍຸໃນ 1 ຊົ່ວໂມງ
await cacheManager.putForHours(
  key: 'user_profile',
  value: userProfile,
  hours: 1,
);

// ດຶງຂໍ້ມູນ
final cachedProfile = await cacheManager.get<UserProfile>('user_profile');
```

### 2. ການຄວບຄຸມການໝົດອາຍຸຂັ້ນສູງ

```dart
// ເກັບຈົນກວ່າຈະໝົດມື້
await cacheManager.putUntilEndOfDay(
  key: 'daily_summary',
  value: summaryData,
);

// ເກັບດ້ວຍເວລາໝົດອາຍຸສະເພາະ
await cacheManager.putWithExpirationTime(
  key: 'limited_offer',
  value: offerData,
  expirationTime: DateTime(2024, 12, 31, 23, 59, 59),
);

// ກວດສອບເວລາທີ່ເຫຼືອ
final remainingTime = await cacheManager.getRemainingTime('limited_offer');
print('ໝົດອາຍຸໃນ: ${remainingTime?.inHours} ຊົ່ວໂມງ');
```

### 3. ການຕິດຕາມເວລາຈິງ

```dart
// ຕິດຕາມສະຖານະ cache
final info = await cacheManager.getEntryInfo('important_data');
if (info != null) {
  print('ສະຖານະ: ${info.statusDescription}');
  print('ເວລາທີ່ເຫຼືອ: ${info.remainingTime}');
  print('ອາຍຸ cache: ${info.age}');
}
```

### 4. ການກໍາຫນົດຄ່າຂັ້ນສູງ

```dart
final cacheManager = CacheManagerLite(
  config: CacheConfig(
    maxCacheSize: 100 * 1024 * 1024, // 100MB
    defaultPolicy: CachePolicy(
      maxAge: Duration(hours: 2),
      encryptionKey: 'your-secret-key', // ການເຂົ້າລະຫັດທາງເລືອກ
    ),
  ),
);
```

## 📖 ອ້າງອີງ API

### CacheManagerLite

ຄລາສຫຼັກສໍາລັບການດໍາເນີນງານ cache

#### ວິທີການຫຼັກ

- `put({required String key, required dynamic value, CachePolicy? policy, Duration? maxAge, DateTime? expiresAt})` - ເກັບຂໍ້ມູນໃນ cache
- `get<T>(String key)` - ດຶງຂໍ້ມູນຈາກ cache ຕາມ key
- `exists(String key)` - ກວດສອບວ່າ key ມີຢູ່ ແລະ ຍັງບໍ່ໝົດອາຍຸ
- `delete(String key)` - ລຶບລາຍການສະເພາະ
- `clear()` - ລຶບຂໍ້ມູນ cache ທັງໝົດ

#### ວິທີການຕາມເວລາ

- `putWithDuration({required String key, required dynamic value, required Duration duration})` - ເກັບດ້ວຍໄລຍະເວລາ
- `putWithExpirationTime({required String key, required dynamic value, required DateTime expirationTime})` - ເກັບຈົນເຖິງເວລາສະເພາະ
- `putForMinutes({required String key, required dynamic value, required int minutes})` - ເກັບເປັນ X ນາທີ
- `putForHours({required String key, required dynamic value, required int hours})` - ເກັບເປັນ X ຊົ່ວໂມງ
- `putForDays({required String key, required dynamic value, required int days})` - ເກັບເປັນ X ມື້
- `putUntilEndOfDay({required String key, required dynamic value})` - ເກັບຈົນເຖິງ 23:59:59
- `putUntilEndOfWeek({required String key, required dynamic value})` - ເກັບຈົນໝົດອາທິດ
- `putUntilEndOfMonth({required String key, required dynamic value})` - ເກັບຈົນໝົດເດືອນ
- `putPermanent({required String key, required dynamic value})` - ເກັບໂດຍບໍ່ມີການໝົດອາຍຸ

#### ວິທີການຕິດຕາມ

- `getEntryInfo(String key)` - ຮັບຂໍ້ມູນລະອຽດຂອງລາຍການ cache
- `getRemainingTime(String key)` - ຮັບເວລາຈົນກວ່າຈະໝົດອາຍຸ
- `extendExpiration({required String key, Duration? additionalTime, DateTime? newExpirationTime})` - ຂະຫຍາຍເວລາໝົດອາຍຸ

#### ວິທີການເຄືອຂ່າຍ

- `getJson(String url, {CachePolicy? policy})` - ດຶງ ແລະ cache JSON ຈາກ URL
- `getBytes(String url, {CachePolicy? policy})` - ດຶງ ແລະ cache bytes ຈາກ URL

### ວິທີການ Factory ຂອງ CachePolicy

```dart
// ຕາມໄລຍະເວລາ
CachePolicy.duration({required Duration duration, String? encryptionKey})
CachePolicy.inMinutes(int minutes, {String? encryptionKey})
CachePolicy.inHours(int hours, {String? encryptionKey})
CachePolicy.inDays(int days, {String? encryptionKey})

// ຕາມເວລາ
CachePolicy.expiresAt({required DateTime expirationTime, String? encryptionKey})
CachePolicy.endOfDay({String? encryptionKey})
CachePolicy.endOfWeek({String? encryptionKey})
CachePolicy.endOfMonth({String? encryptionKey})
CachePolicy.never({String? encryptionKey}) // ບໍ່ມີການໝົດອາຍຸ
```

## 🎨 ຕົວຢ່າງ

### 1. Cache ຕາມເວລາ

```dart
// ເກັບ session ຜູ້ໃຊ້ເປັນເວລາ 2 ຊົ່ວໂມງ
await cacheManager.putForHours(
  key: 'user_session',
  value: sessionData,
  hours: 2,
);

// ເກັບລາຍງານປະຈໍາວັນຈົນໝົດມື້
await cacheManager.putUntilEndOfDay(
  key: 'daily_report',
  value: reportData,
);

// ເກັບດ້ວຍເວລາໝົດອາຍຸສະເພາະ
await cacheManager.putWithExpirationTime(
  key: 'limited_offer',
  value: offerData,
  expirationTime: DateTime(2024, 12, 31, 23, 59, 59),
);
```

### 2. ການຕິດຕາມເວລາຈິງ

```dart
// ຕິດຕາມສະຖານະ cache
final info = await cacheManager.getEntryInfo('important_data');
if (info != null) {
  print('ສະຖານະ: ${info.statusDescription}');
  print('ໝົດອາຍຸທີ່: ${info.expiresAt}');
  print('ເວລາທີ່ເຫຼືອ: ${info.remainingTime}');
  print('ອາຍຸ cache: ${info.age}');
}

// ກວດສອບເວລາທີ່ເຫຼືອ
final remaining = await cacheManager.getRemainingTime('user_session');
if (remaining != null && remaining.inMinutes < 10) {
  // ຂະຫຍາຍການໝົດອາຍຸອີກ 1 ຊົ່ວໂມງ
  await cacheManager.extendExpiration(
    key: 'user_session',
    additionalTime: Duration(hours: 1),
  );
}
```

### 3. Cache REST API

```dart
final posts = await cacheManager.getJson(
  'https://jsonplaceholder.typicode.com/posts',
  policy: CachePolicy.inHours(1),
);
```

### 4. Cache ຮູບພາບ

```dart
final imageBytes = await cacheManager.getBytes(
  'https://example.com/image.jpg',
  policy: CachePolicy.inDays(1),
);
```

### 5. ການຈັດເກັບຂໍ້ມູນທີ່ປອດໄພ

```dart
// ເກັບຂໍ້ມູນທີ່ເຂົ້າລະຫັດ
await cacheManager.put(
  key: 'sensitive_data',
  value: userData,
  policy: CachePolicy.inHours(
    6,
    encryptionKey: 'your-secret-key-2024',
  ),
);
```

### 6. ຕົວຢ່າງແອັບພລິເຄຊັນເກມ

```dart
// session ຜູ້ລິ້ນໝົດອາຍຸໃນ 2 ຊົ່ວໂມງ
await cacheManager.putForHours(
  key: 'player_${playerId}',
  value: playerData,
  hours: 2,
);

// ກະດານຄະແນນປະຈໍາວັນ reset ໃນຕອນໝົດມື້
await cacheManager.putUntilEndOfDay(
  key: 'daily_leaderboard',
  value: leaderboardData,
);

// ຂໍ້ມູນການແຂ່ງຂັນໝົດອາຍຸທີ່ເວລາສະເພາະ
await cacheManager.putWithExpirationTime(
  key: 'tournament_brackets',
  value: tournamentData,
  expirationTime: DateTime(2024, 6, 15, 18, 0, 0), // 6 PM
);
```

## 📱 ການສະໜັບສະໜູນແພລາດຟອມ

- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Windows
- ✅ Linux
- ✅ Web

## 📄 ໃບອະນຸຍາດ

ໃບອະນຸຍາດ MIT - ລາຍລະອຽດໃນ [LICENSE](../LICENSE)
