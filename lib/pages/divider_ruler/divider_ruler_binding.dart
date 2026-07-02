import 'package:get/get.dart';
import 'package:mobilem/pages/divider_ruler/divider_ruler_logic.dart';

class DividerRulerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(DividerRulerLogic.new);
  }
}
