import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:e_absensi/features/auth/pages/login_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Absensi',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// SPLASH SCREEN
// ---------------------------------------------------------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _bg = Color(0xFFFAF6F5);
  static const _titleColor = Color(0xFF4A3F5C);
  static const _dashColor = Color(0xFF54456B);

  late final AnimationController _intro; // animasi masuk logo & teks
  late final AnimationController _loop; // animasi garis loading
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _loop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Pindah ke halaman berikutnya setelah 3 detik

    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => const LoginPage(),
          transitionsBuilder: (_, anim, __, child) {
            return FadeTransition(opacity: anim, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _intro.dispose();
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: _intro, curve: Curves.easeOutCubic);

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo

              // Logo SVG
              FadeTransition(
                opacity: curved,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1.0).animate(curved),
                  child: SizedBox(
                    width: 170,
                    height: 158,
                    child: SvgPicture.asset(
                      'assets/images/E-Absensi_logo.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),
              // Judul
              FadeTransition(
                opacity: curved,
                child: const Text(
                  'E-Absensi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: _titleColor,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(height: 96),
              // Garis loading
              AnimatedBuilder(
                animation: _loop,
                builder: (context, _) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(4, (i) {
                      final t = (_loop.value - i * 0.125) % 1.0;
                      final v = math.sin(t * math.pi); // 0 -> 1 -> 0
                      return Padding(
                        padding: EdgeInsets.only(right: i == 3 ? 0 : 11),
                        child: Opacity(
                          opacity: 0.35 + 0.65 * v,
                          child: Container(
                            width: 40,
                            height: 14,
                            decoration: BoxDecoration(
                              color: _dashColor,
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// LOGO (digambar dengan CustomPainter, tanpa perlu file gambar)
// ---------------------------------------------------------------------------
class LogoPainter extends CustomPainter {
  const LogoPainter();

  static const _white = Colors.white;

  Paint _gradient(
    Path p,
    List<Color> colors, {
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    final rect = p.getBounds();
    return Paint()
      ..shader = LinearGradient(
        begin: begin,
        end: end,
        colors: colors,
      ).createShader(rect);
  }

  Paint _stroke(double w, [Color c = _white]) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = w
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    // Koordinat dirancang pada kanvas 168 x 156
    final s = size.width / 168;
    canvas.scale(s);

    const darkColors = [Color(0xFF4A3A63), Color(0xFF2A2038)];
    const lightColors = [Color(0xFFA692C4), Color(0xFF7C679D)];

    // 1. Pita di bawah topi
    final band = Path()
      ..addRRect(RRect.fromLTRBR(27, 40, 142, 74, const Radius.circular(3)));
    canvas.drawPath(
      band,
      _gradient(
        band,
        const [Color(0xFFC4B3DA), Color(0xFFA692C4)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );

    // 2. Sisi kiri (dokumen)
    final left = Path()
      ..moveTo(14, 62)
      ..lineTo(80, 88)
      ..lineTo(80, 150)
      ..lineTo(14, 124)
      ..close();
    canvas.drawPath(left, _gradient(left, darkColors));
    canvas.drawPath(left, _stroke(5));

    // Garis teks pada dokumen
    final line = _stroke(4, const Color(0xFFE9E1F3));
    canvas.drawLine(const Offset(25, 80), const Offset(62, 94), line);
    canvas.drawLine(const Offset(25, 91), const Offset(62, 105), line);
    canvas.drawLine(const Offset(25, 102), const Offset(62, 116), line);
    canvas.drawLine(const Offset(25, 113), const Offset(40, 119), line);

    // 3. Sisi kanan (centang)
    final right = Path()
      ..moveTo(88, 88)
      ..lineTo(150, 64)
      ..quadraticBezierTo(156, 62, 156, 68)
      ..lineTo(156, 106)
      ..lineTo(88, 152)
      ..close();
    canvas.drawPath(right, _gradient(right, lightColors));
    canvas.drawPath(right, _stroke(5));

    final check = Path()
      ..moveTo(104, 106)
      ..lineTo(116, 118)
      ..lineTo(138, 92);
    canvas.drawPath(check, _stroke(9));

    // 4. Topi wisuda
    final cap = Path()
      ..moveTo(84, 3)
      ..lineTo(164, 27)
      ..lineTo(84, 58)
      ..lineTo(3, 29)
      ..close();
    canvas.drawPath(cap, _gradient(cap, darkColors));
    canvas.drawPath(cap, _stroke(4));

    // 5. Tali & rumbai
    final dark = Paint()..color = const Color(0xFF2A2038);
    canvas.drawRRect(
      RRect.fromLTRBR(148, 31, 153, 69, const Radius.circular(2.5)),
      dark,
    );
    final tassel = Path()
      ..moveTo(144, 66)
      ..lineTo(157, 66)
      ..lineTo(157, 72)
      ..quadraticBezierTo(157, 80, 150.5, 80)
      ..quadraticBezierTo(144, 80, 144, 72)
      ..close();
    canvas.drawPath(tassel, dark);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Halaman tujuan sementara (ganti dengan LoginPage / HomePage Anda)
// ---------------------------------------------------------------------------
class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Halaman Login')));
  }
}
