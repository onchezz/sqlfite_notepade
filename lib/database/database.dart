import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notepad/models/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<Database> database() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'notes_database.db'),
      onCreate: (db, version) {
        return db.execute(
            '''CREATE TABLE notes( id INTEGER PRIMARY KEY,title TEXT , note TEXT)''');
      },
      version: 1,
    );
  }

  Future<int> insertNote(Note note) async {
    int noteId = 0;
    Database db = await database();
    await db
        .insert('notes', note.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      noteId = value;
    });
    return noteId;
  }

  Future<List<Note>> getNotes() async {
    Database db = await database();
    List<Map<String, dynamic>> noteMap = await db.query('notes');
    return List.generate(noteMap.length, (index) {
      return Note(
        id: noteMap[index]['id'],
        title: noteMap[index]['title'],
        note: noteMap[index]['note'],
        date: noteMap[index]['date'],
      );
    });
  }

  Future<void> upDateNotes(Note note) async {
    Database db = await database();

    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
    //
  }

  Future<void> deleteNote(int id) async {
    Database db = await database();

    await db.delete(
      'notes',
      where: 'id =?',
      whereArgs: [id],
    );
  }
}
