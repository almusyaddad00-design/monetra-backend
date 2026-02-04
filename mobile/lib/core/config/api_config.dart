import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    }

    // Check for Desktop platforms
    if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return 'http://127.0.0.1:8000/api';
    }

    // Android emulator (default for Android platform)
    return 'http://10.0.2.2:8000/api';
  }

  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
