import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/app_chrome.dart';
import 'package:mobilem/components/measure_painters.dart';
import 'package:mobilem/components/measure_tool_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/scale_ruler/scale_ruler_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';

class ScaleRulerView extends GetView<ScaleRulerLogic> {
  const ScaleRulerView({super.key});

  static const _rulerGutter = 46.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasDark,
      appBar: DarkMeasureAppBar(
        title: Lang.scaleRulerTitle,
        actions: [
          Obx(() {
            final visible = controller.showPanel.value;
            return AppBarIconAction(
              icon: visible ? Icons.expand_less_rounded : Icons.tune_rounded,
              onPressed: controller.togglePanel,
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
          final inset = ScaleRulerLogic.originInset;
          final handleHalf = ScreenUtil().setHeight(22);

          return Obx(() {
            final measureFromOrigin = controller.measureFromOrigin.value;
            final showPanel = controller.showPanel.value;

            return Stack(
              fit: StackFit.expand,
              children: [
                _buildCanvas(constraints),
                Positioned(
                  top: ScreenUtil().setHeight(4),
                  left: ScreenUtil().setWidth(_rulerGutter),
                  right: ScreenUtil().setWidth(_rulerGutter),
                  child: IgnorePointer(
                    ignoring: !showPanel,
                    child: AnimatedOpacity(
                      opacity: showPanel ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: _buildControlPanel(),
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
    return Obx(
      () => Container(
        padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(14),
          ScreenUtil().setHeight(12),
          ScreenUtil().setWidth(14),
          ScreenUtil().setHeight(14),
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.52),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Lang.scaleRulerRatio, style: AppTypography.label.copyWith(color: Colors.white60)),
            SizedBox(height: ScreenUtil().setHeight(10)),
            SizedBox(
              height: ScreenUtil().setHeight(34),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: ScaleRulerLogic.ratios.length,
                separatorBuilder: (_, index) => SizedBox(width: ScreenUtil().setWidth(8)),
                itemBuilder: (_, index) {
                  final value = ScaleRulerLogic.ratios[index];
                  final selected = controller.ratio.value == value;
                  return GestureDetector(
                    onTap: () => controller.setRatio(value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(14)),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.cta : Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(ScreenUtil().radius(18)),
                        border: Border.all(
                          color: selected ? AppColors.cta : Colors.white24,
                        ),
                      ),
                      child: Text(
                        '1:$value',
                        style: AppTypography.caption.copyWith(
                          color: selected ? AppColors.primary : Colors.white70,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(12)),
            Row(
              children: [
                Expanded(child: _metricCell(Lang.scaleRulerScreen, '${controller.screenCmText} cm')),
                SizedBox(width: ScreenUtil().setWidth(10)),
                Expanded(child: _metricCell(Lang.scaleRulerReal, '${controller.realCmText} cm')),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(12)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
                border: Border.all(color: AppColors.cta.withValues(alpha: 0.25)),
              ),
              child: Column(
                children: [
                  Text(
                    '${controller.realCmText} cm',
                    style: AppTypography.metric.copyWith(
                      fontSize: ScreenUtil().setSp(30),
                      color: AppColors.cta,
                    ),
                  ),
                  Text(
                    '${controller.realMText} m',
                    style: AppTypography.caption.copyWith(color: Colors.white60),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricCell(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(12),
        vertical: ScreenUtil().setHeight(10),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.label.copyWith(color: Colors.white54)),
          SizedBox(height: ScreenUtil().setHeight(4)),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.cta, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildCanvas(BoxConstraints constraints) {
    final size = Size(constraints.maxWidth, constraints.maxHeight);
    final inset = ScaleRulerLogic.originInset;
    final labelSize = ScreenUtil().setSp(14);

    return Obx(() {
      final scrollOffset = controller.scrollOffset.value;
      final measureFromOrigin = controller.measureFromOrigin.value;

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
        ],
      );
    });
  }
}
