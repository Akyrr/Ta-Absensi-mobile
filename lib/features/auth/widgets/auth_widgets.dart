// lib/features/auth/widgets/auth_widgets.dart

import 'package:flutter/material.dart';
import '../../../core/constants/app_color.dart';

// ============================================================
// SHELL HALAMAN (top bar + kartu putih + footer keamanan)
// ============================================================
class AuthShell extends StatelessWidget {
  final Widget card;
  final Widget? below;
  final bool showBack;

  const AuthShell({
    super.key,
    required this.card,
    this.below,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  _SquareButton(
                    onTap: showBack ? () => Navigator.maybePop(context) : null,
                    child: const Icon(Icons.arrow_back,
                        size: 20, color: AppColors.brandPrimary),
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.brandPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.menu_book_outlined,
                        color: AppColors.textWhite, size: 22),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundWhite,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.borderPrimary),
                        ),
                        child: card,
                      ),
                      if (below != null) ...[
                        const SizedBox(height: 16),
                        below!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_outlined,
                      size: 14, color: AppColors.textTertiary),
                  SizedBox(width: 6),
                  Text(
                    'Jangan bagikan kode OTP kepada siapa pun.',
                    style:
                        TextStyle(fontSize: 11, color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SquareButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _SquareButton({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.backgroundWhite,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(width: 40, height: 40, child: child),
      ),
    );
  }
}

// ============================================================
// HEADER KARTU (ikon + judul + subjudul)
// ============================================================
class CardHeader extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;

  const CardHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.backgroundPrimary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: icon,
        ),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            height: 1.45,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// TOMBOL UTAMA
// ============================================================
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool looksDisabled;
  final Color? color;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.looksDisabled = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bg = looksDisabled
        ? AppColors.textDisabled
        : (color ?? AppColors.brandPrimary);
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          disabledBackgroundColor:
              loading ? AppColors.brandPrimary : AppColors.textDisabled,
          foregroundColor: AppColors.textWhite,
          disabledForegroundColor: AppColors.textWhite,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: loading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textWhite,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(label,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              )
            : Text(
                label,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
      ),
    );
  }
}

// ============================================================
// BANNER INFO (error / warning / success)
// ============================================================
enum BannerType { error, warn, success }

class InfoBanner extends StatelessWidget {
  final BannerType type;
  final String text;
  final Widget? trailing;

  const InfoBanner({
    super.key,
    required this.type,
    required this.text,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final fg = switch (type) {
      BannerType.error => AppColors.statusError,
      BannerType.warn => AppColors.statusWarning,
      BannerType.success => AppColors.statusSuccess,
    };
    final bg = switch (type) {
      BannerType.error => AppColors.statusBackgroundError,
      BannerType.warn => AppColors.statusBackgroundWarning,
      BannerType.success => AppColors.statusBackgroundSuccess,
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: TextStyle(fontSize: 12, height: 1.4, color: fg)),
          if (trailing != null) ...[const SizedBox(height: 4), trailing!],
        ],
      ),
    );
  }
}

// ============================================================
// INPUT FIELD HELPERS
// ============================================================
InputDecoration fieldDecoration({
  required String hint,
  bool error = false,
  Widget? suffix,
}) {
  OutlineInputBorder b(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c, width: w),
      );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 13, color: AppColors.textTertiary),
    isDense: true,
    filled: true,
    fillColor: AppColors.backgroundWhite,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    suffixIcon: suffix,
    enabledBorder:
        b(error ? AppColors.statusError : AppColors.borderPrimary),
    focusedBorder:
        b(error ? AppColors.statusError : AppColors.brandPrimary, 1.5),
    errorBorder: b(AppColors.statusError),
    disabledBorder: b(AppColors.borderPrimary),
  );
}

class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      );
}

class FieldError extends StatelessWidget {
  final String text;
  const FieldError(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          text,
          style: const TextStyle(fontSize: 11, color: AppColors.statusError),
        ),
      );
}