import 'package:get/get.dart';
import 'package:mobilem/pages/main_shell/main_shell_logic.dart';
import 'package:mobilem/pages/profile/profile_logic.dart';
import 'package:mobilem/pages/records/records_logic.dart';
import 'package:mobilem/pages/tools/tools_logic.dart';

class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(MainShellLogic.new);
    Get.lazyPut(ToolsLogic.new);
    Get.lazyPut(RecordsLogic.new);
    Get.lazyPut(ProfileLogic.new);
  }
}
