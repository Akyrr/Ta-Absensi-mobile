import 'package:flutter/material.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/helpers/navigation_helper.dart';
import '../models/student_model.dart';

class DetailAbsensiPage extends StatefulWidget {
  final ClassRoom classRoom;
  final String period;

  const DetailAbsensiPage({
    super.key,
    required this.classRoom,
    this.period = 'Jam ke 3 - 4 (08:30 - 10:00)',
  });

  @override
  State<DetailAbsensiPage> createState() => _DetailAbsensiPageState();
}

class _DetailAbsensiPageState extends State<DetailAbsensiPage> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<Student> get _displayedStudents {
    if (_searchQuery.isEmpty) {
      return widget.classRoom.students;
    }
    return widget.classRoom.students
        .where((s) =>
            s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            s.nisn.contains(_searchQuery))
        .toList();
  }

  void _markAllPresent() {
    setState(() {
      for (var s in widget.classRoom.students) {
        s.status = AttendanceStatus.hadir;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua 33 siswa berhasil ditandai HADIR.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _saveAttendance() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF16A34A),
        content: Text(
          'Presensi ${widget.classRoom.name} untuk ${widget.period} berhasil disimpan!',
        ),
      ),
    );
    NavigationHelper.pop(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.classRoom;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Absensi ${room.name}',
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.period,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
          onPressed: () => NavigationHelper.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: _markAllPresent,
            icon: const Icon(Icons.done_all_rounded, size: 16, color: Color(0xFF16A34A)),
            label: const Text(
              'Semua Hadir',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF16A34A),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statItem('Hadir', room.countHadir, const Color(0xFF16A34A)),
                  _statItem('Sakit', room.countSakit, const Color(0xFF2563EB)),
                  _statItem('Izin', room.countIzin, const Color(0xFFD97706)),
                  _statItem('Alpa', room.countAlpa, const Color(0xFFDC2626)),
                  _statItem('Total', room.totalStudents, AppColors.primaryDark),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    icon: const Icon(Icons.search, size: 18, color: AppColors.textMuted),
                    hintText: 'Cari nama siswa atau NISN (33 Siswa)...',
                    hintStyle: const TextStyle(fontSize: 12.5, color: AppColors.textMuted),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                            child: const Icon(Icons.clear, size: 16),
                          )
                        : null,
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                itemCount: _displayedStudents.length,
                itemBuilder: (context, index) {
                  final student = _displayedStudents[index];
                  final noUrut = index + 1;
                  return _buildStudentTile(student, noUrut);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveAttendance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save_rounded, size: 18, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Simpan Presensi (H: ${room.countHadir}, S: ${room.countSakit}, I: ${room.countIzin}, A: ${room.countAlpa})',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentTile(Student student, int noUrut) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: student.status == AttendanceStatus.alpa
              ? const Color(0xFFFCA5A5)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: Text(
              '$noUrut',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
              ),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: student.gender == 'L'
                  ? const Color(0xFFEFF6FF)
                  : const Color(0xFFFDF2F8),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                student.name.isNotEmpty ? student.name[0] : 'S',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: student.gender == 'L'
                      ? const Color(0xFF1D4ED8)
                      : const Color(0xFFBE185D),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'NISN: ${student.nisn} (${student.gender})',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _statusButton(student, AttendanceStatus.hadir, 'H', const Color(0xFF16A34A)),
              const SizedBox(width: 4),
              _statusButton(student, AttendanceStatus.sakit, 'S', const Color(0xFF2563EB)),
              const SizedBox(width: 4),
              _statusButton(student, AttendanceStatus.izin, 'I', const Color(0xFFD97706)),
              const SizedBox(width: 4),
              _statusButton(student, AttendanceStatus.alpa, 'A', const Color(0xFFDC2626)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusButton(
    Student student,
    AttendanceStatus status,
    String label,
    Color activeColor,
  ) {
    final isSelected = student.status == status;

    return InkWell(
      onTap: () {
        setState(() {
          student.status = status;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isSelected ? activeColor : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? activeColor : const Color(0xFFE5E7EB),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
