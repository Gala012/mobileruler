import 'package:camera/camera.dart';
import 'package:mobilem/components/app_feedback.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/bottom_sheet_helper.dart';
import 'package:mobilem/db_mobilem/db_mobilem_entity.dart';
import 'package:mobilem/db_mobilem/db_mobilem_helper.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/services/app_data_service.dart';
import 'package:mobilem/utils/camera_scale.dart';

class AreaLogic extends GetxController {
  static const _polygonSamplePx = 8.0;

  final isRect = true.obs;
  final points = <Offset>[].obs;
  final rectStart = Rxn<Offset>();
  final rectEnd = Rxn<Offset>();
  final areaValue = 0.0.obs;
  final isDrawing = false.obs;
  final distanceM = 1.0.obs;
  final cameraReady = false.obs;
  final cameraError = ''.obs;

  final distanceController = TextEditingController(text: '1.0');
  CameraController? cameraController;

  double _sceneHeight = 600;

  AppDataService get _data => Get.find<AppDataService>();

  @override
  void onInit() {
    super.onInit();
    DbMobilemHelper.instance.incrementUsage('area');
    _initCamera();
  }

  @override
  void onClose() {
    distanceController.dispose();
    _disposeCamera();
    super.onClose();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        cameraError.value = Lang.areaCameraOptional;
        return;
      }
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        back,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      cameraController = controller;
      await controller.initialize();
      if (isClosed) {
        await controller.dispose();
        return;
      }
      cameraReady.value = true;
      cameraError.value = '';
    } catch (_) {
      cameraError.value = Lang.areaCameraUnavailable;
      cameraReady.value = false;
    }
  }

  Future<void> _disposeCamera() async {
    final controller = cameraController;
    cameraController = null;
    cameraReady.value = false;
    if (controller != null) {
      await controller.dispose();
    }
  }

  String get areaText => areaValue.value > 0 ? areaValue.value.toStringAsFixed(2) : '--';

  String get hintText {
    if (distanceM.value <= 0) {
      return Lang.areaDistanceTip;
    }
    if (areaValue.value > 0) {
      return '${Lang.areaResult}: ${areaValue.value.toStringAsFixed(2)} $unit';
    }
    return isRect.value ? Lang.areaDragRectHint : Lang.areaDragPolygonHint;
  }

  void bindSceneHeight(double height) {
    if ((_sceneHeight - height).abs() < 0.5) return;
    _sceneHeight = height;
    Future.microtask(() {
      if (isClosed) return;
      _recalc();
    });
  }

  void onDistanceChanged(String value) {
    final parsed = double.tryParse(value);
    if (parsed == null || parsed <= 0) return;
    distanceM.value = parsed;
    _recalc();
  }

  void setShapeMode(bool rect) {
    if (isRect.value == rect) return;
    isRect.value = rect;
    resetDrawing();
  }

  void onPanStart(Offset pos) {
    if (distanceM.value <= 0) return;
    isDrawing.value = true;
    areaValue.value = 0;
    if (isRect.value) {
      rectStart.value = pos;
      rectEnd.value = pos;
      return;
    }
    points
      ..clear()
      ..add(pos);
  }

  void onPanUpdate(Offset pos) {
    if (distanceM.value <= 0) return;
    if (isRect.value) {
      rectEnd.value = pos;
      _calcRect();
      return;
    }
    if (points.isEmpty) return;
    final last = points.last;
    if ((pos - last).distance < _polygonSamplePx) return;
    points.add(pos);
    if (points.length >= 3) {
      _calcPolygon();
    }
  }

  void onPanEnd() {
    isDrawing.value = false;
    if (isRect.value) {
      _calcRect();
      return;
    }
    if (points.length >= 3) {
      _calcPolygon();
    }
  }

  void _calcRect() {
    if (rectStart.value == null || rectEnd.value == null) return;
    final w = (rectStart.value!.dx - rectEnd.value!.dx).abs();
    final h = (rectStart.value!.dy - rectEnd.value!.dy).abs();
    if (w < 4 || h < 4) {
      areaValue.value = 0;
      return;
    }
    final mm2 = CameraScale.pxAreaToMm2(w * h, distanceM.value, _sceneHeight);
    areaValue.value = mm2 > 0 ? _toDisplayArea(mm2) : 0;
  }

  void _calcPolygon() {
    if (points.length < 3) return;
    var sum = 0.0;
    for (var i = 0; i < points.length; i++) {
      final j = (i + 1) % points.length;
      sum += points[i].dx * points[j].dy - points[j].dx * points[i].dy;
    }
    final px2 = sum.abs() / 2;
    if (px2 < 16) {
      areaValue.value = 0;
      return;
    }
    final mm2 = CameraScale.pxAreaToMm2(px2, distanceM.value, _sceneHeight);
    areaValue.value = mm2 > 0 ? _toDisplayArea(mm2) : 0;
  }

  void _recalc() {
    if (isRect.value) {
      _calcRect();
      return;
    }
    if (points.length >= 3) {
      _calcPolygon();
    }
  }

  double _toDisplayArea(double mm2) {
    final unit = _data.settings.value.defaultAreaUnit;
    return unit == 'inch2' ? mm2 / 645.16 : mm2 / 100;
  }

  void resetDrawing() {
    isDrawing.value = false;
    points.clear();
    rectStart.value = null;
    rectEnd.value = null;
    areaValue.value = 0;
  }

  void reset() {
    resetDrawing();
    distanceM.value = 1.0;
    distanceController.text = '1.0';
  }

  String get unit {
    return _data.settings.value.defaultAreaUnit == 'inch2' ? 'inch²' : 'cm²';
  }

  Future<void> save() async {
    if (areaValue.value <= 0 || distanceM.value <= 0) return;
    final note = await showNoteInputSheet() ?? '';
    await _data.saveMeasurement(
      MeasurementRecordEntity(
        toolType: 'area',
        value: double.parse(areaValue.value.toStringAsFixed(2)),
        unit: unit,
        note: note,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    AppToast.success(Lang.areaSaved);
    resetDrawing();
  }
}
