import 'package:flutter/material.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/helpers/navigation_helper.dart';
import '../../jurnal/models/jurnal_model.dart';
import 'detail_jadwal_page.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  String _selectedDay = 'Senin';
  final List<String> _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];

  final List<TeachingSchedule> _allSchedules = [
    TeachingSchedule(
      id: 'sch_1',
      subject: 'Pemrograman Web & Perangkat Bergerak',
      className: 'XII RPL 1',
      period: 'Jam 1 - 2 (07:00 - 08:30)',
      timeRange: '07:00 - 08:30',
      room: 'Lab Komputer RPL 1',
      day: 'Senin',
    ),
    TeachingSchedule(
      id: 'sch_2',
      subject: 'Pemrograman Web & Perangkat Bergerak',
      className: 'XII RPL 2',
      period: 'Jam 3 - 4 (08:30 - 10:00)',
      timeRange: '08:30 - 10:00',
      room: 'Lab Komputer RPL 2',
      day: 'Senin',
    ),
    TeachingSchedule(
      id: 'sch_3',
      subject: 'Basis Data Terdistribusi',
      className: 'XI RPL 1',
      period: 'Jam 5 - 6 (10:15 - 11:45)',
      timeRange: '10:15 - 11:45',
      room: 'Lab Komputer RPL 1',
      day: 'Senin',
    ),
    TeachingSchedule(
      id: 'sch_4',
      subject: 'Produk Kreatif & Kewirausahaan (PKK)',
      className: 'XII RPL 1',
      period: 'Jam 1 - 4 (07:00 - 10:00)',
      timeRange: '07:00 - 10:00',
      room: 'Ruang Teori XII RPL 1',
      day: 'Selasa',
    ),
    TeachingSchedule(
      id: 'sch_5',
      subject: 'Pemodelan Perangkat Lunak (PPL)',
      className: 'XI RPL 2',
      period: 'Jam 5 - 8 (10:15 - 14:00)',
      timeRange: '10:15 - 14:00',
      room: 'Lab Komputer RPL 2',
      day: 'Rabu',
    ),
  ];

  List<TeachingSchedule> get _currentSchedules =>
      _allSchedules.where((s) => s.day == _selectedDay).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('Jadwal Mengajar Guru SMK', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _days.map((day) {
                    final isSelected = _selectedDay == day;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(day),
                        selected: isSelected,
                        selectedColor: AppColors.primaryDark,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedDay = day);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: _currentSchedules.isEmpty
                  ? Center(
                      child: Text(
                        'Tidak ada jadwal mengajar pada hari $_selectedDay.',
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _currentSchedules.length,
                      itemBuilder: (context, index) {
                        final sch = _currentSchedules[index];
                        return InkWell(
                          onTap: () => NavigationHelper.push(
                            context,
                            DetailJadwalPage(schedule: sch),
                          ),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
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
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.schedule_rounded, color: Color(0xFF2563EB), size: 24),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(sch.subject, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                                      const SizedBox(height: 3),
                                      Text('${sch.className} • ${sch.room}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                      const SizedBox(height: 3),
                                      Text(sch.period, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2563EB))),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
