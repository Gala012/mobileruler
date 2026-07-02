import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobilem/utils/app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get display => GoogleFonts.inter(
        fontSize: ScreenUtil().setSp(28),
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.6,
        height: 1.2,
      );

  static TextStyle get headline => GoogleFonts.inter(
        fontSize: ScreenUtil().setSp(22),
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.4,
        height: 1.25,
      );

  static TextStyle get title => GoogleFonts.inter(
        fontSize: ScreenUtil().setSp(17),
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: ScreenUtil().setSp(15),
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: ScreenUtil().setSp(15),
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: ScreenUtil().setSp(13),
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get label => GoogleFonts.inter(
        fontSize: ScreenUtil().setSp(12),
        fontWeight: FontWeight.w500,
        color: AppColors.textHint,
        letterSpacing: 0.2,
      );

  static TextStyle get metric => GoogleFonts.inter(
        fontSize: ScreenUtil().setSp(36),
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -1,
        height: 1,
      );

  static TextStyle get appBar => GoogleFonts.inter(
        fontSize: ScreenUtil().setSp(17),
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
      );
}
