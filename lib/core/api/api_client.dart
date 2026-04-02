import 'package:dio/dio.dart';

class ApiClient {
  ApiClient({required this.baseUrl}) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            sendTimeout: const Duration(seconds: 20),
            headers: const {'Content-Type': 'application/json'},
          ),
        );

  final Dio _dio;
  String baseUrl;

  void updateBaseUrl(String newBaseUrl) {
    baseUrl = newBaseUrl.trim();
    _dio.options.baseUrl = baseUrl;
  }

  Future<Map<String, dynamic>> get(String path) async {
    final response = await _dio.get(path);
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    throw const FormatException('Unexpected API response format.');
  }
}
