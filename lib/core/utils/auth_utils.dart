// lib/core/utils/auth_utils.dart

/// "vincent@gmail.com" -> "v***@gmail.com"
String maskEmail(String email) {
  final parts = email.split('@');
  if (parts.length != 2 || parts[0].isEmpty) return email;
  return '${parts[0][0]}***@${parts[1]}';
}

/// 58 -> "00:58"
String formatTime(int seconds) {
  final m = (seconds ~/ 60).toString().padLeft(2, '0');
  final s = (seconds % 60).toString().padLeft(2, '0');
  return '$m:$s';
}

final RegExp emailRegex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');