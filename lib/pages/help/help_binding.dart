import 'package:get/get.dart';
import 'package:mobilem/pages/help/help_logic.dart';

class HelpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(HelpLogic.new);
  }
}
