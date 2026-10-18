import 'package:flutter/material.dart';
import '../../core/constants/app_color.dart';
import '../../core/constants/session.dart';
import '../../core/helpers/navigation_helper.dart';
import '../absensi/pages/absensi_page.dart';
import '../jurnal/pages/jurnal_page.dart';
import '../jadwal/pages/jadwal_page.dart';
import '../kehadiran_guru/pages/scan_qr_page.dart';
import '../kehadiran_guru/pages/generate_qr_page.dart';
import '../surat/pages/surat_page.dart';
import '../auth/pages/login_page.dart';
import '../auth/reset_kata_sandi/forgot_password_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeDashboardView(),
    const AbsensiPage(),
    const JurnalPage(),
    const JadwalPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryDark,
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_rounded),
              label: 'Presensi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Jurnal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded),
              label: 'Jadwal',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeDashboardView extends StatelessWidget {
  const HomeDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final session = UserSession();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.person, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.name,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          Text(
                            'Guru Kejuruan • ${session.jurusanBinaan}',
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  PopupMenuButton<String>(
                    icon: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.more_vert, size: 18, color: AppColors.primaryDark),
                    ),
                    onSelected: (val) {
                      if (val == 'reset_password') {
                        NavigationHelper.push(context, const ForgotPasswordPage());
                      } else if (val == 'logout') {
                        session.logout();
                        NavigationHelper.pushReplacement(context, const LoginPage());
                      }
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(
                        value: 'reset_password',
                        child: Row(
                          children: [
                            Icon(Icons.lock_reset, size: 18, color: AppColors.primaryDark),
                            SizedBox(width: 8),
                            Text('Ganti Kata Sandi (Mockup UI)', style: TextStyle(fontSize: 12.5)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, size: 18, color: AppColors.danger),
                            SizedBox(width: 8),
                            Text('Keluar Akun', style: TextStyle(fontSize: 12.5, color: AppColors.danger)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E1E2C), Color(0xFF2E344E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E1E2C).withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.fiber_manual_record, size: 9, color: Color(0xFF4ADE80)),
                              SizedBox(width: 5),
                              Text(
                                'SEDANG BERLANGSUNG',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'Jam Ke 3 - 4',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF93C5FD),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'XII RPL 1 • 33 Siswa',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Pemrograman Web & Perangkat Bergerak',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFE2E8F0),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              NavigationHelper.push(context, const AbsensiPage());
                            },
                            icon: const Icon(Icons.how_to_reg_rounded, size: 16, color: AppColors.primaryDark),
                            label: const Text(
                              'Absen Siswa',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              NavigationHelper.push(context, const JurnalPage());
                            },
                            icon: const Icon(Icons.edit_note_rounded, size: 16, color: Colors.white),
                            label: const Text(
                              'Isi Jurnal',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _statBox('33', 'Siswa / Kelas', Icons.groups_rounded, const Color(0xFF2563EB), const Color(0xFFEFF6FF))),
                  const SizedBox(width: 12),
                  Expanded(child: _statBox('96%', 'Tingkat Kehadiran', Icons.check_circle_outline, const Color(0xFF16A34A), const Color(0xFFECFDF5))),
                  const SizedBox(width: 12),
                  Expanded(child: _statBox('2 Kelas', 'Per Jurusan SMK', Icons.apartment_rounded, const Color(0xFFD97706), const Color(0xFFFFFBEB))),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Layanan Presensi & Sekolah',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _menuTile(context, 'Presensi Siswa', 'Absen kelas per jam', Icons.checklist_rounded, const Color(0xFF16A34A), const Color(0xFFECFDF5), () {
                    NavigationHelper.push(context, const AbsensiPage());
                  })),
                  const SizedBox(width: 12),
                  Expanded(child: _menuTile(context, 'Jurnal Guru', 'Catat materi KD per jam', Icons.menu_book_rounded, const Color(0xFF2563EB), const Color(0xFFEFF6FF), () {
                    NavigationHelper.push(context, const JurnalPage());
                  })),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _menuTile(context, 'Jadwal Jam', 'Jadwal mengajar SMK', Icons.access_time_rounded, const Color(0xFF7C3AED), const Color(0xFFF5F3FF), () {
                    NavigationHelper.push(context, const JadwalPage());
                  })),
                  const SizedBox(width: 12),
                  Expanded(child: _menuTile(context, 'Scan QR Guru', 'Presensi kedatangan', Icons.qr_code_scanner_rounded, const Color(0xFFD97706), const Color(0xFFFFFBEB), () {
                    NavigationHelper.push(context, const ScanQrPage());
                  })),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _menuTile(context, 'QR Kelas', 'Tampilkan QR presensi', Icons.qr_code_2_rounded, const Color(0xFF0D9488), const Color(0xFFF0FDFA), () {
                    NavigationHelper.push(context, const GenerateQrPage());
                  })),
                  const SizedBox(width: 12),
                  Expanded(child: _menuTile(context, 'Surat Siswa', 'Izin & sakit dokter', Icons.mark_email_read_rounded, const Color(0xFFDC2626), const Color(0xFFFEF2F2), () {
                    NavigationHelper.push(context, const SuratPage());
                  })),
                ],
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  NavigationHelper.push(context, const ForgotPasswordPage());
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF5271FF).withValues(alpha: 0.5), width: 1.5),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.design_services_rounded, color: Color(0xFF5271FF), size: 24),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Demo UI/UX Reset Password (3 Gambar)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Ganti Kata Sandi • Verifikasi OTP • Kata Sandi Baru',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF5271FF)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statBox(String value, String label, IconData icon, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _menuTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    Color bg,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
