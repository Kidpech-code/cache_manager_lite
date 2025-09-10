import 'package:flutter_test/flutter_test.dart';
import 'package:cache_manager_lite/cache_manager_lite.dart';

void main() {
  group('CacheManagerLite Tests', () {
    test('CachePolicy creation', () {
      final policy = CachePolicy(maxAge: Duration(hours: 1));
      expect(policy.maxAge, Duration(hours: 1));
    });

    test('CacheEntry creation', () {
      final entry = CacheEntry(
        key: 'test_key',
        value: 'test_value',
        createdAt: DateTime.now(),
      );
      expect(entry.key, 'test_key');
      expect(entry.value, 'test_value');
      expect(entry.isExpired, false);
    });

    test('CacheConfig creation', () {
      final config = CacheConfig(
        maxCacheSize: 1024,
        defaultPolicy: CachePolicy(maxAge: Duration(hours: 2)),
      );
      expect(config.maxCacheSize, 1024);
      expect(config.defaultPolicy.maxAge, Duration(hours: 2));
    });

    // Note: For full integration tests, you'd need to mock Dio and Hive
    // This is a basic unit test structure
  });
}
