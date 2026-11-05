import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_color.dart';
import '../../../services/auth_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nisnController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorMessage;

  String get _password => _passwordController.text;

  bool get _hasMinLength => _password.length >= 8;
  bool get _hasUppercase => RegExp(r'[A-Z]').hasMatch(_password);
  bool get _hasLowercase => RegExp(r'[a-z]').hasMatch(_password);
  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_password);

  int get _passwordScore => [
        _hasMinLength,
        _hasUppercase && _hasLowercase,
        _hasNumber,
      ].where((condition) => condition).length;

  String get _passwordStrength {
    if (_password.isEmpty) return 'Belum diisi';
    if (_passwordScore == 3) return 'Kuat';
    if (_passwordScore == 2) return 'Sedang';
    return 'Lemah';
  }

  Color get _passwordStrengthColor {
    if (_passwordScore == 3) return AppColors.statusSuccess;
    if (_passwordScore == 2) return AppColors.statusWarning;
    return AppColors.statusError;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nisnController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Ubah kode error backend menjadi pesan untuk pengguna.
  String _messageFromBody(Map<String, dynamic> body) {
    final code = body['code'];
    switch (code) {
      case 'CONFLICT':
        return 'Surel atau NISN sudah terdaftar. Gunakan data lain atau masuk ke akun Anda.';
      case 'VALIDATION_ERROR':
        final errors = body['errors'];
        if (errors is List && errors.isNotEmpty) {
          return errors.map((e) => e.toString()).join('\n');
        }
        return 'Data yang dimasukkan tidak valid.';
      case 'RATE_LIMITED':
        return 'Terlalu banyak percobaan. Silakan coba lagi nanti.';
      default:
        final message = body['message'];
        return (message is String && message.isNotEmpty)
            ? message
            : 'Terjadi kesalahan saat mendaftar.';
    }
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isSuccess = false;
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) return;
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final body = await AuthService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        nisn: _nisnController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (body['code'] == 'AUTH_REGISTER_SUCCESS') {
        setState(() {
          _isLoading = false;
          _isSuccess = true;
        });

        // Registrasi tidak mengembalikan token, jadi arahkan ke halaman masuk.
        await Future<void>.delayed(const Duration(milliseconds: 1500));
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = _messageFromBody(body);
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Gagal terhubung ke server. Periksa koneksi jaringan Anda.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;

            // Form lebih lebar di layar besar dan tetap nyaman di HP.
            final formWidth = screenWidth >= 700
                ? 520.0
                : (screenWidth - 32).clamp(280.0, 520.0).toDouble();

            return SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (screenHeight - 44).clamp(
                    0.0,
                    double.infinity,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: formWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 28),
                        _buildRegistrationCard(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(
          height: 44,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Tombol Back tetap di posisi semula.
              Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => Navigator.of(context).maybePop(),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 21,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              // Ikon digeser sedikit ke bawah.
              Transform.translate(
                offset: const Offset(0, 68),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.brandPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: AppColors.textWhite,
                    size: 27,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 84),
        Text(
          'Daftar sebagai Siswa',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Lengkapi data diri untuk memulai presensi\n'
          'dan jurnal sekolah.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isSuccess) ...[
              _buildSuccessBanner(),
              const SizedBox(height: 16),
            ],
            if (_errorMessage != null) ...[
              _buildErrorBanner(_errorMessage!),
              const SizedBox(height: 16),
            ],

            _buildLabel('Nama Lengkap'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              style: _fieldTextStyle(),
              decoration: _inputDecoration(
                hint: 'Masukkan nama lengkap',
              ),
              validator: (value) {
                final v = value?.trim() ?? '';
                if (v.isEmpty) {
                  return 'Nama lengkap wajib diisi';
                }
                if (v.length < 2) {
                  return 'Nama minimal 2 karakter';
                }
                if (v.length > 150) {
                  return 'Nama maksimal 150 karakter';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),
            _buildLabel('Surel'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              style: _fieldTextStyle(),
              decoration: _inputDecoration(
                hint: 'Masukkan surel',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Surel wajib diisi';
                }
                if (value.trim().length > 255) {
                  return 'Surel maksimal 255 karakter';
                }
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                    .hasMatch(value.trim())) {
                  return 'Format surel tidak valid';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),
            _buildLabel('NISN'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nisnController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: _fieldTextStyle(),
              decoration: _inputDecoration(
                hint: 'Masukkan 10 digit NISN',
              ).copyWith(counterText: ''),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NISN wajib diisi';
                }
                if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                  return 'NISN harus terdiri dari 10 digit angka';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),
            _buildLabel('Kata Sandi'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              style: _fieldTextStyle(),
              onChanged: (_) {
                setState(() => _isSuccess = false);
                _formKey.currentState?.validate();
              },
              decoration: _inputDecoration(
                hint: 'Masukkan kata sandi',
              ).copyWith(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kata sandi wajib diisi';
                }
                if (value.length < 8) {
                  return 'Kata sandi minimal 8 karakter';
                }
                if (value.length > 72) {
                  return 'Kata sandi maksimal 72 karakter';
                }
                return null;
              },
            ),

            const SizedBox(height: 8),
            _buildPasswordStrength(),
            const SizedBox(height: 6),
            _buildPasswordRequirement(
              'Minimal 8 karakter',
              _hasMinLength,
            ),
            _buildPasswordRequirement(
              'Mengandung huruf besar & huruf kecil',
              _hasUppercase && _hasLowercase,
            ),
            _buildPasswordRequirement(
              'Mengandung minimal 1 angka',
              _hasNumber,
            ),

            const SizedBox(height: 16),
            _buildLabel('Konfirmasi Kata Sandi'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _register(),
              style: _fieldTextStyle(),
              decoration: _inputDecoration(
                hint: 'Ulangi kata sandi',
              ).copyWith(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword =
                          !_obscureConfirmPassword;
                    });
                  },
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Konfirmasi kata sandi wajib diisi';
                }
                if (value != _passwordController.text) {
                  return 'Konfirmasi kata sandi tidak cocok';
                }
                return null;
              },
            ),

            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: (_isLoading || _isSuccess) ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandPrimary,
                  foregroundColor: AppColors.textWhite,
                  disabledBackgroundColor: AppColors.brandTertiary,
                  disabledForegroundColor: AppColors.textWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('Mendaftarkan...'),
                        ],
                      )
                    : Text(
                        _isSuccess
                            ? 'Registrasi Berhasil'
                            : 'Daftar Sekarang',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _fieldTextStyle() {
    return TextStyle(
      fontSize: 13,
      color: AppColors.textPrimary,
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    OutlineInputBorder border(Color color) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: BorderSide(color: color),
      );
    }

    return InputDecoration(
      isDense: false,
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 12,
        color: AppColors.textTertiary,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 14,
      ),
      filled: true,
      fillColor: AppColors.backgroundWhite,
      border: border(AppColors.borderPrimary),
      enabledBorder: border(AppColors.borderPrimary),
      focusedBorder: border(AppColors.brandTertiary),
      errorBorder: border(AppColors.statusError),
      focusedErrorBorder: border(AppColors.statusError),
    );
  }

  Widget _buildPasswordStrength() {
    final color = _passwordStrengthColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kekuatan kata sandi',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textTertiary,
              ),
            ),
            Text(
              _passwordStrength,
              style: TextStyle(
                fontSize: 11,
                color: _password.isEmpty
                    ? AppColors.textTertiary
                    : color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: List.generate(3, (index) {
            final active =
                _password.isNotEmpty && index < _passwordScore;

            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index == 2 ? 0 : 5,
                ),
                height: 3,
                decoration: BoxDecoration(
                  color: active ? color : AppColors.borderPrimary,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPasswordRequirement(String text, bool isMet) {
    final color = isMet
        ? AppColors.statusSuccess
        : AppColors.textTertiary;

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isMet ? Icons.check_circle_outline : Icons.circle_outlined,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.statusBackgroundSuccess,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppColors.statusSuccess,
            size: 19,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Registrasi berhasil',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.statusSuccess,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Akun siswa siap digunakan. Mengarahkan ke halaman masuk...',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.statusSuccess,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.statusBackgroundError,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.statusError,
            size: 19,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: AppColors.statusError,
              ),
            ),
          ),
        ],
      ),
    );
  }
}