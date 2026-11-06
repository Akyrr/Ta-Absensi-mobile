import 'package:flutter/material.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/helpers/navigation_helper.dart';
import '../models/jurnal_model.dart';

class DetailJurnalPage extends StatelessWidget {
  final JournalEntry entry;
  const DetailJurnalPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('Detail Jurnal Mengajar', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
          onPressed: () => NavigationHelper.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.subject, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                const SizedBox(height: 4),
                Text('${entry.className} • ${entry.period}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const Divider(height: 28),
                _section('Materi Pokok / KD', entry.topic),
                const SizedBox(height: 16),
                _section('Kegiatan Pembelajaran', entry.activities),
                const SizedBox(height: 16),
                _section('Catatan Guru & Kelas', entry.notes),
                const SizedBox(height: 20),
                const Text('Rekap Kehadiran Kelas (33 Siswa)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _badge('Hadir: ${entry.totalHadir}', const Color(0xFFECFDF5), const Color(0xFF16A34A)),
                    const SizedBox(width: 8),
                    _badge('Sakit: ${entry.totalSakit}', const Color(0xFFEFF6FF), const Color(0xFF2563EB)),
                    const SizedBox(width: 8),
                    _badge('Izin: ${entry.totalIzin}', const Color(0xFFFFFBEB), const Color(0xFFD97706)),
                    const SizedBox(width: 8),
                    _badge('Alpa: ${entry.totalAlpa}', const Color(0xFFFEF2F2), const Color(0xFFDC2626)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
        const SizedBox(height: 4),
        Text(content, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4)),
      ],
    );
  }

  Widget _badge(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: text)),
    );
  }
}
