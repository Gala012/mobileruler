import 'package:get/get.dart';
import 'package:mobilem/pages/scale_ruler/scale_ruler_logic.dart';

class ScaleRulerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(ScaleRulerLogic.new);
  }
}
