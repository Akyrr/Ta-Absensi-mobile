class ClassInfo {
  final int id;
  final String name;
  final int gradeLevel;
  final String? homeroomTeacher;

  const ClassInfo({
    required this.id,
    required this.name,
    required this.gradeLevel,
    this.homeroomTeacher,
  });

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      id: json['id'] as int,
      name: json['name'] as String,
      gradeLevel: json['grade_level'] as int,
      homeroomTeacher: json['homeroom_teacher'] as String?,
    );
  }
}