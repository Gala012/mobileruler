import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';
import 'package:mobilem/lang/lang.dart';

class StatsChartSegment {
  const StatsChartSegment({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;
}

class StatsTrendBarChart extends StatelessWidget {
  const StatsTrendBarChart({
    super.key,
    required this.items,
  });

  final List<MapEntry<String, int>> items;

  @override
  Widget build(BuildContext context) {
    final maxValue = items.fold<int>(1, (max, e) => math.max(max, e.value));

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(16),
        ScreenUtil().setHeight(16),
        ScreenUtil().setWidth(12),
        ScreenUtil().setHeight(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(160),
            child: CustomPaint(
              painter: _TrendBarPainter(items: items, maxValue: maxValue),
              size: Size.infinite,
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items
                .map(
                  (e) => Expanded(
                    child: Text(
                      e.key,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.label.copyWith(fontSize: ScreenUtil().setSp(10)),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _TrendBarPainter extends CustomPainter {
  _TrendBarPainter({required this.items, required this.maxValue});

  final List<MapEntry<String, int>> items;
  final int maxValue;

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    final chartTop = 8.0;
    final chartBottom = size.height - 8;
    final chartHeight = chartBottom - chartTop;
    final barGap = 10.0;
    final barWidth = (size.width - barGap * (items.length + 1)) / items.length;

    for (var i = 0; i <= 3; i++) {
      final y = chartBottom - chartHeight * i / 3;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        Paint()
          ..color = AppColors.divider.withValues(alpha: 0.5)
          ..strokeWidth = 1,
      );
    }

    for (var i = 0; i < items.length; i++) {
      final value = items[i].value;
      final ratio = value / maxValue;
      final barHeight = chartHeight * ratio;
      final left = barGap + i * (barWidth + barGap);
      final top = chartBottom - barHeight;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barWidth, barHeight.clamp(0, chartHeight)),
        Radius.circular(ScreenUtil().radius(6)),
      );

      canvas.drawRRect(
        rect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              AppColors.ctaDark,
              value > 0 ? AppColors.cta : AppColors.surfaceMuted,
            ],
          ).createShader(rect.outerRect),
      );

      if (value > 0) {
        final tp = TextPainter(
          text: TextSpan(
            text: '$value',
            style: TextStyle(
              color: AppColors.ctaDark,
              fontSize: ScreenUtil().setSp(10),
              fontWeight: FontWeight.w700,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(left + barWidth / 2 - tp.width / 2, top - tp.height - 4));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TrendBarPainter oldDelegate) =>
      oldDelegate.items != items || oldDelegate.maxValue != maxValue;
}

class StatsDonutChart extends StatelessWidget {
  const StatsDonutChart({
    super.key,
    required this.segments,
    required this.centerLabel,
    required this.centerValue,
  });

  final List<StatsChartSegment> segments;
  final String centerLabel;
  final String centerValue;

  @override
  Widget build(BuildContext context) {
    final total = segments.fold<int>(0, (sum, s) => sum + s.value);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: ScreenUtil().setWidth(130),
            height: ScreenUtil().setWidth(130),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: _DonutPainter(segments: segments, total: total),
                  size: Size.infinite,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      centerValue,
                      style: AppTypography.title.copyWith(
                        color: AppColors.cta,
                        fontSize: ScreenUtil().setSp(22),
                      ),
                    ),
                    Text(
                      centerLabel,
                      style: AppTypography.label.copyWith(fontSize: ScreenUtil().setSp(10)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(12)),
          Expanded(
            child: Column(
              children: segments
                  .map(
                    (s) => Padding(
                      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(8)),
                      child: Row(
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(8),
                            height: ScreenUtil().setWidth(8),
                            decoration: BoxDecoration(color: s.color, shape: BoxShape.circle),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(8)),
                          Expanded(
                            child: Text(
                              s.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.caption,
                            ),
                          ),
                          Text(
                            '${s.value}',
                            style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.segments, required this.total});

  final List<StatsChartSegment> segments;
  final int total;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 4;
    const stroke = 18.0;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.surfaceMuted
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );

    if (total <= 0) return;

    var start = -math.pi / 2;
    for (final segment in segments) {
      if (segment.value <= 0) continue;
      final sweep = 2 * math.pi * segment.value / total;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        Paint()
          ..color = segment.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.segments != segments || oldDelegate.total != total;
}

class StatsAchievementGauge extends StatelessWidget {
  const StatsAchievementGauge({
    super.key,
    required this.current,
    required this.nextTarget,
    required this.progress,
  });

  final int current;
  final int nextTarget;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: ScreenUtil().setWidth(72),
            height: ScreenUtil().setWidth(72),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: ScreenUtil().setWidth(6),
                    backgroundColor: Colors.white.withValues(alpha: 0.12),
                    color: AppColors.cta,
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.cta,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Lang.statsNextBadge,
                  style: AppTypography.label.copyWith(color: Colors.white60),
                ),
                SizedBox(height: ScreenUtil().setHeight(4)),
                Text(
                  '$current / $nextTarget ${Lang.statsTimes}',
                  style: AppTypography.title.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
