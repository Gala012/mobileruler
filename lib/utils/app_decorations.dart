import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilem/utils/app_colors.dart';

class AppDecorations {
  AppDecorations._();

  static BorderRadius get radius12 => BorderRadius.circular(ScreenUtil().radius(12));
  static BorderRadius get radius16 => BorderRadius.circular(ScreenUtil().radius(16));

  static BoxDecoration card({Color? color}) => BoxDecoration(
        color: color ?? AppColors.cardBg,
        borderRadius: radius12,
        border: Border.all(color: AppColors.divider),
      );

  static BoxDecoration cardElevated({Color? color}) => BoxDecoration(
        color: color ?? AppColors.cardBg,
        borderRadius: radius12,
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration shadowCard({
    Color? color,
    double radius = 16,
    double shadowOpacity = 0.07,
  }) =>
      BoxDecoration(
        color: color ?? AppColors.cardBg,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(radius)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: shadowOpacity),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: shadowOpacity * 0.5),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      );

  static BoxDecoration iconBox({Color? tint}) => BoxDecoration(
        color: tint ?? AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
      );
}
