import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/app_chrome.dart';
import 'package:mobilem/components/measure_tool_widgets.dart';
import 'package:mobilem/components/secondary_page_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/outdoor_area/outdoor_area_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';
import 'package:mobilem/utils/geo_area.dart';

class OutdoorAreaView extends GetView<OutdoorAreaLogic> {
  const OutdoorAreaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasDark,
      appBar: DarkMeasureAppBar(
        title: Lang.outdoorAreaTitle,
        actions: [
          AppBarIconAction(
            icon: Icons.refresh_rounded,
            onPressed: controller.reset,
          ),
          Obx(() {
            final ready = controller.areaM2.value > 0;
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
          Obx(() => ToolMetricPanel(text: controller.statusText.value, dark: true)),
          Expanded(
            child: Obx(() {
              final pts = controller.points.toList();
              final state = controller.trackState.value;
              return Stack(
                fit: StackFit.expand,
                children: [
                  CustomPaint(
                    painter: _OutdoorPathPainter(
                      points: pts,
                      closed: state == OutdoorTrackState.done,
                    ),
                    size: Size.infinite,
                  ),
                  if (state == OutdoorTrackState.done)
                    Positioned(
                      left: ScreenUtil().setWidth(16),
                      right: ScreenUtil().setWidth(16),
                      bottom: ScreenUtil().setHeight(16),
                      child: _buildResultCard(),
                    ),
                ],
              );
            }),
          ),
          Obx(() => _buildActions()),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(18),
        vertical: ScreenUtil().setHeight(14),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
        border: Border.all(color: AppColors.cta.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Lang.outdoorAreaResult, style: AppTypography.label.copyWith(color: Colors.white60)),
                SizedBox(height: ScreenUtil().setHeight(4)),
                Text(
                  '${controller.areaText} m²',
                  style: AppTypography.metric.copyWith(fontSize: ScreenUtil().setSp(28), color: AppColors.cta),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Lang.outdoorAreaMu, style: AppTypography.label.copyWith(color: Colors.white60)),
              SizedBox(height: ScreenUtil().setHeight(4)),
              Text(
                '${controller.muText} ${Lang.outdoorAreaMuUnit}',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.cta, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    final state = controller.trackState.value;
    final tracking = state == OutdoorTrackState.tracking;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(16),
        ScreenUtil().setHeight(12),
        ScreenUtil().setWidth(16),
        ScreenUtil().setHeight(20),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.9),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      child: Row(
        children: [
          Expanded(
            child: _actionButton(
              label: Lang.outdoorAreaStart,
              icon: Icons.directions_walk_rounded,
              filled: !tracking,
              onPressed: tracking ? null : controller.startTracking,
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(10)),
          Expanded(
            child: _actionButton(
              label: Lang.outdoorAreaFinish,
              icon: Icons.flag_rounded,
              filled: tracking,
              onPressed: tracking ? controller.finishTracking : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required bool filled,
    required VoidCallback? onPressed,
  }) {
    final enabled = onPressed != null;
    return Material(
      color: enabled
          ? (filled ? AppColors.cta : Colors.white.withValues(alpha: 0.1))
          : Colors.white.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: ScreenUtil().setSp(20),
                color: enabled ? (filled ? AppColors.primary : AppColors.cta) : Colors.white38,
              ),
              SizedBox(width: ScreenUtil().setWidth(6)),
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: enabled ? (filled ? AppColors.primary : AppColors.cta) : Colors.white38,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutdoorPathPainter extends CustomPainter {
  _OutdoorPathPainter({required this.points, required this.closed});

  final List<GeoPoint> points;
  final bool closed;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.canvasDark);

    if (points.length < 2) {
      if (points.length == 1) {
        final p = Offset(size.width / 2, size.height / 2);
        canvas.drawCircle(p, 6, Paint()..color = AppColors.cta);
      }
      return;
    }

    final minLat = points.map((e) => e.latitude).reduce((a, b) => a < b ? a : b);
    final maxLat = points.map((e) => e.latitude).reduce((a, b) => a > b ? a : b);
    final minLon = points.map((e) => e.longitude).reduce((a, b) => a < b ? a : b);
    final maxLon = points.map((e) => e.longitude).reduce((a, b) => a > b ? a : b);

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final p = _project(points, size, minLat, maxLat, minLon, maxLon, points[i]);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    if (closed) path.close();

    if (closed && points.length >= 3) {
      canvas.drawPath(path, Paint()..color = AppColors.cta.withValues(alpha: 0.18));
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.cta
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    for (var i = 0; i < points.length; i++) {
      final p = _project(points, size, minLat, maxLat, minLon, maxLon, points[i]);
      final isStart = i == 0;
      canvas.drawCircle(p, isStart ? 7 : 5, Paint()..color = isStart ? Colors.white : AppColors.cta);
      if (isStart) {
        canvas.drawCircle(
          p,
          10,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5
            ..color = AppColors.cta,
        );
      }
    }
  }

  Offset _project(
    List<GeoPoint> all,
    Size size,
    double minLat,
    double maxLat,
    double minLon,
    double maxLon,
    GeoPoint point,
  ) {
    final pad = 32.0;
    final latSpan = (maxLat - minLat).abs() < 1e-8 ? 1e-5 : maxLat - minLat;
    final lonSpan = (maxLon - minLon).abs() < 1e-8 ? 1e-5 : maxLon - minLon;
    final x = pad + (point.longitude - minLon) / lonSpan * (size.width - pad * 2);
    final y = pad + (maxLat - point.latitude) / latSpan * (size.height - pad * 2);
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant _OutdoorPathPainter oldDelegate) => true;
}
