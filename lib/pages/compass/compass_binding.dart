import 'package:get/get.dart';
import 'package:mobilem/pages/compass/compass_logic.dart';

class CompassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(CompassLogic.new);
  }
}
