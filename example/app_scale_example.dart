import 'package:flutter/material.dart';
import 'package:cache_manager_lite/cache_manager_lite.dart';

/// Example demonstrating different app scale configurations.
/// ตัวอย่างแสดงการกำหนดค่าขนาดแอปที่แตกต่างกัน
class AppScaleExample extends StatefulWidget {
  const AppScaleExample({super.key});

  @override
  State<AppScaleExample> createState() => _AppScaleExampleState();
}

class _AppScaleExampleState extends State<AppScaleExample> {
  CacheManagerLite? selectedCacheManager;
  String selectedScale = 'Small App';
  Map<String, dynamic>? cacheStats;

  final Map<String, CacheManagerLite Function()> scaleConfigs = {
    'Small App (Utility)': () => CacheManagerLite.small(
      appType: AppType.utility,
      enableEncryption: false,
    ),
    'Small App (Productivity)': () => CacheManagerLite.small(
      appType: AppType.utility,
      enableEncryption: true,
    ),
    'Medium App (Social)': () => CacheManagerLite.medium(
      appType: AppType.social,
    ),
    'Medium App (ECommerce)': () => CacheManagerLite.medium(
      appType: AppType.ecommerce,
    ),
    'Large App (Gaming)': () => CacheManagerLite.large(
      appType: AppType.gaming,
    ),
    'Enterprise (News)': () => CacheManagerLite.enterprise(
      appType: AppType.news,
    ),
  };

  @override
  void initState() {
    super.initState();
    _selectScale('Small App (Utility)');
  }

  void _selectScale(String scale) {
    if (scaleConfigs.containsKey(scale)) {
      setState(() {
        selectedCacheManager = scaleConfigs[scale]!();
        selectedScale = scale;
      });
      _updateCacheStats();
    }
  }

  void _updateCacheStats() {
    if (selectedCacheManager != null) {
      final config = selectedCacheManager!.effectiveConfig;
      setState(() {
        cacheStats = {
          'Cache Size': _formatBytes(config.maxCacheSize),
          'Default Duration': _formatDuration(config.defaultPolicy.maxAge ?? Duration(hours: 1)),
          'Cache Type': 'Hive Storage',
          'Status': 'Active',
        };
      });
    }
  }

  Future<void> _testScale(String scale) async {
    if (!scaleConfigs.containsKey(scale)) return;

    try {
      final cacheManager = scaleConfigs[scale]!();
      
      // Test cache operations
      final stopwatch = Stopwatch()..start();
      await cacheManager.put(
        key: 'test_key', 
        value: {'timestamp': DateTime.now().toIso8601String()}
      );
      await cacheManager.get('test_key');
      stopwatch.stop();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ $scale tested! Time: ${stopwatch.elapsedMilliseconds}ms'),
            backgroundColor: Colors.green,
          ),
        );
      }

      if (mounted) {
        setState(() {
          selectedScale = scale;
          selectedCacheManager = cacheManager;
        });
      }
      _updateCacheStats();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error testing $scale: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Scale Configurations'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scale selection buttons
            Text(
              'Choose App Scale:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: scaleConfigs.keys.map((scale) {
                final isSelected = scale == selectedScale;
                return ElevatedButton(
                  onPressed: () => _selectScale(scale),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.blue : Colors.grey.shade200,
                    foregroundColor: isSelected ? Colors.white : Colors.black87,
                  ),
                  child: Text(scale),
                );
              }).toList(),
            ),

            SizedBox(height: 24),

            // Current configuration display
            if (cacheStats != null) ...[
              Text(
                'Current Configuration ($selectedScale):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    ...cacheStats!.entries.map((entry) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              entry.value.toString(),
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],

            SizedBox(height: 24),

            // Test buttons
            Text(
              'Test Configurations:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: scaleConfigs.keys.map((scale) {
                return OutlinedButton(
                  onPressed: () => _testScale(scale),
                  child: Text('Test $scale'),
                );
              }).toList(),
            ),

            Spacer(),

            // Information panel
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Scale Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _getScaleDescription(selectedScale),
                    style: TextStyle(color: Colors.blue.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getScaleDescription(String scale) {
    switch (scale) {
      case 'Small App (Utility)':
        return 'Optimized for utility apps with basic caching needs. Minimal memory usage and simple operations.';
      case 'Small App (Productivity)':
        return 'For productivity apps with security requirements. Includes encryption for sensitive data.';
      case 'Medium App (Social)':
        return 'Balanced performance for social apps with moderate data flow and user interactions.';
      case 'Medium App (ECommerce)':
        return 'Speed-optimized for e-commerce apps requiring fast product data access and transactions.';
      case 'Large App (Gaming)':
        return 'High-performance caching for gaming apps with fast asset loading and minimal latency.';
      case 'Enterprise (News)':
        return 'Enterprise-grade configuration for news apps with fast content delivery and caching.';
      default:
        return 'Select a scale to see its description.';
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
