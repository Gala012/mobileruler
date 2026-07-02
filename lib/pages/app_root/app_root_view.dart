import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilem/pages/app_root/app_root_logic.dart';
import 'package:mobilem/pages/guide/guide_view.dart';
import 'package:mobilem/pages/main_shell/main_shell_view.dart';

class AppRootView extends GetView<AppRootLogic> {
  const AppRootView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final showMain = controller.showMainShell.value;
      final mainMounted = controller.mainShellMounted.value;
      return IndexedStack(
        index: showMain ? 1 : 0,
        sizing: StackFit.expand,
        children: [
          const GuideView(),
          if (mainMounted) const MainShellView() else const SizedBox.shrink(),
        ],
      );
    });
  }
}
