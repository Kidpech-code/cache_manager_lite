import 'package:flutter/material.dart';
import 'package:cache_manager_lite/cache_manager_lite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Cache Manager Demo', home: CacheDemo());
  }
}

class CacheDemo extends StatefulWidget {
  const CacheDemo({super.key});

  @override
  createState() => _CacheDemoState();
}

class _CacheDemoState extends State<CacheDemo> {
  // เริ่มต้นใช้ Cache Manager แบบง่ายสุด
  final cacheManager = CacheManagerLite.forBeginner();

  String _cachedData = '';
  String _inputText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Cache Manager Demo'), backgroundColor: Colors.blue),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ช่องป้อนข้อมูล
            TextField(
              decoration: InputDecoration(
                  labelText: 'ป้อนข้อมูลที่ต้องการแคช',
                  border: OutlineInputBorder()),
              onChanged: (value) {
                _inputText = value;
              },
            ),
            SizedBox(height: 16),

            // ปุ่มบันทึกข้อมูล
            ElevatedButton(
                onPressed: _saveData,
                child: Text('บันทึกข้อมูล (หมดอายุใน 1 ชั่วโมง)')),
            SizedBox(height: 16),

            // ปุ่มดึงข้อมูล
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('ดึงข้อมูลจากแคช'),
            ),
            SizedBox(height: 16),

            // ปุ่มล้างข้อมูล
            ElevatedButton(
              onPressed: _clearData,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('ล้างข้อมูลทั้งหมด'),
            ),
            SizedBox(height: 24),

            // แสดงผลข้อมูล
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ข้อมูลจากแคช:',
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
          key: 'user_data', value: _inputText, hours: 1);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('บันทึกข้อมูลสำเร็จ!')));
    }
  }

  // ดึงข้อมูลจากแคช
  Future<void> _loadData() async {
    final data = await cacheManager.get('user_data');
    setState(() {
      _cachedData = data ?? 'ไม่พบข้อมูลหรือข้อมูลหมดอายุแล้ว';
    });
  }

  // ล้างข้อมูลทั้งหมด
  Future<void> _clearData() async {
    await cacheManager.clear();
    setState(() {
      _cachedData = '';
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('ล้างข้อมูลทั้งหมดแล้ว!')));
  }
}
