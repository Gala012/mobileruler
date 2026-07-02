import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/measure_painters.dart';
import 'package:mobilem/components/app_chrome.dart';
import 'package:mobilem/components/measure_tool_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/tape_ruler/tape_ruler_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';

class TapeRulerView extends GetView<TapeRulerLogic> {
  const TapeRulerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasDark,
      appBar: DarkMeasureAppBar(
        title: Lang.tapeRulerTitle,
        actions: [
          AppBarIconAction(
            icon: Icons.refresh_rounded,
            onPressed: controller.reset,
          ),
          TopBarPillAction(
            label: Lang.tapeRulerAdd,
            icon: Icons.add_rounded,
            onPressed: controller.addSegment,
          ),
          Obx(() {
            final ready = controller.totalMm > 0;
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
          Obx(() => _buildSummaryPanel()),
          Expanded(
            child: Obx(() {
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
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPanel() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(16),
        ScreenUtil().setHeight(12),
        ScreenUtil().setWidth(16),
        ScreenUtil().setHeight(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.88),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(Lang.tapeRulerTotal, style: AppTypography.label.copyWith(color: Colors.white60)),
              SizedBox(width: ScreenUtil().setWidth(8)),
              Text(
                '${controller.totalCmText} cm',
                style: AppTypography.title.copyWith(color: AppColors.cta),
              ),
              const Spacer(),
              Text(
                '${controller.currentCmText} cm',
                style: AppTypography.caption.copyWith(color: Colors.white54),
              ),
            ],
          ),
          if (controller.segments.isEmpty) ...[
            SizedBox(height: ScreenUtil().setHeight(6)),
            Text(Lang.tapeRulerEmpty, style: AppTypography.label.copyWith(color: Colors.white38)),
          ] else ...[
            SizedBox(height: ScreenUtil().setHeight(8)),
            SizedBox(
              height: ScreenUtil().setHeight(32),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.segments.length,
                separatorBuilder: (_, __) => SizedBox(width: ScreenUtil().setWidth(8)),
                itemBuilder: (_, index) {
                  final mm = controller.segments[index];
                  return GestureDetector(
                    onTap: () => controller.removeSegment(index),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(10),
                        vertical: ScreenUtil().setHeight(6),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
                        border: Border.all(color: AppColors.cta.withValues(alpha: 0.25)),
                      ),
                      child: Text(
                        '${Lang.tapeRulerSegment}${index + 1} ${(mm / 10).toStringAsFixed(2)}',
                        style: AppTypography.label.copyWith(color: AppColors.cta),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCanvas(
    BoxConstraints constraints, {
    required bool portrait,
    required double scrollOffset,
    required double measureFromOrigin,
  }) {
    final size = Size(constraints.maxWidth, constraints.maxHeight);
    final inset = TapeRulerLogic.originInset;
    final handleHalf = ScreenUtil().setHeight(22);

    return Stack(
      children: [
        GestureDetector(
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
        CustomPaint(
          painter: RulerMeasureZonePainter(
            isPortrait: portrait,
            measureFromOrigin: measureFromOrigin,
            canvasSize: size,
            originInset: inset,
          ),
          size: size,
        ),
        if (portrait)
          Positioned(
            left: 0,
            right: 0,
            bottom: inset + measureFromOrigin - handleHalf,
            child: HorizontalMeasureLine(
              onDrag: (d) => controller.onMeasureDrag(-d.delta.dy),
            ),
          ),
        Positioned(
          top: ScreenUtil().setHeight(8),
          right: ScreenUtil().setWidth(12),
          child: IconButton(
            onPressed: controller.toggleOrientation,
            icon: Icon(
              portrait ? Icons.screen_rotation_rounded : Icons.stay_current_portrait_rounded,
              color: AppColors.cta,
            ),
          ),
        ),
      ],
    );
  }
}
