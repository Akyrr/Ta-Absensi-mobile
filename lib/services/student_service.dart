import '../features/data_siswa/models/master_student_model.dart';

class StudentService {
  static Future<List<MasterStudent>> getMyClassStudents() async {
    // TODO(Alfin): ganti dengan panggilan API asli (GET /students)
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      MasterStudent(id: 1, name: 'Siti Aminah', nisn: '1234567890', className: 'X RPL 1'),
      MasterStudent(id: 2, name: 'Budi Santoso', nisn: '1234567891', className: 'X RPL 1'),
    ];
  }
}