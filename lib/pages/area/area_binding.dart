import 'package:get/get.dart';
import 'package:mobilem/pages/area/area_logic.dart';

class AreaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(AreaLogic.new);
  }
}
