class TeachingSchedule {
  final String id;
  final String subject;
  final String className;
  final String period;
  final String timeRange;
  final String room;
  final String day;
  bool isCompleted;

  TeachingSchedule({
    required this.id,
    required this.subject,
    required this.className,
    required this.period,
    required this.timeRange,
    required this.room,
    required this.day,
    this.isCompleted = false,
  });
}

class JournalEntry {
  final String id;
  final String scheduleId;
  final String subject;
  final String className;
  final String period;
  final DateTime date;
  final String topic;
  final String activities;
  final String notes;
  final int totalHadir;
  final int totalSakit;
  final int totalIzin;
  final int totalAlpa;

  JournalEntry({
    required this.id,
    required this.scheduleId,
    required this.subject,
    required this.className,
    required this.period,
    required this.date,
    required this.topic,
    required this.activities,
    required this.notes,
    required this.totalHadir,
    required this.totalSakit,
    required this.totalIzin,
    required this.totalAlpa,
  });
}

class JournalRepository {
  static final JournalRepository _instance = JournalRepository._internal();
  factory JournalRepository() => _instance;
  JournalRepository._internal() {
    _initSchedules();
  }

  final List<TeachingSchedule> schedules = [];
  final List<JournalEntry> journals = [];

  void _initSchedules() {
    schedules.addAll([
      TeachingSchedule(
        id: 'sch_1',
        subject: 'Pemrograman Web & Perangkat Bergerak',
        className: 'XII RPL 1',
        period: 'Jam ke 1 - 2',
        timeRange: '07:00 - 08:30',
        room: 'Lab RPL 1',
        day: 'Senin',
        isCompleted: true,
      ),
      TeachingSchedule(
        id: 'sch_2',
        subject: 'Pemrograman Web & Perangkat Bergerak',
        className: 'XII RPL 2',
        period: 'Jam ke 3 - 4',
        timeRange: '08:30 - 10:00',
        room: 'Lab RPL 2',
        day: 'Senin',
        isCompleted: false,
      ),
      TeachingSchedule(
        id: 'sch_3',
        subject: 'Basis Data Terdistribusi',
        className: 'XI RPL 1',
        period: 'Jam ke 5 - 6',
        timeRange: '10:15 - 11:45',
        room: 'Lab RPL 1',
        day: 'Senin',
        isCompleted: false,
      ),
      TeachingSchedule(
        id: 'sch_4',
        subject: 'Produk Kreatif & Kewirausahaan (PKK)',
        className: 'XII RPL 1',
        period: 'Jam ke 7 - 8',
        timeRange: '12:30 - 14:00',
        room: 'Ruang Teori 12',
        day: 'Selasa',
        isCompleted: false,
      ),
    ]);

    journals.add(
      JournalEntry(
        id: 'jrn_1',
        scheduleId: 'sch_1',
        subject: 'Pemrograman Web & Perangkat Bergerak',
        className: 'XII RPL 1',
        period: 'Jam ke 1 - 2',
        date: DateTime.now(),
        topic: 'Implementasi State Management & Desain UI Mobile Flutter',
        activities:
            'Guru mempresentasikan struktur folder arsitektur clean Flutter, siswa mempraktikkan pembuatan form reset kata sandi dan verifikasi OTP.',
        notes: 'Semua siswa membawa laptop, 2 siswa izin sakit sudah tercatat.',
        totalHadir: 31,
        totalSakit: 1,
        totalIzin: 1,
        totalAlpa: 0,
      ),
    );
  }

  void addJournal(JournalEntry entry) {
    journals.insert(0, entry);
    final idx = schedules.indexWhere((s) => s.id == entry.scheduleId);
    if (idx != -1) {
      schedules[idx].isCompleted = true;
    }
  }
}
