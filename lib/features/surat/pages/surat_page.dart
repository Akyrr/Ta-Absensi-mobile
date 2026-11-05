import 'package:flutter/material.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/helpers/navigation_helper.dart';
import 'upload_surat_page.dart';

class SuratPage extends StatelessWidget {
  const SuratPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('Surat Keterangan Siswa', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file_rounded, color: AppColors.primaryDark),
            onPressed: () => NavigationHelper.push(context, const UploadSuratPage()),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _suratCard('Aisyah Nur Rahmawati', 'XII RPL 1', 'Surat Dokter (Sakit Demam)', '16 Okt 2026', 'Disetujui'),
            _suratCard('Arya Bima Sena', 'XII RPL 1', 'Surat Dispensasi Lomba LKS SMK', '16 Okt 2026', 'Disetujui'),
            _suratCard('Dimas Aditya Permana', 'XII RPL 2', 'Surat Izin Keperluan Keluarga', '15 Okt 2026', 'Menunggu'),
          ],
        ),
      ),
    );
  }

  Widget _suratCard(String student, String kelas, String type, String date, String status) {
    final isApproved = status == 'Disetujui';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(color: Color(0xFFEFF6FF), shape: BoxShape.circle),
            child: const Icon(Icons.description_outlined, color: Color(0xFF2563EB), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                const SizedBox(height: 3),
                Text('$kelas • $type', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 3),
                Text(date, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isApproved ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isApproved ? const Color(0xFF16A34A) : const Color(0xFFD97706),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
