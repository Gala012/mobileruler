import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilem/components/app_chrome.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';

class MeasureHandle extends StatelessWidget {
  const MeasureHandle({super.key, this.active = true});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final size = ScreenUtil().setWidth(28);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.cta : AppColors.textHint,
        border: Border.all(color: Colors.white.withValues(alpha: 0.85), width: 2.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.cta.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.28,
          height: size * 0.28,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class HorizontalMeasureLine extends StatelessWidget {
  const HorizontalMeasureLine({
    super.key,
    required this.onDrag,
    this.showHandles = true,
  });

  final void Function(DragUpdateDetails details) onDrag;
  final bool showHandles;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: onDrag,
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: double.infinity,
        height: ScreenUtil().setHeight(44),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 2,
              margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(8)),
              decoration: BoxDecoration(
                color: AppColors.cta,
                borderRadius: BorderRadius.circular(1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cta.withValues(alpha: 0.45),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            if (showHandles) const MeasureHandle(),
          ],
        ),
      ),
    );
  }
}

class DualMeasureReadout extends StatelessWidget {
  const DualMeasureReadout({
    super.key,
    required this.primaryValue,
    required this.primaryUnit,
    required this.secondaryValue,
    required this.secondaryUnit,
    this.vertical = true,
  });

  final String primaryValue;
  final String primaryUnit;
  final String secondaryValue;
  final String secondaryUnit;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _valueLine(primaryValue, primaryUnit, large: true),
        SizedBox(height: ScreenUtil().setHeight(6)),
        _valueLine(secondaryValue, secondaryUnit, large: false),
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(20),
        vertical: ScreenUtil().setHeight(16),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
        border: Border.all(color: AppColors.cta.withValues(alpha: 0.35)),
      ),
      child: vertical
          ? RotatedBox(quarterTurns: 1, child: content)
          : content,
    );
  }

  Widget _valueLine(String value, String unit, {required bool large}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value,
          style: AppTypography.metric.copyWith(
            fontSize: large ? ScreenUtil().setSp(32) : ScreenUtil().setSp(22),
            color: AppColors.cta,
          ),
        ),
        SizedBox(width: ScreenUtil().setWidth(4)),
        Text(
          unit,
          style: AppTypography.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.85),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class DarkMeasureAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DarkMeasureAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => Size.fromHeight(ScreenUtil().setHeight(56));

  @override
  Widget build(BuildContext context) {
    return AppBarShell(title: title, actions: actions, dark: true);
  }
}

class TopBarPillAction extends StatelessWidget {
  const TopBarPillAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.icon = Icons.save_outlined,
    this.dark = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final IconData icon;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: ScreenUtil().setWidth(8)),
      child: Center(
        child: Material(
          color: enabled
              ? AppColors.cta
              : (dark ? Colors.white.withValues(alpha: 0.08) : AppColors.surfaceMuted),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
          elevation: enabled ? 2 : 0,
          shadowColor: AppColors.cta.withValues(alpha: 0.35),
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(12),
                vertical: ScreenUtil().setHeight(7),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
                border: enabled
                    ? null
                    : Border.all(
                        color: dark ? Colors.white.withValues(alpha: 0.1) : AppColors.divider,
                      ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: ScreenUtil().setSp(15),
                    color: enabled
                        ? AppColors.primary
                        : (dark ? Colors.white38 : AppColors.textHint),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(4)),
                  Text(
                    label,
                    style: AppTypography.caption.copyWith(
                      color: enabled
                          ? AppColors.primary
                          : (dark ? Colors.white38 : AppColors.textHint),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MeasureTipBar extends StatelessWidget {
  const MeasureTipBar({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(16),
        vertical: ScreenUtil().setHeight(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.94),
        border: Border(
          top: BorderSide(color: AppColors.cta.withValues(alpha: 0.15)),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline_rounded, size: ScreenUtil().setSp(16), color: AppColors.cta),
          SizedBox(width: ScreenUtil().setWidth(8)),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(
                color: Colors.white.withValues(alpha: 0.78),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ViewfinderOverlay extends StatelessWidget {
  const ViewfinderOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final inset = ScreenUtil().setWidth(24);
    final corner = ScreenUtil().setWidth(22);
    final stroke = ScreenUtil().setWidth(2.5);

    return IgnorePointer(
      child: CustomPaint(
        painter: _ViewfinderPainter(
          inset: inset,
          cornerLen: corner,
          strokeWidth: stroke,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _ViewfinderPainter extends CustomPainter {
  _ViewfinderPainter({
    required this.inset,
    required this.cornerLen,
    required this.strokeWidth,
  });

  final double inset;
  final double cornerLen;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.cta.withValues(alpha: 0.55)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(inset, inset, size.width - inset * 2, size.height - inset * 2);
    _corner(canvas, paint, rect.topLeft, cornerLen, true, true);
    _corner(canvas, paint, rect.topRight, cornerLen, false, true);
    _corner(canvas, paint, rect.bottomLeft, cornerLen, true, false);
    _corner(canvas, paint, rect.bottomRight, cornerLen, false, false);
  }

  void _corner(Canvas canvas, Paint paint, Offset origin, double len, bool left, bool top) {
    final dx = left ? len : -len;
    final dy = top ? len : -len;
    canvas.drawLine(origin, origin + Offset(dx, 0), paint);
    canvas.drawLine(origin, origin + Offset(0, dy), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
