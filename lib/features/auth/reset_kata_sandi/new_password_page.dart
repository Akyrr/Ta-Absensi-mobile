// lib/features/auth/reset_kata_sandi/new_password_page.dart

import 'package:flutter/material.dart';

import '../../../core/constants/app_color.dart';
import '../pages/login_page.dart'; // sesuaikan nama class (di sini diasumsikan LoginPage)
import '../../../services/auth_service.dart';
import '../widgets/auth_widgets.dart';

class NewPasswordPage extends StatefulWidget {
  final String email;
  const NewPasswordPage({super.key, required this.email});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _showPass = false;
  bool _showConfirm = false;
  bool _loading = false;
  String? _passError;
  String? _confirmError;

  String get _pass => _passCtrl.text;

  bool get _hasLength => _pass.length >= 8;
  bool get _hasCase =>
      RegExp(r'[a-z]').hasMatch(_pass) && RegExp(r'[A-Z]').hasMatch(_pass);
  bool get _hasNumber => RegExp(r'\d').hasMatch(_pass);
  int get _score => [_hasLength, _hasCase, _hasNumber].where((e) => e).length;
  bool get _allValid => _score == 3;

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    String? pe;
    String? ce;
    if (_pass.isEmpty) {
      pe = 'Kata sandi baru wajib diisi';
    } else if (!_allValid) {
      pe = 'Kata sandi belum memenuhi persyaratan';
    }
    if (_confirmCtrl.text.isEmpty) {
      ce = 'Konfirmasi kata sandi wajib diisi';
    } else if (_confirmCtrl.text != _pass) {
      ce = 'Konfirmasi kata sandi tidak sesuai';
    }
    setState(() {
      _passError = pe;
      _confirmError = ce;
    });
    if (pe != null || ce != null) return;

    setState(() => _loading = true);
    await AuthService.resetPassword(widget.email, _pass);
    if (!mounted) return;
    setState(() => _loading = false);
    _showSuccess();
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 64, color: AppColors.statusSuccess),
              const SizedBox(height: 16),
              const Text(
                'Kata sandi baru telah diubah',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Kembali ke login',
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _goToLogin();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      card: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Kata Sandi Baru',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text(
              'Buat kata sandi baru',
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
            ),
          ),
          const SizedBox(height: 20),
          const FieldLabel('Kata sandi baru'),
          TextField(
            controller: _passCtrl,
            obscureText: !_showPass,
            onChanged: (_) => setState(() => _passError = null),
            decoration: fieldDecoration(
              hint: 'Masukkan kata sandi baru',
              error: _passError != null,
              suffix: IconButton(
                icon: Icon(
                  _showPass
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: AppColors.textTertiary,
                ),
                onPressed: () => setState(() => _showPass = !_showPass),
              ),
            ),
          ),
          if (_passError != null) FieldError(_passError!),
          const SizedBox(height: 14),
          const FieldLabel('Konfirmasi kata sandi baru'),
          TextField(
            controller: _confirmCtrl,
            obscureText: !_showConfirm,
            onChanged: (_) => setState(() => _confirmError = null),
            decoration: fieldDecoration(
              hint: 'Ulangi kata sandi baru',
              error: _confirmError != null,
              suffix: IconButton(
                icon: Icon(
                  _showConfirm
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: AppColors.textTertiary,
                ),
                onPressed: () => setState(() => _showConfirm = !_showConfirm),
              ),
            ),
          ),
          if (_confirmError != null) FieldError(_confirmError!),
          const SizedBox(height: 16),
          _strengthMeter(),
          const SizedBox(height: 10),
          _rule('Minimal 8 karakter', _hasLength),
          _rule('Mengandung huruf besar dan kecil', _hasCase),
          _rule('Mengandung minimal 1 angka', _hasNumber),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Simpan Kata Sandi',
            loading: _loading,
            onPressed: _submit,
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: _goToLogin,
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

  Widget _strengthMeter() {
    final label = _pass.isEmpty
        ? 'Belum diisi'
        : ['Lemah', 'Lemah', 'Sedang', 'Kuat'][_score];
    final color = _score == 3
        ? AppColors.statusSuccess
        : (_score == 2 ? AppColors.statusWarning : AppColors.statusError);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kekuatan Kata Sandi',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textTertiary)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: List.generate(3, (i) {
            final active = _pass.isNotEmpty && i < _score;
            return Expanded(
              child: Container(
                height: 3,
                margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                decoration: BoxDecoration(
                  color: active ? color : AppColors.borderPrimary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _rule(String text, bool ok) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: ok ? AppColors.statusSuccess : AppColors.textDisabled,
          ),
          const SizedBox(width: 8),
          Text(text,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}