import 'package:eye_prescription/db/db_helper.dart';
import 'package:flutter/foundation.dart';

class DbProvider extends ChangeNotifier {
  final DBHelper dbHelper;

  List<Map<String, dynamic>> prescriptions = [];
  List<Map<String, dynamic>> filteredPrescriptions = [];

  int? _prescriptionId;
  int? get prescriptionId => _prescriptionId;

  DbProvider({required this.dbHelper}) {
    loadPrescriptions();
  }

  /// ✅ Fetch all prescriptions from DB
  Future<void> loadPrescriptions() async {
    prescriptions = await dbHelper.getAllPrescriptions();
    filteredPrescriptions = prescriptions; // show all initially
    notifyListeners();
  }

  /// ✅ Search filter
  void filterPrescriptions(String query) {
    if (query.isEmpty) {
      filteredPrescriptions = prescriptions;
    } else {
      filteredPrescriptions = prescriptions.where((pres) {
        final name = pres['patient_name']?.toLowerCase() ?? "";
        return name.contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  /// ✅ Insert personal info
  Future<int> insertPersonalInfo(personalInfo) async {
    int id = await dbHelper.insertPersonalInfo(personalInfo);
    _prescriptionId = id;
    notifyListeners();
    return id;
  }

   Future<Map<String, dynamic>?> getFullPrescription() async {
    final data = await dbHelper.getPrescriptionData(_prescriptionId!);
    notifyListeners();
    return data;
  }


  /// ✅ Insert vision details
  Future<int> insertVisionDetails(visionDetails) async {
    int id = await dbHelper.insertVisionDetails(
      visionDetails,
      _prescriptionId!,
    );

    

    /// reload list after insert
    await loadPrescriptions();
    notifyListeners();
    return id;
  }
}
