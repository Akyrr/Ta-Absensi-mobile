import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

// Dipertahankan agar halaman lupa password yang sudah ada tetap bisa dikompilasi.
enum OtpResult { success, invalid, expired }

/// Terlalu sering meminta OTP.
/// [code]: `OTP_RESEND_TOO_SOON` (cooldown 60 dtk), `OTP_RESEND_LIMIT`
/// (maks 5 kali/jam), atau `RATE_LIMITED` (batas per-IP).
class RateLimitException implements Exception {
  final String code;
  RateLimitException([this.code = 'RATE_LIMITED']);
}

/// Error dari backend. Branching pakai [code], jangan [message].
/// Untuk `VALIDATION_ERROR`, rincian ada di [errors].
class AuthException implements Exception {
  final String code;
  final String message;
  final List<String> errors;
  AuthException(this.code, this.message, [this.errors = const []]);

  @override
  String toString() => 'AuthException($code): $message';
}

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _headers = {'Content-Type': 'application/json'};

  static Map<String, dynamic> _decode(http.Response res) =>
      jsonDecode(res.body) as Map<String, dynamic>;

  // ============================================================
  // LOGIN
  // ============================================================
  /// Mengembalikan body response dari server.
  /// Cek `body['code']` untuk percabangan (jangan pakai `message`).
  static Future<Map<String, dynamic>> login(
      String identifier, String password) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.auth}/login'),
      headers: _headers,
      body: jsonEncode({
        'identifier': identifier,
        'password': password,
        'device_info': 'Flutter App',
      }),
    );

    final body = _decode(res);

    if (body['success'] == true) {
      final data = body['data'] as Map<String, dynamic>;
      await _storage.write(key: 'access_token', value: data['access_token']);
      await _storage.write(key: 'refresh_token', value: data['refresh_token']);
    }
    return body;
  }

  // ============================================================
  // REGISTRASI SISWA
  // Sukses: `AUTH_REGISTER_SUCCESS` (201), data = user (tanpa token).
  // Gagal : `CONFLICT`, `VALIDATION_ERROR` (lihat body['errors']), `RATE_LIMITED`.
  // ============================================================
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String nisn,
    required String password,
    String? username,
  }) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.auth}/register'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'email': email,
        'nisn': nisn,
        'password': password,
        if (username != null && username.isNotEmpty) 'username': username,
      }),
    );
    return _decode(res);
  }

  // ============================================================
  // LUPA PASSWORD (sesuai ENDPOINTS.md backend)
  //
  //   POST /forgot-password          { email }
  //   POST /forgot-password/resend   { email }
  //   POST /forgot-password/verify   { email, code, new_password }
  //
  // Backend tidak punya endpoint "verifikasi OTP saja". Kode OTP
  // diverifikasi bersamaan dengan kata sandi baru di langkah terakhir.
  // Karena itu verifyOtp() di bawah hanya menyimpan kode sementara
  // (tidak memanggil API), lalu resetPassword() mengirimnya.
  // ============================================================
  static const cooldown = Duration(seconds: 60);
  static const otpLength = 6; // backend: kode OTP tepat 8 karakter
  static DateTime? _lastSent;
  static String? _pendingCode;

  /// Sisa detik cooldown sebelum boleh minta OTP lagi.
  static int get remainingCooldown {
    if (_lastSent == null) return 0;
    final left =
        cooldown.inSeconds - DateTime.now().difference(_lastSent!).inSeconds;
    return left > 0 ? left : 0;
  }

  static Future<void> _requestOtp(String path, String email) async {
    if (remainingCooldown > 0) throw RateLimitException('OTP_RESEND_TOO_SOON');

    final res = await http.post(
      Uri.parse('${ApiConfig.auth}/$path'),
      headers: _headers,
      body: jsonEncode({'email': email}),
    );
    final body = _decode(res);
    final code = (body['code'] ?? '').toString();

    if (code == 'OTP_RESEND_TOO_SOON' ||
        code == 'OTP_RESEND_LIMIT' ||
        code == 'RATE_LIMITED' ||
        res.statusCode == 429) {
      throw RateLimitException(code.isEmpty ? 'RATE_LIMITED' : code);
    }
    if (body['success'] != true) {
      throw AuthException(
        code.isEmpty ? 'SEND_OTP_FAILED' : code,
        (body['message'] ?? 'Kode belum dapat dikirim.').toString(),
        _errorList(body),
      );
    }
    _lastSent = DateTime.now();
  }

  /// Minta OTP reset password. Respons backend selalu sama, baik email
  /// terdaftar maupun tidak (anti-enumerasi).
  static Future<void> sendOtp(String email) => _requestOtp('forgot-password', email);

  /// Kirim ulang OTP reset password.
  static Future<void> resendOtp(String email) =>
      _requestOtp('forgot-password/resend', email);

  /// Menyimpan kode OTP sementara (TIDAK memanggil API).
  /// Kode yang benar-benar diperiksa backend saat [resetPassword].
  static Future<OtpResult> verifyOtp(String email, String code) async {
    _pendingCode = code.trim();
    return _pendingCode!.length == otpLength
        ? OtpResult.success
        : OtpResult.invalid;
  }

  /// Verifikasi OTP + simpan kata sandi baru dalam satu panggilan.
  /// Melempar [AuthException] dengan `code` salah satu dari:
  ///   OTP_INVALID, OTP_EXPIRED, OTP_TOO_MANY_ATTEMPTS, VALIDATION_ERROR, ...
  static Future<void> resetPassword(String email, String newPassword) async {
    final code = _pendingCode;
    if (code == null || code.isEmpty) {
      throw AuthException('OTP_INVALID', 'Kode OTP belum diisi.');
    }

    final res = await http.post(
      Uri.parse('${ApiConfig.auth}/forgot-password/verify'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'code': code,
        'new_password': newPassword,
      }),
    );
    final body = _decode(res);

    if (body['code'] != 'AUTH_PASSWORD_CHANGED') {
      final c = (body['code'] ?? 'RESET_PASSWORD_FAILED').toString();
      if (c == 'RATE_LIMITED') throw RateLimitException(c);
      throw AuthException(
        c,
        (body['message'] ?? 'Gagal mengubah kata sandi.').toString(),
        _errorList(body),
      );
    }

    // Semua sesi lama dicabut oleh backend -> bersihkan token lokal.
    _pendingCode = null;
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  static List<String> _errorList(Map<String, dynamic> body) {
    final e = body['errors'];
    return e is List ? e.map((x) => x.toString()).toList() : const [];
  }
}