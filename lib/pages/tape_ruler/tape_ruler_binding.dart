import 'package:get/get.dart';
import 'package:mobilem/pages/tape_ruler/tape_ruler_logic.dart';

class TapeRulerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(TapeRulerLogic.new);
  }
}
