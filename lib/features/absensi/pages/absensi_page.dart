import 'package:flutter/material.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/helpers/navigation_helper.dart';
import '../models/student_model.dart';
import 'detail_absensi_page.dart';
import 'history_absensi_page.dart';

class AbsensiPage extends StatefulWidget {
  const AbsensiPage({super.key});

  @override
  State<AbsensiPage> createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  final SmkRepository _repo = SmkRepository();
  String _selectedDepartment = 'ALL';
  int _selectedGrade = 12;

  List<ClassRoom> get _filteredClasses {
    return _repo.classes.where((c) {
      final matchesDep = _selectedDepartment == 'ALL' || c.departmentCode == _selectedDepartment;
      final matchesGrade = _selectedGrade == 0 || c.grade == _selectedGrade;
      return matchesDep && matchesGrade;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Presensi Siswa SMK',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: AppColors.primaryDark),
            tooltip: 'Riwayat Presensi',
            onPressed: () {
              NavigationHelper.push(context, const HistoryAbsensiPage());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildFilterHeader(),
            Expanded(
              child: _filteredClasses.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada kelas yang sesuai filter.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      itemCount: _filteredClasses.length,
                      itemBuilder: (context, index) {
                        final room = _filteredClasses[index];
                        return _buildClassCard(room);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jurusan Keahlian:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _depChip('Semua Jurusan', 'ALL'),
                const SizedBox(width: 8),
                _depChip('RPL (Rekayasa Perangkat Lunak)', 'RPL'),
                const SizedBox(width: 8),
                _depChip('TKJ (Teknik Komputer & Jaringan)', 'TKJ'),
                const SizedBox(width: 8),
                _depChip('DKV (Desain Komunikasi Visual)', 'DKV'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Tingkat:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              _gradeChip('Semua', 0),
              const SizedBox(width: 6),
              _gradeChip('Kelas X', 10),
              const SizedBox(width: 6),
              _gradeChip('Kelas XI', 11),
              const SizedBox(width: 6),
              _gradeChip('Kelas XII', 12),
            ],
          ),
        ],
      ),
    );
  }

  Widget _depChip(String label, String code) {
    final isSelected = _selectedDepartment == code;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedDepartment = code;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryDark : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _gradeChip(String label, int grade) {
    final isSelected = _selectedGrade == grade;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedGrade = grade;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5271FF) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildClassCard(ClassRoom room) {
    final percentHadir = room.totalStudents > 0
        ? ((room.countHadir / room.totalStudents) * 100).toInt()
        : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      room.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      room.departmentCode,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '${room.totalStudents} Siswa',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                'Wali Kelas: ${room.homeroomTeacher}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _statusBadge('Hadir', room.countHadir, const Color(0xFFECFDF5), const Color(0xFF16A34A)),
              const SizedBox(width: 6),
              _statusBadge('Sakit', room.countSakit, const Color(0xFFEFF6FF), const Color(0xFF2563EB)),
              const SizedBox(width: 6),
              _statusBadge('Izin', room.countIzin, const Color(0xFFFFFBEB), const Color(0xFFD97706)),
              const SizedBox(width: 6),
              _statusBadge('Alpa', room.countAlpa, const Color(0xFFFEF2F2), const Color(0xFFDC2626)),
              const Spacer(),
              Text(
                '$percentHadir%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () async {
                await NavigationHelper.push(
                  context,
                  DetailAbsensiPage(classRoom: room),
                );
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.checklist_rounded, size: 16, color: Colors.white),
                  SizedBox(width: 6),
                  Text(
                    'Buka Presensi Kelas (33 Siswa)',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String label, int count, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
    );
  }
}
