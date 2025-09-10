import '../repositories/cache_repository.dart';

/// Use case for clearing all cache entries.
/// กรณีการใช้งานสำหรับการล้างรายการแคชทั้งหมด
class ClearCacheUseCase {
  final CacheRepository repository;

  /// Constructor for ClearCacheUseCase.
  /// - [repository]: The cache repository to use.
  ClearCacheUseCase(this.repository);

  /// Executes the use case to clear all cache.
  /// ดำเนินการกรณีการใช้งานเพื่อล้างแคชทั้งหมด
  Future<void> call() async {
    await repository.clear();
  }
}
