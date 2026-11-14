import '../features/mata_pelajaran/models/subject_model.dart';

class SubjectService {
  static Future<List<Subject>> getSubjects() async {
    // TODO(Alfin): ganti dengan panggilan API asli (GET /subjects)
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      Subject(id: 1, code: 'MTK-10', name: 'Matematika'),
      Subject(id: 2, code: 'FIS-11', name: 'Fisika'),
    ];
  }
}