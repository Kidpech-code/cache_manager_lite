# cache_manager_lite

A high-performance, user-friendly, and secure cache manager for Flutter – designed for maximum flexibility and developer productivity.

## 🌐 Language / ภาษา

- [🇺🇸 English](README.md) (Current)
- [🇹🇭 ไทย / Thai](doc/README.th.md)
- [🇨🇳 中文 / Chinese](doc/README.cn.md)
- [🇲🇲 မြန်မာ / Myanmar](doc/README.mm.md)
- [🇸🇬 Melayu / Singapore](doc/README.sg.md)
- [🇱🇦 ລາວ / Lao](doc/README.la.md)

## Features

- ⚡ **High Performance**: Optimized for speed and efficiency
- 🧠 **Smart Caching**: Intelligent cache management with automatic cleanup
- 🔒 **Secure**: Optional AES encryption for sensitive data
- 📱 **Flutter Optimized**: Built specifically for Flutter applications
- 🎯 **User-Friendly**: Multiple usage levels for different developer skills
- 🛠️ **Customizable**: Extensive configuration options
- 🔧 **Clean Architecture**: Follows Domain-Driven Design principles
- 🕒 **Advanced Expiration**: Comprehensive time-based expiration with countdown timers
- ⏰ **Flexible Time Control**: Duration, DateTime, convenience methods, and real-time monitoring

## 🛠️ Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  cache_manager_lite: ^0.1.1
```

Then run:

```bash
flutter pub get
```

## 📚 Documentation

- 📖 [Complete Documentation Guide](DOCUMENTATION_GUIDE.md) - Comprehensive documentation for all user levels
- 🎯 [User Level Guide](USER_LEVEL_GUIDE.md) - Usage guide by skill level
- 🕒 [Expiration Management Guide](EXPIRATION_GUIDE.md) - Advanced expiration management guide
- 💡 [Examples](example/) - Complete usage examples
- 📝 [Changelog](CHANGELOG.md) - Update history

## 🚀 Quick Start

### 📱 Step 1: Create a New Flutter Project

```bash
# Create new project
flutter create my_cache_app
cd my_cache_app
```

### 📦 Step 2: Add Cache Manager Lite

Edit your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cache_manager_lite: ^0.1.1 # Add this line

dev_dependencies:
  flutter_test:
    sdk: flutter
```

Then run:

```bash
flutter pub get
```

### 🎯 Step 3: Basic Usage for Beginners

Create `lib/main.dart`:

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
  // Initialize Cache Manager with beginner-friendly setup
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
                labelText: 'Enter data to cache',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _inputText = value;
              },
            ),
            SizedBox(height: 16),

            // Save data button
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Save Data (expires in 1 hour)'),
            ),
            SizedBox(height: 16),

            // Load data button
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Load Data from Cache'),
            ),
            SizedBox(height: 16),

            // Clear data button
            ElevatedButton(
              onPressed: _clearData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Clear All Data'),
            ),
            SizedBox(height: 24),

            // Display cached data
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cached Data:',
                       style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(_cachedData.isEmpty ? 'No data' : _cachedData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Save data to cache
  Future<void> _saveData() async {
    if (_inputText.isNotEmpty) {
      // Save data with 1-hour expiration
      await cacheManager.putForHours(
        key: 'user_data',
        value: _inputText,
        hours: 1,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data saved successfully!')),
      );
    }
  }

  // Load data from cache
  Future<void> _loadData() async {
    final data = await cacheManager.get('user_data');
    setState(() {
      _cachedData = data ?? 'No data found or data expired';
    });
  }

  // Clear all cached data
  Future<void> _clearData() async {
    await cacheManager.clear();
    setState(() {
      _cachedData = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All data cleared!')),
    );
  }
}
```

### 🏃‍♂️ Step 4: Run the Application

```bash
flutter run
```

## 🎯 Expected Results

1. **Input Field**: Enter data to cache
2. **Save Button**: Store data with 1-hour expiration
3. **Load Button**: Retrieve cached data
4. **Clear Button**: Remove all cached data

## 💡 Tips for Beginners

- **Start with `.forBeginner()`** - Easiest to use
- **Use `.putForHours()`** - Simple expiration time setup
- **Try Custom `AppType`** - Change according to your app type
- **Adjust `CacheSize`** - Increase cache size as needed

## 🎯 Advanced Usage

### 1. Basic Caching

```dart
import 'package:cache_manager_lite/cache_manager_lite.dart';

// Initialize cache manager
final cacheManager = CacheManagerLite();

// Store data with 1-hour expiration
await cacheManager.putForHours(
  key: 'user_profile',
  value: userProfile,
  hours: 1,
);

// Retrieve data
final cachedProfile = await cacheManager.get<UserProfile>('user_profile');
```

### 2. Advanced Expiration Control

```dart
// Store until end of day
await cacheManager.putUntilEndOfDay(
  key: 'daily_summary',
  value: summaryData,
);

// Store with specific expiration time
await cacheManager.putWithExpirationTime(
  key: 'limited_offer',
  value: offerData,
  expirationTime: DateTime(2024, 12, 31, 23, 59, 59),
);

// Check remaining time
final remainingTime = await cacheManager.getRemainingTime('limited_offer');
print('Expires in: ${remainingTime?.inHours} hours');
```

### 3. Real-time Monitoring

```dart
// Monitor cache status
final info = await cacheManager.getEntryInfo('important_data');
if (info != null) {
  print('Status: ${info.statusDescription}');
  print('Time remaining: ${info.remainingTime}');
  print('Cache age: ${info.age}');
}
```

### 4. Advanced Configuration

```dart
final cacheManager = CacheManagerLite(
  config: CacheConfig(
    maxCacheSize: 100 * 1024 * 1024, // 100MB
    defaultPolicy: CachePolicy(
      maxAge: Duration(hours: 2),
      encryptionKey: 'your-secret-key', // Optional encryption
    ),
  ),
);
```

## 📖 API Reference

### CacheManagerLite

The main class for cache operations.

#### Core Methods

- `put({required String key, required dynamic value, CachePolicy? policy, Duration? maxAge, DateTime? expiresAt})` - Stores data in cache
- `get<T>(String key)` - Retrieves data from cache by key
- `exists(String key)` - Checks if key exists and is not expired
- `delete(String key)` - Removes specific entry
- `clear()` - Clears all cached data

#### Time-Based Methods

- `putWithDuration({required String key, required dynamic value, required Duration duration})` - Store with duration
- `putWithExpirationTime({required String key, required dynamic value, required DateTime expirationTime})` - Store until specific time
- `putForMinutes({required String key, required dynamic value, required int minutes})` - Store for X minutes
- `putForHours({required String key, required dynamic value, required int hours})` - Store for X hours
- `putForDays({required String key, required dynamic value, required int days})` - Store for X days
- `putUntilEndOfDay({required String key, required dynamic value})` - Store until 23:59:59
- `putUntilEndOfWeek({required String key, required dynamic value})` - Store until end of week
- `putUntilEndOfMonth({required String key, required dynamic value})` - Store until end of month
- `putPermanent({required String key, required dynamic value})` - Store without expiration

#### Monitoring Methods

- `getEntryInfo(String key)` - Get detailed cache entry information
- `getRemainingTime(String key)` - Get time until expiration
- `extendExpiration({required String key, Duration? additionalTime, DateTime? newExpirationTime})` - Extend expiration time

#### Network Methods

- `getJson(String url, {CachePolicy? policy})` - Fetches and caches JSON from URL
- `getBytes(String url, {CachePolicy? policy})` - Fetches and caches bytes from URL

### CachePolicy Factory Methods

```dart
// Duration-based
CachePolicy.duration({required Duration duration, String? encryptionKey})
CachePolicy.inMinutes(int minutes, {String? encryptionKey})
CachePolicy.inHours(int hours, {String? encryptionKey})
CachePolicy.inDays(int days, {String? encryptionKey})

// Time-based
CachePolicy.expiresAt({required DateTime expirationTime, String? encryptionKey})
CachePolicy.endOfDay({String? encryptionKey})
CachePolicy.endOfWeek({String? encryptionKey})
CachePolicy.endOfMonth({String? encryptionKey})
CachePolicy.never({String? encryptionKey}) // No expiration
```

## 🎨 Examples

### 1. Time-Based Caching

```dart
// Store user session for 2 hours
await cacheManager.putForHours(
  key: 'user_session',
  value: sessionData,
  hours: 2,
);

// Store daily report until end of day
await cacheManager.putUntilEndOfDay(
  key: 'daily_report',
  value: reportData,
);

// Store with specific expiration
await cacheManager.putWithExpirationTime(
  key: 'limited_offer',
  value: offerData,
  expirationTime: DateTime(2024, 12, 31, 23, 59, 59),
);
```

### 2. Real-time Monitoring

```dart
// Monitor cache status
final info = await cacheManager.getEntryInfo('important_data');
if (info != null) {
  print('Status: ${info.statusDescription}');
  print('Expires at: ${info.expiresAt}');
  print('Time remaining: ${info.remainingTime}');
  print('Cache age: ${info.age}');
}

// Check remaining time
final remaining = await cacheManager.getRemainingTime('user_session');
if (remaining != null && remaining.inMinutes < 10) {
  // Extend expiration by 1 hour
  await cacheManager.extendExpiration(
    key: 'user_session',
    additionalTime: Duration(hours: 1),
  );
}
```

### 3. REST API Caching

```dart
final posts = await cacheManager.getJson(
  'https://jsonplaceholder.typicode.com/posts',
  policy: CachePolicy.inHours(1),
);
```

### 4. Image Caching

```dart
final imageBytes = await cacheManager.getBytes(
  'https://example.com/image.jpg',
  policy: CachePolicy.inDays(1),
);
```

### 5. Secure Data Storage

```dart
// Store encrypted data
await cacheManager.put(
  key: 'sensitive_data',
  value: userData,
  policy: CachePolicy.inHours(
    6,
    encryptionKey: 'your-secret-key-2024',
  ),
);
```

### 6. Gaming Application Example

```dart
// Player session expires in 2 hours
await cacheManager.putForHours(
  key: 'player_${playerId}',
  value: playerData,
  hours: 2,
);

// Daily leaderboard resets at end of day
await cacheManager.putUntilEndOfDay(
  key: 'daily_leaderboard',
  value: leaderboardData,
);

// Tournament data expires at specific time
await cacheManager.putWithExpirationTime(
  key: 'tournament_brackets',
  value: tournamentData,
  expirationTime: DateTime(2024, 6, 15, 18, 0, 0), // 6 PM
);
```

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Windows
- ✅ Linux
- ✅ Web

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.
