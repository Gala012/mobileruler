import 'package:get/get.dart';
import 'package:mobilem/components/app_feedback.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/services/app_data_service.dart';

class UnitSettingsLogic extends GetxController {
  final lengthUnit = 'cm'.obs;
  final areaUnit = 'cm2'.obs;

  AppDataService get _data => Get.find<AppDataService>();

  @override
  void onInit() {
    super.onInit();
    final s = _data.settings.value;
    lengthUnit.value = s.defaultLengthUnit;
    areaUnit.value = s.defaultAreaUnit;
  }

  Future<void> setLengthUnit(String unit) async {
    lengthUnit.value = unit;
    await _save();
  }

  Future<void> setAreaUnit(String unit) async {
    areaUnit.value = unit;
    await _save();
  }

  Future<void> _save() async {
    final updated = _data.settings.value.copyWith(
      defaultLengthUnit: lengthUnit.value,
      defaultAreaUnit: areaUnit.value,
    );
    await _data.updateSettings(updated);
    AppToast.success(Lang.unitSaved);
  }
}
