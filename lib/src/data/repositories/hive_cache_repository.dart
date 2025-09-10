import '../../domain/entities/cache_entry.dart';
import '../../domain/repositories/cache_repository.dart';
import '../datasources/hive_data_source.dart';

/// Implementation of CacheRepository using Hive.
/// การนำ CacheRepository ไปใช้จริงโดยใช้ Hive
class HiveCacheRepository implements CacheRepository {
  final HiveDataSource _dataSource;

  /// Constructor for HiveCacheRepository.
  /// - [_dataSource]: The Hive data source.
  HiveCacheRepository(this._dataSource);

  @override
  Future<CacheEntry?> get(String key) async {
    return await _dataSource.get(key);
  }

  @override
  Future<void> put(CacheEntry entry) async {
    await _dataSource.put(entry);
  }

  @override
  Future<void> delete(String key) async {
    await _dataSource.delete(key);
  }

  @override
  Future<void> clear() async {
    await _dataSource.clear();
  }

  @override
  Future<List<CacheEntry>> getAll() async {
    return await _dataSource.getAll();
  }

  @override
  Future<bool> containsKey(String key) async {
    return await _dataSource.containsKey(key);
  }
}
