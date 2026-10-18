import 'package:flutter/material.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/helpers/navigation_helper.dart';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key});

  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  bool _isScanned = false;

  void _simulateScan() {
    setState(() => _isScanned = true);
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF16A34A),
          content: Text('Presensi Kehadiran Guru Berhasil Tercatat pada 06:45 WIB!'),
        ),
      );
      NavigationHelper.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text('Pindai QR Kehadiran Guru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => NavigationHelper.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF5271FF), width: 3),
                ),
                child: Center(
                  child: _isScanned
                      ? const Icon(Icons.check_circle_rounded, size: 72, color: Color(0xFF16A34A))
                      : const Icon(Icons.qr_code_scanner_rounded, size: 96, color: Colors.white70),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Arahkan kamera ke QR Code di Pos Piket Guru SMK',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _simulateScan,
                icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                label: const Text('Simulasi Pindai QR Sekarang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5271FF),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
