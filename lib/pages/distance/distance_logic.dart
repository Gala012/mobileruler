import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/app_feedback.dart';
import 'package:mobilem/components/bottom_sheet_helper.dart';
import 'package:mobilem/db_mobilem/db_mobilem_entity.dart';
import 'package:mobilem/db_mobilem/db_mobilem_helper.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/services/app_data_service.dart';
import 'package:mobilem/utils/camera_scale.dart';

class DistanceLogic extends GetxController {
  final topLineY = 0.0.obs;
  final bottomLineY = 0.0.obs;
  final objectHeightM = 1.0.obs;
  final distanceM = 0.0.obs;
  final cameraReady = false.obs;
  final cameraError = ''.obs;
  final heightController = TextEditingController(text: '1.0');

  CameraController? cameraController;
  double _sceneHeight = 600;

  AppDataService get _data => Get.find<AppDataService>();

  @override
  void onInit() {
    super.onInit();
    DbMobilemHelper.instance.incrementUsage('distance');
    _initCamera();
  }

  @override
  void onClose() {
    heightController.dispose();
    _disposeCamera();
    super.onClose();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        cameraError.value = Lang.distanceCameraOptional;
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
      cameraError.value = Lang.distanceCameraUnavailable;
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

  void bindSceneHeight(double height) {
    _sceneHeight = height;
    if (topLineY.value > 0) return;
    final top = height * 0.28;
    final bottom = height * 0.62;
    Future.microtask(() {
      if (isClosed) return;
      if (topLineY.value > 0) return;
      topLineY.value = top;
      bottomLineY.value = bottom;
      _recalc();
    });
  }

  void onTopDrag(double delta) {
    topLineY.value = (topLineY.value + delta).clamp(80.0, bottomLineY.value - 60);
    _recalc();
  }

  void onBottomDrag(double delta) {
    bottomLineY.value = (bottomLineY.value + delta).clamp(topLineY.value + 60, _sceneHeight - 80);
    _recalc();
  }

  void onHeightChanged(String value) {
    final parsed = double.tryParse(value);
    if (parsed == null || parsed <= 0) return;
    objectHeightM.value = parsed;
    _recalc();
  }

  void _recalc() {
    final span = (bottomLineY.value - topLineY.value).abs();
    if (span < 20 || objectHeightM.value <= 0 || _sceneHeight <= 0) {
      distanceM.value = 0;
      return;
    }
    final focal = CameraScale.focalLengthPx(_sceneHeight);
    distanceM.value = objectHeightM.value * focal / span;
  }

  void reset() {
    topLineY.value = _sceneHeight * 0.28;
    bottomLineY.value = _sceneHeight * 0.62;
    objectHeightM.value = 1.0;
    heightController.text = '1.0';
    _recalc();
  }

  String get distanceText => distanceM.value > 0 ? distanceM.value.toStringAsFixed(2) : '--';

  String get hintText {
    if (objectHeightM.value <= 0) return Lang.distanceTip;
    if (distanceM.value > 0) {
      return '${Lang.distanceToObject} $distanceText ${Lang.distanceHeightUnit}';
    }
    if (!cameraReady.value && cameraError.value.isNotEmpty) {
      return '${Lang.distanceDragLines} · ${cameraError.value}';
    }
    return Lang.distanceDragLines;
  }

  Future<void> save() async {
    if (distanceM.value <= 0) return;
    final note = await showNoteInputSheet() ?? '';
    await _data.saveMeasurement(
      MeasurementRecordEntity(
        toolType: 'distance',
        value: double.parse(distanceM.value.toStringAsFixed(2)),
        unit: 'm',
        note: note,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    AppToast.success(Lang.distanceSaved);
    reset();
  }
}
