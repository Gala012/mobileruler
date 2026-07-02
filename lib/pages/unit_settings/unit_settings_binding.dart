import 'package:get/get.dart';
import 'package:mobilem/pages/unit_settings/unit_settings_logic.dart';

class UnitSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(UnitSettingsLogic.new);
  }
}
