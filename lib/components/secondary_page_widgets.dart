import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilem/components/app_chrome.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_decorations.dart';
import 'package:mobilem/utils/app_typography.dart';

class SecondaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SecondaryAppBar({
    super.key,
    required this.title,
    this.actions,
    this.dark = false,
  });

  final String title;
  final List<Widget>? actions;
  final bool dark;

  @override
  Size get preferredSize => Size.fromHeight(ScreenUtil().setHeight(56));

  @override
  Widget build(BuildContext context) {
    return AppBarShell(title: title, actions: actions, dark: dark);
  }
}

class ProfileHeroCard extends StatelessWidget {
  const ProfileHeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.badge,
  });

  final String title;
  final String subtitle;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(16),
        ScreenUtil().setHeight(8),
        ScreenUtil().setWidth(16),
        ScreenUtil().setHeight(16),
      ),
      padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
      decoration: AppDecorations.shadowCard(radius: 18, shadowOpacity: 0.07),
      child: Row(
        children: [
          Container(
            width: ScreenUtil().setWidth(56),
            height: ScreenUtil().setWidth(56),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.cta.withValues(alpha: 0.2),
                  AppColors.cta.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
            ),
            child: Icon(Icons.rule_rounded, color: AppColors.cta, size: ScreenUtil().setSp(28)),
          ),
          SizedBox(width: ScreenUtil().setWidth(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.headline.copyWith(fontSize: ScreenUtil().setSp(22))),
                SizedBox(height: ScreenUtil().setHeight(4)),
                Text(subtitle, style: AppTypography.caption),
              ],
            ),
          ),
          if (badge != null)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(10),
                vertical: ScreenUtil().setHeight(5),
              ),
              decoration: BoxDecoration(
                color: AppColors.cta.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
              ),
              child: Text(
                badge!,
                style: AppTypography.label.copyWith(
                  color: AppColors.ctaDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MenuGroupCard extends StatelessWidget {
  const MenuGroupCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
      decoration: AppDecorations.shadowCard(radius: 16, shadowOpacity: 0.06),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Divider(
                height: 1,
                indent: ScreenUtil().setWidth(68),
                color: AppColors.divider.withValues(alpha: 0.6),
              ),
          ],
        ],
      ),
    );
  }
}

class MenuGroupTile extends StatelessWidget {
  const MenuGroupTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.iconColor = AppColors.primary,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(16),
            vertical: ScreenUtil().setHeight(14),
          ),
          child: Row(
            children: [
              Container(
                width: ScreenUtil().setWidth(40),
                height: ScreenUtil().setWidth(40),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(11)),
                ),
                child: Icon(icon, color: iconColor, size: ScreenUtil().setSp(20)),
              ),
              SizedBox(width: ScreenUtil().setWidth(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(2)),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.label.copyWith(fontSize: ScreenUtil().setSp(11)),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: ScreenUtil().setSp(22)),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailHeroCard extends StatelessWidget {
  const DetailHeroCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.toolName,
    required this.value,
    required this.unit,
  });

  final IconData icon;
  final Color iconColor;
  final String toolName;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
      decoration: AppDecorations.shadowCard(radius: 18, shadowOpacity: 0.08),
      child: Column(
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
          SizedBox(height: ScreenUtil().setHeight(12)),
          Text(toolName, style: AppTypography.caption),
          SizedBox(height: ScreenUtil().setHeight(8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: AppTypography.metric.copyWith(
                  fontSize: ScreenUtil().setSp(40),
                  color: AppColors.cta,
                ),
              ),
              SizedBox(width: ScreenUtil().setWidth(6)),
              Text(
                unit,
                style: AppTypography.title.copyWith(color: AppColors.ctaDark),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InfoRowsCard extends StatelessWidget {
  const InfoRowsCard({super.key, required this.rows});

  final List<(String label, String value)> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(18),
        vertical: ScreenUtil().setHeight(6),
      ),
      decoration: AppDecorations.shadowCard(radius: 16, shadowOpacity: 0.05),
      child: Column(
        children: rows.map((row) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: ScreenUtil().setWidth(80),
                  child: Text(row.$1, style: AppTypography.caption),
                ),
                Expanded(
                  child: Text(
                    row.$2,
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class OptionGroupCard extends StatelessWidget {
  const OptionGroupCard({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  final String title;
  final List<(String label, String value)> options;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(4),
            bottom: ScreenUtil().setHeight(10),
          ),
          child: Text(title, style: AppTypography.title.copyWith(fontSize: ScreenUtil().setSp(15))),
        ),
        Container(
          decoration: AppDecorations.shadowCard(radius: 16, shadowOpacity: 0.05),
          child: Column(
            children: [
              for (var i = 0; i < options.length; i++) ...[
                _OptionTile(
                  label: options[i].$1,
                  selected: selected == options[i].$2,
                  onTap: () => onSelect(options[i].$2),
                ),
                if (i < options.length - 1)
                  Divider(
                    height: 1,
                    indent: ScreenUtil().setWidth(16),
                    endIndent: ScreenUtil().setWidth(16),
                    color: AppColors.divider.withValues(alpha: 0.6),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
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
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(16),
            vertical: ScreenUtil().setHeight(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: ScreenUtil().setWidth(22),
                height: ScreenUtil().setWidth(22),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AppColors.cta : Colors.transparent,
                  border: Border.all(
                    color: selected ? AppColors.cta : AppColors.borderStrong,
                    width: 2,
                  ),
                ),
                child: selected
                    ? Icon(Icons.check_rounded, size: ScreenUtil().setSp(14), color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HelpSectionCard extends StatelessWidget {
  const HelpSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.iconColor = AppColors.primary,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(12)),
      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
      decoration: AppDecorations.shadowCard(radius: 14, shadowOpacity: 0.05),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ScreenUtil().setWidth(36),
            height: ScreenUtil().setWidth(36),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
            ),
            child: Icon(icon, color: iconColor, size: ScreenUtil().setSp(18)),
          ),
          SizedBox(width: ScreenUtil().setWidth(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                SizedBox(height: ScreenUtil().setHeight(6)),
                Text(body, style: AppTypography.caption.copyWith(height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AboutBrandCard extends StatelessWidget {
  const AboutBrandCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
      decoration: AppDecorations.shadowCard(radius: 18, shadowOpacity: 0.07),
      child: Column(
        children: [
          Container(
            width: ScreenUtil().setWidth(72),
            height: ScreenUtil().setWidth(72),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.cta.withValues(alpha: 0.25), AppColors.cta.withValues(alpha: 0.08)],
              ),
              borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
            ),
            child: Icon(Icons.rule_rounded, color: AppColors.cta, size: ScreenUtil().setSp(36)),
          ),
          SizedBox(height: ScreenUtil().setHeight(14)),
          Text(
            Lang.appName,
            style: AppTypography.headline.copyWith(fontSize: ScreenUtil().setSp(22)),
          ),
          SizedBox(height: ScreenUtil().setHeight(4)),
          Text(Lang.aboutVersion, style: AppTypography.caption),
        ],
      ),
    );
  }
}

class ToolMetricPanel extends StatelessWidget {
  const ToolMetricPanel({
    super.key,
    required this.text,
    this.dark = false,
    this.trailing,
    this.icon = Icons.info_outline_rounded,
  });

  final String text;
  final bool dark;
  final Widget? trailing;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.cta;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(14),
        ScreenUtil().setHeight(11),
        ScreenUtil().setWidth(16),
        ScreenUtil().setHeight(11),
      ),
      decoration: BoxDecoration(
        color: dark ? AppColors.primary.withValues(alpha: 0.9) : AppColors.cardBg,
        border: Border(
          bottom: BorderSide(
            color: dark ? Colors.white.withValues(alpha: 0.06) : AppColors.divider.withValues(alpha: 0.7),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: ScreenUtil().setWidth(3),
            height: ScreenUtil().setHeight(28),
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(ScreenUtil().radius(2)),
            ),
          ),
          Icon(
            icon,
            size: ScreenUtil().setSp(16),
            color: accent.withValues(alpha: dark ? 0.9 : 1),
          ),
          SizedBox(width: ScreenUtil().setWidth(8)),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(
                color: dark ? Colors.white.withValues(alpha: 0.78) : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class ToolModeChip extends StatelessWidget {
  const ToolModeChip({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(10),
          vertical: ScreenUtil().setHeight(5),
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
        ),
        child: Text(
          label,
          style: AppTypography.label.copyWith(
            color: AppColors.cta,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
