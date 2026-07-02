import 'package:get/get.dart';
import 'package:mobilem/pages/guide/guide_logic.dart';

class GuideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(GuideLogic.new);
  }
}
