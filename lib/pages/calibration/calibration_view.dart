import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/common_widgets.dart';
import 'package:mobilem/components/measure_tool_widgets.dart';
import 'package:mobilem/components/secondary_page_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/calibration/calibration_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_decorations.dart';
import 'package:mobilem/utils/app_typography.dart';

class CalibrationView extends GetView<CalibrationLogic> {
  const CalibrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      appBar: SecondaryAppBar(
        title: Lang.calibrationTitle,
        actions: [
          Obx(() => _buildTopAction()),
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            SizedBox(height: ScreenUtil().setHeight(16)),
            StepIndicator(
              steps: [Lang.calibrationStep1, Lang.calibrationStep2, Lang.calibrationStep3],
              current: controller.step.value,
            ),
            SizedBox(height: ScreenUtil().setHeight(20)),
            Expanded(child: _buildContent()),
            SizedBox(height: ScreenUtil().setHeight(16)),
          ],
        );
      }),
    );
  }

  Widget _buildTopAction() {
    if (controller.step.value == 0) return const SizedBox.shrink();
    if (controller.step.value == 1) {
      return TopBarPillAction(
        label: Lang.confirm,
        icon: Icons.arrow_forward_rounded,
        dark: false,
        onPressed: controller.nextStep,
      );
    }
    return TopBarPillAction(
      label: Lang.save,
      dark: false,
      onPressed: controller.confirm,
    );
  }

  Widget _buildContent() {
    if (controller.step.value == 0) {
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
        itemCount: controller.refs.length,
        separatorBuilder: (_, __) => SizedBox(height: ScreenUtil().setHeight(10)),
        itemBuilder: (_, index) {
          final ref = controller.refs[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => controller.selectRef(ref),
              borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
              child: Ink(
                decoration: AppDecorations.shadowCard(radius: 14, shadowOpacity: 0.05),
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(14)),
                  child: Row(
                    children: [
                      Container(
                        width: ScreenUtil().setWidth(44),
                        height: ScreenUtil().setWidth(44),
                        decoration: BoxDecoration(
                          color: AppColors.cta.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                        ),
                        child: Icon(Icons.credit_card_rounded, color: AppColors.cta, size: ScreenUtil().setSp(22)),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(12)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ref.label, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                            Text(ref.mmLabel, style: AppTypography.caption),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
      child: Column(
        children: [
          Text(Lang.calibrationDragHint, style: AppTypography.caption),
          SizedBox(height: ScreenUtil().setHeight(14)),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                controller.bindSceneWidth(constraints.maxWidth);
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.canvasDark,
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Obx(() => _buildAlignScene(constraints.maxHeight)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlignScene(double height) {
    final centerY = height / 2;
    final left = controller.leftX;
    final right = controller.rightX;
    final lineWidth = right - left;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: left,
          top: centerY - 1,
          width: lineWidth,
          child: GestureDetector(
            onHorizontalDragUpdate: (d) => controller.onLineDrag(d.delta.dx),
            behavior: HitTestBehavior.translucent,
            child: SizedBox(
              height: ScreenUtil().setHeight(44),
              child: Center(
                child: Container(
                  height: 2,
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
              ),
            ),
          ),
        ),
        Positioned(
          left: left - ScreenUtil().setWidth(22),
          top: centerY - ScreenUtil().setHeight(28),
          child: _markerHandle(onDrag: controller.onLeftDrag),
        ),
        Positioned(
          left: right - ScreenUtil().setWidth(22),
          top: centerY - ScreenUtil().setHeight(28),
          child: _markerHandle(onDrag: controller.onRightDrag),
        ),
        Positioned(
          bottom: ScreenUtil().setHeight(20),
          left: 0,
          right: 0,
          child: Text(
            '${controller.markerSpan.value.toStringAsFixed(1)} px',
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Widget _markerHandle({required void Function(double delta) onDrag}) {
    return GestureDetector(
      onHorizontalDragUpdate: (d) => onDrag(d.delta.dx),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: ScreenUtil().setWidth(44),
        height: ScreenUtil().setHeight(56),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: ScreenUtil().setWidth(3),
              height: ScreenUtil().setHeight(36),
              decoration: BoxDecoration(
                color: AppColors.cta,
                borderRadius: BorderRadius.circular(1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cta.withValues(alpha: 0.4),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(4)),
            const MeasureHandle(),
          ],
        ),
      ),
    );
  }
}
