import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/app_chrome.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';

Future<T?> showAppBottomSheet<T>({
  required Widget child,
  String? title,
  String? subtitle,
  IconData? icon,
  Color? iconColor,
  bool showClose = true,
  bool isScrollControlled = true,
  bool compact = false,
}) {
  return Get.bottomSheet<T>(
    Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(ScreenUtil().radius(compact ? 16 : 20))),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.16),
            blurRadius: 28,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: ScreenUtil().setHeight(compact ? 6 : 10)),
            Container(
              width: ScreenUtil().setWidth(compact ? 32 : 40),
              height: ScreenUtil().setHeight(3),
              decoration: BoxDecoration(
                color: AppColors.cta.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(2)),
              ),
            ),
            if (title != null)
              SheetHeader(
                title: title,
                subtitle: subtitle,
                icon: icon,
                iconColor: iconColor,
                compact: compact,
                onClose: showClose ? () => Get.back() : null,
              )
            else
              SizedBox(height: ScreenUtil().setHeight(compact ? 6 : 12)),
            child,
          ],
        ),
      ),
    ),
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.black.withValues(alpha: 0.35),
    barrierColor: Colors.black.withValues(alpha: 0.35),
    enterBottomSheetDuration: const Duration(milliseconds: 280),
    exitBottomSheetDuration: const Duration(milliseconds: 220),
  );
}

Future<bool?> showConfirmSheet({
  required String message,
  String confirmLabel = Lang.confirm,
  String cancelLabel = Lang.cancel,
  bool destructive = true,
}) {
  return showAppBottomSheet<bool>(
    title: Lang.confirm,
    icon: destructive ? Icons.delete_outline_rounded : Icons.help_outline_rounded,
    iconColor: destructive ? AppColors.danger : AppColors.cta,
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(20),
        0,
        ScreenUtil().setWidth(20),
        ScreenUtil().setHeight(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: ScreenUtil().setHeight(24)),
          Row(
            children: [
              Expanded(
                child: SheetSecondaryButton(
                  label: cancelLabel,
                  onPressed: () => Get.back(result: false),
                ),
              ),
              SizedBox(width: ScreenUtil().setWidth(12)),
              Expanded(
                child: SheetPrimaryButton(
                  label: confirmLabel,
                  destructive: destructive,
                  onPressed: () => Get.back(result: true),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Future<String?> showNoteInputSheet({String initial = ''}) {
  final controller = TextEditingController(text: initial);
  return showAppBottomSheet<String>(
    compact: true,
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(16),
        0,
        ScreenUtil().setWidth(16),
        ScreenUtil().setHeight(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  Lang.note,
                  style: AppTypography.title.copyWith(fontSize: ScreenUtil().setSp(16)),
                ),
              ),
              SheetCloseButton(onTap: () => Get.back()),
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          TextField(
            controller: controller,
            maxLines: 2,
            minLines: 1,
            autofocus: true,
            style: AppTypography.bodyMedium,
            decoration: InputDecoration(
              hintText: Lang.noteHint,
              hintStyle: AppTypography.caption,
              isDense: true,
              filled: true,
              fillColor: AppColors.surfaceMuted,
              contentPadding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(12),
                vertical: ScreenUtil().setHeight(10),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
                borderSide: const BorderSide(color: AppColors.cta, width: 1.5),
              ),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(12)),
          SizedBox(
            height: ScreenUtil().setHeight(44),
            child: ElevatedButton(
              onPressed: () => Get.back(result: controller.text.trim()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cta,
                foregroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
                ),
              ),
              child: Text(
                Lang.save,
                style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
