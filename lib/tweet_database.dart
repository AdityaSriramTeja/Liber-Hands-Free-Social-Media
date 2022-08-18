import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:twitter_hackathon/model/note.dart';

class TweetsDatabase {
  static final TweetsDatabase instance = TweetsDatabase._init();

  static Database? _database;

  TweetsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB('notes.db');
    return _database!;
  }

  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 2, onCreate: createDB);
  }

  Future createDB(Database db, int version) async {
    //TODO REPLACED FINAL WITH CONST
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableNotes ( 
  ${NoteFields.id} $idType, 
  ${NoteFields.isImportant} $boolType,
  ${NoteFields.number} $integerType,
  ${NoteFields.title} $textType,
  ${NoteFields.description} $textType,
  ${NoteFields.translated} $textType
  )
''');

    print("CREATED TABLE");
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;

    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NoteFields.number} ASC';

    final result = await db.query(tableNotes, orderBy: orderBy);

    List<Note> tweets = result.map((json) => Note.fromJson(json)).toList();

    //if (tweets.length > 0) {
    return tweets;
  }

  Future<int> update(Note note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future deleteAll() async {
    final db = await instance.database;
    db.execute("DELETE FROM $tableNotes");
    //db.execute("DROP TABLE $tableNotes");
  }
}
