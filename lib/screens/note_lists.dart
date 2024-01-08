// import 'package:flutter/material.dart';
// import 'package:notes/screens/note_detail.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:notes/models/note.dart';
// import 'package:notes/utles//database_helper.dart';
//
// class NoteList extends StatefulWidget {
//   const NoteList({Key? key}) : super(key: key);
//
//   @override
//   State<NoteList> createState() => _NoteListState();
// }
//
// class _NoteListState extends State<NoteList> {
//   DatabaseHelper databaseHelper = DatabaseHelper();
//   List<Note>? noteList;
//   int count = 0;
//
//   ListView getNoteListView() {
//     if (noteList == null) {
//       noteList = <Note>[];
//       updateListView();
//     }
//     return ListView.builder(
//         itemCount: count,
//         itemBuilder: (BuildContext context, int? position) {
//           return Card(
//             color: Colors.white,
//             elevation: 2.0,
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundColor:
//                     getPriorityColor(this.noteList![position!].priority!),
//                 child: getPriorityIcon(this.noteList![position!].priority!),
//               ),
//               trailing: GestureDetector(
//                   onTap: () {
//                     _delete(context, noteList![position!]);
//                   },
//                   child: Icon(Icons.delete, color: Colors.grey)),
//               title: Text(
//                 this.noteList![position!].title!,
//               ),
//               subtitle: Text(this.noteList![position].date!),
//               onTap: () {
//                 navigateToDetail(this.noteList![position], 'Edit Note');
//               },
//             ),
//           );
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (noteList == null) noteList = <Note>[];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notes'),
//       ),
//       body: getNoteListView(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           navigateToDetail(Note('', '', 2), 'Add Note');
//           print('Added ');
//         },
//         tooltip: 'Add note',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
//
//   Color getPriorityColor(int? priority) {
//     switch (priority) {
//       case 1:
//         return Colors.red;
//       case 2:
//         return Colors.yellow;
//       default:
//         return Colors.yellow;
//     }
//   }
//
//   Icon getPriorityIcon(int? priority) {
//     switch (priority) {
//       case 1:
//         return Icon(Icons.play_arrow);
//       case 2:
//         return Icon(Icons.keyboard_arrow_right);
//       default:
//         return Icon(Icons.keyboard_arrow_right);
//     }
//   }
//
//   void _delete(BuildContext context, Note note) async {
//     int result = await databaseHelper.deleteNote(note.id);
//     _showSnackBar(context, "Note Deleted Successfully ");
//     updateListView();
//   }
//
//   void _showSnackBar(BuildContext context, String message) {
//     final snackBar = SnackBar(content: Text(message));
//   }
//
//   void navigateToDetail(Note? note, String? title) async {
//
//     print('navigate to detail');
//
//     bool result =
//         await Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return NoteDetail(note: note, title: title!);
//     }));
//
//     if (result == true) {
//       updateListView();
//     }
//   }
//
//   void updateListView() {
//     final Future<Database> dbFuture = databaseHelper.initializeDatabase();
//     dbFuture.then((database) {
//       Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
//       noteListFuture.then((noteList) {
//         setState(() {
//           this.noteList = noteList;
//           this.count = noteList.length;
//         });
//       });
//     });
//   }
// }
