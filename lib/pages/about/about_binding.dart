import 'package:get/get.dart';
import 'package:mobilem/pages/about/about_logic.dart';

class AboutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(AboutLogic.new);
  }
}
