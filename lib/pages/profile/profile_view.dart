import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/secondary_page_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/profile/profile_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_decorations.dart';
import 'package:mobilem/utils/app_typography.dart';
import 'package:mobilem/utils/tool_icons.dart';

class ProfileView extends GetView<ProfileLogic> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.pageBg,
      child: SafeArea(
        child: Obx(() {
          final count = controller.totalMeasurements.value;
          final badge = count > 0 ? '$count ${Lang.statsTimes}' : null;

          return ListView(
            padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(16),
              ScreenUtil().setHeight(6),
              ScreenUtil().setWidth(16),
              ScreenUtil().setHeight(20),
            ),
            children: [
              Text(
                Lang.profileTitle,
                style: AppTypography.display.copyWith(fontSize: ScreenUtil().setSp(28)),
              ),
              SizedBox(height: ScreenUtil().setHeight(16)),
              _buildHeroCard(badge),
              SizedBox(height: ScreenUtil().setHeight(12)),
              _buildMenuCard(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeroCard(String? badge) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ScreenUtil().setWidth(18)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardBg,
            AppColors.cta.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
        border: Border.all(color: AppColors.cta.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: ScreenUtil().setWidth(60),
            height: ScreenUtil().setWidth(60),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.cta, AppColors.ctaDark],
              ),
              borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cta.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              ToolIcons.ruler,
              color: AppColors.primary,
              size: ScreenUtil().setSp(30),
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Lang.appName, style: AppTypography.title),
                SizedBox(height: ScreenUtil().setHeight(4)),
                Text(
                  Lang.profileHeroDesc,
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
                if (badge != null) ...[
                  SizedBox(height: ScreenUtil().setHeight(10)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(10),
                      vertical: ScreenUtil().setHeight(4),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cta.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
                    ),
                    child: Text(
                      badge,
                      style: AppTypography.label.copyWith(
                        color: AppColors.ctaDark,
                        fontWeight: FontWeight.w700,
                        fontSize: ScreenUtil().setSp(11),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard() {
    return Container(
      decoration: AppDecorations.shadowCard(radius: 16, shadowOpacity: 0.06),
      child: Column(
        children: [
          MenuGroupTile(
            title: Lang.profileStats,
            subtitle: Lang.profileStatsDesc,
            icon: Icons.leaderboard_rounded,
            iconColor: AppColors.cta,
            onTap: controller.goStats,
          ),
          _divider(),
          MenuGroupTile(
            title: Lang.profileCalibration,
            subtitle: Lang.profileCalibrationDesc,
            icon: Icons.precision_manufacturing_rounded,
            iconColor: AppColors.cta,
            onTap: controller.goCalibrationSettings,
          ),
          _divider(),
          MenuGroupTile(
            title: Lang.profileUnit,
            subtitle: Lang.profileUnitDesc,
            icon: Icons.swap_vert_circle_outlined,
            iconColor: AppColors.primary,
            onTap: controller.goUnitSettings,
          ),
          _divider(),
          MenuGroupTile(
            title: Lang.profileHelp,
            subtitle: Lang.profileHelpDesc,
            icon: Icons.menu_book_rounded,
            iconColor: AppColors.secondary,
            onTap: controller.goHelp,
          ),
          _divider(),
          MenuGroupTile(
            title: Lang.profileAbout,
            subtitle: Lang.profileAboutDesc,
            icon: Icons.verified_user_rounded,
            iconColor: AppColors.secondary,
            onTap: controller.goAbout,
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      indent: ScreenUtil().setWidth(68),
      color: AppColors.divider.withValues(alpha: 0.6),
    );
  }
}
