import 'dart:async';
import 'package:mobilem/components/app_feedback.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:mobilem/components/bottom_sheet_helper.dart';
import 'package:mobilem/db_mobilem/db_mobilem_entity.dart';
import 'package:mobilem/db_mobilem/db_mobilem_helper.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/services/app_data_service.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';

class LevelLogic extends GetxController {
  final tiltX = 0.0.obs;
  final tiltY = 0.0.obs;
  final isFlat = false.obs;
  final zeroX = 0.0.obs;
  final zeroY = 0.0.obs;

  StreamSubscription<AccelerometerEvent>? _sub;
  var _lastVibrate = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void onInit() {
    super.onInit();
    DbMobilemHelper.instance.incrementUsage('level');
    _sub = accelerometerEventStream().listen(_onAccel);
  }

  void _onAccel(AccelerometerEvent event) {
    final x = math.atan2(event.x, event.z) * 180 / math.pi - zeroX.value;
    final y = math.atan2(event.y, event.z) * 180 / math.pi - zeroY.value;
    tiltX.value = x;
    tiltY.value = y;
    final flat = x.abs() < 0.5 && y.abs() < 0.5;
    if (flat && !isFlat.value) {
      final now = DateTime.now();
      if (now.difference(_lastVibrate).inMilliseconds > 2000) {
        _lastVibrate = now;
        Vibration.hasVibrator().then((has) {
          if (has == true) Vibration.vibrate(duration: 50);
        });
      }
    }
    isFlat.value = flat;
  }

  void setZero() {
    zeroX.value += tiltX.value;
    zeroY.value += tiltY.value;
  }

  double get totalTilt =>
      math.sqrt(tiltX.value * tiltX.value + tiltY.value * tiltY.value);

  Future<void> save() async {
    final note = await showNoteInputSheet() ?? '';
    await Get.find<AppDataService>().saveMeasurement(
      MeasurementRecordEntity(
        toolType: 'level',
        value: double.parse(totalTilt.toStringAsFixed(2)),
        unit: '°',
        note: note,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    AppToast.success(Lang.levelSaved);
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
