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

class CompassLogic extends GetxController {
  final heading = 0.0.obs;
  final direction = 'N'.obs;

  StreamSubscription<MagnetometerEvent>? _sub;

  static const _dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];

  @override
  void onInit() {
    super.onInit();
    DbMobilemHelper.instance.incrementUsage('compass');
    _sub = magnetometerEventStream().listen(_onMag);
  }

  void _onMag(MagnetometerEvent event) {
    var angle = math.atan2(event.y, event.x) * 180 / math.pi;
    angle = (angle + 360) % 360;
    heading.value = angle;
    final index = ((angle + 22.5) % 360 / 45).floor();
    direction.value = _dirs[index];
  }

  Future<void> save() async {
    final note = await showNoteInputSheet() ?? '';
    await Get.find<AppDataService>().saveMeasurement(
      MeasurementRecordEntity(
        toolType: 'compass',
        value: double.parse(heading.value.toStringAsFixed(1)),
        unit: '°',
        note: note,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    AppToast.success(Lang.compassSaved);
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
