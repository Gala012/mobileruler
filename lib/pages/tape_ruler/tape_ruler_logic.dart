import 'package:get/get.dart';
import 'package:mobilem/components/app_feedback.dart';
import 'package:mobilem/components/bottom_sheet_helper.dart';
import 'package:mobilem/db_mobilem/db_mobilem_entity.dart';
import 'package:mobilem/db_mobilem/db_mobilem_helper.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/services/app_data_service.dart';

class TapeRulerLogic extends GetxController {
  static const originInset = 20.0;

  final isPortrait = true.obs;
  final scrollOffset = 0.0.obs;
  final measureFromOrigin = 120.0.obs;
  final segments = <double>[].obs;
  double _canvasExtent = 600;

  AppDataService get _data => Get.find<AppDataService>();

  @override
  void onInit() {
    super.onInit();
    DbMobilemHelper.instance.incrementUsage('tape_ruler');
  }

  double get pixelsPerMm => _data.pixelsPerMm();

  double get measureMm => measureFromOrigin.value / pixelsPerMm;

  double get totalMm => segments.fold(0.0, (sum, v) => sum + v);

  String get totalCmText => (totalMm / 10).toStringAsFixed(2);

  String get currentCmText => (measureMm / 10).toStringAsFixed(2);

  void bindCanvasExtent(double extent) {
    _canvasExtent = extent;
    final max = _maxMeasurePx(extent);
    final current = measureFromOrigin.value;
    if (current <= max) return;
    final target = (extent * 0.35).clamp(40.0, max);
    if (current == target) return;
    Future.microtask(() {
      if (isClosed) return;
      if (measureFromOrigin.value > max) {
        measureFromOrigin.value = target;
      }
    });
  }

  double _maxMeasurePx(double extent) => extent - originInset;

  void toggleOrientation() => isPortrait.value = !isPortrait.value;

  void onRulerScroll(double delta) {
    scrollOffset.value = (scrollOffset.value + delta).clamp(0.0, 8000.0);
  }

  void onMeasureDrag(double delta) {
    final next = measureFromOrigin.value + delta;
    final max = _maxMeasurePx(_canvasExtent);
    measureFromOrigin.value = next.clamp(0.0, max);
  }

  void addSegment() {
    if (measureMm <= 0) return;
    segments.add(double.parse(measureMm.toStringAsFixed(2)));
  }

  void removeSegment(int index) {
    if (index < 0 || index >= segments.length) return;
    segments.removeAt(index);
  }

  void reset() {
    segments.clear();
    measureFromOrigin.value = 120.0;
    scrollOffset.value = 0;
  }

  Future<void> save() async {
    if (totalMm <= 0) return;
    final note = await showNoteInputSheet() ?? '';
    await _data.saveMeasurement(
      MeasurementRecordEntity(
        toolType: 'tape_ruler',
        value: double.parse(totalCmText),
        unit: 'cm',
        note: note,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    AppToast.success(Lang.tapeRulerSaved);
    reset();
  }
}
