// lib/features/auth/reset_kata_sandi/forgot_password_page.dart

import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/constants/app_color.dart';
import '../../../core/utils/auth_utils.dart';
import '../../../services/auth_service.dart';
import '../widgets/auth_widgets.dart';
import 'otp_verification_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailCtrl = TextEditingController();
  String? _fieldError;
  String? _serverError;
  bool _loading = false;
  bool _sent = false;
  int _cooldown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCooldown(AuthService.remainingCooldown);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _startCooldown(int seconds) {
    _timer?.cancel();
    setState(() => _cooldown = seconds);
    if (seconds <= 0) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_cooldown <= 1) {
        t.cancel();
        if (mounted) setState(() => _cooldown = 0);
      } else if (mounted) {
        setState(() => _cooldown--);
      }
    });
  }

  String? _validate(String v) {
    if (v.trim().isEmpty) return 'Alamat surel wajib diisi';
    if (!emailRegex.hasMatch(v.trim())) return 'Format surel tidak valid';
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final err = _validate(_emailCtrl.text);
    if (err != null) {
      setState(() => _fieldError = err);
      return;
    }
    setState(() {
      _fieldError = null;
      _serverError = null;
      _loading = true;
    });
    try {
      await AuthService.sendOtp(_emailCtrl.text.trim());
      if (!mounted) return;
      setState(() {
        _sent = true;
        _loading = false;
      });
      _startCooldown(AuthService.cooldown.inSeconds);
    } on RateLimitException {
      if (!mounted) return;
      setState(() => _loading = false);
      _startCooldown(AuthService.remainingCooldown);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _serverError =
            'Kode belum dapat dikirim. Silakan coba lagi beberapa saat lagi.';
      });
    }
  }

  void _goVerify() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpVerificationPage(email: _emailCtrl.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rateLimited = _cooldown > 0 && !_sent;

    return AuthShell(
      below: const Text(
        'Pastikan email Anda aktif dan dapat diakses.\nPeriksa kotak masuk atau folder spam.',
        textAlign: TextAlign.center,
        style:
            TextStyle(fontSize: 12, height: 1.5, color: AppColors.textTertiary),
      ),
      card: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(
            icon: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.mail_outline,
                    size: 20, color: AppColors.brandPrimary),
                SizedBox(width: 10),
                Icon(Icons.shield_outlined,
                    size: 20, color: AppColors.brandPrimary),
                SizedBox(width: 10),
                Icon(Icons.verified_user_outlined,
                    size: 20, color: AppColors.textDisabled),
              ],
            ),
            title: 'Lupa Kata Sandi?',
            subtitle:
                'Masukkan surel yang terdaftar pada akun Anda.\nKami akan mengirimkan kode OTP verifikasi.',
          ),
          const SizedBox(height: 20),
          const FieldLabel('Surel terdaftar'),
          TextField(
            controller: _emailCtrl,
            enabled: !_loading && !_sent,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            onChanged: (_) {
              if (_fieldError != null) setState(() => _fieldError = null);
            },
            decoration: fieldDecoration(
              hint: 'Masukkan surel terdaftar',
              error: _fieldError != null,
            ),
          ),
          if (_fieldError != null) FieldError(_fieldError!),
          const SizedBox(height: 12),
          if (rateLimited)
            InfoBanner(
              type: BannerType.warn,
              text:
                  'Terlalu sering meminta kode. Tunggu 1 menit sebelum mencoba lagi.',
              trailing: Text(
                formatTime(_cooldown),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.statusWarning,
                ),
              ),
            ),
          if (_sent)
            const InfoBanner(
              type: BannerType.success,
              text:
                  'Jika surel terdaftar di sistem, kode verifikasi telah dikirimkan ke surel Anda.',
            ),
          if (_serverError != null)
            InfoBanner(type: BannerType.error, text: _serverError!),
          const SizedBox(height: 24),
          if (_sent)
            PrimaryButton(label: 'Lanjutkan Verifikasi', onPressed: _goVerify)
          else
            PrimaryButton(
              label: _loading ? 'Mengirim kode...' : 'Kirim Kode OTP',
              loading: _loading,
              looksDisabled: rateLimited,
              onPressed: rateLimited ? null : _submit,
            ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => Navigator.maybePop(context),
              child: const Text(
                'Kembali ke Halaman Masuk',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}