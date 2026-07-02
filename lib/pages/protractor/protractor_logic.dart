import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mobilem/components/app_feedback.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/bottom_sheet_helper.dart';
import 'package:mobilem/db_mobilem/db_mobilem_entity.dart';
import 'package:mobilem/db_mobilem/db_mobilem_helper.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/services/app_data_service.dart';

class ProtractorLogic extends GetxController {
  static const baselineInset = 0.0;
  static const topInset = 8.0;
  static const bottomLabelMargin = 30.0;
  static const sideLabelMargin = 38.0;
  static const labelOutset = 20.0;
  static const angleBadgeHeight = 58.0;

  final angle = 90.0.obs;
  final locked = false.obs;

  Offset _center = Offset.zero;
  double _radius = 0;

  @override
  void onInit() {
    super.onInit();
    DbMobilemHelper.instance.incrementUsage('protractor');
  }

  static double radiusFor(Size size) {
    return math.min(
      size.width - sideLabelMargin,
      (size.height - topInset - bottomLabelMargin) / 2,
    );
  }

  static double angleBadgeBottomOffset(Size size) {
    final radius = radiusFor(size);
    final centerY = size.height - bottomLabelMargin - radius;
    final labelR = radius + labelOutset;
    var lowLabelBottom = 0.0;
    for (var deg = 10; deg <= 55; deg += 5) {
      final rad = math.pi / 2 - deg * math.pi / 180;
      if (math.cos(rad) <= 0.12) continue;
      final y = centerY + labelR * math.sin(rad);
      lowLabelBottom = math.max(lowLabelBottom, y);
    }
    return math.max(
      bottomLabelMargin,
      size.height - lowLabelBottom - angleBadgeHeight - 14,
    );
  }

  void bindGeometry(Size size) {
    _radius = radiusFor(size);
    _center = Offset(baselineInset, size.height - bottomLabelMargin - _radius);
  }

  void setAngle(double value) => angle.value = value.clamp(0, 180);

  void toggleLock() => locked.value = !locked.value;

  void onTap(Offset localPos) => _setAngleFromPosition(localPos, snapTick: true);

  void onDrag(Offset localPos) => _setAngleFromPosition(localPos, snapTick: false);

  void _setAngleFromPosition(Offset localPos, {required bool snapTick}) {
    if (locked.value || _radius <= 0) return;

    if (snapTick) {
      final snapped = _snapTapToTick(localPos);
      if (snapped != null) {
        setAngle(snapped);
        return;
      }
    }

    if (localPos.dx <= 28 &&
        localPos.dy >= _center.dy - _radius - 8 &&
        localPos.dy <= _center.dy + _radius + 8) {
      setAngle(localPos.dy < _center.dy ? 180 : 0);
      return;
    }

    final dx = localPos.dx - _center.dx;
    final dy = localPos.dy - _center.dy;
    final minDx = snapTick ? 2.0 : -8.0;
    if (dx > minDx) {
      setAngle(math.atan2(dx, dy) * 180 / math.pi);
    }
  }

  double? _snapTapToTick(Offset tap) {
    final labelR = _radius + labelOutset;
    for (var deg = 0; deg <= 180; deg += 10) {
      final lp = _pointOnArc(deg, labelR);
      if ((tap - lp).distance <= 40) return deg.toDouble();
    }

    for (var deg = 0; deg <= 180; deg += 5) {
      final tp = _pointOnArc(deg, _radius);
      if ((tap - tp).distance <= 30) return deg.toDouble();
    }

    for (var deg = 0; deg <= 180; deg++) {
      final tp = _pointOnArc(deg, _radius);
      if ((tap - tp).distance <= 22) return deg.toDouble();
    }

    final dist = (tap - _center).distance;
    if (dist >= _radius - 50 && dist <= _radius + labelOutset + 28) {
      final dx = tap.dx - _center.dx;
      final dy = tap.dy - _center.dy;
      if (dx > -4) {
        return (math.atan2(dx, dy) * 180 / math.pi).clamp(0, 180);
      }
    }

    if (_isInsideSemicircle(tap)) {
      final dx = tap.dx - _center.dx;
      final dy = tap.dy - _center.dy;
      return (math.atan2(dx, dy) * 180 / math.pi).clamp(0, 180);
    }
    return null;
  }

  bool _isInsideSemicircle(Offset tap) {
    final dx = tap.dx - _center.dx;
    final dy = tap.dy - _center.dy;
    if (dx <= 0) return false;
    final dist = math.sqrt(dx * dx + dy * dy);
    return dist <= _radius + 6;
  }

  Offset _pointOnArc(int deg, double r) {
    final rad = math.pi / 2 - deg * math.pi / 180;
    return Offset(
      _center.dx + r * math.cos(rad),
      _center.dy + r * math.sin(rad),
    );
  }

  Future<void> save() async {
    final note = await showNoteInputSheet() ?? '';
    await Get.find<AppDataService>().saveMeasurement(
      MeasurementRecordEntity(
        toolType: 'protractor',
        value: double.parse(angle.value.toStringAsFixed(2)),
        unit: '°',
        note: note,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    AppToast.success(Lang.protractorSaved);
  }
}
