import 'package:flutter/material.dart';
import 'package:cache_manager_lite/cache_manager_lite.dart';

/// Example demonstrating different user level configurations.
/// ตัวอย่างแสดงการกำหนดค่าสำหรับระดับผู้ใช้งานต่างๆ
class UserLevelExample extends StatefulWidget {
  const UserLevelExample({super.key});

  @override
  State<UserLevelExample> createState() => _UserLevelExampleState();
}

class _UserLevelExampleState extends State<UserLevelExample> {
  CacheManagerLite? selectedCacheManager;
  UserLevel selectedLevel = UserLevel.beginner;
  Map<String, dynamic>? levelInfo;
  List<String> operationLogs = [];

  final Map<UserLevel, Map<String, dynamic>> userLevelConfigs = {
    UserLevel.beginner: {
      'name': 'ระดับเริ่มต้น (Beginner)',
      'description': 'การกำหนดค่าง่ายๆ พร้อมค่าเริ่มต้นที่สมเหตุสมผล',
      'color': Colors.green,
      'icon': Icons.school,
      'complexity': 'ง่าย',
      'features': [
        'ค่าเริ่มต้นอัตโนมัติ',
        'การตั้งค่าน้อยที่สุด',
        'การทำงานง่าย',
        'เหมาะสำหรับผู้เริ่มต้น',
      ],
    },
    UserLevel.intermediate: {
      'name': 'ระดับกลาง (Intermediate)',
      'description': 'ตัวเลือกการปรับแต่งปานกลาง พร้อมประสิทธิภาพสมดุล',
      'color': Colors.blue,
      'icon': Icons.trending_up,
      'complexity': 'ปานกลาง',
      'features': [
        'ตัวเลือกการปรับแต่งบางส่วน',
        'ประสิทธิภาพสมดุล',
        'ค่าเริ่มต้นที่ดี',
        'เหมาะสำหรับผู้ใช้ทั่วไป',
      ],
    },
    UserLevel.advanced: {
      'name': 'ระดับสูง (Advanced)',
      'description': 'การควบคุมเต็มรูปแบบ พร้อมตัวเลือกขั้นสูง',
      'color': Colors.orange,
      'icon': Icons.settings,
      'complexity': 'สูง',
      'features': [
        'การควบคุมเต็มรูปแบบ',
        'ตัวเลือกขั้นสูง',
        'รองรับนโยบายกำหนดเอง',
        'เหมาะสำหรับนักพัฒนาที่มีประสบการณ์',
      ],
    },
    UserLevel.expert: {
      'name': 'ระดับผู้เชี่ยวชาญ (Expert)',
      'description': 'การปรับแต่งสมบูรณ์ พร้อมความสามารถปรับจูนละเอียด',
      'color': Colors.red,
      'icon': Icons.engineering,
      'complexity': 'ซับซ้อน',
      'features': [
        'การปรับแต่งสมบูรณ์',
        'ฟีเจอร์ขั้นสูงทั้งหมด',
        'การปรับจูนละเอียด',
        'เหมาะสำหรับผู้เชี่ยวชาญ',
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _selectUserLevel(UserLevel.beginner);
  }

  void _selectUserLevel(UserLevel level) {
    CacheManagerLite cacheManager;

    switch (level) {
      case UserLevel.beginner:
        cacheManager = CacheManagerLite.forBeginner(
          appType: AppType.utility,
          cacheSize: CacheSize.small,
        );
        break;
      case UserLevel.intermediate:
        cacheManager = CacheManagerLite.forIntermediate(
          appType: AppType.social,
          cacheSize: CacheSize.medium,
          performanceLevel: PerformanceLevel.balanced,
          enableEncryption: false,
        );
        break;
      case UserLevel.advanced:
        cacheManager = CacheManagerLite.forAdvanced(
          appType: AppType.ecommerce,
          cacheSize: CacheSize.large,
          performanceLevel: PerformanceLevel.high,
          enableEncryption: true,
          memoryCacheRatio: 0.15,
        );
        break;
      case UserLevel.expert:
        cacheManager = CacheManagerLite.forExpert(
          cacheSize: CacheSize.enterprise,
          performanceLevel: PerformanceLevel.realtime,
          appType: AppType.gaming,
          enableEncryption: true,
          enableBackgroundCleanup: true,
          memoryCacheRatio: 0.1,
        );
        break;
    }

    setState(() {
      selectedLevel = level;
      selectedCacheManager = cacheManager;
      levelInfo = userLevelConfigs[level];
    });

    _updateLevelInfo();
  }

  void _updateLevelInfo() {
    if (selectedCacheManager != null && levelInfo != null) {
      final config = selectedCacheManager!.effectiveConfig;
      setState(() {
        levelInfo!['cacheSize'] = _formatBytes(config.maxCacheSize);
        levelInfo!['duration'] = _formatDuration(
          config.defaultPolicy.maxAge ?? Duration(hours: 1),
        );
      });
    }
  }

  Future<void> _testCacheOperation() async {
    if (selectedCacheManager == null) return;

    setState(() {
      operationLogs.clear();
    });

    try {
      // Test different operations based on user level
      switch (selectedLevel) {
        case UserLevel.beginner:
          await _performBasicTest();
          break;
        case UserLevel.intermediate:
          await _performIntermediateTest();
          break;
        case UserLevel.advanced:
          await _performAdvancedTest();
          break;
        case UserLevel.expert:
          await _performExpertTest();
          break;
      }
    } catch (e) {
      _addLog('❌ Error: $e');
    }
  }

  Future<void> _performBasicTest() async {
    _addLog('🔧 เริ่มการทดสอบระดับเริ่มต้น...');

    final stopwatch = Stopwatch()..start();
    await selectedCacheManager!.put(
      key: 'simple_data',
      value: {
        'message': 'Hello Cache!',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );

    final result = await selectedCacheManager!.get('simple_data');
    stopwatch.stop();

    _addLog('✅ บันทึกและอ่านข้อมูลสำเร็จ');
    _addLog('⏱️ เวลาที่ใช้: ${stopwatch.elapsedMilliseconds}ms');
    _addLog('📦 ข้อมูลที่ได้: ${result != null ? "พบข้อมูล" : "ไม่พบข้อมูล"}');
  }

  Future<void> _performIntermediateTest() async {
    _addLog('🔧 เริ่มการทดสอบระดับกลาง...');

    // Test multiple cache entries
    final stopwatch = Stopwatch()..start();

    for (int i = 0; i < 5; i++) {
      await selectedCacheManager!.put(
        key: 'item_$i',
        value: {
          'id': i,
          'data': 'Item data $i',
          'created': DateTime.now().toIso8601String(),
        },
      );
    }

    int foundCount = 0;
    for (int i = 0; i < 5; i++) {
      final result = await selectedCacheManager!.get('item_$i');
      if (result != null) foundCount++;
    }

    stopwatch.stop();

    _addLog('✅ ทดสอบ Multiple Cache Entries');
    _addLog('📦 บันทึก: 5 รายการ, อ่านได้: $foundCount รายการ');
    _addLog('⏱️ เวลาที่ใช้: ${stopwatch.elapsedMilliseconds}ms');
  }

  Future<void> _performAdvancedTest() async {
    _addLog('🔧 เริ่มการทดสอบระดับสูง...');

    final stopwatch = Stopwatch()..start();

    // Test with custom policy
    await selectedCacheManager!.put(
      key: 'secure_data',
      value: {'sensitive': 'encrypted_info', 'user_id': 12345},
      policy: CachePolicy(
        maxAge: Duration(minutes: 30),
        encryptionKey: 'advanced_test_key',
      ),
    );

    // Test bulk operations
    final bulkData = List.generate(
      10,
      (i) => MapEntry('bulk_$i', {
        'index': i,
        'generated': DateTime.now().millisecondsSinceEpoch,
      }),
    );

    for (final entry in bulkData) {
      await selectedCacheManager!.put(key: entry.key, value: entry.value);
    }

    stopwatch.stop();

    _addLog('✅ ทดสอบ Advanced Features');
    _addLog('🔐 ข้อมูลเข้ารหัส: 1 รายการ');
    _addLog('📦 Bulk Operations: 10 รายการ');
    _addLog('⏱️ เวลาที่ใช้: ${stopwatch.elapsedMilliseconds}ms');
  }

  Future<void> _performExpertTest() async {
    _addLog('🔧 เริ่มการทดสอบระดับผู้เชี่ยวชาญ...');

    final stopwatch = Stopwatch()..start();

    // Performance stress test
    const testCount = 50;
    final futures = <Future>[];

    for (int i = 0; i < testCount; i++) {
      futures.add(
        selectedCacheManager!.put(
          key: 'stress_test_$i',
          value: {
            'id': i,
            'data': List.generate(100, (j) => 'data_${i}_$j'),
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          },
        ),
      );
    }

    await Future.wait(futures);

    // Concurrent read test
    final readFutures = <Future>[];
    for (int i = 0; i < testCount; i++) {
      readFutures.add(selectedCacheManager!.get('stress_test_$i'));
    }

    final results = await Future.wait(readFutures);
    final successCount = results.where((r) => r != null).length;

    stopwatch.stop();

    _addLog('✅ ทดสอบ Expert Performance');
    _addLog('🚀 Concurrent Writes: $testCount operations');
    _addLog('📖 Concurrent Reads: $successCount/$testCount successful');
    _addLog('⏱️ เวลาทั้งหมด: ${stopwatch.elapsedMilliseconds}ms');
    _addLog(
      '⚡ ประสิทธิภาพ: ${(testCount * 1000 / stopwatch.elapsedMilliseconds).toStringAsFixed(1)} ops/sec',
    );
  }

  void _addLog(String message) {
    setState(() {
      operationLogs.add(
        '${DateTime.now().toString().substring(11, 19)} $message',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ระดับผู้ใช้งาน (User Levels)'),
        backgroundColor: levelInfo?['color'] ?? Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User level selector
            Text(
              'เลือกระดับผู้ใช้งาน:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: UserLevel.values.length,
                itemBuilder: (context, index) {
                  final level = UserLevel.values[index];
                  final config = userLevelConfigs[level]!;
                  final isSelected = level == selectedLevel;

                  return Container(
                    width: 200,
                    margin: EdgeInsets.only(right: 12),
                    child: Card(
                      color: isSelected
                          ? config['color']
                          : Colors.grey.shade100,
                      child: InkWell(
                        onTap: () => _selectUserLevel(level),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                config['icon'],
                                color: isSelected
                                    ? Colors.white
                                    : config['color'],
                                size: 32,
                              ),
                              SizedBox(height: 8),
                              Text(
                                config['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'ระดับ: ${config['complexity']}',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white70
                                      : Colors.grey.shade600,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 24),

            // Current level info
            if (levelInfo != null) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: levelInfo!['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: levelInfo!['color'].withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(levelInfo!['icon'], color: levelInfo!['color']),
                        SizedBox(width: 8),
                        Text(
                          levelInfo!['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: levelInfo!['color'],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(levelInfo!['description']),
                    SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ขนาดแคช: ${levelInfo!['cacheSize'] ?? 'N/A'}',
                              ),
                              Text(
                                'ระยะเวลา: ${levelInfo!['duration'] ?? 'N/A'}',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: levelInfo!['features']
                                .map<Widget>(
                                  (feature) => Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check,
                                          size: 16,
                                          color: levelInfo!['color'],
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            feature,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 24),

            // Test button
            Center(
              child: ElevatedButton.icon(
                onPressed: _testCacheOperation,
                icon: Icon(Icons.play_arrow),
                label: Text('ทดสอบการทำงาน'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: levelInfo?['color'] ?? Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Operation logs
            if (operationLogs.isNotEmpty) ...[
              Text(
                'ผลการทดสอบ:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
                    itemCount: operationLogs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          operationLogs[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
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

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}ชม';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}นาที';
    } else {
      return '${duration.inSeconds}วินาที';
    }
  }
}
