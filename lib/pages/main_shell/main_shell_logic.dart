import 'package:get/get.dart';
import 'package:mobilem/pages/records/records_logic.dart';
import 'package:mobilem/pages/tools/tools_logic.dart';

class MainShellLogic extends GetxController {
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
    if (index == 1 && Get.isRegistered<RecordsLogic>()) {
      Get.find<RecordsLogic>().loadRecords();
    }
    if (index == 0 && Get.isRegistered<ToolsLogic>()) {
      Get.find<ToolsLogic>().loadStats();
    }
  }
}
