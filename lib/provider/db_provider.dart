import 'package:eye_prescription/db/db_helper.dart';
import 'package:flutter/foundation.dart';

class DbProvider extends ChangeNotifier {
  DBHelper dbHelper;
  DbProvider({required this.dbHelper});

  List<Map<String, dynamic>> _mData = [];
  List<Map<String, dynamic>> get mData => _mData;

  void addPrescription(String name, String presDate, String reminder, String doctor, ValueNotifier<String?> lens) async{

     bool check = await dbHelper.addPrescription(
            prescriptionName: name,
            prescriptionDate: presDate,
            reminderDate: reminder,
            doctorName: doctor,
            lensType: lens.value ?? '',
          );

          if (check) {
            _mData = await dbHelper.getAllPrescriptions();
            notifyListeners();
          }

  }

  // void addNotePro(String title, String desc) async{
  //   bool check = await dbHelper.addNote(mTitle: title, mNote: desc);
  //   if(check){
  //     _mData = await dbHelper.getAllNotes();
  //     notifyListeners();

  //   }

  // }

  // void updateNotePro(String title, String desc,int sno) async{
  //   bool check = await dbHelper.update(mTitle: title, mDesc: desc, sno: sno);
  //   if(check){
  //     _mData = await dbHelper.getAllNotes();
  //     notifyListeners();
  //   }

  // }
  
  // void deleteNote(int sno) async{
  //   bool check = await dbHelper.delete(sno: sno);
  //   if(check){
  //     _mData = await dbHelper.getAllNotes();
  //     notifyListeners();
  //   }

  // }



  
  void getAllPrescription() async{
    _mData = await dbHelper.getAllPrescriptions();
    notifyListeners();
  }




}
