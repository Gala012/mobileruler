import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/measure_painters.dart';
import 'package:mobilem/components/measure_tool_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/ruler/ruler_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';

class RulerView extends GetView<RulerLogic> {
  const RulerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasDark,
      appBar: DarkMeasureAppBar(
        title: Lang.rulerTitle,
        actions: [
          Obx(() {
            return IconButton(
              onPressed: controller.toggleOrientation,
              icon: Icon(
                controller.isPortrait.value ? Icons.screen_rotation_rounded : Icons.stay_current_portrait_rounded,
                color: AppColors.cta,
              ),
            );
          }),
          Obx(() {
            final ready = controller.measureFromOrigin.value > 0;
            return TopBarPillAction(
              label: Lang.save,
              enabled: ready,
              onPressed: ready ? controller.save : null,
            );
          }),
        ],
      ),
      body: Obx(() {
        final portrait = controller.isPortrait.value;
        final scrollOffset = controller.scrollOffset.value;
        final measureFromOrigin = controller.measureFromOrigin.value;

        return LayoutBuilder(
          builder: (context, constraints) {
            final extent = portrait ? constraints.maxHeight : constraints.maxWidth;
            controller.bindCanvasExtent(extent);
            return _buildCanvas(
              constraints,
              portrait: portrait,
              scrollOffset: scrollOffset,
              measureFromOrigin: measureFromOrigin,
            );
          },
        );
      }),
    );
  }

  Widget _buildCanvas(
    BoxConstraints constraints, {
    required bool portrait,
    required double scrollOffset,
    required double measureFromOrigin,
  }) {
    final size = Size(constraints.maxWidth, constraints.maxHeight);
    final inset = RulerLogic.originInset;
    final handleHalf = ScreenUtil().setHeight(22);

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: GestureDetector(
            onVerticalDragUpdate: portrait ? (d) => controller.onRulerScroll(-d.delta.dy) : null,
            onHorizontalDragUpdate: !portrait ? (d) => controller.onRulerScroll(-d.delta.dx) : null,
            child: CustomPaint(
              painter: DualRulerPainter(
                pixelsPerMm: controller.pixelsPerMm,
                isPortrait: portrait,
                scrollOffset: scrollOffset,
                originInset: inset,
              ),
              size: size,
            ),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: RulerMeasureZonePainter(
              isPortrait: portrait,
              measureFromOrigin: measureFromOrigin,
              canvasSize: size,
              originInset: inset,
            ),
            size: size,
          ),
        ),
        if (portrait)
          Positioned(
            left: 0,
            right: 0,
            bottom: inset + measureFromOrigin - handleHalf,
            child: HorizontalMeasureLine(
              onDrag: (d) => controller.onMeasureDrag(-d.delta.dy),
            ),
          )
        else
          Positioned(
            top: 0,
            bottom: 0,
            left: inset + measureFromOrigin - ScreenUtil().setWidth(22),
            child: _verticalMeasureLine(),
          ),
        Center(
          child: DualMeasureReadout(
            primaryValue: controller.cmText,
            primaryUnit: Lang.rulerUnitCm,
            secondaryValue: controller.inchText,
            secondaryUnit: Lang.rulerUnitInch,
            vertical: portrait,
          ),
        ),
        Positioned(
          top: ScreenUtil().setHeight(12),
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(12),
                vertical: ScreenUtil().setHeight(6),
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
              ),
              child: Text(
                portrait ? Lang.rulerPortrait : Lang.rulerLandscape,
                style: AppTypography.label.copyWith(color: Colors.white70),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _verticalMeasureLine() {
    return GestureDetector(
      onHorizontalDragUpdate: (d) => controller.onMeasureDrag(d.delta.dx),
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: ScreenUtil().setWidth(44),
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 2,
              margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(8)),
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
            const MeasureHandle(),
          ],
        ),
      ),
    );
  }
}
