import 'package:flutter/material.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/helpers/navigation_helper.dart';
import '../models/jurnal_model.dart';
import '../../absensi/models/student_model.dart';

class InputJurnalPage extends StatefulWidget {
  final TeachingSchedule? schedule;
  const InputJurnalPage({super.key, this.schedule});

  @override
  State<InputJurnalPage> createState() => _InputJurnalPageState();
}

class _InputJurnalPageState extends State<InputJurnalPage> {
  final JournalRepository _repo = JournalRepository();
  final SmkRepository _smkRepo = SmkRepository();

  late String _selectedClass;
  late String _selectedPeriod;
  late String _subject;

  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _activitiesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.schedule != null) {
      _selectedClass = widget.schedule!.className;
      _selectedPeriod = widget.schedule!.period;
      _subject = widget.schedule!.subject;
    } else {
      _selectedClass = 'XII RPL 1';
      _selectedPeriod = 'Jam ke 3 - 4 (08:30 - 10:00)';
      _subject = 'Pemrograman Web & Perangkat Bergerak';
    }
    _topicController.text = 'Implementasi Flutter Widget & Form Validasi';
    _activitiesController.text =
        'Siswa mendengarkan penjelasan komponen Flutter, membuat antarmuka halaman reset kata sandi, dan mempraktikkan verifikasi kode OTP.';
    _notesController.text = 'Semua 33 siswa aktif mengikuti sesi praktik pemrograman di Lab.';
  }

  @override
  void dispose() {
    _topicController.dispose();
    _activitiesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final matchingClass = _smkRepo.classes.firstWhere(
      (c) => c.name == _selectedClass,
      orElse: () => _smkRepo.classes.first,
    );

    final newEntry = JournalEntry(
      id: 'jrn_${DateTime.now().millisecondsSinceEpoch}',
      scheduleId: widget.schedule?.id ?? 'sch_custom',
      subject: _subject,
      className: _selectedClass,
      period: _selectedPeriod,
      date: DateTime.now(),
      topic: _topicController.text,
      activities: _activitiesController.text,
      notes: _notesController.text,
      totalHadir: matchingClass.countHadir,
      totalSakit: matchingClass.countSakit,
      totalIzin: matchingClass.countIzin,
      totalAlpa: matchingClass.countAlpa,
    );

    _repo.addJournal(newEntry);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF16A34A),
        content: Text('Jurnal Mengajar Guru berhasil tersimpan!'),
      ),
    );
    NavigationHelper.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('Input Jurnal Mengajar', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 16)),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_selectedClass, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text(_selectedPeriod, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(_subject, style: const TextStyle(fontSize: 13, color: Color(0xFFE2E8F0))),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
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
                    const Text('Detail Kegiatan Pembelajaran', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                    const SizedBox(height: 16),
                    _field('Materi Pokok / Kompetensi Dasar', _topicController, 'Contoh: CRUD Flutter & State Management', maxLines: 2),
                    _field('Rangkuman Kegiatan Belajar Mengajar', _activitiesController, 'Ringkasan aktivitas guru dan siswa di kelas...', maxLines: 4),
                    _field('Catatan / Hambatan Kelas', _notesController, 'Catatan siswa tidak tertib atau kendala lab...', maxLines: 2),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _handleSubmit,
                        icon: const Icon(Icons.save_rounded, size: 18, color: Colors.white),
                        label: const Text('Simpan Jurnal Jam Ini', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
