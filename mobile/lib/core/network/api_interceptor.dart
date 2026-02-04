import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../core/utils/shared_prefs_service.dart';

class ApiInterceptor extends Interceptor {
  final SharedPrefsService _sharedPrefsService;

  ApiInterceptor(this._sharedPrefsService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _sharedPrefsService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized - potentially logout user
    if (err.response?.statusCode == 401) {
      // Logic to trigger logout or refresh token
      // For now, simple logging
      debugPrint('Unauthorized! Token might be expired.');
    }
    super.onError(err, handler);
  }
}
