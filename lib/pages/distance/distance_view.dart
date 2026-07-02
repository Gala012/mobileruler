import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/app_chrome.dart';
import 'package:mobilem/components/measure_painters.dart';
import 'package:mobilem/components/measure_tool_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/distance/distance_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';

class DistanceView extends GetView<DistanceLogic> {
  const DistanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasDark,
      appBar: DarkMeasureAppBar(
        title: Lang.distanceTitle,
        actions: [
          AppBarIconAction(
            icon: Icons.refresh_rounded,
            onPressed: controller.reset,
          ),
          Obx(() {
            final ready = controller.distanceM.value > 0;
            return TopBarPillAction(
              label: Lang.save,
              enabled: ready,
              onPressed: ready ? controller.save : null,
            );
          }),
        ],
      ),
      body: Column(
        children: [
          _buildInputPanel(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                controller.bindSceneHeight(constraints.maxHeight);
                return Obx(() => _buildScene(constraints));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputPanel() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(16),
        ScreenUtil().setHeight(10),
        ScreenUtil().setWidth(16),
        ScreenUtil().setHeight(10),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.92),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          Text(
            Lang.distanceHeightLabel,
            style: AppTypography.caption.copyWith(color: Colors.white70),
          ),
          SizedBox(width: ScreenUtil().setWidth(10)),
          SizedBox(
            width: ScreenUtil().setWidth(88),
            child: TextField(
              controller: controller.heightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: Lang.distanceHeightHint,
                isDense: true,
                filled: true,
                fillColor: AppColors.cardBg,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(12),
                  vertical: ScreenUtil().setHeight(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: controller.onHeightChanged,
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(6)),
          Text(
            Lang.distanceHeightUnit,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.cta),
          ),
          const Spacer(),
          Obx(() => _buildCameraChip()),
        ],
      ),
    );
  }

  Widget _buildCameraChip() {
    final ready = controller.cameraReady.value;
    final loading = !ready && controller.cameraError.value.isEmpty;
    final label = ready
        ? Lang.distanceCameraOn
        : loading
            ? Lang.distanceCameraLoading
            : Lang.distanceCameraOptional;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(8),
        vertical: ScreenUtil().setHeight(4),
      ),
      decoration: BoxDecoration(
        color: ready
            ? AppColors.cta.withValues(alpha: 0.18)
            : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
        border: Border.all(
          color: ready ? AppColors.cta.withValues(alpha: 0.45) : Colors.white24,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ready ? Icons.videocam_rounded : Icons.videocam_off_outlined,
            size: ScreenUtil().setSp(13),
            color: ready ? AppColors.cta : Colors.white54,
          ),
          SizedBox(width: ScreenUtil().setWidth(4)),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.label.copyWith(
              fontSize: ScreenUtil().setSp(10),
              color: ready ? AppColors.cta : Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScene(BoxConstraints constraints) {
    final topY = controller.topLineY.value;
    final bottomY = controller.bottomLineY.value;
    final cameraReady = controller.cameraReady.value;
    final distanceM = controller.distanceM.value;
    final distanceText = controller.distanceText;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (cameraReady && controller.cameraController != null)
          CameraPreview(controller.cameraController!),
        CustomPaint(
          painter: DistanceScenePainter(
            topY: topY,
            bottomY: bottomY,
            drawBackground: !cameraReady,
          ),
          size: Size(constraints.maxWidth, constraints.maxHeight),
        ),
        const ViewfinderOverlay(),
        Positioned(
          left: 0,
          right: 0,
          top: topY - ScreenUtil().setHeight(22),
          child: HorizontalMeasureLine(onDrag: (d) => controller.onTopDrag(d.delta.dy)),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: bottomY - ScreenUtil().setHeight(22),
          child: HorizontalMeasureLine(onDrag: (d) => controller.onBottomDrag(d.delta.dy)),
        ),
        Positioned(
          left: ScreenUtil().setWidth(10),
          top: topY + ScreenUtil().setHeight(8),
          child: _lineTag(Lang.distanceHeightLabel),
        ),
        Positioned(
          right: ScreenUtil().setWidth(12),
          bottom: ScreenUtil().setHeight(12),
          child: _distanceBadge(distanceM, distanceText),
        ),
      ],
    );
  }

  Widget _lineTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(8),
        vertical: ScreenUtil().setHeight(4),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(6)),
      ),
      child: Text(
        text,
        style: AppTypography.label.copyWith(
          fontSize: ScreenUtil().setSp(10),
          color: Colors.white70,
        ),
      ),
    );
  }

  Widget _distanceBadge(double distanceM, String distanceText) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(16),
        vertical: ScreenUtil().setHeight(10),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
        border: Border.all(color: AppColors.cta.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Lang.distanceResult,
            style: AppTypography.label.copyWith(
              fontSize: ScreenUtil().setSp(10),
              color: Colors.white60,
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(2)),
          Text(
            distanceM > 0 ? '$distanceText m' : '-- m',
            style: AppTypography.metric.copyWith(
              fontSize: ScreenUtil().setSp(28),
              color: AppColors.cta,
            ),
          ),
        ],
      ),
    );
  }
}
