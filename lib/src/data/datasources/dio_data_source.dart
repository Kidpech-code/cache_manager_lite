import 'package:dio/dio.dart';

/// Data source for HTTP requests using Dio.
/// แหล่งข้อมูลสำหรับคำขอ HTTP โดยใช้ Dio
class DioDataSource {
  final Dio _dio;

  /// Constructor for DioDataSource.
  /// - [_dio]: Dio instance to use for requests.
  DioDataSource(this._dio);

  /// Fetches JSON data from a URL.
  /// ดึงข้อมูล JSON จาก URL
  Future<Map<String, dynamic>> getJson(String url) async {
    final response = await _dio.get(url);
    return response.data;
  }

  /// Fetches bytes from a URL.
  /// ดึงไบต์จาก URL
  Future<List<int>> getBytes(String url) async {
    final response = await _dio.get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data;
  }
}
