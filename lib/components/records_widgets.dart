import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_decorations.dart';
import 'package:mobilem/utils/app_typography.dart';

class RecordsHeader extends StatelessWidget {
  const RecordsHeader({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(16),
        ScreenUtil().setHeight(6),
        ScreenUtil().setWidth(16),
        ScreenUtil().setHeight(8),
      ),
      child: Text(
        title,
        style: AppTypography.display.copyWith(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }
}

class RecordsFilterChip extends StatelessWidget {
  const RecordsFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.cardBg,
      borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(icon != null ? 12 : 14),
            vertical: ScreenUtil().setHeight(8),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
            boxShadow: selected
                ? null
                : [
                    BoxShadow(
                      color: AppColors.shadow.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: ScreenUtil().setSp(14),
                  color: selected ? AppColors.cta : AppColors.textSecondary,
                ),
                SizedBox(width: ScreenUtil().setWidth(4)),
              ],
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecordsDateHeader extends StatelessWidget {
  const RecordsDateHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(4),
        ScreenUtil().setHeight(14),
        ScreenUtil().setWidth(4),
        ScreenUtil().setHeight(8),
      ),
      child: Row(
        children: [
          Container(
            width: ScreenUtil().setWidth(3),
            height: ScreenUtil().setHeight(14),
            decoration: BoxDecoration(
              color: AppColors.cta,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(8)),
          Text(
            title,
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class RecordItemCard extends StatelessWidget {
  const RecordItemCard({
    super.key,
    required this.toolName,
    required this.timeText,
    required this.valueText,
    required this.unit,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.note,
  });

  final String toolName;
  final String timeText;
  final String valueText;
  final String unit;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
        child: Ink(
          decoration: AppDecorations.shadowCard(radius: 14, shadowOpacity: 0.05),
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(12)),
            child: Row(
              children: [
                Container(
                  width: ScreenUtil().setWidth(44),
                  height: ScreenUtil().setWidth(44),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                  ),
                  child: Icon(icon, color: iconColor, size: ScreenUtil().setSp(22)),
                ),
                SizedBox(width: ScreenUtil().setWidth(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        toolName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(3)),
                      Text(timeText, style: AppTypography.label.copyWith(fontSize: ScreenUtil().setSp(11))),
                      if (note != null && note!.isNotEmpty) ...[
                        SizedBox(height: ScreenUtil().setHeight(4)),
                        Text(
                          note!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.label.copyWith(
                            color: AppColors.textHint,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(8)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          valueText,
                          style: AppTypography.title.copyWith(
                            color: AppColors.cta,
                            fontSize: ScreenUtil().setSp(18),
                          ),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(2)),
                        Text(
                          unit,
                          style: AppTypography.label.copyWith(
                            color: AppColors.ctaDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(6)),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textHint,
                      size: ScreenUtil().setSp(20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RecordsEmptyCard extends StatelessWidget {
  const RecordsEmptyCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(24),
        vertical: ScreenUtil().setHeight(48),
      ),
      decoration: AppDecorations.shadowCard(radius: 16, shadowOpacity: 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: ScreenUtil().setWidth(56),
            height: ScreenUtil().setWidth(56),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
            ),
            child: Icon(Icons.history_rounded, size: ScreenUtil().setSp(28), color: AppColors.textHint),
          ),
          SizedBox(height: ScreenUtil().setHeight(16)),
          Text(title, style: AppTypography.title),
          SizedBox(height: ScreenUtil().setHeight(6)),
          Text(subtitle, textAlign: TextAlign.center, style: AppTypography.caption),
        ],
      ),
    );
  }
}
