import 'package:flutter/material.dart';
import 'core/constants/app_color.dart';
import 'features/auth/pages/splash_screen.dart';
import 'features/auth/pages/login_page.dart';
import 'features/auth/reset_kata_sandi/forgot_password_page.dart';
import 'features/auth/reset_kata_sandi/otp_verification_page.dart';
import 'features/auth/reset_kata_sandi/new_password_page.dart';
import 'features/home/home.dart';
import 'features/absensi/pages/absensi_page.dart';
import 'features/jurnal/pages/jurnal_page.dart';
import 'features/jadwal/pages/jadwal_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AbsensiJurnalApp());
}

class AbsensiJurnalApp extends StatelessWidget {
  const AbsensiJurnalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absensi & Jurnal Guru SMK',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F7F9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryDark,
          primary: AppColors.primaryDark,
          secondary: AppColors.accentBlue,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primaryDark,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/otp-verification': (context) => const OtpVerificationPage(),
        '/new-password': (context) => const NewPasswordPage(),
        '/absensi': (context) => const AbsensiPage(),
        '/jurnal': (context) => const JurnalPage(),
        '/jadwal': (context) => const JadwalPage(),
      },
    );
  }
}
