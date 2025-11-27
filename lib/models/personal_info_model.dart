class PersonalInfoModel {
  final int? id;
  final String patientName;
  final int age;
  final String doctorName;
  final String examDate;
  final String reminderDate;
  final String lensType;

  PersonalInfoModel({
    this.id,
    required this.patientName,
    required this.age,
    required this.doctorName,
    required this.examDate,
    required this.reminderDate,
    required this.lensType,
  });

  // Convert to Map for DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_name': patientName,
      'age': age,
      'doctor_name': doctorName,
      'exam_date': examDate,
      'reminder_date': reminderDate,
      'lens_type': lensType,
    };
  }

  // Create from Map
  factory PersonalInfoModel.fromMap(Map<String, dynamic> map) {
    return PersonalInfoModel(
      id: map['id'],
      patientName: map['patient_name'],
      age: map['age'],
      doctorName: map['doctor_name'],
      examDate: map['exam_date'],
      reminderDate: map['reminder_date'],
      lensType: map['lens_type'],
    );
  }
}
