import 'package:get/get.dart';
import 'package:mobilem/pages/level/level_logic.dart';

class LevelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(LevelLogic.new);
  }
}
