import 'package:flutter/material.dart';

import 'features/auth/pages/splash_screen.dart';
import 'features/auth/pages/login_page.dart';
import 'features/auth/reset_kata_sandi/forgot_password_page.dart';
import 'features/home/home.dart';
import 'features/absensi/pages/absensi_page.dart';
import 'features/jurnal/pages/jurnal_page.dart';
import 'features/jadwal/pages/jadwal_page.dart';

class AbsensiJurnalApp extends StatelessWidget {
  const AbsensiJurnalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Disposisi',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF282333),
        ),
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/home': (context) {
          final role =
              ModalRoute.of(context)?.settings.arguments as String? ?? 'guru';
          return HomePage(activeRole: role);
        },
        // Halaman OTP dan Kata Sandi Baru tidak didaftarkan di sini karena
        // butuh parameter email; keduanya dibuka lewat Navigator.push.
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/absensi': (context) => const AbsensiPage(),
        '/jurnal': (context) => const JurnalPage(),
        '/jadwal': (context) => const JadwalPage(),
      },
    );
  }
}