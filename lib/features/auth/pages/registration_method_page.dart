import 'package:flutter/material.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/helpers/navigation_helper.dart';
import 'registration_page.dart';

class RegistrationMethodPage extends StatelessWidget {
  const RegistrationMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('Metode Pendaftaran', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
          onPressed: () => NavigationHelper.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pilih Metode Akun', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
              const SizedBox(height: 8),
              const Text('Anda dapat mendaftar menggunakan Akun Belajar.id atau Akun Dapodik Sekolah.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              _methodTile(context, 'Akun Belajar.id Kemendikbudristek', 'Verifikasi otomatis SSO guru dinas', Icons.verified_user_rounded),
              _methodTile(context, 'Nomor Induk Pegawai (NIP / NUPTK)', 'Pendaftaran manual data kepegawaian', Icons.badge_outlined),
            ],
          ),
        ),
      ),
    );
  }

  Widget _methodTile(BuildContext context, String title, String subtitle, IconData icon) {
    return InkWell(
      onTap: () => NavigationHelper.push(context, const RegistrationPage()),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.primaryDark, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
