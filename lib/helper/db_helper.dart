import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'huertix.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE participaciones_local (
            id TEXT PRIMARY KEY,
            zonaId TEXT,
            usuarioId TEXT,
            nombreZona TEXT,
            tarea TEXT,
            fecha TEXT
          )
        ''');
      },
    );
  }

  static Future<void> guardarParticipacion(Map<String, dynamic> data) async {
    final dbClient = await db;
    await dbClient.insert(
      'participaciones_local',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<bool> yaParticipa(String zonaId, String usuarioId) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'participaciones_local',
      where: 'zonaId = ? AND usuarioId = ?',
      whereArgs: [zonaId, usuarioId],
    );
    return result.isNotEmpty;
  }

  static Future<List<String>> obtenerParticipaciones(String usuarioId) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'participaciones_local',
      where: 'usuarioId = ?',
      whereArgs: [usuarioId],
    );
    return result.map((e) => e['zonaId'] as String).toList();
  }

  static Future<void> eliminarBaseDeDatos() async {
    final path = join(await getDatabasesPath(), 'huertix.db');
    await deleteDatabase(path);
  }
}
