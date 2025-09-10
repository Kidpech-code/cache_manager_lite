import '../entities/cache_entry.dart';
import '../repositories/cache_repository.dart';

/// Use case for storing a cache entry.
/// กรณีการใช้งานสำหรับการจัดเก็บรายการแคช
class PutCacheUseCase {
  final CacheRepository repository;

  /// Constructor for PutCacheUseCase.
  /// - [repository]: The cache repository to use.
  PutCacheUseCase(this.repository);

  /// Executes the use case to store a cache entry.
  /// ดำเนินการกรณีการใช้งานเพื่อจัดเก็บรายการแคช
  Future<void> call(CacheEntry entry) async {
    await repository.put(entry);
  }
}
