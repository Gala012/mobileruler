import 'package:get/get.dart';
import 'package:mobilem/db_mobilem/db_mobilem_helper.dart';

class ProfileLogic extends GetxController {
  final totalMeasurements = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  Future<void> loadStats() async {
    totalMeasurements.value = await DbMobilemHelper.instance.getTotalMeasurements();
  }

  void goStats() => Get.toNamed('/stats');
  void goCalibrationSettings() => Get.toNamed('/calibration_settings');
  void goUnitSettings() => Get.toNamed('/unit_settings');
  void goHelp() => Get.toNamed('/help');
  void goAbout() => Get.toNamed('/about');
}
