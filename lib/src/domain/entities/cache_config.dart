import 'cache_policy.dart';

/// Configuration for the cache manager.
/// การกำหนดค่าของตัวจัดการแคช
class CacheConfig {
  /// Maximum total cache size in bytes.
  /// ขนาดแคชทั้งหมดสูงสุดในไบต์
  final int maxCacheSize;

  /// Default policy to apply to cache entries.
  /// นโยบายเริ่มต้นที่จะใช้กับรายการแคช
  final CachePolicy defaultPolicy;

  /// Constructor for CacheConfig.
  /// - [maxCacheSize]: Total cache size limit.
  /// - [defaultPolicy]: Default caching policy.
  CacheConfig({required this.maxCacheSize, required this.defaultPolicy});
}
