import 'package:hive/hive.dart';
import '../../domain/entities/cache_entry.dart';
import '../../platform/platform.dart';

/// Data source for Hive-based cache storage with WASM compatibility.
/// แหล่งข้อมูลสำหรับการจัดเก็บแคชที่ใช้ Hive รองรับ WASM
class HiveDataSource {
  late Box<Map> _box;

  /// Initializes the Hive box with platform-specific implementation.
  /// เริ่มต้นกล่อง Hive ด้วยการใช้งานที่เฉพาะเจาะจงแต่ละแพลตฟอร์ม
  Future<void> init() async {
    await initializePlatformStorage();
    _box = await getPlatformBox<Map>('cache_manager_lite');
  }

  /// Retrieves a cache entry from Hive.
  /// ดึงรายการแคชจาก Hive
  Future<CacheEntry?> get(String key) async {
    final data = _box.get(key);
    if (data != null) {
      return CacheEntry.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  /// Stores a cache entry in Hive.
  /// จัดเก็บรายการแคชใน Hive
  Future<void> put(CacheEntry entry) async {
    await _box.put(entry.key, entry.toJson());
  }

  /// Deletes a cache entry from Hive.
  /// ลบรายการแคชจาก Hive
  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  /// Clears all entries from Hive.
  /// ล้างรายการทั้งหมดจาก Hive
  Future<void> clear() async {
    await _box.clear();
  }

  /// Gets all cache entries from Hive.
  /// รับรายการแคชทั้งหมดจาก Hive
  Future<List<CacheEntry>> getAll() async {
    return _box.values
        .map((e) => CacheEntry.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Checks if a key exists in Hive.
  /// ตรวจสอบว่าคีย์มีอยู่ใน Hive หรือไม่
  Future<bool> containsKey(String key) async {
    return _box.containsKey(key);
  }
}
