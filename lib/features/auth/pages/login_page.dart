import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_color.dart';
import '../widgets/auth_widgets.dart';
import '../../../services/auth_service.dart';
import '../../home/home.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate() || _isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final body = await AuthService.login(email, password);

      if (!mounted) return;

      final code = body['code'];
      if (code == 'AUTH_LOGIN_SUCCESS') {
        String activeRole = 'Dashboard Gabungan';
        final data = body['data'];
        if (data is Map<String, dynamic>) {
          final user = data['user'];
          if (user is Map<String, dynamic>) {
            final roles = user['roles'];
            if (roles is List && roles.isNotEmpty) {
              final firstRole = roles.first;
              if (firstRole is String && firstRole.isNotEmpty) {
                activeRole = firstRole;
              } else if (firstRole is Map && firstRole['name'] != null) {
                activeRole = firstRole['name'].toString();
              }
            }
          }
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(activeRole: activeRole),
          ),
        );
      } else {
        String message;
        switch (code) {
          case 'AUTH_INVALID_CREDENTIALS':
            message = 'Surel atau kata sandi tidak valid.';
            break;
          case 'AUTH_ACCOUNT_LOCKED':
            message = 'Akun terkunci. Silakan hubungi admin.';
            break;
          case 'AUTH_ACCOUNT_INACTIVE':
            message = 'Akun tidak aktif. Silakan hubungi admin.';
            break;
          case 'RATE_LIMITED':
            message = 'Terlalu banyak percobaan. Silakan coba lagi nanti.';
            break;
          case 'VALIDATION_ERROR':
            message = 'Data yang dimasukkan tidak valid.';
            break;
          default:
            message = (body['message'] as String?)?.isNotEmpty == true
                ? body['message'] as String
                : 'Terjadi kesalahan saat masuk.';
            break;
        }
        _showMessage(message);
      }
    } catch (_) {
      if (!mounted) return;
      _showMessage('Gagal terhubung ke server. Periksa koneksi jaringan Anda.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            final cardWidth = width >= 600
                ? 440.0
                : (width - 40).clamp(280.0, 460.0).toDouble();

            final scale = (width / 360).clamp(0.95, 1.20);
            double s(double value) => value * scale;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: width >= 600 ? 24 : 20,
                vertical: 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height - 40),
                child: Center(
                  child: SizedBox(
                    width: cardWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeader(s),
                        SizedBox(height: s(30)),
                        _buildLoginCard(s),
                        SizedBox(height: s(24)),
                        _buildFooter(s),
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

  Widget _buildHeader(double Function(double) s) {
    return Column(
      children: [
        Container(
          width: s(44),
          height: s(44),
          decoration: BoxDecoration(
            color: AppColors.brandPrimary,
            borderRadius: BorderRadius.circular(s(12)),
          ),
          child: Icon(
            Icons.menu_book_rounded,
            color: Colors.white,
            size: s(27),
          ),
        ),
        SizedBox(height: s(12)),
        Text(
          'Masuk',
          style: TextStyle(
            fontSize: s(27),
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: s(5)),
        Text(
          'Masuk untuk melanjutkan ke aplikasi.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: s(12), color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildLoginCard(double Function(double) s) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(s(14)),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(s(16)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Surel', s),
            SizedBox(height: s(7)),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: s(12), color: AppColors.textPrimary),
              decoration: _inputDecoration(hint: 'Masukkan surel', s: s),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Surel wajib diisi';
                }

                if (!RegExp(
                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                ).hasMatch(value.trim())) {
                  return 'Format surel tidak valid';
                }

                return null;
              },
            ),
            SizedBox(height: s(14)),
            _buildLabel('Kata Sandi', s),
            SizedBox(height: s(7)),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: TextStyle(fontSize: s(12), color: AppColors.textPrimary),
              decoration: _inputDecoration(hint: 'Masukkan kata sandi', s: s)
                  .copyWith(
                    suffixIconConstraints: BoxConstraints(
                      minWidth: s(40),
                      minHeight: s(24),
                    ),
                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: s(19),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kata sandi wajib diisi';
                }

                return null;
              },
            ),
            SizedBox(height: s(8)),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot-password');
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  padding: EdgeInsets.symmetric(vertical: s(5)),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Lupa Kata Sandi?',
                  style: TextStyle(
                    fontSize: s(11),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: s(10)),

            // Tombol Masuk
            SizedBox(
              width: double.infinity,
              height: s(42),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandPrimary,
                  foregroundColor: AppColors.textWhite,
                  disabledBackgroundColor: AppColors.brandPrimary,
                  disabledForegroundColor: AppColors.textWhite,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(s(8)),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        width: s(20),
                        height: s(20),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textWhite,
                        ),
                      )
                    : Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: s(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            SizedBox(height: s(16)),
            Row(
              children: [
                const Expanded(child: Divider(color: AppColors.borderPrimary)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: s(12)),
                  child: Text(
                    'atau',
                    style: TextStyle(
                      fontSize: s(10),
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
                const Expanded(child: Divider(color: AppColors.borderPrimary)),
              ],
            ),
            SizedBox(height: s(16)),
            SizedBox(
              width: double.infinity,
              height: s(42),
              child: OutlinedButton(
                onPressed: () {
                  _showMessage('Google Sign-In belum dihubungkan.');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  padding: EdgeInsets.zero,
                  side: const BorderSide(color: AppColors.borderPrimary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(s(8)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_google.svg',
                      width: 18,
                      height: 18,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: s(9)),
                    Text(
                      'Masuk dengan Google',
                      style: TextStyle(
                        fontSize: s(11),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(double Function(double) s) {
    return Column(
      children: [
        Text(
          'Belum punya akun?',
          style: TextStyle(fontSize: s(11), color: AppColors.textSecondary),
        ),
        SizedBox(height: s(7)),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegistrationPage()),
            );
          },
          child: Text(
            'Daftar sebagai Siswa',
            style: TextStyle(
              fontSize: s(12),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, double Function(double) s) {
    return Text(
      text,
      style: TextStyle(
        fontSize: s(12),
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required double Function(double) s,
  }) {
    OutlineInputBorder makeBorder(Color color) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(s(8)),
        borderSide: BorderSide(color: color),
      );
    }

    return InputDecoration(
      isDense: true,
      hintText: hint,
      hintStyle: TextStyle(fontSize: s(11), color: AppColors.textTertiary),
      contentPadding: EdgeInsets.symmetric(horizontal: s(12), vertical: s(12)),
      filled: true,
      fillColor: AppColors.backgroundWhite,
      border: makeBorder(AppColors.borderPrimary),
      enabledBorder: makeBorder(AppColors.borderPrimary),
      focusedBorder: makeBorder(AppColors.borderStrong),
      errorBorder: makeBorder(AppColors.statusError),
      focusedErrorBorder: makeBorder(AppColors.statusError),
    );
  }
}
