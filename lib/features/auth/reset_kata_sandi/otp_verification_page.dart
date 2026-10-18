import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/helpers/navigation_helper.dart';
import 'new_password_page.dart';

enum OtpScreenState {
  countdown,
  resendAvailable,
  expired,
  attemptsExceeded,
  success,
}

class OtpVerificationPage extends StatefulWidget {
  final String email;
  const OtpVerificationPage({
    super.key,
    this.email = 'guru.rpl@smk.belajar.id',
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  OtpScreenState _state = OtpScreenState.countdown;
  int _secondsLeft = 58;
  int _attemptsRemaining = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = 58;
      _state = OtpScreenState.countdown;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        timer.cancel();
        setState(() {
          _state = OtpScreenState.resendAvailable;
        });
      }
    });
  }

  String get _maskedEmail {
    final parts = widget.email.split('@');
    if (parts.length == 2 && parts[0].isNotEmpty) {
      final name = parts[0];
      final masked = name.length > 1
          ? '${name[0]}***'
          : '$name***';
      return '$masked@${parts[1]}';
    }
    return 'v***@gmail.com';
  }

  bool get _isOtpComplete {
    return _controllers.every((c) => c.text.isNotEmpty);
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
    setState(() {});
  }

  void _fillMockOtp() {
    final mockDigits = ['1', '2', '8', '4', '5', '6'];
    for (var i = 0; i < 6; i++) {
      _controllers[i].text = mockDigits[i];
    }
    setState(() {});
  }

  void _handleVerify() {
    if (!_isOtpComplete) return;

    final enteredCode = _controllers.map((c) => c.text).join();

    if (enteredCode == '128456' || _state == OtpScreenState.success) {
      setState(() {
        _state = OtpScreenState.success;
      });
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        NavigationHelper.push(context, const NewPasswordPage());
      });
    } else {
      setState(() {
        if (_attemptsRemaining > 1) {
          _attemptsRemaining--;
        } else {
          _attemptsRemaining = 0;
          _state = OtpScreenState.attemptsExceeded;
        }
      });
    }
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
              const SizedBox(height: 24),
              _buildBottomNotice(),
              const SizedBox(height: 16),
              _buildStateSwitcher(),
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.mail_outline_rounded,
              size: 24,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Verifikasi Kode',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Masukkan kode 6 digit yang telah kami kirimkan\nke email Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _maskedEmail,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 20),
          _buildOtpBoxes(),
          const SizedBox(height: 14),
          if (_state == OtpScreenState.success)
            const Text(
              'Email berhasil diverifikasi',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF16A34A),
              ),
            )
          else
            Text(
              'Sisa percobaan: $_attemptsRemaining kali',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _attemptsRemaining == 0
                    ? AppColors.danger
                    : AppColors.textSecondary,
              ),
            ),
          const SizedBox(height: 18),
          _buildActionButton(),
          const SizedBox(height: 14),
          _buildResendSection(),
          const SizedBox(height: 14),
          if (_state == OtpScreenState.expired) _buildExpiredBanner(),
          if (_state == OtpScreenState.attemptsExceeded) _buildAttemptsExceededBanner(),
          if (_state == OtpScreenState.success) _buildSuccessBanner(),
        ],
      ),
    );
  }

  Widget _buildOtpBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        final isFilled = _controllers[index].text.isNotEmpty;
        return Container(
          width: 44,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isFilled
                  ? AppColors.primaryDark
                  : const Color(0xFFE2E8F0),
              width: isFilled ? 1.5 : 1.0,
            ),
          ),
          child: Center(
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (val) => _onOtpChanged(val, index),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildActionButton() {
    if (_state == OtpScreenState.success) {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            NavigationHelper.push(context, const NewPasswordPage());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3D7B5F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check, size: 18, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Terverifikasi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final isReady = _isOtpComplete && _attemptsRemaining > 0;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isReady ? _handleVerify : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          disabledBackgroundColor: const Color(0xFFB0B4BA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Verifikasi',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildResendSection() {
    if (_state == OtpScreenState.success) {
      return const Column(
        children: [
          Text(
            'Kode OTP berhasil dikonfirmasi',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Tidak perlu kirim ulang kode',
            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      );
    }

    return Column(
      children: [
        const Text(
          'Anda dapat meminta kode baru.',
          style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
        ),
        const SizedBox(height: 6),
        if (_state == OtpScreenState.countdown)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF60A5FA),
                width: 1.2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Kirim ulang kode dalam 00:${_secondsLeft.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          )
        else
          InkWell(
            onTap: () {
              _startTimer();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kode OTP baru telah dikirimkan ke email Anda.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Kirim Ulang Kode',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildExpiredBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: const Center(
        child: Text(
          'Kode OTP telah kedaluwarsa. Silakan minta kode baru',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.5,
            color: Color(0xFF92400E),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildAttemptsExceededBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: const Center(
        child: Text(
          'Batas percobaan habis. Silakan kirim ulang kode baru',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.5,
            color: Color(0xFF991B1B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFA7F3D0)),
      ),
      child: const Center(
        child: Text(
          'Akun Anda siap digunakan.\nVerifikasi berhasil. Email Anda telah terverifikasi.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.5,
            color: Color(0xFF065F46),
            fontWeight: FontWeight.w500,
            height: 1.35,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNotice() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.textMuted),
        SizedBox(width: 6),
        Text(
          'Jangan bagikan kode OTP kepada siapa pun.',
          style: TextStyle(
            fontSize: 11.5,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildStateSwitcher() {
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
            'Demo State:',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          _stateChip('Countdown', OtpScreenState.countdown, () {
            _startTimer();
          }),
          _stateChip('Kirim Ulang', OtpScreenState.resendAvailable, () {
            _timer?.cancel();
            setState(() {
              _state = OtpScreenState.resendAvailable;
            });
          }),
          _stateChip('Expired', OtpScreenState.expired, () {
            _timer?.cancel();
            setState(() {
              _state = OtpScreenState.expired;
            });
          }),
          _stateChip('Batas Habis', OtpScreenState.attemptsExceeded, () {
            setState(() {
              _attemptsRemaining = 0;
              _state = OtpScreenState.attemptsExceeded;
            });
          }),
          _stateChip('Sukses (128456)', OtpScreenState.success, () {
            _fillMockOtp();
            setState(() {
              _state = OtpScreenState.success;
            });
          }),
        ],
      ),
    );
  }

  Widget _stateChip(String label, OtpScreenState state, VoidCallback onTap) {
    final isSelected = _state == state;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryDark : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.primaryDark,
          ),
        ),
      ),
    );
  }
}
