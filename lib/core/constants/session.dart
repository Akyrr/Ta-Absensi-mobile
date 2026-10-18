import 'role.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  String name = 'Drs. Mochamad Arifin, S.Kom';
  String nip = '19840214 200801 1 007';
  String email = 'guru.rpl@smk.belajar.id';
  String sekolah = 'SMK Negeri 1 Surabaya (Pusat Keunggulan)';
  String jurusanBinaan = 'Rekayasa Perangkat Lunak (RPL)';
  UserRole currentRole = UserRole.guruMataPelajaran;
  bool isLoggedIn = false;

  void logout() {
    isLoggedIn = false;
  }

  void login({String? userEmail, UserRole? role}) {
    isLoggedIn = true;
    if (userEmail != null && userEmail.isNotEmpty) {
      email = userEmail;
    }
    if (role != null) {
      currentRole = role;
    }
  }
}
