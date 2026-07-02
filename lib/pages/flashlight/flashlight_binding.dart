import 'package:get/get.dart';
import 'package:mobilem/pages/flashlight/flashlight_logic.dart';

class FlashlightBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(FlashlightLogic.new);
  }
}
