import 'package:get/get.dart';
import 'package:mobilem/pages/calibration/calibration_logic.dart';

class CalibrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(CalibrationLogic.new);
  }
}
