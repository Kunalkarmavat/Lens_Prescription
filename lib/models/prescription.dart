import 'lens.dart';

class Prescription {
  int? id;
  String? patientName;
  String? doctorName;
  String? date;
  String? expiryDate;
  String? revisitDate;
  LensOption? lensType;
  Lens? lens;

  Prescription({
    this.id,
    this.patientName,
    this.doctorName,
    this.date,
    this.expiryDate,
    this.revisitDate,
    this.lensType,
    this.lens,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientName': patientName,
      'doctorName': doctorName,
      'date': date,
      'expiryDate': expiryDate,
      'revisitDate': revisitDate,
      'lensType': lensType?.toString(),
      'prism': lens?.prism,
      'pupillaryDistance': lens?.pupillaryDistance,
      'rightSphere': lens?.rightSphere,
      'leftSphere': lens?.leftSphere,
      'rightCylinder': lens?.rightCylinder,
      'leftCylinder': lens?.leftCylinder,
      'rightAxis': lens?.rightAxis,
      'leftAxis': lens?.leftAxis,
    };
  }

  factory Prescription.fromMap(Map<String, dynamic> map) {
    return Prescription(
      id: map['id'],
      patientName: map['patientName'],
      doctorName: map['doctorName'],
      date: map['date'],
      expiryDate: map['expiryDate'],
      revisitDate: map['revisitDate'],
      lensType: map['lensType'] != null
          ? LensOption.values.firstWhere(
              (e) => e.toString() == map['lensType'],
            )
          : null,
      lens: map['rightSphere'] != null
          ? Lens(
              prism: map['prism'] as String? ?? '',
              pupillaryDistance: map['pupillaryDistance'] as String? ?? '',
              rightSphere: map['rightSphere'] as double? ?? 0.0,
              leftSphere: map['leftSphere'] as double? ?? 0.0,
              rightCylinder: map['rightCylinder'] as double? ?? 0.0,
              leftCylinder: map['leftCylinder'] as double? ?? 0.0,
              rightAxis: map['rightAxis'] as double? ?? 0.0,
              leftAxis: map['leftAxis'] as double? ?? 0.0,
            )
          : null,
    );
  }
}
