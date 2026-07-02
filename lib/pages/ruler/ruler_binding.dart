import 'package:get/get.dart';
import 'package:mobilem/pages/ruler/ruler_logic.dart';

class RulerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(RulerLogic.new);
  }
}
