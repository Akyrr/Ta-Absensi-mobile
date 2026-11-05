import 'package:flutter/material.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/helpers/navigation_helper.dart';
import '../../jurnal/models/jurnal_model.dart';
import '../../absensi/models/student_model.dart';
import '../../absensi/pages/detail_absensi_page.dart';

class DetailJadwalPage extends StatelessWidget {
  final TeachingSchedule schedule;
  const DetailJadwalPage({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    final smkRepo = SmkRepository();
    final matchingClass = smkRepo.classes.firstWhere(
      (c) => c.name == schedule.className,
      orElse: () => smkRepo.classes.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('Detail Jadwal Mengajar', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
          onPressed: () => NavigationHelper.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
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
                    Text(schedule.subject, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                    const SizedBox(height: 6),
                    Text(schedule.className, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2563EB))),
                    const Divider(height: 24),
                    _row('Hari / Waktu', '${schedule.day}, ${schedule.timeRange}'),
                    _row('Jam Pelajaran', schedule.period),
                    _row('Ruangan / Lab', schedule.room),
                    _row('Total Siswa', '${matchingClass.totalStudents} Siswa (Rata-rata 33 per kelas)'),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    NavigationHelper.push(
                      context,
                      DetailAbsensiPage(classRoom: matchingClass, period: schedule.period),
                    );
                  },
                  icon: const Icon(Icons.checklist, size: 18, color: Colors.white),
                  label: const Text('Buka Presensi Siswa Jam Ini', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
