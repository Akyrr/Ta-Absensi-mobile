import 'package:flutter/material.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/helpers/navigation_helper.dart';
import '../models/jurnal_model.dart';
import '../../absensi/models/student_model.dart';
import '../../absensi/pages/detail_absensi_page.dart';
import 'input_jurnal_page.dart';
import 'detail_jurnal_page.dart';
import 'history_jurnal_page.dart';

class JurnalPage extends StatefulWidget {
  const JurnalPage({super.key});

  @override
  State<JurnalPage> createState() => _JurnalPageState();
}

class _JurnalPageState extends State<JurnalPage> {
  final JournalRepository _journalRepo = JournalRepository();
  final SmkRepository _smkRepo = SmkRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('Jurnal Mengajar Guru', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_edu_rounded, color: AppColors.primaryDark),
            tooltip: 'Riwayat Jurnal',
            onPressed: () {
              NavigationHelper.push(context, const HistoryJurnalPage());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E1E2C), Color(0xFF2D3250)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Jadwal Mengajar Hari Ini', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                        Icon(Icons.access_time_filled, color: Colors.amber, size: 20),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pastikan Anda mengabsen 33 siswa dan mengisi rangkuman materi setiap jam mata pelajaran selesai.',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Jam Mengajar Terjadwal', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
              const SizedBox(height: 12),
              ..._journalRepo.schedules.map((schedule) => _buildScheduleCard(schedule)),
              const SizedBox(height: 20),
              const Text('Jurnal Selesai Diisi Hari Ini', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
              const SizedBox(height: 12),
              if (_journalRepo.journals.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Belum ada jurnal yang disubmit hari ini.', style: TextStyle(color: AppColors.textMuted)),
                  ),
                )
              else
                ..._journalRepo.journals.map((entry) => _buildJournalCard(entry)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCard(TeachingSchedule schedule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  schedule.period,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: schedule.isCompleted ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  schedule.isCompleted ? 'Selesai' : 'Siap Diabsen',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: schedule.isCompleted ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(schedule.subject, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
          const SizedBox(height: 4),
          Text('${schedule.className} • ${schedule.room} • ${schedule.timeRange}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    final matchingClass = _smkRepo.classes.firstWhere(
                      (c) => c.name == schedule.className,
                      orElse: () => _smkRepo.classes.first,
                    );
                    NavigationHelper.push(
                      context,
                      DetailAbsensiPage(classRoom: matchingClass, period: schedule.period),
                    );
                  },
                  icon: const Icon(Icons.people_outline, size: 16),
                  label: const Text('Absen Siswa', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryDark,
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await NavigationHelper.push(
                      context,
                      InputJurnalPage(schedule: schedule),
                    );
                    setState(() {});
                  },
                  icon: const Icon(Icons.edit_note_rounded, size: 16, color: Colors.white),
                  label: const Text('Isi Jurnal', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJournalCard(JournalEntry entry) {
    return InkWell(
      onTap: () {
        NavigationHelper.push(context, DetailJurnalPage(entry: entry));
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.className, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                Text(entry.period, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
            const SizedBox(height: 6),
            Text(entry.topic, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.check_circle_outline, size: 14, color: Color(0xFF16A34A)),
                const SizedBox(width: 4),
                Text('Hadir: ${entry.totalHadir} | Sakit: ${entry.totalSakit} | Izin: ${entry.totalIzin}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                const Spacer(),
                const Text('Detail >', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.accentBlue)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
