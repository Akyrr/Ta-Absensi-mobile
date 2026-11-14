import 'package:flutter/material.dart';

import '../../../core/constants/app_color.dart';

class WebOnlyPage extends StatelessWidget {
  const WebOnlyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.desktop_windows_outlined,
                  size: 48, color: AppColors.textTertiary),
              const SizedBox(height: 16),
              const Text(
                'Akun ini hanya dapat diakses lewat web/desktop',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false),
                child: const Text('Kembali ke Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}