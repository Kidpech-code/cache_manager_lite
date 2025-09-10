import 'package:flutter/material.dart';
import 'package:cache_manager_lite/cache_manager_lite.dart';

/// Example demonstrating custom cache configurations.
/// ตัวอย่างแสดงการกำหนดค่าแคชแบบกำหนดเอง
class CustomConfigExample extends StatefulWidget {
  const CustomConfigExample({super.key});

  @override
  State<CustomConfigExample> createState() => _CustomConfigExampleState();
}

class _CustomConfigExampleState extends State<CustomConfigExample> {
  CacheManagerLite? customCacheManager;

  // Custom configuration parameters
  int customCacheSize = 10; // MB
  int customDurationHours = 6;
  bool enableCustomEncryption = true;
  String encryptionKey = 'my_custom_key_2024';
  double memoryRatio = 0.25;
  bool enableBackgroundCleanup = true;
  AppType selectedAppType = AppType.social;

  List<String> logs = [];
  bool isConfigured = false;

  final Map<AppType, Map<String, dynamic>> appTypeInfo = {
    AppType.social: {
      'name': 'Social Media',
      'icon': Icons.people,
      'color': Colors.blue,
      'description': 'Optimized for social media content',
    },
    AppType.ecommerce: {
      'name': 'E-Commerce',
      'icon': Icons.shopping_cart,
      'color': Colors.green,
      'description': 'Optimized for product catalogs',
    },
    AppType.news: {
      'name': 'News',
      'icon': Icons.newspaper,
      'color': Colors.orange,
      'description': 'Optimized for article content',
    },
    AppType.gaming: {
      'name': 'Gaming',
      'icon': Icons.games,
      'color': Colors.red,
      'description': 'Optimized for game assets',
    },
    AppType.education: {
      'name': 'Education',
      'icon': Icons.school,
      'color': Colors.purple,
      'description': 'Optimized for learning content',
    },
    AppType.utility: {
      'name': 'Utility',
      'icon': Icons.build,
      'color': Colors.grey,
      'description': 'Basic utility configuration',
    },
  };

  void _createCustomConfiguration() {
    try {
      // Create custom cache policy
      final customPolicy = CachePolicy(
        maxAge: Duration(hours: customDurationHours),
        encryptionKey: enableCustomEncryption ? encryptionKey : null,
      );

      // Create custom cache manager
      customCacheManager = CacheManagerLite.custom(
        customSizeBytes: customCacheSize * 1024 * 1024, // Convert MB to bytes
        customPolicy: customPolicy,
        appType: selectedAppType,
        enableEncryption: enableCustomEncryption,
        encryptionKey: enableCustomEncryption ? encryptionKey : null,
        enableBackgroundCleanup: enableBackgroundCleanup,
        memoryCacheRatio: memoryRatio,
      );

      setState(() {
        isConfigured = true;
        logs.clear();
      });

      _addLog('✅ สร้าง Custom Configuration สำเร็จ');
      _addLog('📦 ขนาดแคช: ${customCacheSize}MB');
      _addLog('⏰ ระยะเวลา: $customDurationHoursชม');
      _addLog(
        '🔐 การเข้ารหัส: ${enableCustomEncryption ? "เปิดใช้งาน" : "ปิดใช้งาน"}',
      );
      _addLog('💾 Memory Ratio: ${(memoryRatio * 100).toStringAsFixed(1)}%');
      _addLog(
        '🧹 Background Cleanup: ${enableBackgroundCleanup ? "เปิด" : "ปิด"}',
      );
      _addLog('📱 App Type: ${appTypeInfo[selectedAppType]!['name']}');
    } catch (e) {
      _addLog('❌ Error: $e');
    }
  }

  Future<void> _testCustomConfiguration() async {
    if (customCacheManager == null) {
      _addLog('⚠️ กรุณาสร้าง Configuration ก่อน');
      return;
    }

    _addLog('🔧 เริ่มทดสอบ Custom Configuration...');

    try {
      final stopwatch = Stopwatch()..start();

      // Test 1: Basic operations
      await customCacheManager!.put(
        key: 'custom_test_1',
        value: {
          'type': 'custom_config_test',
          'app_type': selectedAppType.toString(),
          'timestamp': DateTime.now().toIso8601String(),
          'data': List.generate(100, (i) => 'test_data_$i'),
        },
      );

      final result1 = await customCacheManager!.get('custom_test_1');
      _addLog('✅ Basic Test: ${result1 != null ? "Success" : "Failed"}');

      // Test 2: Encryption test (if enabled)
      if (enableCustomEncryption) {
        await customCacheManager!.put(
          key: 'encrypted_test',
          value: {
            'sensitive_data': 'this_should_be_encrypted',
            'user_id': 12345,
          },
          policy: CachePolicy(
            maxAge: Duration(minutes: 30),
            encryptionKey: encryptionKey,
          ),
        );

        final encryptedResult = await customCacheManager!.get('encrypted_test');
        _addLog(
          '🔐 Encryption Test: ${encryptedResult != null ? "Success" : "Failed"}',
        );
      }

      // Test 3: Performance test
      const batchSize = 20;
      final batchStopwatch = Stopwatch()..start();

      for (int i = 0; i < batchSize; i++) {
        await customCacheManager!.put(
          key: 'batch_$i',
          value: {
            'batch_id': i,
            'config_type': 'custom',
            'data': List.generate(50, (j) => 'item_${i}_$j'),
          },
        );
      }

      batchStopwatch.stop();
      _addLog(
        '🚀 Batch Write ($batchSize items): ${batchStopwatch.elapsedMilliseconds}ms',
      );

      // Test 4: Read performance
      final readStopwatch = Stopwatch()..start();
      int successReads = 0;

      for (int i = 0; i < batchSize; i++) {
        final result = await customCacheManager!.get('batch_$i');
        if (result != null) successReads++;
      }

      readStopwatch.stop();
      _addLog('📖 Batch Read: $successReads/$batchSize successful');
      _addLog('⏱️ Read Time: ${readStopwatch.elapsedMilliseconds}ms');

      stopwatch.stop();
      _addLog(
        '🎉 การทดสอบเสร็จสิ้น - เวลารวม: ${stopwatch.elapsedMilliseconds}ms',
      );
    } catch (e) {
      _addLog('❌ Test Error: $e');
    }
  }

  Future<void> _clearCache() async {
    if (customCacheManager == null) return;

    try {
      await customCacheManager!.clear();
      _addLog('🧹 ล้างแคชสำเร็จ');
    } catch (e) {
      _addLog('❌ Clear Error: $e');
    }
  }

  void _addLog(String message) {
    setState(() {
      logs.add('${DateTime.now().toString().substring(11, 19)} $message');
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentAppInfo = appTypeInfo[selectedAppType]!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Configuration'),
        backgroundColor: currentAppInfo['color'],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Configuration Panel
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🛠️ Custom Configuration Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Cache Size
                    Text('ขนาดแคช (MB): $customCacheSize'),
                    Slider(
                      value: customCacheSize.toDouble(),
                      min: 1,
                      max: 100,
                      divisions: 99,
                      label: '${customCacheSize}MB',
                      onChanged: (value) {
                        setState(() {
                          customCacheSize = value.round();
                        });
                      },
                    ),

                    // Cache Duration
                    Text('ระยะเวลาแคช (ชั่วโมง): $customDurationHours'),
                    Slider(
                      value: customDurationHours.toDouble(),
                      min: 1,
                      max: 48,
                      divisions: 47,
                      label: '${customDurationHours}h',
                      onChanged: (value) {
                        setState(() {
                          customDurationHours = value.round();
                        });
                      },
                    ),

                    // Memory Ratio
                    Text(
                      'Memory Ratio: ${(memoryRatio * 100).toStringAsFixed(1)}%',
                    ),
                    Slider(
                      value: memoryRatio,
                      min: 0.1,
                      max: 0.5,
                      divisions: 40,
                      label: '${(memoryRatio * 100).toStringAsFixed(1)}%',
                      onChanged: (value) {
                        setState(() {
                          memoryRatio = value;
                        });
                      },
                    ),

                    // App Type Selection
                    Text('ประเภทแอป:'),
                    SizedBox(height: 8),
                    DropdownButton<AppType>(
                      value: selectedAppType,
                      isExpanded: true,
                      items: AppType.values.map((type) {
                        final info = appTypeInfo[type]!;
                        return DropdownMenuItem(
                          value: type,
                          child: Row(
                            children: [
                              Icon(info['icon'], color: info['color']),
                              SizedBox(width: 8),
                              Text(info['name']),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedAppType = value;
                          });
                        }
                      },
                    ),

                    SizedBox(height: 16),

                    // Switches
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            title: Text(
                              'การเข้ารหัส',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: enableCustomEncryption,
                            onChanged: (value) {
                              setState(() {
                                enableCustomEncryption = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            title: Text(
                              'Auto Cleanup',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: enableBackgroundCleanup,
                            onChanged: (value) {
                              setState(() {
                                enableBackgroundCleanup = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    // Encryption Key
                    if (enableCustomEncryption) ...[
                      Text('Encryption Key:'),
                      TextField(
                        controller: TextEditingController(text: encryptionKey),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter custom encryption key',
                        ),
                        onChanged: (value) {
                          encryptionKey = value;
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _createCustomConfiguration,
                    icon: Icon(Icons.settings),
                    label: Text('สร้าง Config'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentAppInfo['color'],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isConfigured ? _testCustomConfiguration : null,
                    icon: Icon(Icons.play_arrow),
                    label: Text('ทดสอบ'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isConfigured ? _clearCache : null,
                    icon: Icon(Icons.clear),
                    label: Text('ล้างแคช'),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Logs
            if (logs.isNotEmpty) ...[
              Text(
                'ผลการทำงาน:',
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
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 1),
                        child: Text(
                          logs[index],
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
}
