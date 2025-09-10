# cache_manager_lite

一个高性能、用户友好且安全的 Flutter 缓存管理器 - 专为最大化灵活性和开发人员生产力而设计。

## 🌐 Language / 语言

- [🇺🇸 English](../README.md)
- [🇹🇭 ไทย / Thai](README.th.md)
- [🇨🇳 中文 / Chinese](README.cn.md) (Current)
- [🇲🇲 မြန်မာ / Myanmar](README.mm.md)
- [🇸🇬 Melayu / Singapore](README.sg.md)
- [🇱🇦 ລາວ / Lao](README.la.md)

## 功能特性

- ⚡ **高性能**: 针对速度和效率进行优化
- 🧠 **智能缓存**: 智能缓存管理，自动清理
- 🔒 **安全**: 敏感数据的可选 AES 加密
- 📱 **Flutter 优化**: 专为 Flutter 应用程序构建
- 🎯 **用户友好**: 针对不同开发人员技能的多种使用级别
- 🛠️ **可定制**: 丰富的配置选项
- 🔧 **清洁架构**: 遵循领域驱动设计原则
- 🕒 **高级过期**: 全面的基于时间的过期机制和倒计时器
- ⏰ **灵活的时间控制**: Duration、DateTime、便捷方法和实时监控

## 🛠️ 安装

将以下内容添加到您的 `pubspec.yaml` 文件中：

```yaml
dependencies:
  cache_manager_lite: ^0.1.1
```

然后运行：

```bash
flutter pub get
```

## 📚 文档

- 📖 [完整文档指南](../DOCUMENTATION_GUIDE.md) - 所有用户级别的综合文档
- 🎯 [用户级别指南](../USER_LEVEL_GUIDE.md) - 按技能级别的使用指南
- 🕒 [过期管理指南](../EXPIRATION_GUIDE.md) - 高级过期管理指南
- 💡 [示例](../example/) - 完整使用示例
- 📝 [更新日志](../CHANGELOG.md) - 更新历史

## 🚀 快速开始

### 📱 步骤 1: 创建新的 Flutter 项目

```bash
# 创建新项目
flutter create my_cache_app
cd my_cache_app
```

### 📦 步骤 2: 添加 Cache Manager Lite

编辑您的 `pubspec.yaml` 文件：

```yaml
dependencies:
  flutter:
    sdk: flutter
  cache_manager_lite: ^0.1.1 # 添加此行

dev_dependencies:
  flutter_test:
    sdk: flutter
```

然后运行：

```bash
flutter pub get
```

### 🎯 步骤 3: 初学者基本用法

创建 `lib/main.dart`：

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
  // 使用初学者友好的设置初始化 Cache Manager
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
            // 输入字段
            TextField(
              decoration: InputDecoration(
                labelText: '输入要缓存的数据',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _inputText = value;
              },
            ),
            SizedBox(height: 16),

            // 保存数据按钮
            ElevatedButton(
              onPressed: _saveData,
              child: Text('保存数据 (1小时后过期)'),
            ),
            SizedBox(height: 16),

            // 加载数据按钮
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('从缓存加载数据'),
            ),
            SizedBox(height: 16),

            // 清除数据按钮
            ElevatedButton(
              onPressed: _clearData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('清除所有数据'),
            ),
            SizedBox(height: 24),

            // 显示缓存数据
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('缓存数据：',
                       style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(_cachedData.isEmpty ? '无数据' : _cachedData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 将数据保存到缓存
  Future<void> _saveData() async {
    if (_inputText.isNotEmpty) {
      // 保存数据，1小时后过期
      await cacheManager.putForHours(
        key: 'user_data',
        value: _inputText,
        hours: 1,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('数据保存成功！')),
      );
    }
  }

  // 从缓存加载数据
  Future<void> _loadData() async {
    final data = await cacheManager.get('user_data');
    setState(() {
      _cachedData = data ?? '未找到数据或数据已过期';
    });
  }

  // 清除所有缓存数据
  Future<void> _clearData() async {
    await cacheManager.clear();
    setState(() {
      _cachedData = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('所有数据已清除！')),
    );
  }
}
```

### 🏃‍♂️ 步骤 4: 运行应用程序

```bash
flutter run
```

## 🎯 预期结果

1. **输入字段**: 输入要缓存的数据
2. **保存按钮**: 存储数据，1 小时后过期
3. **加载按钮**: 检索缓存的数据
4. **清除按钮**: 删除所有缓存的数据

## 💡 初学者提示

- **从 `.forBeginner()` 开始** - 最易于使用
- **使用 `.putForHours()`** - 简单的过期时间设置
- **尝试自定义 `AppType`** - 根据您的应用类型更改
- **调整 `CacheSize`** - 根据需要增加缓存大小

## 🎯 高级用法

### 1. 基本缓存

```dart
import 'package:cache_manager_lite/cache_manager_lite.dart';

// 初始化缓存管理器
final cacheManager = CacheManagerLite();

// 存储数据，1小时后过期
await cacheManager.putForHours(
  key: 'user_profile',
  value: userProfile,
  hours: 1,
);

// 检索数据
final cachedProfile = await cacheManager.get<UserProfile>('user_profile');
```

### 2. 高级过期控制

```dart
// 存储到当天结束
await cacheManager.putUntilEndOfDay(
  key: 'daily_summary',
  value: summaryData,
);

// 使用特定过期时间存储
await cacheManager.putWithExpirationTime(
  key: 'limited_offer',
  value: offerData,
  expirationTime: DateTime(2024, 12, 31, 23, 59, 59),
);

// 检查剩余时间
final remainingTime = await cacheManager.getRemainingTime('limited_offer');
print('过期时间：${remainingTime?.inHours} 小时');
```

### 3. 实时监控

```dart
// 监控缓存状态
final info = await cacheManager.getEntryInfo('important_data');
if (info != null) {
  print('状态：${info.statusDescription}');
  print('剩余时间：${info.remainingTime}');
  print('缓存年龄：${info.age}');
}
```

### 4. 高级配置

```dart
final cacheManager = CacheManagerLite(
  config: CacheConfig(
    maxCacheSize: 100 * 1024 * 1024, // 100MB
    defaultPolicy: CachePolicy(
      maxAge: Duration(hours: 2),
      encryptionKey: 'your-secret-key', // 可选加密
    ),
  ),
);
```

## 📖 API 参考

### CacheManagerLite

缓存操作的主要类。

#### 核心方法

- `put({required String key, required dynamic value, CachePolicy? policy, Duration? maxAge, DateTime? expiresAt})` - 在缓存中存储数据
- `get<T>(String key)` - 通过键从缓存中检索数据
- `exists(String key)` - 检查键是否存在且未过期
- `delete(String key)` - 删除特定条目
- `clear()` - 清除所有缓存数据

#### 基于时间的方法

- `putWithDuration({required String key, required dynamic value, required Duration duration})` - 按持续时间存储
- `putWithExpirationTime({required String key, required dynamic value, required DateTime expirationTime})` - 存储到特定时间
- `putForMinutes({required String key, required dynamic value, required int minutes})` - 存储 X 分钟
- `putForHours({required String key, required dynamic value, required int hours})` - 存储 X 小时
- `putForDays({required String key, required dynamic value, required int days})` - 存储 X 天
- `putUntilEndOfDay({required String key, required dynamic value})` - 存储到 23:59:59
- `putUntilEndOfWeek({required String key, required dynamic value})` - 存储到周末
- `putUntilEndOfMonth({required String key, required dynamic value})` - 存储到月末
- `putPermanent({required String key, required dynamic value})` - 无过期存储

#### 监控方法

- `getEntryInfo(String key)` - 获取详细的缓存条目信息
- `getRemainingTime(String key)` - 获取到过期的时间
- `extendExpiration({required String key, Duration? additionalTime, DateTime? newExpirationTime})` - 延长过期时间

#### 网络方法

- `getJson(String url, {CachePolicy? policy})` - 从 URL 获取和缓存 JSON
- `getBytes(String url, {CachePolicy? policy})` - 从 URL 获取和缓存字节

### CachePolicy 工厂方法

```dart
// 基于持续时间
CachePolicy.duration({required Duration duration, String? encryptionKey})
CachePolicy.inMinutes(int minutes, {String? encryptionKey})
CachePolicy.inHours(int hours, {String? encryptionKey})
CachePolicy.inDays(int days, {String? encryptionKey})

// 基于时间
CachePolicy.expiresAt({required DateTime expirationTime, String? encryptionKey})
CachePolicy.endOfDay({String? encryptionKey})
CachePolicy.endOfWeek({String? encryptionKey})
CachePolicy.endOfMonth({String? encryptionKey})
CachePolicy.never({String? encryptionKey}) // 无过期
```

## 🎨 示例

### 1. 基于时间的缓存

```dart
// 存储用户会话2小时
await cacheManager.putForHours(
  key: 'user_session',
  value: sessionData,
  hours: 2,
);

// 存储每日报告到当天结束
await cacheManager.putUntilEndOfDay(
  key: 'daily_report',
  value: reportData,
);

// 使用特定过期时间存储
await cacheManager.putWithExpirationTime(
  key: 'limited_offer',
  value: offerData,
  expirationTime: DateTime(2024, 12, 31, 23, 59, 59),
);
```

### 2. 实时监控

```dart
// 监控缓存状态
final info = await cacheManager.getEntryInfo('important_data');
if (info != null) {
  print('状态：${info.statusDescription}');
  print('过期时间：${info.expiresAt}');
  print('剩余时间：${info.remainingTime}');
  print('缓存年龄：${info.age}');
}

// 检查剩余时间
final remaining = await cacheManager.getRemainingTime('user_session');
if (remaining != null && remaining.inMinutes < 10) {
  // 延长过期时间1小时
  await cacheManager.extendExpiration(
    key: 'user_session',
    additionalTime: Duration(hours: 1),
  );
}
```

### 3. REST API 缓存

```dart
final posts = await cacheManager.getJson(
  'https://jsonplaceholder.typicode.com/posts',
  policy: CachePolicy.inHours(1),
);
```

### 4. 图像缓存

```dart
final imageBytes = await cacheManager.getBytes(
  'https://example.com/image.jpg',
  policy: CachePolicy.inDays(1),
);
```

### 5. 安全数据存储

```dart
// 存储加密数据
await cacheManager.put(
  key: 'sensitive_data',
  value: userData,
  policy: CachePolicy.inHours(
    6,
    encryptionKey: 'your-secret-key-2024',
  ),
);
```

### 6. 游戏应用示例

```dart
// 玩家会话2小时后过期
await cacheManager.putForHours(
  key: 'player_${playerId}',
  value: playerData,
  hours: 2,
);

// 每日排行榜在当天结束时重置
await cacheManager.putUntilEndOfDay(
  key: 'daily_leaderboard',
  value: leaderboardData,
);

// 锦标赛数据在特定时间过期
await cacheManager.putWithExpirationTime(
  key: 'tournament_brackets',
  value: tournamentData,
  expirationTime: DateTime(2024, 6, 15, 18, 0, 0), // 6 PM
);
```

## 📱 平台支持

- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Windows
- ✅ Linux
- ✅ Web

## 📄 许可证

MIT 许可证 - 详见 [LICENSE](../LICENSE)
