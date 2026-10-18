import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();

  /// Mengembalikan body response dari server.
  /// Cek `body['code']` untuk percabangan (jangan pakai `message`).
  static Future<Map<String, dynamic>> login(
      String identifier, String password) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.auth}/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'identifier': identifier,
        'password': password,
        'device_info': 'Flutter App',
      }),
    );

    final body = jsonDecode(res.body) as Map<String, dynamic>;

    if (body['success'] == true) {
      final data = body['data'] as Map<String, dynamic>;
      await _storage.write(key: 'access_token', value: data['access_token']);
      await _storage.write(key: 'refresh_token', value: data['refresh_token']);
    }
    return body;
  }
}