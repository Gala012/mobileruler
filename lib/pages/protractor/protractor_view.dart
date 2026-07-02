import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/app_chrome.dart';
import 'package:mobilem/components/measure_painters.dart';
import 'package:mobilem/components/measure_tool_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/protractor/protractor_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';

class ProtractorView extends GetView<ProtractorLogic> {
  const ProtractorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasDark,
      appBar: DarkMeasureAppBar(
        title: Lang.protractorTitle,
        actions: [
          Obx(() {
            final locked = controller.locked.value;
            return AppBarIconAction(
              icon: locked ? Icons.lock_rounded : Icons.lock_open_rounded,
              accent: !locked,
              onPressed: controller.toggleLock,
            );
          }),
          TopBarPillAction(
            label: Lang.save,
            onPressed: controller.save,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          controller.bindGeometry(size);
          return Obx(() => _buildCanvas(size));
        },
      ),
    );
  }

  Widget _buildCanvas(Size size) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (d) => controller.onTap(d.localPosition),
          onPanStart: (d) => controller.onDrag(d.localPosition),
          onPanUpdate: (d) => controller.onDrag(d.localPosition),
          onDoubleTap: controller.toggleLock,
          child: CustomPaint(
            painter: ProtractorPainter(
              angle: controller.angle.value,
              locked: controller.locked.value,
              baselineInset: ProtractorLogic.baselineInset,
              topInset: ProtractorLogic.topInset,
              bottomLabelMargin: ProtractorLogic.bottomLabelMargin,
              sideLabelMargin: ProtractorLogic.sideLabelMargin,
              labelOutset: ProtractorLogic.labelOutset,
              labelFontSize: ScreenUtil().setSp(15),
            ),
            size: size,
          ),
        ),
        Positioned(
          right: ScreenUtil().setWidth(12),
          bottom: ProtractorLogic.angleBadgeBottomOffset(size),
          child: IgnorePointer(
            child: Obx(() => _angleBadge()),
          ),
        ),
      ],
    );
  }

  Widget _angleBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(22),
        vertical: ScreenUtil().setHeight(10),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
        border: Border.all(color: AppColors.cta.withValues(alpha: 0.35)),
      ),
      child: Text(
        '${controller.angle.value.toStringAsFixed(1)}°',
        style: AppTypography.metric.copyWith(
          fontSize: ScreenUtil().setSp(34),
          color: AppColors.cta,
        ),
      ),
    );
  }
}
