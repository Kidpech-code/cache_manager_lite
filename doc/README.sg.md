# cache_manager_lite

Pengurusan cache prestasi tinggi, mesra pengguna dan selamat untuk Flutter – direka untuk fleksibiliti maksimum dan produktiviti pembangun.

## 🌐 Language / Bahasa

- [🇺🇸 English](../README.md)
- [🇹🇭 ไทย / Thai](README.th.md)
- [🇨🇳 中文 / Chinese](README.cn.md)
- [🇲🇲 မြန်မာ / Myanmar](README.mm.md)
- [🇸🇬 Melayu / Singapore](README.sg.md) (Current)
- [🇱🇦 ລາວ / Lao](README.la.md)

## Ciri-ciri

- ⚡ **Prestasi Tinggi**: Dioptimumkan untuk kelajuan dan kecekapan
- 🧠 **Cache Pintar**: Pengurusan cache pintar dengan pembersihan automatik
- 🔒 **Selamat**: Penyulitan AES pilihan untuk data sensitif
- 📱 **Dioptimumkan Flutter**: Dibina khusus untuk aplikasi Flutter
- 🎯 **Mesra Pengguna**: Berbagai tahap penggunaan untuk kemahiran pembangun yang berbeza
- 🛠️ **Boleh Disesuaikan**: Pilihan konfigurasi yang luas
- 🔧 **Seni Bina Bersih**: Mengikuti prinsip Domain-Driven Design
- 🕒 **Tamat Tempoh Lanjutan**: Tamat tempoh berasaskan masa yang menyeluruh dengan pemasa undur
- ⏰ **Kawalan Masa Fleksibel**: Duration, DateTime, kaedah mudah dan pemantauan masa nyata

## 🛠️ Pemasangan

Tambahkan ini ke fail `pubspec.yaml` pakej anda:

```yaml
dependencies:
  cache_manager_lite: ^0.1.0
```

Kemudian jalankan:

```bash
flutter pub get
```

## 📚 Dokumentasi

- 📖 [Panduan Dokumentasi Lengkap](../DOCUMENTATION_GUIDE.md) - Dokumentasi menyeluruh untuk semua tahap pengguna
- 🎯 [Panduan Tahap Pengguna](../USER_LEVEL_GUIDE.md) - Panduan penggunaan mengikut tahap kemahiran
- 🕒 [Panduan Pengurusan Tamat Tempoh](../EXPIRATION_GUIDE.md) - Panduan pengurusan tamat tempoh lanjutan
- 💡 [Contoh](../example/) - Contoh penggunaan lengkap
- 📝 [Log Perubahan](../CHANGELOG.md) - Sejarah kemaskini

## 🚀 Mula Pantas

### 📱 Langkah 1: Cipta Projek Flutter Baru

```bash
# Cipta projek baru
flutter create my_cache_app
cd my_cache_app
```

### 📦 Langkah 2: Tambah Cache Manager Lite

Edit fail `pubspec.yaml` anda:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cache_manager_lite: ^0.1.0 # Tambah baris ini

dev_dependencies:
  flutter_test:
    sdk: flutter
```

Kemudian jalankan:

```bash
flutter pub get
```

### 🎯 Langkah 3: Penggunaan Asas untuk Pemula

Cipta `lib/main.dart`:

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
  // Mulakan Cache Manager dengan tetapan mesra pemula
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
            // Medan input
            TextField(
              decoration: InputDecoration(
                labelText: 'Masukkan data untuk cache',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _inputText = value;
              },
            ),
            SizedBox(height: 16),

            // Butang simpan data
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Simpan Data (tamat tempoh dalam 1 jam)'),
            ),
            SizedBox(height: 16),

            // Butang muat data
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Muat Data dari Cache'),
            ),
            SizedBox(height: 16),

            // Butang kosongkan data
            ElevatedButton(
              onPressed: _clearData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Kosongkan Semua Data'),
            ),
            SizedBox(height: 24),

            // Papar data cache
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data Cache:',
                       style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(_cachedData.isEmpty ? 'Tiada data' : _cachedData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Simpan data ke cache
  Future<void> _saveData() async {
    if (_inputText.isNotEmpty) {
      // Simpan data dengan tamat tempoh 1 jam
      await cacheManager.putForHours(
        key: 'user_data',
        value: _inputText,
        hours: 1,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data disimpan dengan jayanya!')),
      );
    }
  }

  // Muat data dari cache
  Future<void> _loadData() async {
    final data = await cacheManager.get('user_data');
    setState(() {
      _cachedData = data ?? 'Tiada data ditemui atau data telah tamat tempoh';
    });
  }

  // Kosongkan semua data cache
  Future<void> _clearData() async {
    await cacheManager.clear();
    setState(() {
      _cachedData = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Semua data telah dikosongkan!')),
    );
  }
}
```

### 🏃‍♂️ Langkah 4: Jalankan Aplikasi

```bash
flutter run
```

## 🎯 Hasil Yang Dijangkakan

1. **Medan Input**: Masukkan data untuk cache
2. **Butang Simpan**: Simpan data dengan tamat tempoh 1 jam
3. **Butang Muat**: Dapatkan data cache
4. **Butang Kosong**: Buang semua data cache

## 💡 Petua untuk Pemula

- **Mulakan dengan `.forBeginner()`** - Paling mudah digunakan
- **Gunakan `.putForHours()`** - Tetapan masa tamat tempoh mudah
- **Cuba Custom `AppType`** - Ubah mengikut jenis aplikasi anda
- **Laraskan `CacheSize`** - Tingkatkan saiz cache mengikut keperluan

## 🎯 Penggunaan Lanjutan

### 1. Cache Asas

```dart
import 'package:cache_manager_lite/cache_manager_lite.dart';

// Mulakan pengurusan cache
final cacheManager = CacheManagerLite();

// Simpan data dengan tamat tempoh 1 jam
await cacheManager.putForHours(
  key: 'user_profile',
  value: userProfile,
  hours: 1,
);

// Dapatkan data
final cachedProfile = await cacheManager.get<UserProfile>('user_profile');
```

### 2. Kawalan Tamat Tempoh Lanjutan

```dart
// Simpan sehingga akhir hari
await cacheManager.putUntilEndOfDay(
  key: 'daily_summary',
  value: summaryData,
);

// Simpan dengan masa tamat tempoh khusus
await cacheManager.putWithExpirationTime(
  key: 'limited_offer',
  value: offerData,
  expirationTime: DateTime(2024, 12, 31, 23, 59, 59),
);

// Semak masa yang tinggal
final remainingTime = await cacheManager.getRemainingTime('limited_offer');
print('Tamat tempoh dalam: ${remainingTime?.inHours} jam');
```

### 3. Pemantauan Masa Nyata

```dart
// Pantau status cache
final info = await cacheManager.getEntryInfo('important_data');
if (info != null) {
  print('Status: ${info.statusDescription}');
  print('Masa yang tinggal: ${info.remainingTime}');
  print('Umur cache: ${info.age}');
}
```

### 4. Konfigurasi Lanjutan

```dart
final cacheManager = CacheManagerLite(
  config: CacheConfig(
    maxCacheSize: 100 * 1024 * 1024, // 100MB
    defaultPolicy: CachePolicy(
      maxAge: Duration(hours: 2),
      encryptionKey: 'your-secret-key', // Penyulitan pilihan
    ),
  ),
);
```

## 📖 Rujukan API

### CacheManagerLite

Kelas utama untuk operasi cache.

#### Kaedah Teras

- `put({required String key, required dynamic value, CachePolicy? policy, Duration? maxAge, DateTime? expiresAt})` - Simpan data dalam cache
- `get<T>(String key)` - Dapatkan data dari cache mengikut kunci
- `exists(String key)` - Semak jika kunci wujud dan tidak tamat tempoh
- `delete(String key)` - Buang entri khusus
- `clear()` - Kosongkan semua data cache

#### Kaedah Berasaskan Masa

- `putWithDuration({required String key, required dynamic value, required Duration duration})` - Simpan dengan tempoh
- `putWithExpirationTime({required String key, required dynamic value, required DateTime expirationTime})` - Simpan sehingga masa tertentu
- `putForMinutes({required String key, required dynamic value, required int minutes})` - Simpan untuk X minit
- `putForHours({required String key, required dynamic value, required int hours})` - Simpan untuk X jam
- `putForDays({required String key, required dynamic value, required int days})` - Simpan untuk X hari
- `putUntilEndOfDay({required String key, required dynamic value})` - Simpan sehingga 23:59:59
- `putUntilEndOfWeek({required String key, required dynamic value})` - Simpan sehingga akhir minggu
- `putUntilEndOfMonth({required String key, required dynamic value})` - Simpan sehingga akhir bulan
- `putPermanent({required String key, required dynamic value})` - Simpan tanpa tamat tempoh

#### Kaedah Pemantauan

- `getEntryInfo(String key)` - Dapatkan maklumat terperinci entri cache
- `getRemainingTime(String key)` - Dapatkan masa sehingga tamat tempoh
- `extendExpiration({required String key, Duration? additionalTime, DateTime? newExpirationTime})` - Lanjutkan masa tamat tempoh

#### Kaedah Rangkaian

- `getJson(String url, {CachePolicy? policy})` - Ambil dan cache JSON dari URL
- `getBytes(String url, {CachePolicy? policy})` - Ambil dan cache bytes dari URL

### Kaedah Factory CachePolicy

```dart
// Berasaskan tempoh
CachePolicy.duration({required Duration duration, String? encryptionKey})
CachePolicy.inMinutes(int minutes, {String? encryptionKey})
CachePolicy.inHours(int hours, {String? encryptionKey})
CachePolicy.inDays(int days, {String? encryptionKey})

// Berasaskan masa
CachePolicy.expiresAt({required DateTime expirationTime, String? encryptionKey})
CachePolicy.endOfDay({String? encryptionKey})
CachePolicy.endOfWeek({String? encryptionKey})
CachePolicy.endOfMonth({String? encryptionKey})
CachePolicy.never({String? encryptionKey}) // Tiada tamat tempoh
```

## 🎨 Contoh

### 1. Cache Berasaskan Masa

```dart
// Simpan sesi pengguna untuk 2 jam
await cacheManager.putForHours(
  key: 'user_session',
  value: sessionData,
  hours: 2,
);

// Simpan laporan harian sehingga akhir hari
await cacheManager.putUntilEndOfDay(
  key: 'daily_report',
  value: reportData,
);

// Simpan dengan tamat tempoh khusus
await cacheManager.putWithExpirationTime(
  key: 'limited_offer',
  value: offerData,
  expirationTime: DateTime(2024, 12, 31, 23, 59, 59),
);
```

### 2. Pemantauan Masa Nyata

```dart
// Pantau status cache
final info = await cacheManager.getEntryInfo('important_data');
if (info != null) {
  print('Status: ${info.statusDescription}');
  print('Tamat tempoh pada: ${info.expiresAt}');
  print('Masa yang tinggal: ${info.remainingTime}');
  print('Umur cache: ${info.age}');
}

// Semak masa yang tinggal
final remaining = await cacheManager.getRemainingTime('user_session');
if (remaining != null && remaining.inMinutes < 10) {
  // Lanjutkan tamat tempoh sebanyak 1 jam
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

### 4. Cache Imej

```dart
final imageBytes = await cacheManager.getBytes(
  'https://example.com/image.jpg',
  policy: CachePolicy.inDays(1),
);
```

### 5. Penyimpanan Data Selamat

```dart
// Simpan data tersulit
await cacheManager.put(
  key: 'sensitive_data',
  value: userData,
  policy: CachePolicy.inHours(
    6,
    encryptionKey: 'your-secret-key-2024',
  ),
);
```

### 6. Contoh Aplikasi Gaming

```dart
// Sesi pemain tamat tempoh dalam 2 jam
await cacheManager.putForHours(
  key: 'player_${playerId}',
  value: playerData,
  hours: 2,
);

// Papan pendahulu harian reset pada akhir hari
await cacheManager.putUntilEndOfDay(
  key: 'daily_leaderboard',
  value: leaderboardData,
);

// Data kejohanan tamat tempoh pada masa tertentu
await cacheManager.putWithExpirationTime(
  key: 'tournament_brackets',
  value: tournamentData,
  expirationTime: DateTime(2024, 6, 15, 18, 0, 0), // 6 PM
);
```

## 📱 Sokongan Platform

- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Windows
- ✅ Linux
- ✅ Web

## 📄 Lesen

Lesen MIT - lihat [LICENSE](../LICENSE) untuk butiran
