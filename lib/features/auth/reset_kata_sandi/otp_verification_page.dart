// lib/features/auth/reset_kata_sandi/otp_verification_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_color.dart';
import '../../../core/utils/auth_utils.dart';
import '../../../services/auth_service.dart';
import '../widgets/auth_widgets.dart';
import 'new_password_page.dart';

enum OtpError { none, incomplete, invalid, expired, locked }

class OtpVerificationPage extends StatefulWidget {
  final String email;
  const OtpVerificationPage({super.key, required this.email});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  static const _length = 6;
  static const _maxAttempts = 3;

  final _ctrl = TextEditingController();
  final _focus = FocusNode();

  int _attempts = _maxAttempts;
  OtpError _error = OtpError.none;
  bool _loading = false;
  bool _verified = false;

  int _resendIn = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final left = AuthService.remainingCooldown;
    _startResendTimer(left > 0 ? left : AuthService.cooldown.inSeconds);
    _focus.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _startResendTimer(int seconds) {
    _timer?.cancel();
    setState(() => _resendIn = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendIn <= 1) {
        t.cancel();
        if (mounted) setState(() => _resendIn = 0);
      } else if (mounted) {
        setState(() => _resendIn--);
      }
    });
  }

  String get _code => _ctrl.text;
  bool get _locked => _error == OtpError.locked;

  Future<void> _verify() async {
    if (_code.length < _length) {
      setState(() => _error = OtpError.incomplete);
      return;
    }
    setState(() => _loading = true);
    final result = await AuthService.verifyOtp(widget.email, _code);
    if (!mounted) return;

    switch (result) {
      case OtpResult.success:
        setState(() {
          _loading = false;
          _verified = true;
          _error = OtpError.none;
        });
        _focus.unfocus();
        await Future.delayed(const Duration(milliseconds: 1200));
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => NewPasswordPage(email: widget.email),
          ),
        );
      case OtpResult.invalid:
        _attempts--;
        setState(() {
          _loading = false;
          _error = _attempts <= 0 ? OtpError.locked : OtpError.invalid;
        });
      case OtpResult.expired:
        _ctrl.clear();
        setState(() {
          _loading = false;
          _error = OtpError.expired;
        });
    }
  }

  Future<void> _resend() async {
    try {
      await AuthService.sendOtp(widget.email);
    } on RateLimitException {
      _startResendTimer(AuthService.remainingCooldown);
      return;
    }
    if (!mounted) return;
    _ctrl.clear();
    setState(() {
      _attempts = _maxAttempts;
      _error = OtpError.none;
    });
    _startResendTimer(AuthService.cooldown.inSeconds);
    _focus.requestFocus();
  }

  Widget? _errorBanner() {
    switch (_error) {
      case OtpError.incomplete:
        return const InfoBanner(
          type: BannerType.error,
          text: 'Masukkan 6 karakterkode OTP secara lengkap',
        );
      case OtpError.invalid:
        return const InfoBanner(
          type: BannerType.error,
          text: 'Kode OTP tidak valid. Silakan periksa kembali.',
        );
      case OtpError.expired:
        return const InfoBanner(
          type: BannerType.warn,
          text: 'Kode OTP telah kedaluwarsa. Silakan minta kode baru',
        );
      case OtpError.locked:
        return const InfoBanner(
          type: BannerType.error,
          text: 'Batas percobaan habis. Silakan kirim ulang kode baru',
        );
      case OtpError.none:
        return _verified
            ? const InfoBanner(
                type: BannerType.success,
                text: 'Verifikasi berhasil. Email Anda telah terverifikasi.',
              )
            : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _resendIn == 0 && !_verified;
    final banner = _errorBanner();

    return AuthShell(
      below: Column(
        children: [
          Text(
            _verified ? 'Akun Anda siap digunakan.' : 'Belum menerima kode?',
            style: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
          ),
          if (banner != null) ...[const SizedBox(height: 12), banner],
        ],
      ),
      card: Column(
        children: [
          const CardHeader(
            icon: Icon(
              Icons.mail_outline,
              size: 22,
              color: AppColors.brandPrimary,
            ),
            title: 'Verifikasi Kode',
            subtitle:
                'Masukkan kode 6 karakter yang telah kami kirimkan\nke surel Anda.',
          ),
          const SizedBox(height: 6),
          Text(
            maskEmail(widget.email),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          _otpBoxes(),
          const SizedBox(height: 14),
          Text(
            _verified
                ? 'surel berhasil diverifikasi'
                : 'Sisa percobaan: ${_attempts.clamp(0, 3)} kali',
            style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: _verified ? 'Terverifikasi' : 'Verifikasi',
            color: _verified ? AppColors.statusSuccess : null,
            loading: _loading,
            looksDisabled: !_verified && (_code.length < _length || _locked),
            onPressed: (_verified || _locked) ? null : _verify,
          ),
          const SizedBox(height: 14),
          Text(
            _verified
                ? 'Kode OTP berhasil dikonfirmasi'
                : (canResend
                      ? 'Anda dapat meminta kode baru.'
                      : 'Kirim ulang kode dalam ${formatTime(_resendIn)}'),
            style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: canResend ? _resend : null,
            child: Text(
              _verified ? 'Tidak perlu kirim ulang kode' : 'Kirim Ulang Kode',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: canResend
                    ? AppColors.textPrimary
                    : AppColors.textDisabled,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 6 kotak tampilan + 1 TextField tersembunyi (mendukung paste & autofill OTP).
  Widget _otpBoxes() {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => _focus.requestFocus(),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_length, (i) {
              final filled = i < _code.length;
              final isCurrent =
                  _focus.hasFocus &&
                  i == _code.length.clamp(0, _length - 1) &&
                  !_verified;

              Color border = AppColors.borderPrimary;
              if (_verified) {
                border = AppColors.statusSuccess;
              } else if (_error == OtpError.invalid ||
                  _error == OtpError.locked) {
                border = AppColors.statusError;
              } else if (isCurrent) {
                border = AppColors.brandPrimary;
              }

              return Container(
                width: 40,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: border,
                    width: isCurrent || _verified ? 1.5 : 1,
                  ),
                ),
                child: filled
                    ? Text(
                        _code[i],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      )
                    : (isCurrent
                          ? Container(
                              width: 1.5,
                              height: 20,
                              color: AppColors.brandPrimary,
                            )
                          : null),
              );
            }),
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0,
            child: TextField(
              controller: _ctrl,
              focusNode: _focus,
              enabled: !_verified && !_locked && !_loading,
              keyboardType: TextInputType.visiblePassword,
              textCapitalization: TextCapitalization.characters,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                UpperCaseTextFormatter(),
                LengthLimitingTextInputFormatter(_length),
              ],
              onChanged: (_) => setState(() {
                if (_error == OtpError.invalid ||
                    _error == OtpError.incomplete) {
                  _error = OtpError.none;
                }
              }),
            ),
          ),
        ),
      ],
    );
  }
}


class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}