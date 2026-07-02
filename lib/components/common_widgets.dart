import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_decorations.dart';
import 'package:mobilem/utils/app_typography.dart';

class ToolCard extends StatelessWidget {
  const ToolCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBg,
      borderRadius: AppDecorations.radius12,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDecorations.radius12,
        splashColor: AppColors.cta.withValues(alpha: 0.08),
        highlightColor: AppColors.surfaceMuted,
        child: Ink(
          decoration: AppDecorations.card(),
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: ScreenUtil().setWidth(40),
                  height: ScreenUtil().setWidth(40),
                  decoration: AppDecorations.iconBox(),
                  child: Icon(icon, color: color, size: ScreenUtil().setSp(20)),
                ),
                const Spacer(),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.trailing,
    this.iconColor = AppColors.primary,
    this.showDivider = true,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color iconColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: AppColors.cardBg,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(20),
                vertical: ScreenUtil().setHeight(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: ScreenUtil().setWidth(36),
                    height: ScreenUtil().setWidth(36),
                    decoration: AppDecorations.iconBox(tint: AppColors.surfaceMuted),
                    child: Icon(icon, color: iconColor, size: ScreenUtil().setSp(18)),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(14)),
                  Expanded(child: Text(title, style: AppTypography.bodyMedium)),
                  trailing ??
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textHint,
                        size: ScreenUtil().setSp(20),
                      ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: ScreenUtil().setWidth(70),
            color: AppColors.divider,
          ),
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.expanded = true,
    this.color = AppColors.cta,
    this.textColor = Colors.white,
    this.icon,
    this.height = 52,
  });

  final String label;
  final VoidCallback onPressed;
  final bool expanded;
  final Color color;
  final Color textColor;
  final IconData? icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        elevation: 0,
        minimumSize: Size(expanded ? double.infinity : 0, ScreenUtil().setHeight(height)),
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenUtil().radius(8))),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: ScreenUtil().setSp(18)),
            SizedBox(width: ScreenUtil().setWidth(6)),
          ],
          Text(label, style: AppTypography.bodyMedium.copyWith(color: textColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.expanded = true,
    this.icon,
    this.height = 52,
  });

  final String label;
  final VoidCallback onPressed;
  final bool expanded;
  final IconData? icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(expanded ? double.infinity : 0, ScreenUtil().setHeight(height)),
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: ScreenUtil().setSp(18)),
            SizedBox(width: ScreenUtil().setWidth(6)),
          ],
          Text(label),
        ],
      ),
    );
    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: ScreenUtil().setWidth(64),
              height: ScreenUtil().setWidth(64),
              decoration: AppDecorations.iconBox(),
              child: Icon(icon, size: ScreenUtil().setSp(28), color: AppColors.textHint),
            ),
            SizedBox(height: ScreenUtil().setHeight(20)),
            Text(title, textAlign: TextAlign.center, style: AppTypography.title),
            if (subtitle != null) ...[
              SizedBox(height: ScreenUtil().setHeight(8)),
              Text(subtitle!, textAlign: TextAlign.center, style: AppTypography.caption),
            ],
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.unit,
  });

  final String label;
  final String value;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
      decoration: AppDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.label),
          SizedBox(height: ScreenUtil().setHeight(10)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: AppTypography.metric.copyWith(fontSize: ScreenUtil().setSp(32))),
              if (unit != null) ...[
                SizedBox(width: ScreenUtil().setWidth(4)),
                Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(4)),
                  child: Text(unit!, style: AppTypography.caption),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBg,
      borderRadius: AppDecorations.radius12,
      child: InkWell(
        onTap: onAction,
        borderRadius: AppDecorations.radius12,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppDecorations.radius12,
            border: Border.all(color: AppColors.cta.withValues(alpha: 0.35)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(16),
              vertical: ScreenUtil().setHeight(14),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: AppColors.cta, size: ScreenUtil().setSp(18)),
                SizedBox(width: ScreenUtil().setWidth(10)),
                Expanded(child: Text(message, style: AppTypography.caption.copyWith(color: AppColors.textPrimary))),
                Text(
                  actionLabel,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.cta,
                    fontWeight: FontWeight.w600,
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

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

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
            horizontal: ScreenUtil().setWidth(16),
            vertical: ScreenUtil().setHeight(8),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
            border: Border.all(color: selected ? AppColors.primary : AppColors.divider),
          ),
          child: Text(
            label,
            style: AppTypography.caption.copyWith(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class ToolMetricBar extends StatelessWidget {
  const ToolMetricBar({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.accentColor = AppColors.cta,
  });

  final String label;
  final String value;
  final String? unit;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(20),
        vertical: ScreenUtil().setHeight(18),
      ),
      decoration: const BoxDecoration(
        color: AppColors.cardBg,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        children: [
          Text(label, style: AppTypography.label),
          SizedBox(height: ScreenUtil().setHeight(6)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTypography.metric.copyWith(color: accentColor),
              ),
              if (unit != null) ...[
                SizedBox(width: ScreenUtil().setWidth(4)),
                Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(6)),
                  child: Text(unit!, style: AppTypography.title.copyWith(color: accentColor)),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class ToolActionBar extends StatelessWidget {
  const ToolActionBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(20),
        ScreenUtil().setHeight(12),
        ScreenUtil().setWidth(20),
        ScreenUtil().setHeight(20),
      ),
      decoration: const BoxDecoration(
        color: AppColors.cardBg,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}

class RecordListTile extends StatelessWidget {
  const RecordListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onTap,
    this.selected = false,
    this.leading,
  });

  final String title;
  final String subtitle;
  final String value;
  final VoidCallback onTap;
  final bool selected;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBg,
      borderRadius: AppDecorations.radius12,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDecorations.radius12,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppDecorations.radius12,
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.divider,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
            child: Row(
              children: [
                if (leading != null) ...[leading!, SizedBox(width: ScreenUtil().setWidth(12))],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.bodyMedium),
                      SizedBox(height: ScreenUtil().setHeight(4)),
                      Text(subtitle, style: AppTypography.label),
                    ],
                  ),
                ),
                Text(
                  value,
                  style: AppTypography.title.copyWith(color: AppColors.cta),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailCard extends StatelessWidget {
  const DetailCard({
    super.key,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
      decoration: AppDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.label),
          SizedBox(height: ScreenUtil().setHeight(8)),
          Text(
            value,
            style: highlight
                ? AppTypography.metric.copyWith(fontSize: ScreenUtil().setSp(28), color: AppColors.cta)
                : AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class StepIndicator extends StatelessWidget {
  const StepIndicator({
    super.key,
    required this.steps,
    required this.current,
  });

  final List<String> steps;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: Row(
        children: List.generate(steps.length, (i) {
          final active = current >= i;
          final done = current > i;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: ScreenUtil().setWidth(28),
                        height: ScreenUtil().setWidth(28),
                        decoration: BoxDecoration(
                          color: active ? (done ? AppColors.cta : AppColors.primary) : AppColors.surfaceMuted,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: active ? Colors.transparent : AppColors.divider,
                          ),
                        ),
                        child: Center(
                          child: done
                              ? Icon(Icons.check_rounded, color: Colors.white, size: ScreenUtil().setSp(14))
                              : Text(
                                  '${i + 1}',
                                  style: AppTypography.caption.copyWith(
                                    color: active ? Colors.white : AppColors.textHint,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(6)),
                      Text(
                        steps[i],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.label.copyWith(
                          color: active ? AppColors.textPrimary : AppColors.textHint,
                          fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 1,
                      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(18)),
                      color: current > i ? AppColors.cta : AppColors.divider,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
