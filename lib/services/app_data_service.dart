import 'package:get/get.dart';
import 'package:mobilem/db_mobilem/db_mobilem_entity.dart';
import 'package:mobilem/db_mobilem/db_mobilem_helper.dart';
import 'package:mobilem/utils/screen_metrics.dart';

class AppDataService extends GetxService {
  final Rx<AppSettingsEntity> settings = const AppSettingsEntity().obs;
  final recordRevision = 0.obs;

  Future<AppDataService> init() async {
    settings.value = await DbMobilemHelper.instance.getSettings();
    return this;
  }

  Future<void> refreshSettings() async {
    settings.value = await DbMobilemHelper.instance.getSettings();
  }

  Future<void> updateSettings(AppSettingsEntity newSettings) async {
    await DbMobilemHelper.instance.saveSettings(newSettings);
    settings.value = newSettings;
  }

  Future<void> markGuideSeen() async {
    final updated = settings.value.copyWith(hasSeenGuide: true);
    await updateSettings(updated);
  }

  Future<void> saveCalibration({
    required double factor,
    required String refType,
  }) async {
    final updated = settings.value.copyWith(
      calibrationFactor: factor,
      calibrationRefType: refType,
      calibratedAt: DateTime.now().toIso8601String(),
    );
    await updateSettings(updated);
  }

  Future<void> resetCalibration() async {
    final updated = settings.value.copyWith(
      calibrationFactor: 0,
      calibrationRefType: '',
      calibratedAt: null,
    );
    await updateSettings(updated);
  }

  Future<int> saveMeasurement(MeasurementRecordEntity record) async {
    final id = await DbMobilemHelper.instance.insertRecord(record);
    await DbMobilemHelper.instance.incrementUsage(record.toolType);
    recordRevision.value++;
    return id;
  }

  double autoPixelsPerMm() => ScreenMetrics.autoPixelsPerMm();

  bool get isManuallyCalibrated => settings.value.isManuallyCalibrated;

  double pixelsPerMm() {
    final factor = settings.value.calibrationFactor;
    if (factor > 0) return factor;
    return autoPixelsPerMm();
  }
}
