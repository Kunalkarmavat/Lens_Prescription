import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/personal_info_model.dart';
import '../models/vision_details_model.dart';

class DBHelper {
  DBHelper._init();
  static final DBHelper instance = DBHelper._init();

  static Database? _db;

  // ✅ Table Names
  static const String tablePersonalInfo = 'personal_info';
  static const String tableVisionDetails = 'vision_details';

  // ✅ Personal Info Columns
  static const String colId = 'id';
  static const String colPatientName = 'patient_name';
  static const String colAge = 'age';
  static const String colDoctorName = 'doctor_name';
  static const String colExamDate = 'exam_date';
  static const String colReminderDate = 'reminder_date';
  static const String colLensType = 'lens_type';

  // ✅ Vision Details Columns
  static const String colPersonalInfoId = 'personal_info_id';

  static const String colRightSphere = 'right_sphere';
  static const String colLeftSphere = 'left_sphere';

  static const String colRightNearAdd = 'right_near_add';
  static const String colLeftNearAdd = 'left_near_add';

  static const String colIntermediateAdd = 'intermediate_add';

  static const String colRightCylinder = 'right_cylinder';
  static const String colLeftCylinder = 'left_cylinder';

  static const String colRightAxis = 'right_axis';
  static const String colLeftAxis = 'left_axis';

  static const String colPrism = 'prism';
  static const String colRightHorizontalPrism = 'right_horizontal_prism';
  static const String colLeftHorizontalPrism = 'left_horizontal_prism';
  static const String colRightVerticalPrism = 'right_vertical_prism';
  static const String colLeftVerticalPrism = 'left_vertical_prism';

  static const String colPupillaryDistance = 'pupillary_distance';
  static const String colSinglePD = 'single_pd';
  static const String colRightDistancePd = 'right_distance_pd';
  static const String colleftDistancePd = 'left_distance_pd';

  static const String colNote = 'note';

  // ✅ Initialize Database
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('eye_prescription.db');
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tablePersonalInfo (
      $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colPatientName TEXT,
      $colAge INTEGER,
      $colDoctorName TEXT,
      $colExamDate TEXT,
      $colReminderDate TEXT,
      $colLensType TEXT
    )
  ''');

    await db.execute('''
  CREATE TABLE $tableVisionDetails (

    $colId INTEGER PRIMARY KEY AUTOINCREMENT,

    $colPersonalInfoId INTEGER,

    $colRightSphere REAL,
    $colLeftSphere REAL,
    $colRightNearAdd REAL,
    $colLeftNearAdd REAL,

    $colIntermediateAdd INTEGER,

    $colRightCylinder REAL,
    $colLeftCylinder REAL,
    $colRightAxis INTEGER,
    $colLeftAxis INTEGER,

    $colPrism INTEGER,

    $colRightHorizontalPrism TEXT,
    $colLeftHorizontalPrism TEXT,
    $colRightVerticalPrism TEXT,
    $colLeftVerticalPrism TEXT,

    $colPupillaryDistance INTEGER,

    $colSinglePD INTEGER,
    $colRightDistancePd REAL,
    $colleftDistancePd REAL,
    $colNote TEXT,
    
    FOREIGN KEY ($colPersonalInfoId) REFERENCES $tablePersonalInfo($colId)

  )
''');
  }

  // ✅ Insert Personal Info
  Future<int> insertPersonalInfo(PersonalInfoModel info) async {
    final db = await database;
    return await db.insert(tablePersonalInfo, info.toMap());
  }

  // ✅ Insert Vision Details
  Future<int> insertVisionDetails(
    VisionDetails details,
    int personalInfoId,
  ) async {
    final db = await database;
    final data = details.toMap();
    data[colPersonalInfoId] = personalInfoId;
    return await db.insert(tableVisionDetails, data);
  }

  // ✅ Get Joined Prescription Data
  Future<Map<String, dynamic>?> getPrescriptionData(int personalInfoId) async {
    final db = await database;

    final result = await db.rawQuery(
      '''
      SELECT p.*, v.*
      FROM $tablePersonalInfo p
      LEFT JOIN $tableVisionDetails v
      ON p.$colId = v.$colPersonalInfoId
      WHERE p.$colId = ?
    ''',
      [personalInfoId],
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getAllPrescriptions() async {
    final db = await database;

    final result = await db.rawQuery('''
    SELECT p.*, v.*
    FROM $tablePersonalInfo p
    LEFT JOIN $tableVisionDetails v
    ON p.$colId = v.$colPersonalInfoId
    ORDER BY p.$colId DESC
  ''');

    return result;
  }

  // ✅ Delete prescription (delete from both tables)
  Future<int> deletePrescription(int personalInfoId) async {
    final db = await database;

    // Delete from vision_details first
    await db.delete(
      tableVisionDetails,
      where: '$colPersonalInfoId = ?',
      whereArgs: [personalInfoId],
    );

    // Delete from personal_info
    return await db.delete(
      tablePersonalInfo,
      where: '$colId = ?',
      whereArgs: [personalInfoId],
    );
  }

  // ✅ Close Database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
