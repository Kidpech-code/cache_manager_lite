import 'package:flutter/material.dart';
import 'package:cache_manager_lite/cache_manager_lite.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Todo App with Cache', home: CustomCacheDemo());
  }
}

class CustomCacheDemo extends StatefulWidget {
  const CustomCacheDemo({super.key});

  @override
  CustomCacheDemoState createState() => CustomCacheDemoState();
}

class CustomCacheDemoState extends State<CustomCacheDemo> {
  // Cache Manager แบบ Custom ง่ายๆ
  late final CacheManagerLite cacheManager;
  bool _isInitialized = false;

  List<String> _todoList = [];
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _initializeCache();
  }

  Future<void> _initializeCache() async {
    cacheManager = CacheManagerLite.forBeginner(
      appType: AppType.social, // เปลี่ยนเป็นแอป Social
      cacheSize: CacheSize.medium, // ขนาดแคชกลาง
    );

    setState(() {
      _isInitialized = true;
    });

    await _loadTodoList(); // โหลดรายการ Todo เมื่อเริ่มแอป
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(
            title: Text('Todo App with Cache'), backgroundColor: Colors.purple),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
          title: Text('Todo App with Cache'), backgroundColor: Colors.purple),
      body: Column(
        children: [
          // ส่วนเพิ่ม Todo ใหม่
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: 'เพิ่มรายการใหม่...',
                        border: OutlineInputBorder()),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(onPressed: _addTodo, child: Text('เพิ่ม')),
              ],
            ),
          ),

          // ปุ่มควบคุม
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveTodoList,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text('บันทึก (24 ชั่วโมง)'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _clearAll,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text('ล้างทั้งหมด'),
                  ),
                ),
              ],
            ),
          ),

          // แสดงสถานะแคช
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.blue),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                      'รายการจะถูกบันทึกอัตโนมัติและหมดอายุใน 24 ชั่วโมง',
                      style: TextStyle(color: Colors.blue[700])),
                ),
              ],
            ),
          ),

          // รายการ Todo
          Expanded(
            child: _todoList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list_alt, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('ไม่มีรายการ Todo',
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                        SizedBox(height: 8),
                        Text('ลองเพิ่มรายการใหม่ข้างบน',
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _todoList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              child: Text('${index + 1}')),
                          title: Text(_todoList[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTodo(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // สถิติ
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text('รายการทั้งหมด: ${_todoList.length} รายการ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // เพิ่ม Todo ใหม่
  Future<void> _addTodo() async {
    if (!_isInitialized || _controller.text.trim().isEmpty) return;

    final newTodo = _controller.text.trim();
    setState(() {
      _todoList.add(newTodo);
      _controller.clear();
    });

    // บันทึกอัตโนมัติเมื่อเพิ่มรายการใหม่
    await _saveTodoList();
  }

  // ลบ Todo
  Future<void> _deleteTodo(int index) async {
    if (!_isInitialized) return;

    final deletedTodo = _todoList[index];
    setState(() {
      _todoList.removeAt(index);
    });

    // บันทึกอัตโนมัติเมื่อลบรายการ
    await _saveTodoList();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ลบ "$deletedTodo" แล้ว'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'เลิกทำ',
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                _todoList.insert(index, deletedTodo);
              });
              _saveTodoList();
            },
          ),
        ),
      );
    }
  }

  // บันทึกรายการ Todo ลงแคช (หมดอายุใน 24 ชั่วโมง)
  Future<void> _saveTodoList() async {
    if (!_isInitialized) return;

    await cacheManager.put(
      key: 'todo_list',
      value: _todoList,
      policy: CachePolicy(maxAge: Duration(hours: 24)),
    );

    // แสดงข้อความเฉพาะเมื่อกดปุ่มบันทึกเท่านั้น
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('บันทึกรายการ Todo แล้ว (หมดอายุใน 24 ชั่วโมง)'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2)),
      );
    }
  }

  // โหลดรายการ Todo จากแคช
  Future<void> _loadTodoList() async {
    if (!_isInitialized) return;

    final cachedList = await cacheManager.get('todo_list');
    if (cachedList != null && cachedList is List) {
      setState(() {
        _todoList = List<String>.from(cachedList);
      });

      if (_todoList.isNotEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('โหลดรายการ Todo จากแคชแล้ว (${_todoList.length} รายการ)'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // ล้างข้อมูลทั้งหมด
  Future<void> _clearAll() async {
    // แสดง dialog ยืนยัน
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณต้องการลบรายการ Todo ทั้งหมดหรือไม่?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('ยกเลิก')),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('ลบทั้งหมด'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await cacheManager.clear();
      setState(() {
        _todoList.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('ล้างข้อมูลทั้งหมดแล้ว!'),
          backgroundColor: Colors.red));
    }
  }
}
