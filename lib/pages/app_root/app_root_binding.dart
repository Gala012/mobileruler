import 'package:get/get.dart';
import 'package:mobilem/pages/app_root/app_root_logic.dart';
import 'package:mobilem/pages/guide/guide_binding.dart';
import 'package:mobilem/pages/main_shell/main_shell_binding.dart';

class AppRootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppRootLogic());
    GuideBinding().dependencies();
    MainShellBinding().dependencies();
  }
}
