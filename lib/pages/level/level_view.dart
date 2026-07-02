import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/measure_painters.dart';
import 'package:mobilem/components/measure_tool_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/level/level_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';

class LevelView extends GetView<LevelLogic> {
  const LevelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasDark,
      appBar: DarkMeasureAppBar(
        title: Lang.levelTitle,
        actions: [
          TopBarPillAction(
            label: Lang.levelZero,
            icon: Icons.adjust_rounded,
            onPressed: controller.setZero,
          ),
          TopBarPillAction(
            label: Lang.save,
            onPressed: controller.save,
          ),
        ],
      ),
      body: Stack(
        children: [
          Obx(() {
            return CustomPaint(
              painter: LevelBubblePainter(
                tiltX: controller.tiltX.value,
                tiltY: controller.tiltY.value,
              ),
              size: Size.infinite,
            );
          }),
          Positioned(
            top: ScreenUtil().setHeight(12),
            left: 0,
            right: 0,
            child: Obx(() => _buildStatusBadge()),
          ),
          Positioned(
            left: ScreenUtil().setWidth(16),
            right: ScreenUtil().setWidth(16),
            bottom: ScreenUtil().setHeight(20),
            child: Obx(() => _buildAxisPanel()),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final flat = controller.isFlat.value;
    final total = controller.totalTilt;
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(22),
          vertical: ScreenUtil().setHeight(10),
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
          border: Border.all(
            color: flat
                ? AppColors.success.withValues(alpha: 0.55)
                : AppColors.cta.withValues(alpha: 0.35),
          ),
          boxShadow: flat
              ? [
                  BoxShadow(
                    color: AppColors.success.withValues(alpha: 0.2),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              flat ? Icons.check_circle_rounded : Icons.straighten_rounded,
              size: ScreenUtil().setSp(18),
              color: flat ? AppColors.success : AppColors.cta,
            ),
            SizedBox(width: ScreenUtil().setWidth(8)),
            Text(
              flat ? Lang.levelFlat : '${total.toStringAsFixed(2)}°',
              style: AppTypography.metric.copyWith(
                fontSize: ScreenUtil().setSp(flat ? 22 : 30),
                color: flat ? AppColors.success : AppColors.cta,
              ),
            ),
            if (!flat) ...[
              SizedBox(width: ScreenUtil().setWidth(6)),
              Text(
                Lang.levelTotal,
                style: AppTypography.label.copyWith(color: Colors.white54),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAxisPanel() {
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(14)),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _axisGauge(Lang.levelAxisX, controller.tiltX.value)),
          SizedBox(width: ScreenUtil().setWidth(12)),
          Expanded(child: _axisGauge(Lang.levelAxisY, controller.tiltY.value)),
        ],
      ),
    );
  }

  Widget _axisGauge(String label, double value) {
    final normalized = (value.clamp(-15, 15) / 15 + 1) / 2;
    final isNearZero = value.abs() < 0.5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.label.copyWith(color: Colors.white60)),
            Text(
              '${value.toStringAsFixed(2)}°',
              style: AppTypography.bodyMedium.copyWith(
                color: isNearZero ? AppColors.success : AppColors.cta,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(8)),
        LayoutBuilder(
          builder: (context, constraints) {
            final trackW = constraints.maxWidth;
            final thumbX = trackW * normalized;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: ScreenUtil().setHeight(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(3)),
                  ),
                ),
                Positioned(
                  left: trackW / 2 - 1,
                  top: -ScreenUtil().setHeight(2),
                  child: Container(
                    width: 2,
                    height: ScreenUtil().setHeight(10),
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                Positioned(
                  left: thumbX.clamp(0.0, trackW - ScreenUtil().setWidth(10)) - ScreenUtil().setWidth(5),
                  top: -ScreenUtil().setHeight(3),
                  child: Container(
                    width: ScreenUtil().setWidth(10),
                    height: ScreenUtil().setWidth(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isNearZero ? AppColors.success : AppColors.cta,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.7), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: (isNearZero ? AppColors.success : AppColors.cta).withValues(alpha: 0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(height: ScreenUtil().setHeight(4)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('-15°', style: AppTypography.label.copyWith(color: Colors.white30, fontSize: ScreenUtil().setSp(10))),
            Text('+15°', style: AppTypography.label.copyWith(color: Colors.white30, fontSize: ScreenUtil().setSp(10))),
          ],
        ),
      ],
    );
  }
}
