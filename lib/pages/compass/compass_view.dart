import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/measure_painters.dart';
import 'package:mobilem/components/measure_tool_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/compass/compass_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';
import 'package:mobilem/utils/tool_icons.dart';

class CompassView extends GetView<CompassLogic> {
  const CompassView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasDark,
      appBar: DarkMeasureAppBar(
        title: Lang.compassTitle,
        actions: [
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
              painter: CompassPainter(heading: controller.heading.value),
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
            child: Obx(() => _buildInfoPanel()),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
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
          border: Border.all(color: AppColors.cta.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ToolIcons.compass, size: ScreenUtil().setSp(18), color: AppColors.cta),
            SizedBox(width: ScreenUtil().setWidth(8)),
            Text(
              controller.direction.value,
              style: AppTypography.metric.copyWith(
                fontSize: ScreenUtil().setSp(30),
                color: AppColors.cta,
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(10)),
            Container(
              width: 1,
              height: ScreenUtil().setHeight(22),
              color: Colors.white24,
            ),
            SizedBox(width: ScreenUtil().setWidth(10)),
            Text(
              '${controller.heading.value.toStringAsFixed(1)}°',
              style: AppTypography.title.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPanel() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: _infoCell(Lang.compassHeading, controller.direction.value)),
              SizedBox(width: ScreenUtil().setWidth(10)),
              Expanded(
                child: _infoCell(
                  Lang.compassDegrees,
                  '${controller.heading.value.toStringAsFixed(1)}°',
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(12)),
          Row(
            children: [
              Icon(Icons.screen_rotation_rounded, size: ScreenUtil().setSp(14), color: Colors.white38),
              SizedBox(width: ScreenUtil().setWidth(6)),
              Expanded(
                child: Text(
                  Lang.compassCalibrateHint,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.label.copyWith(color: Colors.white38),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoCell(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(12),
        vertical: ScreenUtil().setHeight(10),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
        border: Border.all(color: AppColors.cta.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.label.copyWith(color: Colors.white60)),
          SizedBox(height: ScreenUtil().setHeight(4)),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.cta,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
