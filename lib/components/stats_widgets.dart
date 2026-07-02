import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_decorations.dart';
import 'package:mobilem/utils/app_typography.dart';
import 'package:mobilem/lang/lang.dart';

class StatsSectionTitle extends StatelessWidget {
  const StatsSectionTitle({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(12)),
      child: Row(
        children: [
          Icon(icon, size: ScreenUtil().setSp(18), color: AppColors.ctaDark),
          SizedBox(width: ScreenUtil().setWidth(8)),
          Text(
            title,
            style: AppTypography.title.copyWith(fontSize: ScreenUtil().setSp(16)),
          ),
        ],
      ),
    );
  }
}

class StatsMetricCard extends StatelessWidget {
  const StatsMetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
      decoration: AppDecorations.shadowCard(radius: 16, shadowOpacity: 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ScreenUtil().setWidth(40),
            height: ScreenUtil().setWidth(40),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
            ),
            child: Icon(icon, color: iconColor, size: ScreenUtil().setSp(20)),
          ),
          SizedBox(height: ScreenUtil().setHeight(14)),
          Text(label, style: AppTypography.label),
          SizedBox(height: ScreenUtil().setHeight(6)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTypography.metric.copyWith(fontSize: ScreenUtil().setSp(28)),
              ),
              SizedBox(width: ScreenUtil().setWidth(4)),
              Padding(
                padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(3)),
                child: Text(unit, style: AppTypography.caption),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatsHighlightCard extends StatelessWidget {
  const StatsHighlightCard({
    super.key,
    required this.title,
    required this.toolName,
    required this.count,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String toolName;
  final int count;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ScreenUtil().setWidth(18)),
      decoration: AppDecorations.shadowCard(radius: 18, shadowOpacity: 0.07),
      child: Row(
        children: [
          Container(
            width: ScreenUtil().setWidth(52),
            height: ScreenUtil().setWidth(52),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
            ),
            child: Icon(icon, color: iconColor, size: ScreenUtil().setSp(26)),
          ),
          SizedBox(width: ScreenUtil().setWidth(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.label),
                SizedBox(height: ScreenUtil().setHeight(4)),
                Text(toolName, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$count',
                style: AppTypography.title.copyWith(color: AppColors.ctaDark),
              ),
              Text(Lang.statsTimes, style: AppTypography.label),
            ],
          ),
        ],
      ),
    );
  }
}

class StatsUsageCard extends StatelessWidget {
  const StatsUsageCard({
    super.key,
    required this.rank,
    required this.toolName,
    required this.count,
    required this.ratio,
    required this.icon,
    required this.iconColor,
  });

  final int rank;
  final String toolName;
  final int count;
  final double ratio;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
      padding: EdgeInsets.all(ScreenUtil().setWidth(14)),
      decoration: AppDecorations.shadowCard(radius: 16, shadowOpacity: 0.05),
      child: Row(
        children: [
          Container(
            width: ScreenUtil().setWidth(28),
            height: ScreenUtil().setWidth(28),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: rank == 1 ? AppColors.cta.withValues(alpha: 0.15) : AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
            ),
            child: Text(
              '$rank',
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: rank == 1 ? AppColors.ctaDark : AppColors.textHint,
              ),
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(10)),
          Container(
            width: ScreenUtil().setWidth(40),
            height: ScreenUtil().setWidth(40),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
            ),
            child: Icon(icon, color: iconColor, size: ScreenUtil().setSp(20)),
          ),
          SizedBox(width: ScreenUtil().setWidth(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        toolName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                    Text(
                      '$count',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.ctaDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(8)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(4)),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: ScreenUtil().setHeight(5),
                    backgroundColor: AppColors.surfaceMuted,
                    color: AppColors.cta,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatsBadgeCard extends StatelessWidget {
  const StatsBadgeCard({
    super.key,
    required this.title,
    required this.target,
    required this.progress,
    required this.unlocked,
  });

  final String title;
  final int target;
  final double progress;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
      decoration: AppDecorations.shadowCard(
        radius: 16,
        shadowOpacity: unlocked ? 0.08 : 0.05,
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: ScreenUtil().setWidth(48),
                height: ScreenUtil().setWidth(48),
                child: CircularProgressIndicator(
                  value: unlocked ? 1 : progress,
                  strokeWidth: ScreenUtil().setWidth(3),
                  backgroundColor: AppColors.surfaceMuted,
                  color: unlocked ? AppColors.cta : AppColors.cta.withValues(alpha: 0.5),
                ),
              ),
              Icon(
                unlocked ? Icons.emoji_events_rounded : Icons.lock_outline_rounded,
                color: unlocked ? AppColors.ctaDark : AppColors.textHint,
                size: ScreenUtil().setSp(20),
              ),
            ],
          ),
          SizedBox(width: ScreenUtil().setWidth(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unlocked ? title : Lang.badgeLocked,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: unlocked ? AppColors.textPrimary : AppColors.textHint,
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(4)),
                Text(
                  unlocked
                      ? Lang.statsBadgeDoneLabel(target)
                      : Lang.statsBadgeGoalLabel(target),
                  style: AppTypography.label,
                ),
              ],
            ),
          ),
          if (unlocked)
            Icon(Icons.check_circle_rounded, color: AppColors.success, size: ScreenUtil().setSp(20)),
        ],
      ),
    );
  }
}

class StatsEmptyCard extends StatelessWidget {
  const StatsEmptyCard({
    super.key,
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(20),
        vertical: ScreenUtil().setHeight(28),
      ),
      decoration: AppDecorations.shadowCard(radius: 16, shadowOpacity: 0.05),
      child: Column(
        children: [
          Icon(icon, size: ScreenUtil().setSp(32), color: AppColors.textHint),
          SizedBox(height: ScreenUtil().setHeight(10)),
          Text(message, style: AppTypography.caption),
        ],
      ),
    );
  }
}
