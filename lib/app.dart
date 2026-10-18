
import 'package:flutter/material.dart';
import 'features/auth/pages/splash_screen.dart';

void main() {
  runApp(const AbsensiJurnalApp());
}

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
      home: const SplashScreen(),
    );
  }
}
