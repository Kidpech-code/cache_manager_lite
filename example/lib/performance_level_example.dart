import 'package:flutter/material.dart';
import 'package:cache_manager_lite/cache_manager_lite.dart';

/// Example demonstrating performance level configurations.
/// ตัวอย่างแสดงการกำหนดค่าระดับประสิทธิภาพ
class PerformanceLevelExample extends StatefulWidget {
  const PerformanceLevelExample({super.key});

  @override
  State<PerformanceLevelExample> createState() => _PerformanceLevelExampleState();
}

class _PerformanceLevelExampleState extends State<PerformanceLevelExample> {
  CacheManagerLite? currentCacheManager;
  PerformanceLevel selectedLevel = PerformanceLevel.balanced;
  List<String> logs = [];
  bool isLoading = false;

  final Map<PerformanceLevel, Map<String, dynamic>> performanceConfigs = {
    PerformanceLevel.basic: {
      'name': 'Basic Performance',
      'description': 'Long cache duration (24h), fewer requests',
      'color': Colors.green,
      'icon': Icons.eco,
    },
    PerformanceLevel.balanced: {
      'name': 'Balanced Performance',
      'description': 'Medium cache duration (6h), balanced approach',
      'color': Colors.blue,
      'icon': Icons.balance,
    },
    PerformanceLevel.high: {
      'name': 'High Performance',
      'description': 'Short cache duration (1h), frequent updates',
      'color': Colors.orange,
      'icon': Icons.speed,
    },
    PerformanceLevel.realtime: {
      'name': 'Real-time Performance',
      'description': 'Very short cache (5min), near real-time data',
      'color': Colors.red,
      'icon': Icons.flash_on,
    },
  };

  @override
  void initState() {
    super.initState();
    _selectPerformanceLevel(PerformanceLevel.balanced);
  }

  void _selectPerformanceLevel(PerformanceLevel level) {
    setState(() {
      selectedLevel = level;
      currentCacheManager = CacheManagerLite.forAdvanced(
        cacheSize: CacheSize.medium,
        performanceLevel: level,
        appType: AppType.news,
      );
    });
    _addLog('Switched to ${performanceConfigs[level]!['name']}');
  }

  void _addLog(String message) {
    setState(() {
      logs.insert(
        0,
        '${DateTime.now().toString().substring(11, 19)}: $message',
      );
      if (logs.length > 20) logs.removeLast();
    });
  }

  Future<void> _testPerformance() async {
    if (currentCacheManager == null) return;

    setState(() {
      isLoading = true;
    });

    _addLog('Starting performance test...');

    try {
      // Test multiple API calls
      final urls = [
        'https://jsonplaceholder.typicode.com/posts/1',
        'https://jsonplaceholder.typicode.com/posts/2',
        'https://jsonplaceholder.typicode.com/posts/3',
      ];

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < urls.length; i++) {
        final start = Stopwatch()..start();

        try {
          await currentCacheManager!.getJson(urls[i]);
          start.stop();
          _addLog('API ${i + 1}: ${start.elapsedMilliseconds}ms');
        } catch (e) {
          _addLog('API ${i + 1}: Error - $e');
        }
      }

      stopwatch.stop();
      _addLog('Total time: ${stopwatch.elapsedMilliseconds}ms');
      _addLog('Performance test completed');
    } catch (e) {
      _addLog('Performance test failed: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = performanceConfigs[selectedLevel]!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Performance Levels'),
        backgroundColor: config['color'],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Performance level selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Performance Level:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 16),
                    ...performanceConfigs.keys.map((level) {
                      final levelConfig = performanceConfigs[level]!;
                      return RadioListTile<PerformanceLevel>(
                        title: Row(
                          children: [
                            Icon(
                              levelConfig['icon'],
                              color: levelConfig['color'],
                            ),
                            SizedBox(width: 8),
                            Text(levelConfig['name']),
                          ],
                        ),
                        subtitle: Text(levelConfig['description']),
                        value: level,
                        groupValue: selectedLevel,
                        onChanged: (value) {
                          if (value != null) {
                            _selectPerformanceLevel(value);
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Current configuration display
            Card(
              color: config['color'].withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(config['icon'], color: config['color'], size: 28),
                        SizedBox(width: 12),
                        Text(
                          'Current: ${config['name']}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: config['color'],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      config['description'],
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    if (currentCacheManager != null) ...[
                      SizedBox(height: 12),
                      Text(
                        'Cache Duration: ${_formatDuration(currentCacheManager!.effectiveConfig.defaultPolicy.maxAge)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: config['color'],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Test controls
            Row(
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _testPerformance,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: config['color'],
                    ),
                    child: isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Testing...'),
                            ],
                          )
                        : Text('Test Performance'),
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        logs.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: Text('Clear Logs'),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Performance logs
            SizedBox(
              height: 300, // Fixed height for logs section
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Performance Logs:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Container(
                      height: 200, // Fixed height instead of Expanded
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: logs.isEmpty
                          ? Center(
                              child: Text(
                                'No logs yet. Run a performance test to see results.',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: logs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2.0,
                                  ),
                                  child: Text(
                                    logs[index],
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                      color: index == 0 ? config['color'] : Colors.grey.shade700,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return 'No limit';
    if (duration.inDays > 0) return '${duration.inDays} days';
    if (duration.inHours > 0) return '${duration.inHours} hours';
    if (duration.inMinutes > 0) return '${duration.inMinutes} minutes';
    return '${duration.inSeconds} seconds';
  }
}
