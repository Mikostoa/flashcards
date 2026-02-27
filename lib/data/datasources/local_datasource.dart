

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/entities/collection.dart';

class LocalDataSource {
  static final LocalDataSource _instance = LocalDataSource._internal();
  factory LocalDataSource() => _instance;
  LocalDataSource._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'flashcards.db');
    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE collections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        isActive INTEGER DEFAULT 1,
        customIntervalFactor REAL DEFAULT 1.0
      )
    ''');
    await db.execute('''
      CREATE TABLE flashcards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        collection_id INTEGER,
        next_review_date TEXT,
        interval INTEGER,
        FOREIGN KEY (collection_id) REFERENCES collections(id)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE collections (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          isActive INTEGER DEFAULT 1,
          customIntervalFactor REAL DEFAULT 1.0
        )
      ''');
      await db.execute('''
        ALTER TABLE flashcards ADD COLUMN collection_id INTEGER
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        ALTER TABLE flashcards ADD COLUMN next_review_date TEXT
      ''');
      await db.execute('''
        ALTER TABLE flashcards ADD COLUMN interval INTEGER
      ''');
    }
    if (oldVersion < 4) {
      await db.execute('''
        ALTER TABLE collections ADD COLUMN isActive INTEGER DEFAULT 1
      ''');
      await db.execute('''
        ALTER TABLE collections ADD COLUMN customIntervalFactor REAL DEFAULT 1.0
      ''');
    }
  }

  Future<List<Flashcard>> getFlashcards({int? collectionId}) async {
    final db = await database;
    final now = DateTime.now().toIso8601String().substring(0, 10);
    final maps = collectionId != null
        ? await db.query(
            'flashcards',
            where: 'collection_id = ? AND (next_review_date <= ? OR next_review_date IS NULL) AND EXISTS (SELECT 1 FROM collections WHERE id = collection_id AND isActive = 1)',
            whereArgs: [collectionId, now],
          )
        : await db.query(
            'flashcards',
            where: 'next_review_date <= ? OR next_review_date IS NULL AND EXISTS (SELECT 1 FROM collections WHERE id = collection_id AND isActive = 1)',
            // where: 'next_review_date <= ?',
            whereArgs: [now],
          );
    return maps.map((map) => Flashcard.fromMap(map)).toList();
  }

  Future<void> addFlashcard(Flashcard flashcard) async {
    final db = await database;
    await db.insert('flashcards', flashcard.toMap());
  }

  Future<List<Collection>> getCollections({bool onlyActive = false}) async {
    final db = await database;
    final maps = onlyActive
        ? await db.query('collections', where: 'isActive = ?', whereArgs: [1])
        : await db.query('collections');
    return maps.map((map) => Collection.fromMap(map)).toList();
  }

  Future<void> addCollection(Collection collection) async {
    final db = await database;
    await db.insert('collections', collection.toMap());
  }

  Future<void> updateFlashcard(Flashcard flashcard) async {
    final db = await database;
    await db.update(
      'flashcards',
      flashcard.toMap(),
      where: 'id = ?',
      whereArgs: [flashcard.id],
    );
  }

  Future<void> updateCollection(Collection collection) async {
    final db = await database;
    await db.update(
      'collections',
      collection.toMap(),
      where: 'id = ?',
      whereArgs: [collection.id],
    );
  }
}


