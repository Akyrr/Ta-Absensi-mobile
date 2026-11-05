import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_absensi/features/auth/pages/login_page.dart';

void main() {
  testWidgets('Halaman login menampilkan form masuk', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: LoginPage()),
    );

    // Judul dan tombol "Masuk" (muncul lebih dari sekali)
    expect(find.text('Masuk'), findsWidgets);

    // Label input
    expect(find.text('Surel'), findsOneWidget);
    expect(find.text('Kata Sandi'), findsOneWidget);

    // Tombol lupa kata sandi dan daftar
    expect(find.text('Lupa Kata Sandi?'), findsOneWidget);
    expect(find.text('Daftar sebagai Siswa'), findsOneWidget);
  });
}