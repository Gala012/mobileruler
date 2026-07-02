import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    super.key,
    this.dark = false,
    this.onPressed,
  });

  final bool dark;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final fg = dark ? Colors.white : AppColors.textPrimary;
    return Padding(
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(8)),
      child: Material(
        color: dark ? Colors.white.withValues(alpha: 0.08) : AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
        child: InkWell(
          onTap: onPressed ?? () => Navigator.of(context).maybePop(),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
          child: SizedBox(
            width: ScreenUtil().setWidth(36),
            height: ScreenUtil().setWidth(36),
            child: Icon(Icons.arrow_back_ios_new_rounded, size: ScreenUtil().setSp(18), color: fg),
          ),
        ),
      ),
    );
  }
}

class AppBarIconAction extends StatelessWidget {
  const AppBarIconAction({
    super.key,
    required this.icon,
    required this.onPressed,
    this.dark = true,
    this.accent = true,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool dark;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final color = accent
        ? AppColors.cta
        : (dark ? Colors.white.withValues(alpha: 0.75) : AppColors.textSecondary);
    return Padding(
      padding: EdgeInsets.only(right: ScreenUtil().setWidth(4)),
      child: Material(
        color: dark ? Colors.white.withValues(alpha: 0.08) : AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
          child: SizedBox(
            width: ScreenUtil().setWidth(36),
            height: ScreenUtil().setWidth(36),
            child: Icon(icon, color: color, size: ScreenUtil().setSp(18)),
          ),
        ),
      ),
    );
  }
}

class AppBarShell extends StatelessWidget implements PreferredSizeWidget {
  const AppBarShell({
    super.key,
    required this.title,
    this.actions,
    this.dark = false,
    this.leading,
  });

  final String title;
  final List<Widget>? actions;
  final bool dark;
  final Widget? leading;

  @override
  Size get preferredSize => Size.fromHeight(ScreenUtil().setHeight(56));

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final fg = dark ? Colors.white : AppColors.textPrimary;
    final bg = dark ? AppColors.canvasDark : AppColors.pageBg;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          bottom: BorderSide(
            color: dark
                ? AppColors.cta.withValues(alpha: 0.12)
                : AppColors.divider.withValues(alpha: 0.9),
          ),
        ),
        boxShadow: dark
            ? [
                BoxShadow(
                  color: AppColors.cta.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: ScreenUtil().setHeight(56),
          child: Row(
            children: [
              if (leading != null)
                leading!
              else if (canPop)
                AppBarBackButton(dark: dark)
              else
                SizedBox(width: ScreenUtil().setWidth(16)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(canPop ? 2 : 0)),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.appBar.copyWith(color: fg),
                  ),
                ),
              ),
              if (actions != null) ...actions!,
              if (actions == null || actions!.isEmpty)
                SizedBox(width: ScreenUtil().setWidth(8)),
            ],
          ),
        ),
      ),
    );
  }
}

class SheetCloseButton extends StatelessWidget {
  const SheetCloseButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
        child: SizedBox(
          width: ScreenUtil().setWidth(30),
          height: ScreenUtil().setWidth(30),
          child: Icon(Icons.close_rounded, size: ScreenUtil().setSp(18), color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

class SheetHeader extends StatelessWidget {
  const SheetHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onClose,
    this.icon,
    this.iconColor,
    this.compact = false,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onClose;
  final IconData? icon;
  final Color? iconColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(16),
          ScreenUtil().setHeight(2),
          ScreenUtil().setWidth(12),
          ScreenUtil().setHeight(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTypography.title.copyWith(fontSize: ScreenUtil().setSp(16)),
              ),
            ),
            if (onClose != null) SheetCloseButton(onTap: onClose!),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(20),
        ScreenUtil().setHeight(4),
        ScreenUtil().setWidth(12),
        ScreenUtil().setHeight(16),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.cta).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
              ),
              child: Icon(icon, color: iconColor ?? AppColors.cta, size: ScreenUtil().setSp(20)),
            ),
            SizedBox(width: ScreenUtil().setWidth(12)),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.title),
                if (subtitle != null) ...[
                  SizedBox(height: ScreenUtil().setHeight(2)),
                  Text(subtitle!, style: AppTypography.caption),
                ],
              ],
            ),
          ),
          if (onClose != null) SheetCloseButton(onTap: onClose!),
        ],
      ),
    );
  }
}

class SheetPrimaryButton extends StatelessWidget {
  const SheetPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.destructive = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: ScreenUtil().setHeight(48),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: destructive ? AppColors.danger : AppColors.cta,
          foregroundColor: destructive ? Colors.white : AppColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
          ),
        ),
        child: Text(label, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class SheetSecondaryButton extends StatelessWidget {
  const SheetSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: ScreenUtil().setHeight(48),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          side: BorderSide(color: AppColors.divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
          ),
        ),
        child: Text(label, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
