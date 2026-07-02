import 'package:get/get.dart';
import 'package:mobilem/pages/outdoor_area/outdoor_area_logic.dart';

class OutdoorAreaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(OutdoorAreaLogic.new);
  }
}
