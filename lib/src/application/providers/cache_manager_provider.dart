import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../cache_manager_lite.dart';

/// Riverpod provider for CacheManagerLite.
/// โปรไวเดอร์ Riverpod สำหรับ CacheManagerLite
final cacheManagerProvider = Provider<CacheManagerLite>((ref) {
  return CacheManagerLite();
});
