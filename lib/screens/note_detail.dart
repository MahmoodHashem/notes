import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes/models/note.dart';
import 'package:notes/utles//database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  NoteDetail({
    Key? key,
    this.note,
    this.title,
  }) : super(key: key);

  final Note? note;
  final String? title;

  @override
  State<NoteDetail> createState() => _NoteDetailState(this.note!, this.title!);
}

class _NoteDetailState extends State<NoteDetail> {
  DatabaseHelper helper = DatabaseHelper();

  String? title;
  Note? note;

  _NoteDetailState(this.note, this.title) {}

  static List<String> _priorities = ['Low', 'High'];

  TextEditingController? titleController = TextEditingController();
  TextEditingController? descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController!.text = note!.title!;
    descriptionController!.text = note!.description! ?? 'null';

    TextStyle? textStyle = Theme.of(context).textTheme.titleMedium;
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title!),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, right: 10.0, left: 10.0),
        child: ListView(
          children: [
            ListTile(
              title: DropdownButton(
                items: _priorities.map((String? dropDownStringItem) {
                  return DropdownMenuItem(
                      value: dropDownStringItem!,
                      child: Text(dropDownStringItem));
                }).toList(),
                value: getPriorityAsString(note!.priority!),
                onChanged: (valueSelectedByUser) {
                  setState(() {
                    updatePriorityAsInt(valueSelectedByUser!);
                  });
                },
                style: textStyle,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController!,
                style: textStyle,
                onChanged: (value) {
                  print("Somthing was entered in title ");
                  updateTitle();
                },
                decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (value) {
                  print("Somthing was entered in description");
                  updateDescription();
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).primaryColorDark),
                      ),
                      child: Text(
                        'Save',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        _save();
                        print('save was clicked ');
                      },
                    ),
                  ),
                  Container(
                    width: 5,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).primaryColorDark),
                      ),
                      child: Text(
                        'Delete',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        _delete();
                        print('Delete was clicked');
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String? value) {
    switch (value) {
      case 'High':
        note?.priority = 1;
        break;
      case 'Low':
        note?.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int? value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
      default:
        priority = _priorities[0];
    }
    return priority;
  }

  void updateTitle() {
    note?.title = titleController!.text;
  }

  // Update the description of Note object
  void updateDescription() {
    note?.description = descriptionController!.text;
  }

  void _save() async {
    moveToLastScreen();

    note?.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note?.id != null) {
      // Case 1: Update operation
      result = await helper.updateNote(note!);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertNote(note!);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note?.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note!.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
