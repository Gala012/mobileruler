import 'package:mobilem/db_mobilem/data.dart';
import 'package:mobilem/db_mobilem/db_mobilem_entity.dart';
import 'package:sqflite/sqflite.dart';

class DbMobilemHelper {
  DbMobilemHelper._();
  static final DbMobilemHelper instance = DbMobilemHelper._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await DbMobilemData.initDb();
    return _db!;
  }

  Future<AppSettingsEntity> getSettings() async {
    final db = await database;
    final rows = await db.query('app_settings', where: 'id = ?', whereArgs: [1]);
    if (rows.isEmpty) {
      final defaults = AppSettingsEntity();
      await db.insert('app_settings', defaults.toMap());
      return defaults;
    }
    return AppSettingsEntity.fromMap(rows.first);
  }

  Future<void> saveSettings(AppSettingsEntity settings) async {
    final db = await database;
    await db.update('app_settings', settings.toMap(), where: 'id = ?', whereArgs: [1]);
  }

  Future<int> insertRecord(MeasurementRecordEntity record) async {
    final db = await database;
    return db.insert('measurement_records', record.toMap());
  }

  Future<List<MeasurementRecordEntity>> getRecords({String? toolType}) async {
    final db = await database;
    final rows = toolType == null || toolType.isEmpty
        ? await db.query('measurement_records', orderBy: 'created_at DESC')
        : await db.query(
            'measurement_records',
            where: 'tool_type = ?',
            whereArgs: [toolType],
            orderBy: 'created_at DESC',
          );
    return rows.map(MeasurementRecordEntity.fromMap).toList();
  }

  Future<MeasurementRecordEntity?> getRecordById(int id) async {
    final db = await database;
    final rows = await db.query('measurement_records', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return MeasurementRecordEntity.fromMap(rows.first);
  }

  Future<void> deleteRecord(int id) async {
    final db = await database;
    await db.delete('measurement_records', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> incrementUsage(String toolType) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    final rows = await db.query('usage_stats', where: 'tool_type = ?', whereArgs: [toolType]);
    if (rows.isEmpty) {
      await db.insert('usage_stats', {
        'tool_type': toolType,
        'use_count': 1,
        'last_used_at': now,
      });
    } else {
      final count = (rows.first['use_count'] as int? ?? 0) + 1;
      await db.update(
        'usage_stats',
        {'use_count': count, 'last_used_at': now},
        where: 'tool_type = ?',
        whereArgs: [toolType],
      );
    }
    await _checkBadges(db);
  }

  Future<void> _checkBadges(Database db) async {
    final total = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM measurement_records'),
        ) ??
        0;
    final thresholds = {'badge_10': 10, 'badge_50': 50, 'badge_100': 100};
    final now = DateTime.now().toIso8601String();
    for (final entry in thresholds.entries) {
      if (total >= entry.value) {
        final existing = await db.query(
          'achievement_badges',
          where: 'badge_key = ?',
          whereArgs: [entry.key],
        );
        if (existing.isEmpty) {
          await db.insert('achievement_badges', {
            'badge_key': entry.key,
            'unlocked_at': now,
          });
        }
      }
    }
  }

  Future<List<UsageStatEntity>> getUsageStats() async {
    final db = await database;
    final rows = await db.query('usage_stats', orderBy: 'use_count DESC');
    return rows.map(UsageStatEntity.fromMap).toList();
  }

  Future<int> getTotalMeasurements() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM measurement_records'),
        ) ??
        0;
  }

  Future<int> getRecentActiveDays() async {
    final db = await database;
    final since = DateTime.now().subtract(const Duration(days: 7)).toIso8601String();
    final rows = await db.rawQuery(
      "SELECT DISTINCT date(created_at) as d FROM measurement_records WHERE created_at >= ?",
      [since],
    );
    return rows.length;
  }

  Future<List<MapEntry<String, int>>> getDailyMeasurementTrend({int days = 7}) async {
    final db = await database;
    final startDay = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ).subtract(Duration(days: days - 1));
    final since = startDay.toIso8601String();
    final rows = await db.rawQuery(
      "SELECT date(created_at) as d, COUNT(*) as c FROM measurement_records WHERE created_at >= ? GROUP BY date(created_at)",
      [since],
    );
    final map = <String, int>{};
    for (final row in rows) {
      map[row['d'] as String] = row['c'] as int;
    }
    final result = <MapEntry<String, int>>[];
    for (var i = 0; i < days; i++) {
      final day = startDay.add(Duration(days: i));
      final key =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      result.add(MapEntry('${day.month}/${day.day}', map[key] ?? 0));
    }
    return result;
  }

  Future<List<AchievementBadgeEntity>> getBadges() async {
    final db = await database;
    final rows = await db.query('achievement_badges', orderBy: 'unlocked_at ASC');
    return rows.map(AchievementBadgeEntity.fromMap).toList();
  }
}
