
import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const Color brandPrimary = Color(0xFF282333);
  static const Color brandSecondary = Color(0xFF514857);
  static const Color brandTertiary = Color(0xFF807583);

  // Background
  static const Color backgroundPrimary = Color(0xFFF5EFEF);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF9F5F5);

  // Text
  static const Color textPrimary = Color(0xFF282333);
  static const Color textSecondary = Color(0xFF514857);
  static const Color textTertiary = Color(0xFF807583);
  static const Color textDisabled = Color(0xFFC4BDC5);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Border / Garis
  static const Color borderPrimary = Color(0xFFD1C7D1);
  static const Color borderSecondary = Color(0xFFB1A8B2);
  static const Color borderStrong = Color(0xFF514857);

  // Status
  static const Color statusSuccess = Color(0xFF4F7A64);
  static const Color statusWarning = Color(0xFFA47745);
  static const Color statusError = Color(0xFFA05252);
  static const Color statusInfo = Color(0xFF5C718A);

  // Background Status
  static const Color statusBackgroundSuccess = Color(0xFFEFF0EB);
  static const Color statusBackgroundWarning = Color(0xFFF4EDE3);
  static const Color statusBackgroundError = Color(0xFFF4E7E7);
  static const Color statusBackgroundInfo = Color(0xFFE9EEF2);

    // ── Alias dari versi Aziz (agar halaman reset password, OTP, dll. jalan) ──

  // Brand
  static const Color brandDark = brandPrimary;
  static const Color brandMedium = brandSecondary;
  static const Color brandLight = brandTertiary;

  // Background
  static const Color bgScaffold = backgroundPrimary;
  static const Color bgSurface = backgroundWhite;
  static const Color bgSoft = backgroundSecondary;

  // Teks
  static const Color textMuted = textTertiary;

  // Border
  static const Color borderLight = borderPrimary;
  static const Color borderMedium = borderSecondary;
  static const Color borderDark = borderStrong;

  // Status
  static const Color statusDanger = statusError;

  // Latar status
  static const Color bgStatusSuccess = statusBackgroundSuccess;
  static const Color bgStatusWarning = statusBackgroundWarning;
  static const Color bgStatusDanger = statusBackgroundError;
  static const Color bgStatusInfo = statusBackgroundInfo;

  // Backward compatibility (dipakai halaman Aziz)
  static const Color primaryDark = brandPrimary;
  static const Color primaryNavy = brandPrimary;
  static const Color primaryLight = brandSecondary;
  static const Color accentBlue = statusInfo;
  static const Color brandBlue = statusInfo;
  static const Color lightBlueBg = statusBackgroundInfo;
  static const Color background = backgroundPrimary;
  static const Color surface = backgroundWhite;
  static const Color cardBorder = borderPrimary;
  static const Color inputBorder = borderSecondary;
  static const Color inputFocused = brandPrimary;
  static const Color inputBg = backgroundWhite;
  static const Color textHint = textDisabled;
  static const Color success = statusSuccess;
  static const Color successPrimary = statusSuccess;
  static const Color successBg = statusBackgroundSuccess;
  static const Color successBorder = borderPrimary;
  static const Color successText = statusSuccess;
  static const Color warning = statusWarning;
  static const Color warningBg = statusBackgroundWarning;
  static const Color warningBorder = borderPrimary;
  static const Color warningText = statusWarning;
  static const Color danger = statusError;
  static const Color dangerLight = statusError;
  static const Color dangerBg = statusBackgroundError;
  static const Color dangerBorder = borderPrimary;
  static const Color dangerText = statusError;

  // Status kehadiran
  static const Color hadir = statusSuccess;
  static const Color izin = statusWarning;
  static const Color alpa = statusError;
  static const Color sakit = statusInfo;
}
