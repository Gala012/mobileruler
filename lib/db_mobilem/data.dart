import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbMobilemData {
  static const String _dbName = 'mobilem.db';
  static const int _version = 1;

  static Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE app_settings (
        id INTEGER PRIMARY KEY,
        has_seen_guide INTEGER NOT NULL DEFAULT 0,
        default_length_unit TEXT NOT NULL DEFAULT 'cm',
        default_area_unit TEXT NOT NULL DEFAULT 'cm2',
        calibration_factor REAL NOT NULL DEFAULT 0,
        calibration_ref_type TEXT NOT NULL DEFAULT '',
        calibrated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE measurement_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tool_type TEXT NOT NULL,
        value REAL NOT NULL,
        unit TEXT NOT NULL,
        extra_json TEXT NOT NULL DEFAULT '{}',
        note TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE usage_stats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tool_type TEXT NOT NULL UNIQUE,
        use_count INTEGER NOT NULL DEFAULT 0,
        last_used_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE achievement_badges (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        badge_key TEXT NOT NULL UNIQUE,
        unlocked_at TEXT NOT NULL
      )
    ''');

    await db.insert('app_settings', {
      'id': 1,
      'has_seen_guide': 0,
      'default_length_unit': 'cm',
      'default_area_unit': 'cm2',
      'calibration_factor': 0,
      'calibration_ref_type': '',
      'calibrated_at': null,
    });
  }
}
