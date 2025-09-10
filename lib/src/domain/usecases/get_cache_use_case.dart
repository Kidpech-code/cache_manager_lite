import '../entities/cache_entry.dart';
import '../repositories/cache_repository.dart';

/// Use case for retrieving a cache entry.
/// กรณีการใช้งานสำหรับการดึงรายการแคช
class GetCacheUseCase {
  final CacheRepository repository;

  /// Constructor for GetCacheUseCase.
  /// - [repository]: The cache repository to use.
  GetCacheUseCase(this.repository);

  /// Executes the use case to get a cache entry by key.
  /// ดำเนินการกรณีการใช้งานเพื่อรับรายการแคชโดยคีย์
  Future<CacheEntry?> call(String key) async {
    return await repository.get(key);
  }
}
