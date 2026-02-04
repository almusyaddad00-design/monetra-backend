import 'package:dio/dio.dart';
import '../config/api_config.dart';

class DioClient {
  final Dio _dio;

  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: const Duration(milliseconds: ApiConfig.connectTimeout),
            receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeout),
            headers: {'Content-Type': 'application/json'},
          ),
        );

  Dio get dio => _dio;

  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }
}
