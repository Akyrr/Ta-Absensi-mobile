import 'package:flutter/material.dart';

import '../constants/app_color.dart';

class AccessDeniedPage extends StatelessWidget {
  const AccessDeniedPage({super.key});

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
              const Icon(Icons.lock_outline,
                  size: 48, color: AppColors.textTertiary),
              const SizedBox(height: 16),
              const Text(
                'Anda tidak memiliki akses ke halaman ini',
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
                    context, '/home', (route) => false),
                child: const Text('Kembali ke Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}