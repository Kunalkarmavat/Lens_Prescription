import 'package:eye_prescription/db/db_helper.dart';
import 'package:eye_prescription/provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNotePage extends StatelessWidget {

  bool update;
  String title;
  String desc;
  int sno;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  DBHelper? dbRef; 
  String error_msg = 'Title and Description cannot be empty';
  AddNotePage({ this.update= false, this.title = "", this.desc="", this.sno=0});
  

  @override
  Widget build(BuildContext context) {

    if(update) {
      _titleController.text = title;
      _noteController.text = desc;
    }


    return (
      Scaffold(
        appBar: AppBar(
          title: const Text('Add Note Screen'),
        ),
        body: Container(
      padding: const EdgeInsets.all(16.0),
      
      height: MediaQuery.of(context).viewInsets.bottom + 300,
      
      width: double.infinity,
      color: Colors.white,
      child: Column(
                    mainAxisSize: MainAxisSize.min,

        children: [
          update ? Text('Update Note') : Text('Add Note'),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),

          SizedBox(height: 16),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    String title = _titleController.text;
                    String note = _noteController.text;
          
                    if (note.isNotEmpty &&
                        title.isNotEmpty) {
                          
                          if(update) {
                      //  context.read<DbProvider>().updateNotePro(title, note, sno);

                          } else {
                            // context.read<DbProvider>().addNotePro(title, note);
                          }
                          Navigator.pop(context);
                  
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(error_msg)));
                    }
          
                  },
                  child: update ? Text('Update') : Text('Save'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ],
      ),
    )
      )
      
    );
  }
}