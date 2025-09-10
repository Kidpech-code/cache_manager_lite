import 'package:dio/dio.dart';
import '../../domain/entities/cache_entry.dart';
import '../../domain/entities/cache_policy.dart';
import '../../domain/usecases/get_cache_use_case.dart';
import '../../domain/usecases/put_cache_use_case.dart';
import '../../utils/encryption_utils.dart';

/// Dio interceptor for automatic caching.
/// Interceptor ของ Dio สำหรับการแคชอัตโนมัติ
class DioCacheInterceptor extends Interceptor {
  final GetCacheUseCase _getCacheUseCase;
  final PutCacheUseCase _putCacheUseCase;
  final CachePolicy? defaultPolicy;

  /// Constructor for DioCacheInterceptor.
  /// - [_getCacheUseCase]: Use case for getting cache.
  /// - [_putCacheUseCase]: Use case for putting cache.
  /// - [defaultPolicy]: Default caching policy.
  DioCacheInterceptor(
    this._getCacheUseCase,
    this._putCacheUseCase, {
    this.defaultPolicy,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check if request should be cached
    // ตรวจสอบว่าคำขอควรถูกแคชหรือไม่
    if (_shouldCache(options)) {
      final key = _generateKey(options);
      final cached = await _getCacheUseCase(key);
      if (cached != null && !cached.isExpired) {
        // Return cached response
        // ส่งคืนการตอบสนองที่แคชไว้
        final response = Response(
          requestOptions: options,
          data: _decryptIfNeeded(cached.value, cached.isEncrypted),
          statusCode: 200,
        );
        handler.resolve(response);
        return;
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Cache the response if it should be cached
    // แคชการตอบสนองหากควรถูกแคช
    if (_shouldCache(response.requestOptions)) {
      final key = _generateKey(response.requestOptions);
      final policy = defaultPolicy ?? CachePolicy(maxAge: Duration(hours: 1));
      final entry = CacheEntry(
        key: key,
        value: _encryptIfNeeded(response.data, policy),
        createdAt: DateTime.now(),
        expiresAt: policy.expiresAt,
        isEncrypted: policy.encryptionKey != null,
      );
      await _putCacheUseCase(entry);
    }
    super.onResponse(response, handler);
  }

  /// Determines if the request should be cached.
  /// กำหนดว่าคำขอควรถูกแคชหรือไม่
  bool _shouldCache(RequestOptions options) {
    // Cache GET requests only
    // แคชเฉพาะคำขอ GET
    return options.method == 'GET';
  }

  /// Generates a cache key from request options.
  /// สร้างคีย์แคชจากตัวเลือกคำขอ
  String _generateKey(RequestOptions options) {
    return 'dio_${options.method}_${options.uri}';
  }

  /// Encrypts data if needed.
  /// เข้ารหัสข้อมูลหากจำเป็น
  dynamic _encryptIfNeeded(dynamic data, CachePolicy? policy) {
    if (policy?.encryptionKey != null) {
      final jsonString = data.toString();
      return EncryptionUtils.encryptData(jsonString, policy!.encryptionKey!);
    }
    return data;
  }

  /// Decrypts data if needed.
  /// ถอดรหัสข้อมูลหากจำเป็น
  dynamic _decryptIfNeeded(dynamic data, bool isEncrypted) {
    if (isEncrypted && data is String && defaultPolicy?.encryptionKey != null) {
      return EncryptionUtils.decryptData(data, defaultPolicy!.encryptionKey!);
    }
    return data;
  }
}
