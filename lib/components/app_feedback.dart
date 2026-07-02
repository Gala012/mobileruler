import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';

enum AppToastType { success, info, warning, error }

class AppToast {
  AppToast._();

  static void success(String message, {String? title}) {
    _show(message, title: title, type: AppToastType.success);
  }

  static void info(String message, {String? title}) {
    _show(message, title: title, type: AppToastType.info);
  }

  static void warning(String message, {String? title}) {
    _show(message, title: title, type: AppToastType.warning);
  }

  static void error(String message, {String? title}) {
    _show(message, title: title, type: AppToastType.error);
  }

  static void _show(
    String message, {
    String? title,
    AppToastType type = AppToastType.success,
  }) {
    if (message.isEmpty && (title == null || title.isEmpty)) return;

    final accent = switch (type) {
      AppToastType.success => AppColors.cta,
      AppToastType.info => AppColors.primary,
      AppToastType.warning => AppColors.ctaDark,
      AppToastType.error => AppColors.danger,
    };

    final icon = switch (type) {
      AppToastType.success => Icons.check_circle_rounded,
      AppToastType.info => Icons.info_outline_rounded,
      AppToastType.warning => Icons.warning_amber_rounded,
      AppToastType.error => Icons.error_outline_rounded,
    };

    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(14),
          vertical: ScreenUtil().setHeight(12),
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
          border: Border.all(color: accent.withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.28),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: ScreenUtil().setWidth(36),
              height: ScreenUtil().setWidth(36),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
              ),
              child: Icon(icon, color: accent, size: ScreenUtil().setSp(20)),
            ),
            SizedBox(width: ScreenUtil().setWidth(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null && title.isNotEmpty) ...[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(2)),
                  ],
                  Text(
                    message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.82),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: Colors.transparent,
      barBlur: 0,
      overlayBlur: 0,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      margin: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(16),
        0,
        ScreenUtil().setWidth(16),
        ScreenUtil().setHeight(20),
      ),
      padding: EdgeInsets.zero,
      borderRadius: 0,
      duration: const Duration(milliseconds: 2400),
      animationDuration: const Duration(milliseconds: 320),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
    );
  }
}
