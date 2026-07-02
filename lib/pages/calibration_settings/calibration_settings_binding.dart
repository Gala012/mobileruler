import 'package:get/get.dart';
import 'package:mobilem/pages/calibration_settings/calibration_settings_logic.dart';

class CalibrationSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(CalibrationSettingsLogic.new);
  }
}
