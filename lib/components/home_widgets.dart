import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';

class HomeSectionTitle extends StatelessWidget {
  const HomeSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(2),
        bottom: ScreenUtil().setHeight(12),
      ),
      child: Text(
        title,
        style: AppTypography.label.copyWith(
          color: AppColors.textHint,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class HomeCalibrationTip extends StatelessWidget {
  const HomeCalibrationTip({
    super.key,
    required this.message,
    required this.actionLabel,
    required this.onTap,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cta.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(16),
            vertical: ScreenUtil().setHeight(13),
          ),
          child: Row(
            children: [
              Icon(Icons.tune_rounded, color: AppColors.ctaDark, size: ScreenUtil().setSp(18)),
              SizedBox(width: ScreenUtil().setWidth(10)),
              Expanded(child: Text(message, style: AppTypography.caption)),
              Text(
                actionLabel,
                style: AppTypography.caption.copyWith(
                  color: AppColors.ctaDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeToolItemCard extends StatelessWidget {
  const HomeToolItemCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.featured = false,
    this.accentColor = AppColors.primary,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool featured;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return ToolGridTile(
      title: title,
      icon: icon,
      onTap: onTap,
      featured: featured,
    );
  }
}

class ToolGridTile extends StatelessWidget {
  const ToolGridTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.featured = false,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final iconBg = featured ? AppColors.cta.withValues(alpha: 0.14) : AppColors.surfaceMuted;
    final iconColor = featured ? AppColors.ctaDark : AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(14),
              vertical: ScreenUtil().setHeight(16),
            ),
            child: Row(
              children: [
                Container(
                  width: ScreenUtil().setWidth(48),
                  height: ScreenUtil().setWidth(48),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: ScreenUtil().setSp(24),
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(12)),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: ScreenUtil().setSp(15),
                      height: 1.25,
                    ),
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
