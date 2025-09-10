# 🚀 คู่มือเริ่มต้นใช้งาน Cache Manager Lite

## 📋 สารบัญ

1. [การสร้างโปรเจคใหม่](#-step-1-การสร้างโปรเจคใหม่)
2. [การติดตั้ง Package](#-step-2-การติดตั้ง-package)
3. [ตัวอย่างพื้นฐาน](#-step-3-ตัวอย่างพื้นฐาน)
4. [ตัวอย่าง Custom ง่ายๆ](#-step-4-ตัวอย่าง-custom-งายๆ)
5. [เทคนิคการใช้งาน](#-step-5-เทคนิคการใช้งาน)

---

## 🛠️ Step 1: การสร้างโปรเจคใหม่

### วิธีที่ 1: ใช้ Command Line

```bash
# สร้างโปรเจค Flutter ใหม่
flutter create my_cache_app

# เข้าไปในโฟลเดอร์โปรเจค
cd my_cache_app

# เปิดด้วย VS Code (ถ้ามี)
code .
```

### วิธีที่ 2: ใช้ IDE

**Android Studio:**

1. File → New → New Flutter Project
2. เลือก Flutter Application
3. ตั้งชื่อโปรเจค: `my_cache_app`
4. กด Create

**VS Code:**

1. Ctrl+Shift+P (หรือ Cmd+Shift+P บน Mac)
2. พิมพ์: "Flutter: New Project"
3. เลือก Application
4. ตั้งชื่อโปรเจค: `my_cache_app`

---

## 📦 Step 2: การติดตั้ง Package

### เปิดไฟล์ `pubspec.yaml`

```yaml
name: my_cache_app
description: A new Flutter project.

version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  # เพิ่มบรรทัดนี้
  cache_manager_lite: ^0.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```

### รันคำสั่งติดตั้ง

```bash
flutter pub get
```

### ตรวจสอบการติดตั้ง

```bash
flutter pub deps
```

หากติดตั้งสำเร็จ จะเห็น `cache_manager_lite` ในรายการ dependencies

---

## 🎯 Step 3: ตัวอย่างพื้นฐาน

### สร้างไฟล์ `lib/main.dart`

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
      home: BasicCacheDemo(),
    );
  }
}

class BasicCacheDemo extends StatefulWidget {
  @override
  _BasicCacheDemoState createState() => _BasicCacheDemoState();
}

class _BasicCacheDemoState extends State<BasicCacheDemo> {
  // 🎯 สร้าง Cache Manager แบบง่ายสุด
  final cacheManager = CacheManagerLite.forBeginner();

  String _cachedData = '';
  final TextEditingController _controller = TextEditingController();

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
            // 📝 ช่องป้อนข้อมูล
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'ป้อนข้อมูลที่ต้องการแคช',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.edit),
              ),
            ),
            SizedBox(height: 20),

            // 💾 ปุ่มบันทึก
            ElevatedButton.icon(
              onPressed: _saveData,
              icon: Icon(Icons.save),
              label: Text('บันทึกข้อมูล (1 ชั่วโมง)'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
                backgroundColor: Colors.blue,
              ),
            ),
            SizedBox(height: 12),

            // 📂 ปุ่มดึงข้อมูล
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: Icon(Icons.folder_open),
              label: Text('ดึงข้อมูลจากแคช'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
                backgroundColor: Colors.green,
              ),
            ),
            SizedBox(height: 12),

            // 🗑️ ปุ่มล้างข้อมูล
            ElevatedButton.icon(
              onPressed: _clearData,
              icon: Icon(Icons.delete),
              label: Text('ล้างข้อมูลทั้งหมด'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
                backgroundColor: Colors.red,
              ),
            ),
            SizedBox(height: 24),

            // 📄 แสดงผลข้อมูล
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.storage, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'ข้อมูลจากแคช:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _cachedData.isEmpty ? 'ไม่มีข้อมูล' : _cachedData,
                      style: TextStyle(
                        fontSize: 14,
                        color: _cachedData.isEmpty ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 💾 บันทึกข้อมูลลงแคช
  Future<void> _saveData() async {
    final inputText = _controller.text.trim();

    if (inputText.isNotEmpty) {
      // บันทึกข้อมูลโดยหมดอายุใน 1 ชั่วโมง
      await cacheManager.putForHours(
        key: 'user_data',
        value: inputText,
        hours: 1,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('บันทึกข้อมูลสำเร็จ! (หมดอายุใน 1 ชั่วโมง)'),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('กรุณาป้อนข้อมูลก่อนบันทึก'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // 📂 ดึงข้อมูลจากแคช
  Future<void> _loadData() async {
    final data = await cacheManager.get('user_data');
    setState(() {
      _cachedData = data ?? 'ไม่พบข้อมูลหรือข้อมูลหมดอายุแล้ว';
    });
  }

  // 🗑️ ล้างข้อมูลทั้งหมด
  Future<void> _clearData() async {
    await cacheManager.clear();
    setState(() {
      _cachedData = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.delete_sweep, color: Colors.white),
            SizedBox(width: 8),
            Text('ล้างข้อมูลทั้งหมดแล้ว!'),
          ],
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

### รันแอป

```bash
flutter run
```

---

## 🎨 Step 4: ตัวอย่าง Custom ง่ายๆ

### สร้างไฟล์ `lib/todo_app.dart`

```dart
import 'package:flutter/material.dart';
import 'package:cache_manager_lite/cache_manager_lite.dart';

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  // 🎯 Cache Manager แบบ Custom ง่ายๆ
  final cacheManager = CacheManagerLite.forBeginner(
    appType: AppType.social,        // เหมาะสำหรับแอป Social
    cacheSize: CacheSize.medium,    // ขนาดแคชกลาง (25-50MB)
  );

  List<String> _todoList = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodoList(); // โหลดข้อมูลเมื่อเริ่มแอป
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App with Cache'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: _showInfo,
          ),
        ],
      ),
      body: Column(
        children: [
          // 📝 ส่วนเพิ่มรายการใหม่
          _buildAddTodoSection(),

          // 🎛️ ปุ่มควบคุม
          _buildControlButtons(),

          // 📊 แสดงสถิติ
          _buildStatsSection(),

          // 📋 รายการ Todo
          Expanded(
            child: _buildTodoList(),
          ),
        ],
      ),
    );
  }

  // 📝 ส่วนเพิ่มรายการ
  Widget _buildAddTodoSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'เพิ่มรายการใหม่...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.add_task),
              ),
              onSubmitted: (_) => _addTodo(),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: _addTodo,
            child: Text('เพิ่ม'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  // 🎛️ ปุ่มควบคุม
  Widget _buildControlButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _saveTodoList,
              icon: Icon(Icons.save),
              label: Text('บันทึก'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _clearAll,
              icon: Icon(Icons.delete_sweep),
              label: Text('ล้างทั้งหมด'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // 📊 ส่วนแสดงสถิติ
  Widget _buildStatsSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.blue[100]!],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.analytics, color: Colors.blue),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'สถิติ: ${_todoList.length} รายการ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                Text(
                  'ข้อมูลจะบันทึกอัตโนมัติและหมดอายุใน 24 ชั่วโมง',
                  style: TextStyle(fontSize: 12, color: Colors.blue[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 📋 รายการ Todo
  Widget _buildTodoList() {
    if (_todoList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'ไม่มีรายการ Todo',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'เพิ่มรายการใหม่เพื่อเริ่มต้นใช้งาน',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _todoList.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
              backgroundColor: Colors.purple,
            ),
            title: Text(_todoList[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _removeTodo(index),
            ),
          ),
        );
      },
    );
  }

  // ➕ เพิ่มรายการใหม่
  Future<void> _addTodo() async {
    final newTodo = _controller.text.trim();

    if (newTodo.isNotEmpty) {
      setState(() {
        _todoList.add(newTodo);
        _controller.clear();
      });

      // บันทึกอัตโนมัติ
      await _saveTodoList(showMessage: false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เพิ่มรายการ "$newTodo" แล้ว'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  // ❌ ลบรายการ
  Future<void> _removeTodo(int index) async {
    final removedItem = _todoList[index];

    setState(() {
      _todoList.removeAt(index);
    });

    // บันทึกอัตโนมัติ
    await _saveTodoList(showMessage: false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ลบ "$removedItem" แล้ว'),
        action: SnackBarAction(
          label: 'เลิกทำ',
          onPressed: () {
            setState(() {
              _todoList.insert(index, removedItem);
            });
            _saveTodoList(showMessage: false);
          },
        ),
      ),
    );
  }

  // 💾 บันทึกรายการ Todo
  Future<void> _saveTodoList({bool showMessage = true}) async {
    await cacheManager.putForHours(
      key: 'todo_list',
      value: _todoList,
      hours: 24, // หมดอายุใน 24 ชั่วโมง
    );

    if (showMessage && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('บันทึกรายการ Todo แล้ว (${_todoList.length} รายการ)'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // 📂 โหลดรายการ Todo
  Future<void> _loadTodoList() async {
    final cachedList = await cacheManager.get('todo_list');

    if (cachedList != null && cachedList is List) {
      setState(() {
        _todoList = List<String>.from(cachedList);
      });

      if (_todoList.isNotEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('โหลดข้อมูลจากแคช (${_todoList.length} รายการ)'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    }
  }

  // 🗑️ ล้างข้อมูลทั้งหมด
  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ยืนยันการลบ'),
        content: Text('คุณต้องการลบรายการ Todo ทั้งหมดหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('ลบทั้งหมด'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await cacheManager.clear();
      setState(() {
        _todoList.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ล้างข้อมูลทั้งหมดแล้ว!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ℹ️ แสดงข้อมูล
  void _showInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('เกี่ยวกับ Cache Manager'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📱 App Type: Social'),
            Text('💾 Cache Size: Medium (25-50MB)'),
            Text('⏰ Expiration: 24 ชั่วโมง'),
            Text('🔄 Auto Save: เปิดใช้งาน'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ปิด'),
          ),
        ],
      ),
    );
  }
}
```

### เรียกใช้ในไฟล์ `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'todo_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App with Cache',
      home: TodoApp(),
    );
  }
}
```

---

## 🎯 Step 5: เทคนิคการใช้งาน

### 🔧 การเลือก CacheManager ให้เหมาะสม

```dart
// สำหรับผู้เริ่มต้น - ง่ายที่สุด
final basic = CacheManagerLite.forBeginner();

// สำหรับแอป Social Media
final social = CacheManagerLite.forBeginner(
  appType: AppType.social,
  cacheSize: CacheSize.medium,
);

// สำหรับแอป E-commerce
final ecommerce = CacheManagerLite.forBeginner(
  appType: AppType.ecommerce,
  cacheSize: CacheSize.large,
);
```

### ⏰ การตั้งเวลาหมดอายุ

```dart
// วิธีต่างๆ ในการตั้งเวลา
await cacheManager.putForMinutes(key: 'temp', value: data, minutes: 30);
await cacheManager.putForHours(key: 'session', value: data, hours: 2);
await cacheManager.putForDays(key: 'profile', value: data, days: 7);

// หมดอายุเมื่อสิ้นวัน
await cacheManager.putUntilEndOfDay(key: 'daily', value: data);

// ไม่หมดอายุ
await cacheManager.putPermanent(key: 'config', value: data);
```

### 🔍 การตรวจสอบข้อมูล

```dart
// ตรวจสอบว่ามีข้อมูลหรือไม่
final exists = await cacheManager.exists('my_key');

// ดูเวลาที่เหลือ
final remaining = await cacheManager.getRemainingTime('my_key');
if (remaining != null) {
  print('เหลือเวลา: ${remaining.inMinutes} นาที');
}

// ดูข้อมูลละเอียด
final info = await cacheManager.getEntryInfo('my_key');
if (info != null) {
  print('สถานะ: ${info.statusDescription}');
  print('อายุ: ${info.age}');
}
```

### 🎨 ประเภทข้อมูลที่รองรับ

```dart
// String
await cacheManager.put(key: 'name', value: 'John Doe');

// Numbers
await cacheManager.put(key: 'age', value: 25);
await cacheManager.put(key: 'price', value: 99.99);

// Lists
await cacheManager.put(key: 'items', value: ['item1', 'item2', 'item3']);

// Maps
await cacheManager.put(key: 'user', value: {
  'name': 'John',
  'email': 'john@example.com',
  'age': 25,
});

// Objects (ต้อง serialize เป็น Map ก่อน)
final userMap = user.toJson();
await cacheManager.put(key: 'user_object', value: userMap);
```

---

## 🚀 ขั้นตอนถัดไป

หลังจากลองตัวอย่างพื้นฐานแล้ว คุณสามารถศึกษาเพิ่มเติม:

1. **[User Level Guide](USER_LEVEL_GUIDE.md)** - เรียนรู้ระดับการใช้งานขั้นสูง
2. **[Expiration Guide](EXPIRATION_GUIDE.md)** - เทคนิคการจัดการเวลาหมดอายุ
3. **[Examples](example/)** - ตัวอย่างการใช้งานในสถานการณ์ต่างๆ

---

## ❓ คำถามที่พบบ่อย

### Q: ข้อมูลจะหายไปหรือไม่เมื่อปิดแอป?

A: ไม่หาย ข้อมูลจะเก็บไว้จนกว่าจะหมดอายุหรือลบออก

### Q: สามารถเปลี่ยน cache size ได้หรือไม่?

A: ได้ ใช้ parameter `cacheSize` เมื่อสร้าง CacheManager

### Q: รองรับข้อมูลขนาดใหญ่หรือไม่?

A: รองรับ แต่ควรตั้งค่า `cacheSize` ให้เหมาะสม

### Q: สามารถใช้หลาย CacheManager ได้หรือไม่?

A: ได้ แต่แนะนำให้ใช้ตัวเดียวเพื่อจัดการที่ง่าย

---

🎉 **ยินดีด้วย! คุณพร้อมใช้งาน Cache Manager Lite แล้ว**
