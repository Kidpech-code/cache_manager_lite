import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cache_manager_lite/cache_manager_lite.dart';

/// Basic cache manager provider.
/// โปรไวเดอร์ cache manager พื้นฐาน
final cacheManagerProvider = Provider<CacheManagerLite>((ref) {
  return CacheManagerLite.forBeginner();
});

/// Example showing Riverpod integration.
/// ตัวอย่างแสดงการผสานรวมกับ Riverpod
class RiverpodExample extends ConsumerWidget {
  const RiverpodExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cacheManager = ref.watch(cacheManagerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Riverpod Integration Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  final data = await cacheManager.getJson(
                    'https://jsonplaceholder.typicode.com/posts/1',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data loaded: ${data['title']}')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: Text('Load JSON Data'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await cacheManager.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Cache cleared using Riverpod')),
                );
              },
              child: Text('Clear Cache'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom cache manager provider with specific configuration.
/// โปรไวเดอร์ cache manager แบบกำหนดเองพร้อมการกำหนดค่าเฉพาะ
final customCacheManagerProvider = Provider<CacheManagerLite>((ref) {
  return CacheManagerLite.forIntermediate(
    appType: AppType.social,
    cacheSize: CacheSize.medium,
    enableEncryption: true,
  );
});
