//import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:saude_em_foco_v2/vaccine.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static const _databaseName = 'vacinas2.db';
  static const _databaseVersion = 1;
  static const _vaccineTable = 'vaccines';

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    await _onUpgrade(await openDatabase(path, version: _databaseVersion, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE $_vaccineTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          age_min INTEGER NOT NULL,
          age_max INTEGER NOT NULL
        )
      ''');
    }),1,1);
    return await openDatabase(path);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
  }

  Future<void> insertVaccine(Vaccine vaccine) async {
    final db = await database;
    await db.insert(_vaccineTable, vaccine.toMap());
  }

  Future<List<Vaccine>> getAllVaccines() async {
    final db = await database;
    final maps = await db.query(_vaccineTable, orderBy: 'age_min ASC');
    return List.generate(maps.length, (i) => Vaccine.fromMap(maps[i]));
  }

  Future<void> updateVaccine(Vaccine vaccine) async {
    final db = await database;
    final values = {'name': vaccine.name, 'age_min': vaccine.ageMin, 'age_max': vaccine.ageMax};
    final id = vaccine.id;
    if (id != null) {
      await db.update(_vaccineTable, values, where: 'id = ?', whereArgs: [id]);
    }
  }

  Future<void> deleteVaccine(int id) async {
    final db = await database;
    await db.delete(_vaccineTable, where: 'id = ?', whereArgs: [id]);
  }
}

extension VaccineMap on Vaccine {
  Map<String, dynamic> toMap() => {
    'name': name,
    'age_min': ageMin,
    'age_max': ageMax,
  };
}

extension VaccineFromMap on Vaccine {
  static Vaccine fromMap(Map<String, dynamic> map) => Vaccine(
    id: map['id'] as int,
    name: map['name'] as String,
    ageMin: map['age_min'] as int,
    ageMax: map['age_max'] as int,
  );
}
