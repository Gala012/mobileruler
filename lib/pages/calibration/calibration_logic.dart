import 'package:get/get.dart';
import 'package:mobilem/components/app_feedback.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/services/app_data_service.dart';

class CalibrationRef {
  const CalibrationRef({required this.key, required this.label, required this.mm, required this.mmLabel});

  final String key;
  final String label;
  final double mm;
  final String mmLabel;
}

class CalibrationLogic extends GetxController {
  static const minSpan = 80.0;
  static const maxSpan = 400.0;
  static const edgeInset = 20.0;

  final step = 0.obs;
  final selectedRef = Rxn<CalibrationRef>();
  final markerSpan = 200.0.obs;
  final markerCenterX = 0.0.obs;

  final refs = const [
    CalibrationRef(key: 'bank_card', label: Lang.calibrationRefBankCard, mm: 85.6, mmLabel: Lang.calibrationRefBankCardMm),
    CalibrationRef(key: 'id_card', label: Lang.calibrationRefIdCard, mm: 85.6, mmLabel: Lang.calibrationRefIdCardMm),
    CalibrationRef(key: 'coin', label: Lang.calibrationRefCoin, mm: 25.0, mmLabel: Lang.calibrationRefCoinMm),
  ];

  AppDataService get _data => Get.find<AppDataService>();

  double _sceneWidth = 0;
  bool _needsLayout = true;

  double get leftX => markerCenterX.value - markerSpan.value / 2;

  double get rightX => markerCenterX.value + markerSpan.value / 2;

  void selectRef(CalibrationRef ref) {
    selectedRef.value = ref;
    step.value = 1;
    _needsLayout = true;
  }

  void bindSceneWidth(double width) {
    if (width <= 0) return;
    _sceneWidth = width;
    if (!_needsLayout) return;
    final span = markerSpan.value.clamp(minSpan, maxSpan).clamp(minSpan, width - edgeInset * 2);
    markerSpan.value = span;
    markerCenterX.value = width / 2;
    _needsLayout = false;
  }

  void nextStep() {
    if (step.value < 2) step.value++;
  }

  void prevStep() {
    if (step.value > 0) step.value--;
  }

  void onLeftDrag(double delta) {
    if (_sceneWidth <= 0) return;
    final right = rightX;
    final newLeft = (leftX + delta).clamp(edgeInset, right - minSpan);
    markerSpan.value = right - newLeft;
    markerCenterX.value = (newLeft + right) / 2;
  }

  void onRightDrag(double delta) {
    if (_sceneWidth <= 0) return;
    final left = leftX;
    final newRight = (rightX + delta).clamp(left + minSpan, _sceneWidth - edgeInset);
    markerSpan.value = newRight - left;
    markerCenterX.value = (left + newRight) / 2;
  }

  void onLineDrag(double delta) {
    if (_sceneWidth <= 0) return;
    final half = markerSpan.value / 2;
    final minCenter = half + edgeInset;
    final maxCenter = _sceneWidth - half - edgeInset;
    if (minCenter > maxCenter) return;
    markerCenterX.value = (markerCenterX.value + delta).clamp(minCenter, maxCenter);
  }

  Future<void> confirm() async {
    final ref = selectedRef.value;
    if (ref == null) return;
    final factor = markerSpan.value / ref.mm;
    await _data.saveCalibration(factor: factor, refType: ref.key);
    Get.back();
    AppToast.success(Lang.calibrationSaved, title: Lang.calibrationSuccess);
  }
}
