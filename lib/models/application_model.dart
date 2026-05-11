class ApplicationModel {
  final String id;
  final String studentId;
  final String year;
  final String module1;
  final String module2;
  final String status;
  final bool eligible;

  ApplicationModel({
    required this.id,
    required this.studentId,
    required this.year,
    required this.module1,
    required this.module2,
    required this.status,
    required this.eligible,
  });

    factory ApplicationModel.fromMap(
      Map<String, dynamic> map) {
    return ApplicationModel(
      id: map['id'].toString(),
      studentId: map['student_id'],
      year: map['year'],
      module1: map['module1'],
      module2: map['module2'],
      status: map['status'],
      eligible: map['eligible'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'year': year,
      'module1': module1,
      'module2': module2,
      'status': status,
      'eligible': eligible,
    };
  }
}
