import '../features/kelas/models/class_model.dart';

class ClassService {
  static Future<List<ClassInfo>> getMyClasses() async {
    // TODO(Alfin): ganti dengan panggilan API asli (GET /classes)
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      ClassInfo(id: 1, name: 'X RPL 1', gradeLevel: 10, homeroomTeacher: 'Ibu Rina'),
    ];
  }
}