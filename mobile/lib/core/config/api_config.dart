import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    // Production / Real Device URL
    const String productionUrl =
        'https://monetra-backend-production-8b0d.up.railway.app/api';

    // Uncomment this to force using production server even in debug mode
    return productionUrl;

    if (kReleaseMode) {
      return productionUrl;
    }

    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    }

    // Check for Desktop platforms
    if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return 'http://127.0.0.1:8000/api';
    }

    // Android Emulator
    return 'http://10.0.2.2:8000/api';
  }

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
