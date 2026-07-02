import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/measure_painters.dart';
import 'package:mobilem/components/measure_tool_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/divider_ruler/divider_ruler_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';

class DividerRulerView extends GetView<DividerRulerLogic> {
  const DividerRulerView({super.key});

  static const _rulerGutter = 46.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasDark,
      appBar: DarkMeasureAppBar(
        title: Lang.dividerRulerTitle,
        actions: [
          Obx(() {
            final visible = controller.showPanel.value;
            return IconButton(
              tooltip: visible ? Lang.dividerRulerHidePanel : Lang.dividerRulerShowPanel,
              onPressed: controller.togglePanel,
              icon: Icon(
                visible ? Icons.expand_less_rounded : Icons.tune_rounded,
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          controller.bindCanvasExtent(constraints.maxHeight);
          final inset = DividerRulerLogic.originInset;
          final handleHalf = ScreenUtil().setHeight(22);

          return Obx(() {
            final measureFromOrigin = controller.measureFromOrigin.value;
            final showPanel = controller.showPanel.value;

            return Stack(
              fit: StackFit.expand,
              children: [
                _buildCanvas(constraints),
                Positioned(
                  top: ScreenUtil().setHeight(8),
                  left: ScreenUtil().setWidth(_rulerGutter),
                  right: ScreenUtil().setWidth(_rulerGutter),
                  child: IgnorePointer(
                    ignoring: !showPanel,
                    child: AnimatedOpacity(
                      opacity: showPanel ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Obx(() => _buildControlPanel()),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: inset + measureFromOrigin - handleHalf,
                  child: HorizontalMeasureLine(
                    onDrag: (d) => controller.onMeasureDrag(-d.delta.dy),
                  ),
                ),
              ],
            );
          });
        },
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(14),
        ScreenUtil().setHeight(10),
        ScreenUtil().setWidth(14),
        ScreenUtil().setHeight(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(Lang.dividerRulerParts, style: AppTypography.label.copyWith(color: Colors.white70)),
              const Spacer(),
              IconButton(
                onPressed: controller.decreaseParts,
                icon: Icon(Icons.remove_circle_outline_rounded, color: AppColors.cta, size: ScreenUtil().setSp(22)),
              ),
              Text(
                '${controller.parts.value}',
                style: AppTypography.title.copyWith(color: AppColors.cta),
              ),
              IconButton(
                onPressed: controller.increaseParts,
                icon: Icon(Icons.add_circle_outline_rounded, color: AppColors.cta, size: ScreenUtil().setSp(22)),
              ),
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(6)),
          Row(
            children: [
              Expanded(child: _metricCell(Lang.dividerRulerTotal, '${controller.totalCmText} cm')),
              SizedBox(width: ScreenUtil().setWidth(10)),
              Expanded(child: _metricCell(Lang.dividerRulerEach, '${controller.partCmText} cm')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricCell(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(12),
        vertical: ScreenUtil().setHeight(8),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.label.copyWith(color: Colors.white54)),
          SizedBox(height: ScreenUtil().setHeight(2)),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.cta, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildCanvas(BoxConstraints constraints) {
    final size = Size(constraints.maxWidth, constraints.maxHeight);
    final inset = DividerRulerLogic.originInset;
    final labelSize = ScreenUtil().setSp(14);

    return Obx(() {
      final scrollOffset = controller.scrollOffset.value;
      final measureFromOrigin = controller.measureFromOrigin.value;
      final parts = controller.parts.value;

      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onVerticalDragUpdate: (d) => controller.onRulerScroll(-d.delta.dy),
              child: CustomPaint(
                painter: DualRulerPainter(
                  pixelsPerMm: controller.pixelsPerMm,
                  isPortrait: true,
                  scrollOffset: scrollOffset,
                  originInset: inset,
                  labelFontSize: labelSize,
                ),
                size: size,
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: RulerMeasureZonePainter(
                isPortrait: true,
                measureFromOrigin: measureFromOrigin,
                canvasSize: size,
                originInset: inset,
              ),
              size: size,
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: DividerRulerOverlayPainter(
                measurePx: measureFromOrigin,
                parts: parts,
                originInset: inset,
                isPortrait: true,
                labelFontSize: labelSize,
              ),
              size: size,
            ),
          ),
        ],
      );
    });
  }
}
