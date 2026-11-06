enum AttendanceStatus {
  hadir('H', 'Hadir'),
  sakit('S', 'Sakit'),
  izin('I', 'Izin'),
  alpa('A', 'Alpa');

  final String code;
  final String label;
  const AttendanceStatus(this.code, this.label);
}

class Student {
  final String nisn;
  final String name;
  final String gender;
  AttendanceStatus status;
  String? note;

  Student({
    required this.nisn,
    required this.name,
    required this.gender,
    this.status = AttendanceStatus.hadir,
    this.note,
  });
}

class DepartmentInfo {
  final String id;
  final String code;
  final String name;
  final String iconName;

  const DepartmentInfo({
    required this.id,
    required this.code,
    required this.name,
    required this.iconName,
  });
}

class ClassRoom {
  final String id;
  final String name;
  final String departmentCode;
  final int grade;
  final String homeroomTeacher;
  final List<Student> students;

  ClassRoom({
    required this.id,
    required this.name,
    required this.departmentCode,
    required this.grade,
    required this.homeroomTeacher,
    required this.students,
  });

  int get totalStudents => students.length;
  int get countHadir => students.where((s) => s.status == AttendanceStatus.hadir).length;
  int get countSakit => students.where((s) => s.status == AttendanceStatus.sakit).length;
  int get countIzin => students.where((s) => s.status == AttendanceStatus.izin).length;
  int get countAlpa => students.where((s) => s.status == AttendanceStatus.alpa).length;
}

class SmkRepository {
  static final SmkRepository _instance = SmkRepository._internal();
  factory SmkRepository() => _instance;
  SmkRepository._internal() {
    _initData();
  }

  final List<DepartmentInfo> departments = [
    const DepartmentInfo(
      id: 'dep_rpl',
      code: 'RPL',
      name: 'Rekayasa Perangkat Lunak',
      iconName: 'laptop_chromebook',
    ),
    const DepartmentInfo(
      id: 'dep_tkj',
      code: 'TKJ',
      name: 'Teknik Komputer & Jaringan',
      iconName: 'router',
    ),
    const DepartmentInfo(
      id: 'dep_dkv',
      code: 'DKV',
      name: 'Desain Komunikasi Visual',
      iconName: 'brush',
    ),
  ];

  final List<ClassRoom> classes = [];

  void _initData() {
    final studentNames = [
      'Achmad Rizky Pratama',
      'Aditya Bagus Saputra',
      'Agung Prasetyo',
      'Aisyah Nur Rahmawati',
      'Alfin Mochamad',
      'Ananda Dwi Lestari',
      'Angga Wahyu Pratama',
      'Arya Bima Sena',
      'Bagus Tri Pamungkas',
      'Bayu Setiawan',
      'Bima Purbawasesa',
      'Citra Kirana Putri',
      'Danang Tri Laksono',
      'Denny Kurniawan',
      'Dimas Aditya Permana',
      'Dwi Cahyono',
      'Fadhil Muhammad',
      'Farhan Alamsyah',
      'Galang Rambu Anarki',
      'Hafizh Alamsyah',
      'Ilham Maulana',
      'Indah Permatasari',
      'Kevin Sanjaya',
      'Luthfi Hakim',
      'Muhammad Aziz',
      'Nabila Azzahra',
      'Nurul Hidayah',
      'Rafi Ahmad Dani',
      'Reza Rahardian',
      'Rizka Amanda',
      'Satria Nugraha',
      'Tiara Andini Putri',
      'Wahyu Hidayat',
    ];

    final classConfigs = [
      {'name': 'XII RPL 1', 'dep': 'RPL', 'grade': 12, 'wali': 'Bambang Sugeng, S.Pd'},
      {'name': 'XII RPL 2', 'dep': 'RPL', 'grade': 12, 'wali': 'Siti Maryam, S.Kom'},
      {'name': 'XI RPL 1', 'dep': 'RPL', 'grade': 11, 'wali': 'Hendro Wibowo, S.Kom'},
      {'name': 'XI RPL 2', 'dep': 'RPL', 'grade': 11, 'wali': 'Nurhayati, M.Pd'},
      {'name': 'XII TKJ 1', 'dep': 'TKJ', 'grade': 12, 'wali': 'Agus Suprianto, M.T'},
      {'name': 'XII TKJ 2', 'dep': 'TKJ', 'grade': 12, 'wali': 'Dra. Endang Sulastri'},
      {'name': 'XII DKV 1', 'dep': 'DKV', 'grade': 12, 'wali': 'Rini Kusumawardani, S.Sn'},
      {'name': 'XII DKV 2', 'dep': 'DKV', 'grade': 12, 'wali': 'Faisal Rahman, M.Ds'},
    ];

    for (var i = 0; i < classConfigs.length; i++) {
      final config = classConfigs[i];
      final classStudents = <Student>[];

      for (var s = 0; s < studentNames.length; s++) {
        final nisnNum = 54000000 + (i * 100) + s;
        final name = studentNames[s];
        final isFemale = name.contains('Aisyah') ||
            name.contains('Lestari') ||
            name.contains('Citra') ||
            name.contains('Indah') ||
            name.contains('Nabila') ||
            name.contains('Nurul') ||
            name.contains('Rizka') ||
            name.contains('Tiara');

        AttendanceStatus st = AttendanceStatus.hadir;
        if (s == 3) st = AttendanceStatus.sakit;
        if (s == 7) st = AttendanceStatus.izin;

        classStudents.add(
          Student(
            nisn: '00$nisnNum',
            name: name,
            gender: isFemale ? 'P' : 'L',
            status: st,
          ),
        );
      }

      classes.add(
        ClassRoom(
          id: 'cls_${config['name']?.toString().replaceAll(' ', '_')}',
          name: config['name'] as String,
          departmentCode: config['dep'] as String,
          grade: config['grade'] as int,
          homeroomTeacher: config['wali'] as String,
          students: classStudents,
        ),
      );
    }
  }

  ClassRoom? getClassById(String id) {
    try {
      return classes.firstWhere((c) => c.id == id);
    } catch (_) {
      return classes.isNotEmpty ? classes.first : null;
    }
  }
}
