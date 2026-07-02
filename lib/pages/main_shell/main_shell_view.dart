import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/main_shell/main_shell_logic.dart';
import 'package:mobilem/pages/profile/profile_view.dart';
import 'package:mobilem/pages/records/records_view.dart';
import 'package:mobilem/pages/tools/tools_view.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';

class MainShellView extends GetView<MainShellLogic> {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    const pages = [
      ToolsView(),
      RecordsView(),
      ProfileView(),
    ];

    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: Obx(() {
        final currentIndex = controller.currentIndex.value;
        return Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(12),
                vertical: ScreenUtil().setHeight(8),
              ),
              child: Row(
                children: [
                  _navItem(
                    currentIndex,
                    0,
                    Icons.grid_view_rounded,
                    Icons.grid_view_outlined,
                    Lang.tabTools,
                  ),
                  _navItem(
                    currentIndex,
                    1,
                    Icons.history_rounded,
                    Icons.history_outlined,
                    Lang.tabRecords,
                  ),
                  _navItem(
                    currentIndex,
                    2,
                    Icons.person_rounded,
                    Icons.person_outline_rounded,
                    Lang.tabProfile,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _navItem(
    int currentIndex,
    int index,
    IconData selectedIcon,
    IconData unselectedIcon,
    String label,
  ) {
    final selected = currentIndex == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.changeTab(index),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(6)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? selectedIcon : unselectedIcon,
                  size: ScreenUtil().setSp(24),
                  color: selected ? AppColors.ctaDark : AppColors.textHint,
                ),
                SizedBox(height: ScreenUtil().setHeight(4)),
                Text(
                  label,
                  style: AppTypography.label.copyWith(
                    color: selected ? AppColors.primary : AppColors.textHint,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: ScreenUtil().setSp(11),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
