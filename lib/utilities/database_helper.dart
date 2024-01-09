import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:notes/models/note.dart';

class DatabaseHelper {
  static late DatabaseHelper _databaseHelper;   //singleton
  static late Database _database;

  static const _databaseName = "notes_database.db";
  static const table = 'notes_table';
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnDescription = 'description';
  static const columnDate = 'date';
  static const columnPriority = 'priority';


  DatabaseHelper._createInstance();  // named constructor to create instance of databasehelper

  factory DatabaseHelper() {
    _databaseHelper = DatabaseHelper._createInstance();
    return _databaseHelper;
  }

  Future<Database> get database async {
    _database = await initializeDb();
    return _database;
  }

  Future<Database> initializeDb() async {

    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}notes_database.db';

    return await openDatabase(path, version: 1, onCreate: _onCreate);

  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnDescription TEXT NOT NULL,
            $columnDate INTEGER NOT NULL,
            $columnPriority INTEGER NOT NULL
          )
          ''');
  }


  Future<List<Note>> getNoteMapList() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table, orderBy: columnPriority);

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<int> insert(Note note) async {
    Database db = await database;
    return await db.insert(table, note.toMap());
  }

  Future<int> update(Note note) async {
    Database db = await database;
    return await db.update(table, note.toMap(),
        where: '$columnId = ?', whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    Database db = await database;
    return await db.rawDelete("DELETE FROM $table WHERE $columnId = $id");
  }

  Future<int> getCount() async {

    Database db = await database;

    List<Map<String, dynamic>> x = await db.rawQuery("SELECT COUNT (*) FROM $table");

    int result = Sqflite.firstIntValue(x)!;

    return result;

  }

  Future<List<Note>> getNoteList() async {

    List noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = [];

    for (int i = 0; i < count; i++){
      noteList.add(Note.fromMap(noteMapList[i]));
    }

    return noteList;

  }


 }
