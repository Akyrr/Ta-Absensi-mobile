enum UserRole {
  guruMataPelajaran('Guru Mata Pelajaran', 'Mengabsen siswa per jam & mengisi jurnal'),
  waliKelas('Wali Kelas', 'Monitoring kehadiran kelas binaan & rekap surat'),
  kurikulum('Tim Kurikulum / Admin', 'Pengelolaan jadwal, kelas, dan jurusan');

  final String title;
  final String description;

  const UserRole(this.title, this.description);
}
