import 'package:eye_prescription/db/db_helper.dart';
import 'package:flutter/foundation.dart';

class DbProvider extends ChangeNotifier {
  final DBHelper dbHelper;
  DbProvider({required this.dbHelper});

  List<Map<String, dynamic>> _mData = [];
  List<Map<String, dynamic>> get mData => _mData;

  int? _lastInsertedPrescriptionId;
  int? get lastInsertedPrescriptionId => _lastInsertedPrescriptionId;

  // 🔹 Add new prescription
  Future<int> addOnPrescription(
    String name,
    String presDate,
    String reminder,
    String doctor,
    String lens,
  ) async {
    int id = await dbHelper.addPrescription(
      prescriptionName: name,
      prescriptionDate: presDate,
      reminderDate: reminder,
      doctorName: doctor,
      lensType: lens,
    );

    if (id > 0) {
      _lastInsertedPrescriptionId = id;
      _mData = await dbHelper.getAllPrescriptions();
      notifyListeners();
    }

    return id; // ✅ Return inserted prescription ID
  }

  // 🔹 Add lens info
  Future<int> addLensInfo({
    required int prescriptionId,
    required String rightSphere,
    required String leftSphere,
    required String rightNearAdd,
    required String leftNearAdd,
    required String intermediateAdd,
    required String rightCylinder,
    required String leftCylinder,
    required String rightAxis,
    required String leftAxis,
    required String prism,
    required String pupillaryDistance,
    required String note,
  }) async {
    int id = await dbHelper.addLensInfo(
      prescriptionId: prescriptionId,
      rightSphere: rightSphere,
      leftSphere: leftSphere,
      rightNearAdd: rightNearAdd,
      leftNearAdd: leftNearAdd,
      intermediateAdd: intermediateAdd,
      rightCylinder: rightCylinder,
      leftCylinder: leftCylinder,
      rightAxis: rightAxis,
      leftAxis: leftAxis,
      prism: prism,
      pupillaryDistance: pupillaryDistance,
      note: note,
    );

    notifyListeners();
    return id;
  }

  // 🔹 Get all prescriptions
  Future<void> getAllPrescription() async {
    _mData = await dbHelper.getAllPrescriptions();
    notifyListeners();
  }

  // 🔹 Get single prescription (with lens info)
  Future<Map<String, dynamic>?> getSinglePrescriptionData() async {
    if (_lastInsertedPrescriptionId == null) return null;

    final data = await dbHelper.getSinglePrescriptionData(_lastInsertedPrescriptionId!);
    return data;
  }

  // 🔹 Delete prescription
  Future<void> deletePrescription(int id) async {
    await dbHelper.deletePrescription(id);
    _mData = await dbHelper.getAllPrescriptions();
    notifyListeners();
  }
}
