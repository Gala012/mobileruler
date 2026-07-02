import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:mobilem/services/app_data_service.dart';

class AppRootLogic extends GetxController {
  final showMainShell = false.obs;
  final mainShellMounted = false.obs;

  AppDataService get _data => Get.find<AppDataService>();

  @override
  void onInit() {
    super.onInit();
    final seen = _data.settings.value.hasSeenGuide;
    mainShellMounted.value = seen;
    showMainShell.value = seen;
    ever(_data.settings, (_) => _onSettingsChanged());
  }

  void _onSettingsChanged() {
    final seen = _data.settings.value.hasSeenGuide;
    if (!seen) {
      showMainShell.value = false;
      return;
    }
    if (!mainShellMounted.value) {
      mainShellMounted.value = true;
    }
    if (showMainShell.value) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (isClosed) return;
      showMainShell.value = true;
    });
  }
}
