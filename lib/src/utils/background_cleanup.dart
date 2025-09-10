import 'dart:async';
import '../domain/repositories/cache_repository.dart';

/// Utility for background cache cleanup.
/// ยูทิลิตี้สำหรับการล้างแคชในพื้นหลัง
class BackgroundCleanup {
  Timer? _timer;

  /// Starts periodic cleanup.
  /// เริ่มการล้างเป็นระยะ
  void startCleanup(CacheRepository repository) {
    // Cleanup every hour
    // ล้างทุกชั่วโมง
    _timer = Timer.periodic(Duration(hours: 1), (timer) async {
      await _performCleanup(repository);
    });
  }

  /// Stops the cleanup.
  /// หยุดการล้าง
  void stopCleanup() {
    _timer?.cancel();
  }

  static Future<void> _performCleanup(CacheRepository repository) async {
    final entries = await repository.getAll();
    for (final entry in entries) {
      if (entry.isExpired) {
        await repository.delete(entry.key);
      }
    }
  }
}
