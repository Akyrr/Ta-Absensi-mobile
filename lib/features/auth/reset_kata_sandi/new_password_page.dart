import 'package:flutter/material.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/helpers/navigation_helper.dart';
import '../pages/login_page.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onTextChanged);
    _confirmController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  bool get _hasMin8Chars => _passwordController.text.length >= 8;
  bool get _hasUpperAndLower =>
      _passwordController.text.contains(RegExp(r'[a-z]')) &&
      _passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => _passwordController.text.contains(RegExp(r'[0-9]'));

  bool get _isPasswordValid =>
      _hasMin8Chars && _hasUpperAndLower && _hasNumber;

  bool get _isMismatch {
    if (_confirmController.text.isEmpty) return false;
    return _passwordController.text != _confirmController.text;
  }

  bool get _isMatching =>
      _confirmController.text.isNotEmpty &&
      _passwordController.text == _confirmController.text;

  String get _strengthLabel {
    if (_passwordController.text.isEmpty) return 'Belum diisi';
    var score = 0;
    if (_hasMin8Chars) score++;
    if (_hasUpperAndLower) score++;
    if (_hasNumber) score++;

    if (score == 1) return 'Lemah';
    if (score == 2) return 'Sedang';
    if (score == 3) return 'Kuat';
    return 'Belum diisi';
  }

  int get _strengthSegments {
    if (_passwordController.text.isEmpty) return 0;
    var score = 0;
    if (_hasMin8Chars) score++;
    if (_hasUpperAndLower) score++;
    if (_hasNumber) score++;
    return score;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Kata sandi baru\ntelah di ubah',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF5271FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      NavigationHelper.pushAndRemoveAll(
                        context,
                        const LoginPage(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5271FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Kembali ke login',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _fillSampleMismatch() {
    _passwordController.text = 'Admin123';
    _confirmController.text = 'Admin456';
  }

  void _fillSampleValid() {
    _passwordController.text = 'SmkJuara2026';
    _confirmController.text = 'SmkJuara2026';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              _buildTopBar(context),
              const SizedBox(height: 24),
              _buildMainCard(),
              const SizedBox(height: 16),
              _buildDemoBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => NavigationHelper.pop(context),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 20,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF232635),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.menu_book_rounded,
            size: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildMainCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Kata Sandi Baru',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Buat Kata Sandi Baru',
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Kata Sandi Baru',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: const TextStyle(
                fontSize: 14,
                letterSpacing: 2,
                color: AppColors.primaryDark,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
                ),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Konfirmasi kata sandi baru',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isMismatch
                    ? const Color(0xFFEF4444)
                    : const Color(0xFFE5E7EB),
                width: _isMismatch ? 1.5 : 1.0,
              ),
            ),
            child: TextField(
              controller: _confirmController,
              obscureText: _obscureConfirm,
              style: TextStyle(
                fontSize: 14,
                letterSpacing: _confirmController.text.isNotEmpty ? 2 : 0,
                color: _isMismatch ? const Color(0xFFDC2626) : AppColors.primaryDark,
              ),
              decoration: InputDecoration(
                hintText: 'Ulangi Kata Sandi Baru',
                hintStyle: TextStyle(
                  letterSpacing: 0,
                  fontSize: 13,
                  color: _isMismatch
                      ? const Color(0xFFDC2626).withValues(alpha: 0.8)
                      : AppColors.textMuted,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      _obscureConfirm = !_obscureConfirm;
                    });
                  },
                  child: Icon(
                    _obscureConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: _isMismatch ? const Color(0xFFDC2626) : AppColors.textMuted,
                  ),
                ),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),
            ),
          ),
          if (_isMismatch)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Kata sandi baru tidak sesuai',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kekuatan Kata Sandi',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _strengthLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: _strengthSegments >= 1
                        ? const Color(0xFF3D7B5F)
                        : const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: _strengthSegments >= 2
                        ? const Color(0xFF3D7B5F)
                        : const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: _strengthSegments >= 3
                        ? const Color(0xFF3D7B5F)
                        : const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRequirementItem('Minimal 8 Karakter', _hasMin8Chars),
          const SizedBox(height: 6),
          _buildRequirementItem(
              'Mengandung huruf besar dan kecil', _hasUpperAndLower),
          const SizedBox(height: 6),
          _buildRequirementItem(
              'Mengandung minimal 1 angka', _hasNumber),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: (_isPasswordValid && _isMatching)
                  ? _showSuccessDialog
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                disabledBackgroundColor: const Color(0xFF232232).withValues(alpha: 0.85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Kirim Kode OTP',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: () {
              NavigationHelper.pushAndRemoveAll(context, const LoginPage());
            },
            child: const Text(
              'Kembali ke Halaman Masuk',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
          size: 15,
          color: isMet ? const Color(0xFF3D7B5F) : const Color(0xFF9CA3AF),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 11.5,
            color: isMet ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isMet ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildDemoBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            'Demo Frame:',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          _chip('Frame 1245 (Mismatch)', _fillSampleMismatch),
          _chip('Frame 1240 (Valid)', _fillSampleValid),
          _chip('Frame 1246 (Dialog)', _showSuccessDialog),
        ],
      ),
    );
  }

  Widget _chip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDark,
          ),
        ),
      ),
    );
  }
}
