import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/app_chrome.dart';
import 'package:mobilem/components/bottom_sheet_helper.dart';
import 'package:mobilem/components/measure_painters.dart';
import 'package:mobilem/components/measure_tool_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/area/area_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';

class AreaView extends GetView<AreaLogic> {
  const AreaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasDark,
      appBar: DarkMeasureAppBar(
        title: Lang.areaTitle,
        actions: [
          Obx(() {
            return TopBarPillAction(
              label: controller.isRect.value ? Lang.areaRect : Lang.areaPolygon,
              icon: controller.isRect.value ? Icons.crop_square_rounded : Icons.pentagon_outlined,
              onPressed: () => _showShapeSheet(context),
            );
          }),
          AppBarIconAction(
            icon: Icons.refresh_rounded,
            onPressed: controller.reset,
          ),
          Obx(() {
            final ready = controller.areaValue.value > 0 && controller.distanceM.value > 0;
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
          Obx(() => _buildMetricsPanel()),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                controller.bindSceneHeight(constraints.maxHeight);
                return Stack(
                  fit: StackFit.expand,
                  children: const [
                    _CameraLayer(),
                    _AreaCanvas(),
                    ViewfinderOverlay(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsPanel() {
    final cameraReady = controller.cameraReady.value;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(14),
        ScreenUtil().setHeight(10),
        ScreenUtil().setWidth(14),
        ScreenUtil().setHeight(10),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.92),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      child: Row(
        children: [
          Text(
            Lang.areaDistanceLabel,
            style: AppTypography.caption.copyWith(
              color: Colors.white70,
              fontSize: ScreenUtil().setSp(12),
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(8)),
          SizedBox(
            width: ScreenUtil().setWidth(72),
            child: TextField(
              controller: controller.distanceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: Lang.areaDistanceHint,
                isDense: true,
                filled: true,
                fillColor: AppColors.cardBg,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(10),
                  vertical: ScreenUtil().setHeight(8),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: controller.onDistanceChanged,
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(4)),
          Text(
            Lang.distanceHeightUnit,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.cta,
              fontSize: ScreenUtil().setSp(14),
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(12)),
          Container(
            width: 1,
            height: ScreenUtil().setHeight(32),
            color: Colors.white.withValues(alpha: 0.12),
          ),
          SizedBox(width: ScreenUtil().setWidth(12)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  Lang.areaResult,
                  style: AppTypography.caption.copyWith(
                    color: Colors.white60,
                    fontSize: ScreenUtil().setSp(10),
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(6)),
                Text(
                  '${controller.areaText} ${controller.unit}',
                  style: AppTypography.metric.copyWith(
                    fontSize: ScreenUtil().setSp(16),
                    color: AppColors.cta,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(8)),
          _cameraChip(cameraReady),
        ],
      ),
    );
  }

  Widget _cameraChip(bool ready) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(6),
        vertical: ScreenUtil().setHeight(4),
      ),
      decoration: BoxDecoration(
        color: ready ? AppColors.cta.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
        border: Border.all(
          color: ready ? AppColors.cta.withValues(alpha: 0.45) : Colors.white24,
        ),
      ),
      child: Icon(
        ready ? Icons.videocam_rounded : Icons.videocam_off_outlined,
        size: ScreenUtil().setSp(14),
        color: ready ? AppColors.cta : Colors.white54,
      ),
    );
  }

  Future<void> _showShapeSheet(BuildContext context) async {
    await showAppBottomSheet<void>(
      title: Lang.areaShapeTitle,
      icon: Icons.crop_free_rounded,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(20),
          0,
          ScreenUtil().setWidth(20),
          ScreenUtil().setHeight(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => _shapeOption(
                  icon: Icons.crop_square_rounded,
                  title: Lang.areaRect,
                  subtitle: Lang.areaDragRectHint,
                  selected: controller.isRect.value,
                  onTap: () {
                    controller.setShapeMode(true);
                    Get.back();
                  },
                )),
            SizedBox(height: ScreenUtil().setHeight(10)),
            Obx(() => _shapeOption(
                  icon: Icons.pentagon_outlined,
                  title: Lang.areaPolygon,
                  subtitle: Lang.areaDragPolygonHint,
                  selected: !controller.isRect.value,
                  onTap: () {
                    controller.setShapeMode(false);
                    Get.back();
                  },
                )),
          ],
        ),
      ),
    );
  }

  Widget _shapeOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected ? AppColors.cta.withValues(alpha: 0.12) : AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(14),
            vertical: ScreenUtil().setHeight(14),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
            border: Border.all(
              color: selected ? AppColors.cta : AppColors.divider,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: selected ? AppColors.ctaDark : AppColors.textSecondary, size: ScreenUtil().setSp(28)),
              SizedBox(width: ScreenUtil().setWidth(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: selected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(4)),
                    Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle_rounded, color: AppColors.ctaDark, size: ScreenUtil().setSp(22)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CameraLayer extends GetView<AreaLogic> {
  const _CameraLayer();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.cameraReady.value && controller.cameraController != null) {
        return CameraPreview(controller.cameraController!);
      }
      return CustomPaint(
        painter: DistanceScenePainter(topY: 0, bottomY: 0),
        size: Size.infinite,
      );
    });
  }
}

class _AreaCanvas extends GetView<AreaLogic> {
  const _AreaCanvas();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isRect = controller.isRect.value;
      final rectStart = controller.rectStart.value;
      final rectEnd = controller.rectEnd.value;
      final points = controller.points.toList();
      final isDrawing = controller.isDrawing.value;

      return GestureDetector(
        onPanStart: (d) => controller.onPanStart(d.localPosition),
        onPanUpdate: (d) => controller.onPanUpdate(d.localPosition),
        onPanEnd: (_) => controller.onPanEnd(),
        child: CustomPaint(
          painter: _AreaOverlayPainter(
            isRect: isRect,
            rectStart: rectStart,
            rectEnd: rectEnd,
            points: points,
            isDrawing: isDrawing,
          ),
          size: Size.infinite,
        ),
      );
    });
  }
}

class _AreaOverlayPainter extends CustomPainter {
  _AreaOverlayPainter({
    required this.isRect,
    this.rectStart,
    this.rectEnd,
    required this.points,
    required this.isDrawing,
  });

  final bool isRect;
  final Offset? rectStart;
  final Offset? rectEnd;
  final List<Offset> points;
  final bool isDrawing;

  @override
  void paint(Canvas canvas, Size size) {
    if (isRect && rectStart != null && rectEnd != null) {
      final rect = Rect.fromPoints(rectStart!, rectEnd!);
      canvas.drawRect(rect, Paint()..color = AppColors.cta.withValues(alpha: isDrawing ? 0.18 : 0.24));
      canvas.drawRect(
        rect,
        Paint()
          ..color = AppColors.cta
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
      _drawHandle(canvas, rectStart!);
      _drawHandle(canvas, rectEnd!);
      return;
    }

    if (!isRect && points.isNotEmpty) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      if (points.length >= 3) {
        path.close();
        canvas.drawPath(path, Paint()..color = AppColors.cta.withValues(alpha: isDrawing ? 0.14 : 0.22));
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.cta
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      _drawHandle(canvas, points.first);
      if (points.length > 1) {
        _drawHandle(canvas, points.last);
      }
    }
  }

  void _drawHandle(Canvas canvas, Offset p) {
    canvas.drawCircle(p, 7, Paint()..color = AppColors.cta);
    canvas.drawCircle(
      p,
      11,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = Colors.white70,
    );
  }

  @override
  bool shouldRepaint(covariant _AreaOverlayPainter oldDelegate) => true;
}
