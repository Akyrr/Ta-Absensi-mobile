import 'package:flutter/foundation.dart';

class ApiConfig {
  // Android emulator memakai 10.0.2.2 untuk menjangkau laptop.
  // Kalau pakai HP asli, ganti dengan IP laptop, contoh: 'http://192.168.1.5:8080'
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://localhost:8080';
  }

  static const String authPrefix = '/api/v1/auth';

  static String get auth => '$baseUrl$authPrefix';
}