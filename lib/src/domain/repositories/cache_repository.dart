import '../entities/cache_entry.dart';

/// Abstract repository for cache operations.
/// รีพอสิทอรีนามธรรมสำหรับการดำเนินการแคช
abstract class CacheRepository {
  /// Retrieves a cache entry by key.
  /// ดึงรายการแคชโดยคีย์
  Future<CacheEntry?> get(String key);

  /// Stores a cache entry.
  /// จัดเก็บรายการแคช
  Future<void> put(CacheEntry entry);

  /// Deletes a cache entry by key.
  /// ลบรายการแคชโดยคีย์
  Future<void> delete(String key);

  /// Clears all cache entries.
  /// ล้างรายการแคชทั้งหมด
  Future<void> clear();

  /// Gets all cache entries.
  /// รับรายการแคชทั้งหมด
  Future<List<CacheEntry>> getAll();

  /// Checks if a key exists in the cache.
  /// ตรวจสอบว่าคีย์มีอยู่ในแคชหรือไม่
  Future<bool> containsKey(String key);
}
