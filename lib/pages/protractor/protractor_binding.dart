import 'package:get/get.dart';
import 'package:mobilem/pages/protractor/protractor_logic.dart';

class ProtractorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(ProtractorLogic.new);
  }
}
