import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mobilem/utils/app_colors.dart';

class DualRulerPainter extends CustomPainter {
  DualRulerPainter({
    required this.pixelsPerMm,
    required this.isPortrait,
    required this.scrollOffset,
    this.originInset = 20,
    this.labelFontSize = 14,
  });

  final double pixelsPerMm;
  final bool isPortrait;
  final double scrollOffset;
  final double originInset;
  final double labelFontSize;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.canvasDark);

    if (isPortrait) {
      _drawVerticalScale(canvas, size, left: true);
      _drawVerticalScale(canvas, size, left: false);
    } else {
      _drawHorizontalScale(canvas, size, top: true);
      _drawHorizontalScale(canvas, size, top: false);
    }
  }

  void _drawVerticalScale(Canvas canvas, Size size, {required bool left}) {
    final edge = left ? 0.0 : size.width;
    final tickDir = left ? 1.0 : -1.0;
    final labelX = left ? 46.0 : size.width - 46.0;
    final originY = size.height - originInset;

    _drawTicks(
      canvas,
      size.height - originInset,
      scrollOffset,
      (pos) {
        final y = originY - pos.distance;
        final x1 = edge;
        final x2 = edge + tickDir * pos.tickLen;
        canvas.drawLine(Offset(x1, y), Offset(x2, y), pos.paint);
        if (pos.label != null) {
          final labelY = pos.label == '0' ? y - 6 : y;
          _paintRotatedLabel(canvas, pos.label!, Offset(labelX, labelY), left ? -math.pi / 2 : math.pi / 2);
        }
      },
      cmOnLeft: left,
    );

    final baseline = Paint()
      ..color = AppColors.cta.withValues(alpha: 0.55)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(0, originY), Offset(size.width, originY), baseline);
  }

  void _drawHorizontalScale(Canvas canvas, Size size, {required bool top}) {
    final edge = top ? 0.0 : size.height;
    final tickDir = top ? 1.0 : -1.0;
    final originX = originInset;

    _drawTicks(
      canvas,
      size.width - originInset,
      scrollOffset,
      (pos) {
        final x = originX + pos.distance;
        final y1 = edge;
        final y2 = edge + tickDir * pos.tickLen;
        canvas.drawLine(Offset(x, y1), Offset(x, y2), pos.paint);
        if (pos.label != null) {
          final tp = TextPainter(
            text: TextSpan(text: pos.label, style: _labelStyle),
            textDirection: TextDirection.ltr,
          )..layout();
          final labelX = pos.label == '0' ? x - 4 : x + 4;
          tp.paint(canvas, Offset(labelX, top ? pos.tickLen + 6 : size.height - pos.tickLen - tp.height - 6));
        }
      },
      cmOnLeft: top,
    );

    final baseline = Paint()
      ..color = AppColors.cta.withValues(alpha: 0.55)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(originX, 0), Offset(originX, size.height), baseline);
  }

  void _drawTicks(
    Canvas canvas,
    double length,
    double scroll,
    void Function(_TickPos pos) draw,
    {required bool cmOnLeft}
  ) {
    final endMm = scroll / pixelsPerMm + length / pixelsPerMm;
    final startMm = scroll / pixelsPerMm;

    for (var mm = startMm.floor(); mm <= endMm.ceil(); mm++) {
      final distance = (mm * pixelsPerMm) - scroll;
      if (distance < -30 || distance > length + 30) continue;

      final isCmMajor = mm % 10 == 0;
      final isInchMajor = ((mm / 25.4).round() * 25.4 - mm).abs() < 0.6;
      final isMid = mm % 5 == 0;

      final showCm = cmOnLeft;
      final isMajor = showCm ? isCmMajor : isInchMajor;
      final tickLen = isMajor ? 36.0 : (isMid ? 22.0 : 10.0);
      final paint = Paint()
        ..color = isMajor ? Colors.white : Colors.white.withValues(alpha: 0.45)
        ..strokeWidth = isMajor ? 1.8 : 1;

      String? label;
      if (isMajor) {
        label = showCm ? (mm / 10).toStringAsFixed(0) : (mm / 25.4).toStringAsFixed(0);
      }

      draw(_TickPos(distance: distance, tickLen: tickLen, paint: paint, label: label));
    }
  }

  TextStyle get _labelStyle => TextStyle(
        color: Colors.white,
        fontSize: labelFontSize,
        fontWeight: FontWeight.w700,
      );

  void _paintRotatedLabel(Canvas canvas, String text, Offset center, double angle) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: _labelStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DualRulerPainter oldDelegate) {
    return oldDelegate.pixelsPerMm != pixelsPerMm ||
        oldDelegate.isPortrait != isPortrait ||
        oldDelegate.scrollOffset != scrollOffset ||
        oldDelegate.originInset != originInset ||
        oldDelegate.labelFontSize != labelFontSize;
  }
}

class _TickPos {
  _TickPos({required this.distance, required this.tickLen, required this.paint, this.label});

  final double distance;
  final double tickLen;
  final Paint paint;
  final String? label;
}

class RulerMeasureZonePainter extends CustomPainter {
  RulerMeasureZonePainter({
    required this.isPortrait,
    required this.measureFromOrigin,
    required this.canvasSize,
    this.originInset = 20,
  });

  final bool isPortrait;
  final double measureFromOrigin;
  final Size canvasSize;
  final double originInset;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = AppColors.cta.withValues(alpha: 0.12);
    if (isPortrait) {
      final originY = canvasSize.height - originInset;
      final top = originY - measureFromOrigin;
      canvas.drawRect(Rect.fromLTWH(0, top, canvasSize.width, measureFromOrigin), fill);
    } else {
      final left = originInset;
      canvas.drawRect(Rect.fromLTWH(left, 0, measureFromOrigin, canvasSize.height), fill);
    }
  }

  @override
  bool shouldRepaint(covariant RulerMeasureZonePainter oldDelegate) {
    return oldDelegate.measureFromOrigin != measureFromOrigin ||
        oldDelegate.isPortrait != isPortrait ||
        oldDelegate.canvasSize != canvasSize ||
        oldDelegate.originInset != originInset;
  }
}

class ProtractorPainter extends CustomPainter {
  ProtractorPainter({
    required this.angle,
    required this.locked,
    this.baselineInset = 0,
    this.topInset = 8,
    this.bottomLabelMargin = 30,
    this.sideLabelMargin = 38,
    this.labelOutset = 20,
    this.labelFontSize = 15,
  });

  final double angle;
  final bool locked;
  final double baselineInset;
  final double topInset;
  final double bottomLabelMargin;
  final double sideLabelMargin;
  final double labelOutset;
  final double labelFontSize;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.canvasDark);

    final cx = baselineInset;
    final radius = math.min(
      size.width - sideLabelMargin,
      (size.height - topInset - bottomLabelMargin) / 2,
    );
    final cy = size.height - bottomLabelMargin - radius;
    final center = Offset(cx, cy);

    _drawLongEdgeRuler(canvas, cx, size.height, topInset);
    _drawBaseline(canvas, center, radius);
    _drawArcTicks(canvas, center, radius);

    final clamped = angle.clamp(0, 180);
    final armRad = math.pi / 2 - clamped * math.pi / 180;
    final baselineEnd = Offset(cx, cy + radius);
    final armEnd = Offset(
      center.dx + radius * math.cos(armRad),
      center.dy + radius * math.sin(armRad),
    );

    final startRad = math.pi / 2;
    final sector = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(baselineEnd.dx, baselineEnd.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        startRad,
        armRad - startRad,
        false,
      )
      ..close();
    canvas.drawPath(sector, Paint()..color = AppColors.cta.withValues(alpha: 0.14));

    final basePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final armPaint = Paint()
      ..color = AppColors.cta
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(cx, cy - radius), baselineEnd, basePaint);
    canvas.drawLine(center, armEnd, armPaint);

    canvas.drawCircle(center, 7, Paint()..color = AppColors.cta);
    canvas.drawCircle(
      center,
      11,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.cta.withValues(alpha: 0.5),
    );

    _drawHandle(canvas, armEnd, locked);
  }

  void _drawLongEdgeRuler(Canvas canvas, double x, double height, double topInset) {
    final paint = Paint()
      ..color = AppColors.cta.withValues(alpha: 0.8)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(x, topInset), Offset(x, height), paint);
  }

  void _drawBaseline(Canvas canvas, Offset center, double radius) {
    final bottom = Offset(center.dx, center.dy + radius);
    final top = Offset(center.dx, center.dy - radius);
    final tick = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(bottom.dx - 6, bottom.dy),
      Offset(bottom.dx + 6, bottom.dy),
      tick,
    );
    canvas.drawLine(
      Offset(top.dx - 6, top.dy),
      Offset(top.dx + 6, top.dy),
      tick,
    );
  }

  void _drawArcTicks(Canvas canvas, Offset center, double radius) {
    for (var deg = 0; deg <= 180; deg++) {
      final rad = math.pi / 2 - deg * math.pi / 180;
      final isMajor = deg % 10 == 0;
      final isMid = deg % 5 == 0;
      final inner = radius - (isMajor ? 34 : (isMid ? 22 : 10));
      final p1 = Offset(center.dx + inner * math.cos(rad), center.dy + inner * math.sin(rad));
      final p2 = Offset(center.dx + radius * math.cos(rad), center.dy + radius * math.sin(rad));
      canvas.drawLine(
        p1,
        p2,
        Paint()
          ..color = isMajor ? Colors.white : Colors.white.withValues(alpha: 0.45)
          ..strokeWidth = isMajor ? 2 : 1,
      );
      if (isMajor) {
        final labelR = radius + labelOutset;
        final lp = Offset(
          center.dx + labelR * math.cos(rad),
          center.dy + labelR * math.sin(rad),
        );
        _paintLabel(canvas, '$deg', lp);
      }
    }
  }

  void _paintLabel(Canvas canvas, String text, Offset at, {double? fontSize}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize ?? labelFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(at.dx - tp.width / 2, at.dy - tp.height / 2));
  }

  void _drawHandle(Canvas canvas, Offset pos, bool locked) {
    canvas.drawCircle(pos, 14, Paint()..color = locked ? AppColors.textHint : AppColors.cta);
    canvas.drawCircle(
      pos,
      20,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white.withValues(alpha: 0.8),
    );
  }

  @override
  bool shouldRepaint(covariant ProtractorPainter oldDelegate) {
    return oldDelegate.angle != angle ||
        oldDelegate.locked != locked ||
        oldDelegate.baselineInset != baselineInset ||
        oldDelegate.topInset != topInset ||
        oldDelegate.bottomLabelMargin != bottomLabelMargin ||
        oldDelegate.sideLabelMargin != sideLabelMargin ||
        oldDelegate.labelOutset != labelOutset ||
        oldDelegate.labelFontSize != labelFontSize;
  }
}

class DistanceScenePainter extends CustomPainter {
  DistanceScenePainter({
    required this.topY,
    required this.bottomY,
    this.drawBackground = true,
  });

  final double topY;
  final double bottomY;
  final bool drawBackground;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    if (drawBackground) {
      final bg = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1A1A1A),
            AppColors.canvasDark,
            const Color(0xFF0F0F0F),
          ],
        ).createShader(rect);
      canvas.drawRect(rect, bg);

      final noise = Paint()..color = Colors.white.withValues(alpha: 0.02);
      for (var i = 0; i < 12; i++) {
        final y = size.height * (i / 12);
        canvas.drawLine(Offset(0, y), Offset(size.width, y), noise);
      }
    }

    if (bottomY > topY) {
      canvas.drawRect(
        Rect.fromLTRB(0, topY, size.width, bottomY),
        Paint()..color = AppColors.cta.withValues(alpha: drawBackground ? 0.08 : 0.12),
      );
    }
  }

  @override
  bool shouldRepaint(covariant DistanceScenePainter oldDelegate) {
    return oldDelegate.topY != topY ||
        oldDelegate.bottomY != bottomY ||
        oldDelegate.drawBackground != drawBackground;
  }
}

class LevelBubblePainter extends CustomPainter {
  LevelBubblePainter({required this.tiltX, required this.tiltY});

  final double tiltX;
  final double tiltY;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.38;
    final isFlat = tiltX.abs() < 0.5 && tiltY.abs() < 0.5;

    final bg = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.85,
        colors: [
          const Color(0xFF262626),
          AppColors.canvasDark,
          const Color(0xFF0A0A0A),
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    _drawGuideLines(canvas, center, size);
    _drawOuterRing(canvas, center, radius);
    _drawTickRing(canvas, center, radius * 0.92);
    _drawVial(canvas, center, radius * 0.78, isFlat);
    _drawCrosshair(canvas, center, radius * 0.78);
    _drawTargetZone(canvas, center, radius * 0.14, isFlat);
    _drawBubble(canvas, center, radius * 0.78, isFlat);
  }

  void _drawGuideLines(Canvas canvas, Offset center, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), paint);
  }

  void _drawOuterRing(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.cta.withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.drawCircle(
      center,
      radius + 6,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.06)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  void _drawTickRing(Canvas canvas, Offset center, double radius) {
    const majorEvery = 15;
    for (var deg = 0; deg < 360; deg += 5) {
      final rad = deg * math.pi / 180;
      final major = deg % majorEvery == 0;
      final inner = radius - (major ? 14 : 8);
      final outer = radius;
      final p1 = Offset(center.dx + inner * math.cos(rad), center.dy + inner * math.sin(rad));
      final p2 = Offset(center.dx + outer * math.cos(rad), center.dy + outer * math.sin(rad));
      canvas.drawLine(
        p1,
        p2,
        Paint()
          ..color = major
              ? AppColors.cta.withValues(alpha: 0.75)
              : Colors.white.withValues(alpha: 0.18)
          ..strokeWidth = major ? 2 : 1,
      );
    }
    for (final label in ['0°', '90°', '180°', '270°']) {
      final deg = switch (label) {
        '0°' => 0.0,
        '90°' => 90.0,
        '180°' => 180.0,
        _ => 270.0,
      };
      final rad = (deg - 90) * math.pi / 180;
      final pos = Offset(
        center.dx + (radius + 22) * math.cos(rad),
        center.dy + (radius + 22) * math.sin(rad),
      );
      _drawLabel(canvas, label, pos);
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.45),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
  }

  void _drawVial(Canvas canvas, Offset center, double radius, bool isFlat) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            isFlat
                ? AppColors.success.withValues(alpha: 0.18)
                : const Color(0xFF2A2A2A),
            const Color(0xFF141414),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.cta.withValues(alpha: isFlat ? 0.65 : 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.drawCircle(
      center,
      radius - 8,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  void _drawCrosshair(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = AppColors.cta.withValues(alpha: 0.2)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(center.dx - radius + 12, center.dy),
      Offset(center.dx + radius - 12, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius + 12),
      Offset(center.dx, center.dy + radius - 12),
      paint,
    );
  }

  void _drawTargetZone(Canvas canvas, Offset center, double radius, bool isFlat) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = isFlat
            ? AppColors.success.withValues(alpha: 0.35)
            : AppColors.cta.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isFlat ? 2 : 1.5,
    );
    canvas.drawCircle(center, 3, Paint()..color = isFlat ? AppColors.success : AppColors.cta);
    if (isFlat) {
      canvas.drawCircle(
        center,
        radius + 4,
        Paint()
          ..color = AppColors.success.withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }

  void _drawBubble(Canvas canvas, Offset center, double radius, bool isFlat) {
    final maxOffset = radius * 0.62;
    final bubbleX = center.dx + (tiltX.clamp(-15, 15) / 15) * maxOffset;
    final bubbleY = center.dy + (tiltY.clamp(-15, 15) / 15) * maxOffset;
    final bubbleR = radius * 0.16;
    final bubbleCenter = Offset(bubbleX, bubbleY);
    final bubbleColor = isFlat ? AppColors.success : AppColors.cta;

    if (isFlat) {
      canvas.drawCircle(
        bubbleCenter,
        bubbleR + 8,
        Paint()
          ..color = AppColors.success.withValues(alpha: 0.15)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
    }

    canvas.drawCircle(
      bubbleCenter,
      bubbleR,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.35),
          colors: [
            bubbleColor.withValues(alpha: 0.95),
            bubbleColor.withValues(alpha: 0.7),
            bubbleColor.withValues(alpha: 0.45),
          ],
        ).createShader(Rect.fromCircle(center: bubbleCenter, radius: bubbleR)),
    );
    canvas.drawCircle(
      bubbleCenter,
      bubbleR,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.drawCircle(
      Offset(bubbleX - bubbleR * 0.32, bubbleY - bubbleR * 0.32),
      bubbleR * 0.22,
      Paint()..color = Colors.white.withValues(alpha: 0.65),
    );
  }

  @override
  bool shouldRepaint(covariant LevelBubblePainter oldDelegate) =>
      oldDelegate.tiltX != tiltX || oldDelegate.tiltY != tiltY;
}

class CompassPainter extends CustomPainter {
  CompassPainter({required this.heading});

  final double heading;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.38;

    final bg = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.9,
        colors: [
          const Color(0xFF262626),
          AppColors.canvasDark,
          const Color(0xFF0A0A0A),
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    _drawGuideLines(canvas, center, size);
    _drawFixedPointer(canvas, center, radius);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-heading * math.pi / 180);
    canvas.translate(-center.dx, -center.dy);

    _drawOuterRing(canvas, center, radius);
    _drawTickRing(canvas, center, radius * 0.94);
    _drawInnerDial(canvas, center, radius * 0.82);
    _drawDirectionLabels(canvas, center, radius * 0.72);
    _drawNeedle(canvas, center, radius * 0.68);
    canvas.restore();

    canvas.drawCircle(
      center,
      10,
      Paint()
        ..shader = RadialGradient(
          colors: [AppColors.cta, AppColors.primary],
        ).createShader(Rect.fromCircle(center: center, radius: 10)),
    );
    canvas.drawCircle(
      center,
      10,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  void _drawGuideLines(Canvas canvas, Offset center, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), paint);
  }

  void _drawFixedPointer(Canvas canvas, Offset center, double radius) {
    final tip = Offset(center.dx, center.dy - radius - 18);
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(tip.dx - 8, tip.dy + 14)
      ..lineTo(tip.dx + 8, tip.dy + 14)
      ..close();
    canvas.drawPath(path, Paint()..color = AppColors.cta.withValues(alpha: 0.85));
    canvas.drawCircle(
      tip,
      3,
      Paint()..color = AppColors.cta,
    );
  }

  void _drawOuterRing(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.cta.withValues(alpha: 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.drawCircle(
      center,
      radius + 8,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  void _drawTickRing(Canvas canvas, Offset center, double radius) {
    for (var deg = 0; deg < 360; deg += 10) {
      final rad = (deg - 90) * math.pi / 180;
      final major = deg % 30 == 0;
      final inner = radius - (major ? 16 : 9);
      final outer = radius;
      final p1 = Offset(center.dx + inner * math.cos(rad), center.dy + inner * math.sin(rad));
      final p2 = Offset(center.dx + outer * math.cos(rad), center.dy + outer * math.sin(rad));
      canvas.drawLine(
        p1,
        p2,
        Paint()
          ..color = major
              ? AppColors.cta.withValues(alpha: 0.7)
              : Colors.white.withValues(alpha: 0.15)
          ..strokeWidth = major ? 2 : 1,
      );
    }
  }

  void _drawInnerDial(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [const Color(0xFF2A2A2A), const Color(0xFF141414)],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.cta.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawDirectionLabels(Canvas canvas, Offset center, double labelRadius) {
    const labels = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    for (var i = 0; i < labels.length; i++) {
      final rad = -math.pi / 2 + i * math.pi / 4;
      final label = labels[i];
      final isCardinal = label.length == 1;
      final isNorth = label == 'N';
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: isNorth
                ? AppColors.cta
                : (isCardinal ? Colors.white.withValues(alpha: 0.85) : Colors.white.withValues(alpha: 0.45)),
            fontSize: isCardinal ? 16 : 11,
            fontWeight: isNorth ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(
          center.dx + labelRadius * math.cos(rad) - tp.width / 2,
          center.dy + labelRadius * math.sin(rad) - tp.height / 2,
        ),
      );
    }
  }

  void _drawNeedle(Canvas canvas, Offset center, double length) {
    final north = Path()
      ..moveTo(center.dx, center.dy - length + 16)
      ..lineTo(center.dx - 11, center.dy)
      ..lineTo(center.dx, center.dy - 4)
      ..close();
    canvas.drawPath(
      north,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.cta, AppColors.ctaDark],
        ).createShader(Rect.fromCenter(center: center, width: 24, height: length)),
    );

    final south = Path()
      ..moveTo(center.dx, center.dy + length * 0.42)
      ..lineTo(center.dx - 9, center.dy)
      ..lineTo(center.dx, center.dy + 4)
      ..close();
    canvas.drawPath(
      south,
      Paint()..color = Colors.white.withValues(alpha: 0.25),
    );
  }

  @override
  bool shouldRepaint(covariant CompassPainter oldDelegate) => oldDelegate.heading != heading;
}

class DividerRulerOverlayPainter extends CustomPainter {
  DividerRulerOverlayPainter({
    required this.measurePx,
    required this.parts,
    required this.originInset,
    required this.isPortrait,
    this.labelFontSize = 14,
  });

  final double measurePx;
  final int parts;
  final double originInset;
  final bool isPortrait;
  final double labelFontSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (parts < 2 || measurePx <= 0) return;

    if (isPortrait) {
      _paintPortrait(canvas, size);
    } else {
      _paintLandscape(canvas, size);
    }
  }

  void _paintPortrait(Canvas canvas, Size size) {
    final originY = size.height - originInset;
    final topY = originY - measurePx;
    final linePaint = Paint()
      ..color = AppColors.cta
      ..strokeWidth = 2;
    final edgePaint = Paint()
      ..color = AppColors.cta.withValues(alpha: 0.85)
      ..strokeWidth = 2.5;

    canvas.drawLine(Offset(0, topY), Offset(size.width, topY), edgePaint);

    for (var i = 1; i < parts; i++) {
      final y = originY - measurePx * i / parts;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
      canvas.drawLine(Offset(0, y), Offset(44, y), edgePaint..strokeWidth = 3);
      canvas.drawLine(Offset(size.width - 44, y), Offset(size.width, y), edgePaint..strokeWidth = 3);
      _paintDivisionLabel(canvas, '$i', Offset(size.width / 2, y - 10));
    }

    _paintDivisionLabel(canvas, '0', Offset(size.width / 2, originY - 8));
    _paintDivisionLabel(canvas, '$parts', Offset(size.width / 2, topY + 14));
  }

  void _paintLandscape(Canvas canvas, Size size) {
    final originX = originInset;
    final endX = originInset + measurePx;
    final linePaint = Paint()
      ..color = AppColors.cta
      ..strokeWidth = 2;
    final edgePaint = Paint()
      ..color = AppColors.cta.withValues(alpha: 0.85)
      ..strokeWidth = 2.5;

    canvas.drawLine(Offset(endX, 0), Offset(endX, size.height), edgePaint);

    for (var i = 1; i < parts; i++) {
      final x = originX + measurePx * i / parts;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
      _paintDivisionLabel(canvas, '$i', Offset(x + 8, size.height / 2));
    }
  }

  void _paintDivisionLabel(Canvas canvas, String text, Offset center) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: AppColors.cta,
          fontSize: labelFontSize,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant DividerRulerOverlayPainter oldDelegate) =>
      oldDelegate.measurePx != measurePx ||
      oldDelegate.parts != parts ||
      oldDelegate.originInset != originInset ||
      oldDelegate.isPortrait != isPortrait ||
      oldDelegate.labelFontSize != labelFontSize;
}
