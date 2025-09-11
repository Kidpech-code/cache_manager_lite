# Custom Object Caching Guide

**CacheManagerLite** รองรับการเก็บ custom objects ได้อย่างสมบูรณ์ โดยใช้ pattern `toJson()` และ `fromJson()`

## 🎯 การรองรับ Custom Objects

### ✅ ประเภทข้อมูลที่รองรับ:

- **Primitive types**: `String`, `int`, `double`, `bool`
- **Collections**: `List<T>`, `Map<String, dynamic>`
- **Custom objects**: ผ่าน `toJson()` serialization
- **Nested objects**: objects ที่มี objects อื่นข้างใน
- **Complex structures**: List of objects, Map of objects

### 🔧 วิธีการใช้งาน

#### 1. สร้าง Model Class พร้อม Serialization

```dart
class User {
  final String id;
  final String name;
  final String email;
  final int age;
  final List<String> hobbies;
  final Address address; // Nested object

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.hobbies,
    required this.address,
  });

  /// Convert object to Map for caching
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'hobbies': hobbies,
      'address': address.toJson(), // Serialize nested object
    };
  }

  /// Create object from cached Map
  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
      hobbies: List<String>.from(json['hobbies']),
      address: Address.fromJson(json['address']), // Deserialize nested object
    );
  }
}

class Address {
  final String street;
  final String city;
  final String country;

  Address({required this.street, required this.city, required this.country});

  Map<String, dynamic> toJson() {
    return {'street': street, 'city': city, 'country': country};
  }

  static Address fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      country: json['country'],
    );
  }
}
```

#### 2. Cache Custom Objects

```dart
final cacheManager = CacheManagerLite.forIntermediate();

// สร้าง custom object
final user = User(
  id: 'user_123',
  name: 'John Doe',
  email: 'john@example.com',
  age: 28,
  hobbies: ['Photography', 'Travel'],
  address: Address(
    street: '123 Main St',
    city: 'Bangkok',
    country: 'Thailand',
  ),
);

// Cache object โดย convert เป็น Map ก่อน
await cacheManager.putForHours(
  key: 'user_profile',
  value: user.toJson(), // ใช้ toJson() method
  hours: 2,
  encryptionKey: 'user-encryption-key', // Optional encryption
);
```

#### 3. Retrieve Custom Objects

```dart
// ดึง object กลับมา
final userMap = await cacheManager.get<Map<String, dynamic>>('user_profile');

if (userMap != null) {
  // Convert Map กลับเป็น object
  final user = User.fromJson(userMap);
  print('Welcome back, ${user.name}!');
}
```

#### 4. Cache Collections of Custom Objects

```dart
// Cache list of objects
final users = [user1, user2, user3];
final userMaps = users.map((user) => user.toJson()).toList();

await cacheManager.putForDays(
  key: 'user_list',
  value: userMaps, // List<Map<String, dynamic>>
  days: 1,
);

// Retrieve list of objects
final cachedMaps = await cacheManager.get<List<dynamic>>('user_list');
if (cachedMaps != null) {
  final users = cachedMaps
      .cast<Map<String, dynamic>>()
      .map((map) => User.fromJson(map))
      .toList();
}
```

## 🏗️ Advanced Patterns

### 1. Generic Serialization Helper

```dart
class CacheHelper {
  static Future<void> cacheObject<T>({
    required CacheManagerLite cacheManager,
    required String key,
    required T object,
    required Map<String, dynamic> Function(T) toJson,
    Duration? duration,
    String? encryptionKey,
  }) async {
    await cacheManager.put(
      key: key,
      value: toJson(object),
      maxAge: duration,
      encryptionKey: encryptionKey,
    );
  }

  static Future<T?> retrieveObject<T>({
    required CacheManagerLite cacheManager,
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final map = await cacheManager.get<Map<String, dynamic>>(key);
    return map != null ? fromJson(map) : null;
  }
}

// การใช้งาน
await CacheHelper.cacheObject(
  cacheManager: cacheManager,
  key: 'user_profile',
  object: user,
  toJson: (user) => user.toJson(),
  duration: Duration(hours: 2),
);

final user = await CacheHelper.retrieveObject(
  cacheManager: cacheManager,
  key: 'user_profile',
  fromJson: User.fromJson,
);
```

### 2. Mixin for Cacheable Objects

```dart
mixin Cacheable<T> {
  Map<String, dynamic> toJson();

  Future<void> cache({
    required CacheManagerLite cacheManager,
    required String key,
    Duration? duration,
    String? encryptionKey,
  }) async {
    await cacheManager.put(
      key: key,
      value: toJson(),
      maxAge: duration,
      encryptionKey: encryptionKey,
    );
  }
}

class User with Cacheable<User> {
  // ... existing code ...

  @override
  Map<String, dynamic> toJson() {
    // ... serialization logic ...
  }
}

// การใช้งาน
await user.cache(
  cacheManager: cacheManager,
  key: 'user_profile',
  duration: Duration(hours: 2),
);
```

### 3. Repository Pattern

```dart
class UserRepository {
  final CacheManagerLite _cacheManager;

  UserRepository(this._cacheManager);

  Future<void> saveUser(User user) async {
    await _cacheManager.putForHours(
      key: 'user_${user.id}',
      value: user.toJson(),
      hours: 24,
      encryptionKey: 'user-repo-key',
    );
  }

  Future<User?> getUser(String userId) async {
    final userMap = await _cacheManager.get<Map<String, dynamic>>('user_$userId');
    return userMap != null ? User.fromJson(userMap) : null;
  }

  Future<List<User>> getAllUsers() async {
    final userMaps = await _cacheManager.get<List<dynamic>>('all_users');
    if (userMaps != null) {
      return userMaps
          .cast<Map<String, dynamic>>()
          .map((map) => User.fromJson(map))
          .toList();
    }
    return [];
  }
}
```

## 💡 Best Practices

### 1. การจัดการ DateTime

```dart
class Event {
  final DateTime startTime;
  final DateTime endTime;

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(), // Convert to String
      'endTime': endTime.toIso8601String(),
    };
  }

  static Event fromJson(Map<String, dynamic> json) {
    return Event(
      startTime: DateTime.parse(json['startTime']), // Parse from String
      endTime: DateTime.parse(json['endTime']),
    );
  }
}
```

### 2. การจัดการ Enums

```dart
enum UserRole { admin, user, guest }

class User {
  final UserRole role;

  Map<String, dynamic> toJson() {
    return {
      'role': role.name, // Convert enum to String
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.guest,
      ),
    );
  }
}
```

### 3. การจัดการ Null Safety

```dart
class OptionalData {
  final String? optionalField;
  final List<String>? optionalList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (optionalField != null) map['optionalField'] = optionalField;
    if (optionalList != null) map['optionalList'] = optionalList;
    return map;
  }

  static OptionalData fromJson(Map<String, dynamic> json) {
    return OptionalData(
      optionalField: json['optionalField'],
      optionalList: json['optionalList']?.cast<String>(),
    );
  }
}
```

### 4. Version Management

```dart
class VersionedData {
  final int version;
  final Map<String, dynamic> data;

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'data': data,
    };
  }

  static VersionedData fromJson(Map<String, dynamic> json) {
    final version = json['version'] ?? 1;

    // Handle version migration
    if (version < 2) {
      // Migrate old data format
      return migrateFromV1(json);
    }

    return VersionedData(
      version: version,
      data: json['data'],
    );
  }

  static VersionedData migrateFromV1(Map<String, dynamic> json) {
    // Migration logic here
    return VersionedData(version: 2, data: json);
  }
}
```

## 🔧 Troubleshooting

### ปัญหาที่พบบ่อย:

1. **Type casting errors**: ใช้ `.cast<Type>()` สำหรับ Lists และ Maps
2. **Null values**: จัดการ null safety อย่างถูกต้อง
3. **Nested objects**: ตรวจสอบว่า nested objects มี toJson/fromJson
4. **DateTime serialization**: ใช้ ISO8601 string format
5. **Enum serialization**: ใช้ enum.name และ handle fallback

### Performance Tips:

1. **ใช้ Type parameters**: `get<Map<String, dynamic>>()`
2. **Cache validation**: ตรวจสอบ null ก่อนใช้งาน
3. **Batch operations**: cache หลาย objects พร้อมกัน
4. **Encryption**: ใช้เฉพาะข้อมูลที่จำเป็น

## 📖 ตัวอย่างสมบูรณ์

ดูตัวอย่างการใช้งานครบถ้วนใน:

- `example/lib/custom_object_example.dart`
- `example/lib/auth_example.dart`
- `example/lib/data_security_example.dart`

**CacheManagerLite รองรับ custom objects อย่างสมบูรณ์** ผ่าน standard JSON serialization pattern ที่ใช้กันทั่วไปใน Flutter/Dart ecosystem! 🚀
