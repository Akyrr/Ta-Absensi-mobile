import 'package:flutter/material.dart';

/// Official HADIRA Color Palette
class AppColors {
  // ── Brand ──
  static const Color brandDark = Color(0xFF282333);
  static const Color brandMedium = Color(0xFF514857);
  static const Color brandLight = Color(0xFF807583);

  // ── Background ──
  static const Color bgScaffold = Color(0xFFF5EFEF);
  static const Color bgSurface = Color(0xFFFFFFFF);
  static const Color bgSoft = Color(0xFFF9F5F5);

  // ── Teks ──
  static const Color textPrimary = Color(0xFF282333);
  static const Color textSecondary = Color(0xFF514857);
  static const Color textMuted = Color(0xFF807583);
  static const Color textDisabled = Color(0xFFC4BDC5);
  static const Color textWhite = Color(0xFFFFFFFF);

  // ── Garis / Borders ──
  static const Color borderLight = Color(0xFFD1C7D1);
  static const Color borderMedium = Color(0xFFB1A8B2);
  static const Color borderDark = Color(0xFF514857);

  // ── Status (H/I/A/S) ──
  static const Color statusSuccess = Color(0xFF4F7A64); // Hadir
  static const Color statusWarning = Color(0xFFA47745); // Izin / Rate Limit
  static const Color statusDanger = Color(0xFFA05252);  // Alpa / Error
  static const Color statusInfo = Color(0xFF5C718A);    // Sakit

  // ── Latar Status ──
  static const Color bgStatusSuccess = Color(0xFFEFF0EB);
  static const Color bgStatusWarning = Color(0xFFF4EDE3);
  static const Color bgStatusDanger = Color(0xFFF4E7E7);
  static const Color bgStatusInfo = Color(0xFFE9EEF2);

  // Backward compatibility aliases
  static const Color primaryDark = brandDark;
  static const Color primaryNavy = brandDark;
  static const Color primaryLight = brandMedium;
  static const Color accentBlue = statusInfo;
  static const Color brandBlue = statusInfo;
  static const Color lightBlueBg = bgStatusInfo;
  static const Color background = bgScaffold;
  static const Color surface = bgSurface;
  static const Color cardBorder = borderLight;
  static const Color inputBorder = borderMedium;
  static const Color inputFocused = brandDark;
  static const Color inputBg = bgSurface;
  static const Color textHint = textDisabled;
  static const Color success = statusSuccess;
  static const Color successPrimary = statusSuccess;
  static const Color successBg = bgStatusSuccess;
  static const Color successBorder = borderLight;
  static const Color successText = statusSuccess;
  static const Color warning = statusWarning;
  static const Color warningBg = bgStatusWarning;
  static const Color warningBorder = borderLight;
  static const Color warningText = statusWarning;
  static const Color danger = statusDanger;
  static const Color dangerLight = statusDanger;
  static const Color dangerBg = bgStatusDanger;
  static const Color dangerBorder = borderLight;
  static const Color dangerText = statusDanger;

  // Attendance status mapping
  static const Color hadir = statusSuccess;
  static const Color izin = statusWarning;
  static const Color alpa = statusDanger;
  static const Color sakit = statusInfo;
}
