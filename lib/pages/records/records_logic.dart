import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobilem/db_mobilem/db_mobilem_entity.dart';
import 'package:mobilem/db_mobilem/db_mobilem_helper.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/services/app_data_service.dart';

class RecordSection {
  const RecordSection({required this.title, required this.items});

  final String title;
  final List<MeasurementRecordEntity> items;
}

class RecordsLogic extends GetxController {
  final records = <MeasurementRecordEntity>[].obs;
  final filter = ''.obs;

  final filters = const ['', 'ruler', 'protractor', 'distance', 'area', 'outdoor_area', 'level', 'compass'];

  @override
  void onInit() {
    super.onInit();
    loadRecords();
    ever(Get.find<AppDataService>().recordRevision, (_) => loadRecords());
  }

  Future<void> loadRecords() async {
    records.value = await DbMobilemHelper.instance.getRecords(
      toolType: filter.value.isEmpty ? null : filter.value,
    );
  }

  void setFilter(String value) {
    filter.value = value;
    loadRecords();
  }

  String filterLabel(String value) {
    if (value.isEmpty) return Lang.filterAll;
    return Lang.toolTypeLabel(value);
  }

  List<RecordSection> get sections {
    final map = <String, List<MeasurementRecordEntity>>{};
    final order = <String>[];
    for (final record in records) {
      final key = _dateLabel(DateTime.parse(record.createdAt));
      if (!map.containsKey(key)) {
        map[key] = [];
        order.add(key);
      }
      map[key]!.add(record);
    }
    return order.map((title) => RecordSection(title: title, items: map[title]!)).toList();
  }

  String _dateLabel(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(dateTime.year, dateTime.month, dateTime.day);
    if (day == today) return Lang.recordsToday;
    if (day == today.subtract(const Duration(days: 1))) return Lang.recordsYesterday;
    return DateFormat('MMM d', 'en_US').format(dateTime);
  }

  String timeLabel(String createdAt) {
    return DateFormat('HH:mm').format(DateTime.parse(createdAt));
  }

  Future<void> deleteRecord(int id) async {
    await DbMobilemHelper.instance.deleteRecord(id);
    await loadRecords();
  }

  void openDetail(int id) async {
    await Get.toNamed('/record_detail', arguments: id);
    await loadRecords();
  }
}
