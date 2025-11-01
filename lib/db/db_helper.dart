import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {

  DBHelper._();
  static final getInstance = DBHelper._();

  // Database name
  static const String DB_NAME = 'prescriptionDB.db';

  // Prescription Table
  static const String TABLE_PRESCRIPTION = 'prescription_table';
  static const String COLUMN_PRES_SNO = 's_no';
  static const String COLUMN_PRES_NAME = 'prescription_name';
  static const String COLUMN_PRES_DATE = 'prescription_date';
  static const String COLUMN_REMINDER_DATE = 'reminder_date';
  static const String COLUMN_DOCTOR_NAME = 'doctor_name';
  static const String COLUMN_LENS_TYPE = 'lens_type';

  // Lens Info Table
  static const String TABLE_LENS_INFO = 'lens_info_table';
  static const String COLUMN_LENS_ID = 'lens_id';
  static const String COLUMN_PRES_ID = 'prescription_id';
  static const String COLUMN_RIGHT_SPHERE = 'right_sphere';
  static const String COLUMN_LEFT_SPHERE = 'left_sphere';
  static const String COLUMN_RIGHT_NEAR_ADD = 'right_near_add';
  static const String COLUMN_LEFT_NEAR_ADD = 'left_near_add';
  static const String COLUMN_INTERMEDIATE_ADD = 'intermediate_add';
  static const String COLUMN_RIGHT_CYLINDER = 'right_cylinder';
  static const String COLUMN_LEFT_CYLINDER = 'left_cylinder';
  static const String COLUMN_RIGHT_AXIS = 'right_axis';
  static const String COLUMN_LEFT_AXIS = 'left_axis';
  static const String COLUMN_PRISM = 'prism';
  static const String COLUMN_PD = 'pupillary_distance';
  static const String COLUMN_NOTE = 'note';

  Database? _db;

  // Get DB
  Future<Database> getDB() async {
    _db ??= await _openDB();
    return _db!;
  }

  // Open DB
  Future<Database> _openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, DB_NAME);

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        // Prescription Table
        await db.execute('''
          CREATE TABLE $TABLE_PRESCRIPTION (
            $COLUMN_PRES_SNO INTEGER PRIMARY KEY AUTOINCREMENT,
            $COLUMN_PRES_NAME TEXT NOT NULL,
            $COLUMN_PRES_DATE TEXT NOT NULL,
            $COLUMN_REMINDER_DATE TEXT,
            $COLUMN_DOCTOR_NAME TEXT,
            $COLUMN_LENS_TYPE TEXT
          )
        ''');

        // Lens Info Table
        await db.execute('''
          CREATE TABLE $TABLE_LENS_INFO (
            $COLUMN_LENS_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $COLUMN_PRES_ID INTEGER,
            $COLUMN_RIGHT_SPHERE TEXT,
            $COLUMN_LEFT_SPHERE TEXT,
            $COLUMN_RIGHT_NEAR_ADD TEXT,
            $COLUMN_LEFT_NEAR_ADD TEXT,
            $COLUMN_INTERMEDIATE_ADD TEXT,
            $COLUMN_RIGHT_CYLINDER TEXT,
            $COLUMN_LEFT_CYLINDER TEXT,
            $COLUMN_RIGHT_AXIS TEXT,
            $COLUMN_LEFT_AXIS TEXT,
            $COLUMN_PRISM TEXT,
            $COLUMN_PD TEXT,
            $COLUMN_NOTE TEXT,
            FOREIGN KEY ($COLUMN_PRES_ID) REFERENCES $TABLE_PRESCRIPTION ($COLUMN_PRES_SNO) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  // void Search( String SearchText)async {
  //   print("Searching for $SearchText");
  //   final db = await getDB();
  //   List<Map<String, dynamic>> results = await db.query(
  //     TABLE_PRESCRIPTION,
  //     where: '$COLUMN_PRES_NAME LIKE ?',
  //     whereArgs: ['%$SearchText%'],
  //   );
  // }

  // Insert Prescription
Future<int> addPrescription({
  required String prescriptionName,
  required String prescriptionDate,
  required String reminderDate,
  required String doctorName,
  required String lensType,
}) async {
  final db = await getDB();
  int id = await db.insert(TABLE_PRESCRIPTION, {
    COLUMN_PRES_NAME: prescriptionName,
    COLUMN_PRES_DATE: prescriptionDate,
    COLUMN_REMINDER_DATE: reminderDate,
    COLUMN_DOCTOR_NAME: doctorName,
    COLUMN_LENS_TYPE: lensType,
  });
  
  return id; // 👈 return the new record ID
}


  // Insert Lens Info
// Insert Lens Info
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
  final db = await getDB();
  int id = await db.insert(TABLE_LENS_INFO, {
    COLUMN_PRES_ID: prescriptionId,
    COLUMN_RIGHT_SPHERE: rightSphere,
    COLUMN_LEFT_SPHERE: leftSphere,
    COLUMN_RIGHT_NEAR_ADD: rightNearAdd,
    COLUMN_LEFT_NEAR_ADD: leftNearAdd,
    COLUMN_INTERMEDIATE_ADD: intermediateAdd,
    COLUMN_RIGHT_CYLINDER: rightCylinder,
    COLUMN_LEFT_CYLINDER: leftCylinder,
    COLUMN_RIGHT_AXIS: rightAxis,
    COLUMN_LEFT_AXIS: leftAxis,
    COLUMN_PRISM: prism,
    COLUMN_PD: pupillaryDistance,
    COLUMN_NOTE: note,
  });

  return id; // 👈 Return the inserted row ID
}


  // Get all prescriptions
  Future<List<Map<String, dynamic>>> getAllPrescriptions() async {
    final db = await getDB();
    return await db.query(TABLE_PRESCRIPTION);
  }

  // Get lens info by prescription id
  Future<List<Map<String, dynamic>>> getLensInfoByPrescription(int id) async {
    final db = await getDB();
    return await db.query(
      TABLE_LENS_INFO,
      where: '$COLUMN_PRES_ID = ?',
      whereArgs: [id],
    );
  }

  // Delete prescription (cascade deletes lens info)
  Future<bool> deletePrescription(int sno) async {
    final db = await getDB();
    int result = await db.delete(
      TABLE_PRESCRIPTION,
      where: '$COLUMN_PRES_SNO = ?',
      whereArgs: [sno],
    );
    return result > 0;
  }

  // Close DB
  Future<void> closeDB() async {
    final db = await getDB();
    await db.close();
  }


  Future<Map<String, dynamic>?> getSinglePrescriptionData(int prescriptionId) async {
  final db = await getDB();
  final result = await db.rawQuery('''
    SELECT 
      p.$COLUMN_PRES_SNO AS id,
      p.$COLUMN_PRES_NAME AS name,
      p.$COLUMN_PRES_DATE AS date,
      p.$COLUMN_DOCTOR_NAME AS doctor,
      p.$COLUMN_LENS_TYPE AS lensType,
      l.$COLUMN_RIGHT_SPHERE AS rightSphere,
      l.$COLUMN_LEFT_SPHERE AS leftSphere,
      l.$COLUMN_RIGHT_CYLINDER AS rightCylinder,
      l.$COLUMN_LEFT_CYLINDER AS leftCylinder,
      l.$COLUMN_RIGHT_AXIS AS rightAxis,
      l.$COLUMN_LEFT_AXIS AS leftAxis,
      l.$COLUMN_PRISM AS prism,
      l.$COLUMN_PD AS pupillaryDistance,
      l.$COLUMN_NOTE AS note
    FROM $TABLE_PRESCRIPTION p
    INNER JOIN $TABLE_LENS_INFO l 
    ON p.$COLUMN_PRES_SNO = l.$COLUMN_PRES_ID
    WHERE p.$COLUMN_PRES_SNO = ?
  ''', [prescriptionId]);

  // Return first row if found, else null
  if (result.isNotEmpty) {
    return result.first;
  } else {
    return null;
  }
}

}
