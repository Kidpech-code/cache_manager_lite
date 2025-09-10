# cache_manager_lite

Flutter အတွက် စွမ်းဆောင်ရည်မြင့်၊ အသုံးပြုရလွယ်ကူပြီး လုံခြုံသော cache manager - အမြင့်ဆုံး လိုက်လျောညီထွေမှုနှင့် developer တို့၏ ကုန်ထုတ်စွမ်းအားအတွက် ဒီဇိုင်းထုတ်ထားသည်။

## 🌐 Language / ဘာသာစကား

- [🇺🇸 English](../README.md)
- [🇹🇭 ไทย / Thai](README.th.md)
- [🇨🇳 中文 / Chinese](README.cn.md)
- [🇲🇲 မြန်မာ / Myanmar](README.mm.md) (Current)
- [🇸🇬 Melayu / Singapore](README.sg.md)
- [🇱🇦 ລາວ / Lao](README.la.md)

## လုပ်ဆောင်ချက်များ

- ⚡ **မြင့်မားသော စွမ်းဆောင်ရည်**: မြန်ဆန်မှုနှင့် ထိရောက်မှုအတွက် ပိုမိုကောင်းမွန်စေမည်
- 🧠 **စမတ်ကက်ရှင်း**: ကြိုးဝိုင်းယာ ဖျက်ခြင်းဖြင့် ထိုးထွင်းမှုရှိသော cache စီမံခန့်ခွဲမှု
- 🔒 **လုံခြုံမှု**: အရေးကြီးသောဒေတာများအတွက် AES encryption (ရွေးချယ်နိုင်သော)
- 📱 **Flutter အတွက် အံ့ဩစရာကောင်းသော**: Flutter applications များအတွက် အထူးတည်ဆောက်ထားသည်
- 🎯 **အသုံးပြုရလွယ်ကူမှု**: မတူညီသော developer တို့၏ ကျွမ်းကျင်မှုအတွက် အမျိုးမျိုးသော အသုံးပြုမှုအဆင့်များ
- 🛠️ **စိတ်ကြိုက်ပြင်ဆင်နိုင်မှု**: ကျယ်ပြန့်သော စီမံကိန်းရွေးချယ်မှုများ
- 🔧 **သန့်ရှင်းသော ဗိသုကာ**: Domain-Driven Design အခြေခံများကို လိုက်နာသည်
- 🕒 **အဆင့်မြင့် ကုန်ဆုံးမှု**: countdown timer များဖြင့် အချိန်အခြေပြု ကုန်ဆုံးမှုစနစ်
- ⏰ **လိုက်လျောညီထွေမှုရှိသော အချိန်ထိန်းချုပ်မှု**: Duration၊ DateTime၊ လွယ်ကူသောနည်းလမ်းများနှင့် real-time စောင့်ကြည့်မှု

## 🛠️ ထည့်သွင်းခြင်း

သင့်၏ package ၏ `pubspec.yaml` file ထဲသို့ ဤအရာကို ထည့်ပါ:

```yaml
dependencies:
  cache_manager_lite: ^0.1.1
```

ထို့နောက် run လုပ်ပါ:

```bash
flutter pub get
```

## 📚 စာတမ်းများ

- 📖 [စုံလင်သော စာတမ်းလမ်းညွှန်](../DOCUMENTATION_GUIDE.md) - အသုံးပြုသူအဆင့်အားလုံးအတွက် ကျယ်ကျယ်ပြန့်ပြန့် စာတမ်းများ
- 🎯 [အသုံးပြုသူအဆင့် လမ်းညွှန်](../USER_LEVEL_GUIDE.md) - ကျွမ်းကျင်မှုအဆင့်အလိုက် အသုံးပြုမှုလမ်းညွှန်
- 🕒 [ကုန်ဆုံးမှု စီမံခန့်ခွဲမှု လမ်းညွှန်](../EXPIRATION_GUIDE.md) - အဆင့်မြင့် ကုန်ဆုံးမှု စီမံခန့်ခွဲမှု လမ်းညွှန်
- 💡 [ဥပမာများ](../example/) - စုံလင်သော အသုံးပြုမှု ဥပမာများ
- 📝 [ပြောင်းလဲမှု မှတ်တမ်း](../CHANGELOG.md) - update မှတ်တမ်း

## 🚀 မြန်ဆန်စွာ စတင်ခြင်း

### 📱 အဆင့် ၁: Flutter project အသစ် ဖန်တီးခြင်း

```bash
# project အသစ် ဖန်တီးမည်
flutter create my_cache_app
cd my_cache_app
```

### 📦 အဆင့် ၂: Cache Manager Lite ထည့်သွင်းခြင်း

သင့်၏ `pubspec.yaml` file ကို ပြင်ဆင်ပါ:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cache_manager_lite: ^0.1.1 # ဤလိုင်းကို ထည့်ပါ

dev_dependencies:
  flutter_test:
    sdk: flutter
```

ထို့နောက် run လုပ်ပါ:

```bash
flutter pub get
```

### 🎯 အဆင့် ၃: စတင်သူများအတွက် အခြေခံအသုံးပြုမှု

`lib/main.dart` ကို ဖန်တီးပါ:

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
  // စတင်သူများအတွက် လွယ်ကူသော setup ဖြင့် Cache Manager ကို စတင်ပါ
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
            // Input field
            TextField(
              decoration: InputDecoration(
                labelText: 'cache လုပ်ရန် ဒေတာထည့်ပါ',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _inputText = value;
              },
            ),
            SizedBox(height: 16),

            // ဒေတာသိမ်းဆည်းရန် button
            ElevatedButton(
              onPressed: _saveData,
              child: Text('ဒေတာသိမ်းမည် (၁ နာရီနောက် ကုန်ဆုံးမည်)'),
            ),
            SizedBox(height: 16),

            // ဒေတာ load လုပ်ရန် button
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Cache မှ ဒေတာ load လုပ်မည်'),
            ),
            SizedBox(height: 16),

            // ဒေတာရှင်းမည့် button
            ElevatedButton(
              onPressed: _clearData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('ဒေတာအားလုံး ရှင်းမည်'),
            ),
            SizedBox(height: 24),

            // Cache လုပ်ထားသော ဒေတာ ပြသမည်
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cache လုပ်ထားသော ဒေတာ:',
                       style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(_cachedData.isEmpty ? 'ဒေတာမရှိပါ' : _cachedData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ဒေတာကို cache ထဲသို့ သိမ်းဆည်းမည်
  Future<void> _saveData() async {
    if (_inputText.isNotEmpty) {
      // ဒေတာကို ၁ နာရီနောက် ကုန်ဆုံးအောင် သိမ်းမည်
      await cacheManager.putForHours(
        key: 'user_data',
        value: _inputText,
        hours: 1,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ဒေတာ သိမ်းဆည်းမှု အောင်မြင်ပါသည်!')),
      );
    }
  }

  // Cache မှ ဒေတာကို load လုပ်မည်
  Future<void> _loadData() async {
    final data = await cacheManager.get('user_data');
    setState(() {
      _cachedData = data ?? 'ဒေတာမတွေ့ပါ သို့မဟုတ် ဒေတာ ကုန်ဆုံးပါပြီ';
    });
  }

  // Cache လုပ်ထားသော ဒေတာအားလုံးကို ရှင်းမည်
  Future<void> _clearData() async {
    await cacheManager.clear();
    setState(() {
      _cachedData = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ဒေတာအားလုံး ရှင်းလင်းပါပြီ!')),
    );
  }
}
```

### 🏃‍♂️ အဆင့် ၄: Application ကို run လုပ်ခြင်း

```bash
flutter run
```

## 🎯 မျှော်လင့်ထားသော ရလဒ်များ

1. **Input Field**: cache လုပ်ရန် ဒေတာထည့်မည်
2. **Save Button**: ၁ နာရီနောက် ကုန်ဆုံးအောင် ဒေတာသိမ်းမည်
3. **Load Button**: cache လုပ်ထားသော ဒေတာကို ပြန်လည်ရယူမည်
4. **Clear Button**: cache လုပ်ထားသော ဒေတာအားလုံးကို ဖျက်မည်

## 💡 စတင်သူများအတွက် အကြံပြုချက်များ

- **`.forBeginner()` ဖြင့် စတင်ပါ** - အသုံးပြုရလွယ်ကူဆုံး
- **`.putForHours()` ကို အသုံးပြုပါ** - ရိုးရှင်းသော ကုန်ဆုံးချိန် စနစ်
- **Custom `AppType` ကို စမ်းကြည့်ပါ** - သင့်၏ app အမျိုးအစားအလိုက် ပြောင်းလဲပါ
- **`CacheSize` ကို ချိန်ညှိပါ** - လိုအပ်သလို cache size ကို တိုးမည်

## 🎯 အဆင့်မြင့် အသုံးပြုမှု

### ၁. အခြေခံ Caching

```dart
import 'package:cache_manager_lite/cache_manager_lite.dart';

// Cache manager ကို စတင်မည်
final cacheManager = CacheManagerLite();

// ဒေတာကို ၁ နာရီနောက် ကုန်ဆုံးအောင် သိမ်းမည်
await cacheManager.putForHours(
  key: 'user_profile',
  value: userProfile,
  hours: 1,
);

// ဒေတာကို ပြန်လည်ရယူမည်
final cachedProfile = await cacheManager.get<UserProfile>('user_profile');
```

### ၂. အဆင့်မြင့် ကုန်ဆုံးမှု ထိန်းချုပ်မှု

```dart
// ယနေ့အဆုံးအထိ သိမ်းမည်
await cacheManager.putUntilEndOfDay(
  key: 'daily_summary',
  value: summaryData,
);

// သတ်မှတ်ထားသော ကုန်ဆုံးချိန်ဖြင့် သိမ်းမည်
await cacheManager.putWithExpirationTime(
  key: 'limited_offer',
  value: offerData,
  expirationTime: DateTime(2024, 12, 31, 23, 59, 59),
);

// ကျန်ရှိသောအချိန်ကို စစ်ဆေးမည်
final remainingTime = await cacheManager.getRemainingTime('limited_offer');
print('ကုန်ဆုံးရန်: ${remainingTime?.inHours} နာရီ');
```

### ၃. Real-time စောင့်ကြည့်မှု

```dart
// Cache အခြေအနေကို စောင့်ကြည့်မည်
final info = await cacheManager.getEntryInfo('important_data');
if (info != null) {
  print('အခြေအနေ: ${info.statusDescription}');
  print('ကျန်ရှိသောအချိန်: ${info.remainingTime}');
  print('Cache အသက်: ${info.age}');
}
```

### ၄. အဆင့်မြင့် Configuration

```dart
final cacheManager = CacheManagerLite(
  config: CacheConfig(
    maxCacheSize: 100 * 1024 * 1024, // 100MB
    defaultPolicy: CachePolicy(
      maxAge: Duration(hours: 2),
      encryptionKey: 'your-secret-key', // ရွေးချယ်နိုင်သော encryption
    ),
  ),
);
```

## 📖 API ကိုးကား

### CacheManagerLite

Cache လုပ်ဆောင်ချက်များအတွက် အဓိကအတန်း။

#### အဓိက Method များ

- `put({required String key, required dynamic value, CachePolicy? policy, Duration? maxAge, DateTime? expiresAt})` - Cache ထဲ ဒေတာသိမ်းမည်
- `get<T>(String key)` - Key အရ cache မှ ဒေတာရယူမည်
- `exists(String key)` - Key ရှိမရှိနှင့် ကုန်ဆုံးခြင်းမရှိကို စစ်ဆေးမည်
- `delete(String key)` - သတ်မှတ်ထားသော entry ကို ဖျက်မည်
- `clear()` - Cache လုပ်ထားသော ဒေတာအားလုံးကို ရှင်းမည်

#### အချိန်အခြေပြု Method များ

- `putWithDuration({required String key, required dynamic value, required Duration duration})` - ကြာချိန်အရ သိမ်းမည်
- `putWithExpirationTime({required String key, required dynamic value, required DateTime expirationTime})` - သတ်မှတ်ထားသောအချိန်အထိ သိမ်းမည်
- `putForMinutes({required String key, required dynamic value, required int minutes})` - X မိနစ်အတွက် သိမ်းမည်
- `putForHours({required String key, required dynamic value, required int hours})` - X နာရီအတွက် သိမ်းမည်
- `putForDays({required String key, required dynamic value, required int days})` - X ရက်အတွက် သိမ်းမည်
- `putUntilEndOfDay({required String key, required dynamic value})` - 23:59:59 အထိ သိမ်းမည်
- `putUntilEndOfWeek({required String key, required dynamic value})` - သီတင်းပတ်အဆုံးအထိ သိမ်းမည်
- `putUntilEndOfMonth({required String key, required dynamic value})` - လအဆုံးအထိ သိမ်းမည်
- `putPermanent({required String key, required dynamic value})` - ကုန်ဆုံးမှုမရှိ သိမ်းမည်

#### စောင့်ကြည့်မှု Method များ

- `getEntryInfo(String key)` - Cache entry ၏ အသေးစိတ်အချက်အလက်ရယူမည်
- `getRemainingTime(String key)` - ကုန်ဆုံးရန် ကျန်ရှိသောအချိန်ရယူမည်
- `extendExpiration({required String key, Duration? additionalTime, DateTime? newExpirationTime})` - ကုန်ဆုံးချိန်ကို တိုးမည်

#### Network Method များ

- `getJson(String url, {CachePolicy? policy})` - URL မှ JSON ကို ရယူပြီး cache လုပ်မည်
- `getBytes(String url, {CachePolicy? policy})` - URL မှ bytes ကို ရယူပြီး cache လုပ်မည်

### CachePolicy Factory Method များ

```dart
// ကြာချိန်အခြေပြု
CachePolicy.duration({required Duration duration, String? encryptionKey})
CachePolicy.inMinutes(int minutes, {String? encryptionKey})
CachePolicy.inHours(int hours, {String? encryptionKey})
CachePolicy.inDays(int days, {String? encryptionKey})

// အချိန်အခြေပြု
CachePolicy.expiresAt({required DateTime expirationTime, String? encryptionKey})
CachePolicy.endOfDay({String? encryptionKey})
CachePolicy.endOfWeek({String? encryptionKey})
CachePolicy.endOfMonth({String? encryptionKey})
CachePolicy.never({String? encryptionKey}) // ကုန်ဆုံးမှုမရှি
```

## 🎨 ဥပမာများ

### ၁. အချိန်အခြေပြု Caching

```dart
// အသုံးပြုသူ session ကို ၂ နာရီအတွက် သိမ်းမည်
await cacheManager.putForHours(
  key: 'user_session',
  value: sessionData,
  hours: 2,
);

// နေ့စဉ်အစီရင်ခံစာကို ယနေ့အဆုံးအထိ သိမ်းမည်
await cacheManager.putUntilEndOfDay(
  key: 'daily_report',
  value: reportData,
);

// သတ်မှတ်ထားသော ကုန်ဆုံးချိန်ဖြင့် သိမ်းမည်
await cacheManager.putWithExpirationTime(
  key: 'limited_offer',
  value: offerData,
  expirationTime: DateTime(2024, 12, 31, 23, 59, 59),
);
```

### ၂. Real-time စောင့်ကြည့်မှု

```dart
// Cache အခြေအနေကို စောင့်ကြည့်မည်
final info = await cacheManager.getEntryInfo('important_data');
if (info != null) {
  print('အခြေအနေ: ${info.statusDescription}');
  print('ကုန်ဆုံးချိန်: ${info.expiresAt}');
  print('ကျန်ရှိသောအချိန်: ${info.remainingTime}');
  print('Cache အသက်: ${info.age}');
}

// ကျန်ရှိသောအချိန်ကို စစ်ဆေးမည်
final remaining = await cacheManager.getRemainingTime('user_session');
if (remaining != null && remaining.inMinutes < 10) {
  // ကုန်ဆုံးချိန်ကို ၁ နာရီ တိုးမည်
  await cacheManager.extendExpiration(
    key: 'user_session',
    additionalTime: Duration(hours: 1),
  );
}
```

### ၃. REST API Caching

```dart
final posts = await cacheManager.getJson(
  'https://jsonplaceholder.typicode.com/posts',
  policy: CachePolicy.inHours(1),
);
```

### ၄. ရုပ်ပုံ Caching

```dart
final imageBytes = await cacheManager.getBytes(
  'https://example.com/image.jpg',
  policy: CachePolicy.inDays(1),
);
```

### ၅. လုံခြုံသော ဒေတာသိမ်းဆည်းမှု

```dart
// အသုံးပြုသူ၏ စွမ်းအင်ဖြင့် ဒေတာသိမ်းမည်
await cacheManager.put(
  key: 'sensitive_data',
  value: userData,
  policy: CachePolicy.inHours(
    6,
    encryptionKey: 'your-secret-key-2024',
  ),
);
```

### ၆. ဂိမ်း Application ဥပမာ

```dart
// ကစားသမား session ၂ နာရီနောက် ကုန်ဆုံးမည်
await cacheManager.putForHours(
  key: 'player_${playerId}',
  value: playerData,
  hours: 2,
);

// နေ့စဉ် ဦးဆောင်မှုစာရင်း ယနေ့အဆုံးတွင် reset လုပ်မည်
await cacheManager.putUntilEndOfDay(
  key: 'daily_leaderboard',
  value: leaderboardData,
);

// ပြိုင်ပွဲဒေတာ သတ်မှတ်ထားသောအချိန်တွင် ကုန်ဆုံးမည်
await cacheManager.putWithExpirationTime(
  key: 'tournament_brackets',
  value: tournamentData,
  expirationTime: DateTime(2024, 6, 15, 18, 0, 0), // 6 PM
);
```

## 📱 Platform ပံ့ပိုးမှု

- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Windows
- ✅ Linux
- ✅ Web

## 📄 လိုင်စင်

MIT လိုင်စင် - အသေးစိတ်အတွက် [LICENSE](../LICENSE) ကို ကြည့်ပါ
