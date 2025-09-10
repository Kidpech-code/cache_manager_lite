import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cache_manager_lite/cache_manager_lite.dart';

/// Example demonstrating advanced cache expiration and time management.
/// ตัวอย่างแสดงการจัดการเวลาหมดอายุและการนับเวลาถอยหลังของแคชขั้นสูง
class CacheExpirationExample extends StatefulWidget {
  const CacheExpirationExample({super.key});

  @override
  State<CacheExpirationExample> createState() => _CacheExpirationExampleState();
}

class _CacheExpirationExampleState extends State<CacheExpirationExample> {
  late CacheManagerLite cacheManager;
  List<String> logs = [];
  Map<String, CacheEntryInfo> cacheEntries = {};
  bool isMonitoring = false;

  @override
  void initState() {
    super.initState();
    cacheManager = CacheManagerLite.forAdvanced(appType: AppType.utility, cacheSize: CacheSize.medium);
  }

  void _addLog(String message) {
    setState(() {
      logs.add('${DateTime.now().toString().substring(11, 19)} $message');
      if (logs.length > 20) {
        logs.removeAt(0);
      }
    });
  }

  Future<void> _demonstrateBasicExpiration() async {
    _addLog('🔧 เริ่มทดสอบการหมดอายุพื้นฐาน...');

    // 1. ใช้ Duration
    await cacheManager.put(
      key: 'test_duration',
      value: {'type': 'duration_test', 'created': DateTime.now().toIso8601String()},
      maxAge: Duration(seconds: 10),
    );
    _addLog('✅ สร้างแคชด้วย Duration (10 วินาที)');

    // 2. ใช้ expiresAt โดยตรง
    final specificTime = DateTime.now().add(Duration(seconds: 15));
    await cacheManager.putWithExpirationTime(
      key: 'test_specific_time',
      value: {'type': 'specific_time_test', 'expires_at': specificTime.toIso8601String()},
      expirationTime: specificTime,
    );
    _addLog('✅ สร้างแคชด้วยเวลาเฉพาะ (15 วินาที)');

    await _updateCacheStatus();
  }

  Future<void> _demonstrateConvenienceMethods() async {
    _addLog('🔧 เริ่มทดสอบ Convenience Methods...');

    // ทดสอบ methods ต่างๆ
    await cacheManager.putForMinutes(key: 'expires_in_minutes', value: {'type': 'minutes', 'data': 'expires in 2 minutes'}, minutes: 2);
    _addLog('✅ สร้างแคชหมดอายุใน 2 นาที');

    await cacheManager.putForHours(key: 'expires_in_hours', value: {'type': 'hours', 'data': 'expires in 1 hour'}, hours: 1);
    _addLog('✅ สร้างแคชหมดอายุใน 1 ชั่วโมง');

    await cacheManager.putUntilEndOfDay(key: 'expires_end_of_day', value: {'type': 'end_of_day', 'data': 'expires at end of day'});
    _addLog('✅ สร้างแคชหมดอายุเมื่อสิ้นวัน');

    await cacheManager.putPermanent(key: 'permanent_cache', value: {'type': 'permanent', 'data': 'never expires (practically)'});
    _addLog('✅ สร้างแคชถาวร (ไม่หมดอายุ)');

    await _updateCacheStatus();
  }

  Future<void> _demonstrateAdvancedFeatures() async {
    _addLog('🔧 เริ่มทดสอบฟีเจอร์ขั้นสูง...');

    // สร้างแคชด้วย custom policy
    final customPolicy = CachePolicy.expiresAt(expirationTime: DateTime.now().add(Duration(seconds: 30)), encryptionKey: 'secure_key_123');

    await cacheManager.put(key: 'custom_policy_cache', value: {'sensitive_data': 'encrypted content', 'id': 12345}, policy: customPolicy);
    _addLog('✅ สร้างแคชด้วย Custom Policy + การเข้ารหัส');

    // ทดสอบการขยายเวลา
    await cacheManager.put(
      key: 'extendable_cache',
      value: {'type': 'extendable', 'original_data': 'will be extended'},
      maxAge: Duration(seconds: 20),
    );
    _addLog('✅ สร้างแคชที่สามารถขยายเวลาได้');

    // ขยายเวลาหลังจาก 5 วินาที
    Future.delayed(Duration(seconds: 5), () async {
      final extended = await cacheManager.extendExpiration(key: 'extendable_cache', additionalTime: Duration(seconds: 30));
      if (extended) {
        _addLog('⏰ ขยายเวลาแคช "extendable_cache" เพิ่ม 30 วินาที');
        await _updateCacheStatus();
      }
    });

    await _updateCacheStatus();
  }

  Future<void> _updateCacheStatus() async {
    final keys = [
      'test_duration',
      'test_specific_time',
      'expires_in_minutes',
      'expires_in_hours',
      'expires_end_of_day',
      'permanent_cache',
      'custom_policy_cache',
      'extendable_cache',
    ];

    Map<String, CacheEntryInfo> newEntries = {};

    for (final key in keys) {
      final info = await cacheManager.getEntryInfo(key);
      if (info != null) {
        newEntries[key] = info;
      }
    }

    setState(() {
      cacheEntries = newEntries;
    });
  }

  void _startMonitoring() {
    if (isMonitoring) return;

    setState(() {
      isMonitoring = true;
    });

    _addLog('🔄 เริ่มการตรวจสอบแบบเรียลไทม์...');

    // อัปเดตสถานะทุก 2 วินาที
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (!isMonitoring || !mounted) {
        timer.cancel();
        return;
      }

      _updateCacheStatus();
    });
  }

  void _stopMonitoring() {
    setState(() {
      isMonitoring = false;
    });
    _addLog('⏹️ หยุดการตรวจสอบแบบเรียลไทม์');
  }

  Future<void> _clearAllCache() async {
    await cacheManager.clear();
    setState(() {
      cacheEntries.clear();
    });
    _addLog('🧹 ล้างแคชทั้งหมดแล้ว');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cache Expiration Management'), backgroundColor: Colors.purple, foregroundColor: Colors.white),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Control buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _demonstrateBasicExpiration,
                  icon: Icon(Icons.timer),
                  label: Text('Basic Expiration'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                ElevatedButton.icon(
                  onPressed: _demonstrateConvenienceMethods,
                  icon: Icon(Icons.schedule),
                  label: Text('Convenience Methods'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton.icon(
                  onPressed: _demonstrateAdvancedFeatures,
                  icon: Icon(Icons.settings),
                  label: Text('Advanced Features'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
                ElevatedButton.icon(
                  onPressed: isMonitoring ? _stopMonitoring : _startMonitoring,
                  icon: Icon(isMonitoring ? Icons.stop : Icons.play_arrow),
                  label: Text(isMonitoring ? 'Stop Monitor' : 'Start Monitor'),
                  style: ElevatedButton.styleFrom(backgroundColor: isMonitoring ? Colors.red : Colors.purple),
                ),
                ElevatedButton.icon(
                  onPressed: _clearAllCache,
                  icon: Icon(Icons.clear),
                  label: Text('Clear All'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Cache entries status
            if (cacheEntries.isNotEmpty) ...[
              Text('Cache Entries Status:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),

              Expanded(
                flex: 2,
                child: ListView.builder(
                  itemCount: cacheEntries.length,
                  itemBuilder: (context, index) {
                    final entry = cacheEntries.entries.elementAt(index);
                    final key = entry.key;
                    final info = entry.value;

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      color: info.isExpired
                          ? Colors.red.shade50
                          : info.remainingTime != null && info.remainingTime!.inSeconds < 30
                          ? Colors.yellow.shade50
                          : Colors.green.shade50,
                      child: ListTile(
                        title: Text(
                          key,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, decoration: info.isExpired ? TextDecoration.lineThrough : null),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status: ${info.statusDescription}'),
                            if (info.expiresAt != null) Text('Expires: ${info.expiresAt!.toString().substring(11, 19)}'),
                            Text('Age: ${info.age.inSeconds}s'),
                            if (info.isEncrypted)
                              Row(
                                children: [
                                  Icon(Icons.lock, size: 16, color: Colors.orange),
                                  SizedBox(width: 4),
                                  Text('Encrypted', style: TextStyle(color: Colors.orange)),
                                ],
                              ),
                          ],
                        ),
                        trailing: info.isExpired
                            ? Icon(Icons.close, color: Colors.red)
                            : info.remainingTime != null && info.remainingTime!.inSeconds < 30
                            ? Icon(Icons.warning, color: Colors.orange)
                            : Icon(Icons.check, color: Colors.green),
                      ),
                    );
                  },
                ),
              ),
            ],

            SizedBox(height: 16),

            // Logs
            if (logs.isNotEmpty) ...[
              Text('Operation Logs:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ListView.builder(
                    reverse: true,
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 1),
                        child: Text(logs[logs.length - 1 - index], style: TextStyle(fontSize: 12, fontFamily: 'monospace')),
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
