import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/measure_tool_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/flashlight/flashlight_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';

class FlashlightView extends GetView<FlashlightLogic> {
  const FlashlightView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasDark,
      appBar: DarkMeasureAppBar(
        title: Lang.flashlightTitle,
        actions: [
          Obx(() {
            if (!controller.available.value) return const SizedBox.shrink();
            final sos = controller.sosMode.value;
            return TopBarPillAction(
              label: sos ? Lang.flashlightSosActive : Lang.flashlightSos,
              icon: Icons.sos_rounded,
              onPressed: controller.toggleSos,
            );
          }),
        ],
      ),
      body: Obx(() {
        if (!controller.available.value) {
          return _buildUnavailable();
        }
        return Stack(
          children: [
            _buildAmbientGlow(),
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: ScreenUtil().setHeight(12)),
                  _buildStatusBadge(),
                  const Spacer(),
                  _buildPowerButton(),
                  SizedBox(height: ScreenUtil().setHeight(20)),
                  _buildStateHint(),
                  const Spacer(),
                  _buildFooterHint(),
                  SizedBox(height: ScreenUtil().setHeight(16)),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildUnavailable() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flash_off_rounded, size: ScreenUtil().setSp(48), color: Colors.white24),
            SizedBox(height: ScreenUtil().setHeight(16)),
            Text(
              Lang.flashlightUnavailable,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmbientGlow() {
    final on = controller.isOn.value;
    final sos = controller.sosMode.value;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.15),
          radius: 0.95,
          colors: on
              ? [
                  AppColors.cta.withValues(alpha: sos ? 0.22 : 0.35),
                  AppColors.cta.withValues(alpha: 0.08),
                  AppColors.canvasDark,
                ]
              : [
                  const Color(0xFF262626),
                  AppColors.canvasDark,
                  const Color(0xFF0A0A0A),
                ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final on = controller.isOn.value;
    final sos = controller.sosMode.value;
    final label = sos
        ? Lang.flashlightSosActive
        : (on ? Lang.flashlightStatusOn : Lang.flashlightStatusOff);
    final color = sos || on ? AppColors.cta : Colors.white54;

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(20),
          vertical: ScreenUtil().setHeight(10),
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
          border: Border.all(color: color.withValues(alpha: on || sos ? 0.5 : 0.2)),
          boxShadow: on || sos
              ? [
                  BoxShadow(
                    color: AppColors.cta.withValues(alpha: 0.18),
                    blurRadius: 16,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              sos ? Icons.sos_rounded : (on ? Icons.flash_on_rounded : Icons.flash_off_rounded),
              size: ScreenUtil().setSp(18),
              color: color,
            ),
            SizedBox(width: ScreenUtil().setWidth(8)),
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPowerButton() {
    final on = controller.isOn.value;
    final sos = controller.sosMode.value;

    return GestureDetector(
      onTap: sos ? null : controller.toggle,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            width: ScreenUtil().setWidth(220),
            height: ScreenUtil().setWidth(220),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: on ? AppColors.cta.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.06),
                width: 1,
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            width: ScreenUtil().setWidth(190),
            height: ScreenUtil().setWidth(190),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: on ? AppColors.cta.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.08),
                width: 1.5,
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            width: ScreenUtil().setWidth(156),
            height: ScreenUtil().setWidth(156),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: on
                    ? [AppColors.cta.withValues(alpha: 0.35), AppColors.cta.withValues(alpha: 0.12)]
                    : [Colors.white.withValues(alpha: 0.08), Colors.white.withValues(alpha: 0.03)],
              ),
              border: Border.all(
                color: on ? AppColors.cta : Colors.white24,
                width: 2.5,
              ),
              boxShadow: on
                  ? [
                      BoxShadow(
                        color: AppColors.cta.withValues(alpha: 0.5),
                        blurRadius: 48,
                        spreadRadius: 6,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              on ? Icons.flash_on_rounded : Icons.flash_off_rounded,
              size: ScreenUtil().setSp(58),
              color: on ? AppColors.primary : Colors.white38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateHint() {
    final sos = controller.sosMode.value;
    if (sos) {
      return Text(
        Lang.flashlightSosActive,
        style: AppTypography.caption.copyWith(color: AppColors.cta),
      );
    }
    return Text(
      controller.isOn.value ? Lang.flashlightOff : Lang.flashlightOn,
      style: AppTypography.title.copyWith(
        color: controller.isOn.value ? AppColors.cta : Colors.white70,
      ),
    );
  }

  Widget _buildFooterHint() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(32)),
      child: Text(
        Lang.flashlightLeaveHint,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.label.copyWith(color: Colors.white38),
      ),
    );
  }
}
