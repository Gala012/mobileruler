import 'package:get/get.dart';
import 'package:mobilem/components/app_feedback.dart';
import 'package:mobilem/components/bottom_sheet_helper.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/services/app_data_service.dart';

class CalibrationSettingsLogic extends GetxController {
  AppDataService get _data => Get.find<AppDataService>();

  void goRecalibrate() => Get.toNamed('/calibration');

  Future<void> resetCalibration() async {
    final result = await showConfirmSheet(message: Lang.calibrationResetConfirm);
    if (result == true) {
      await _data.resetCalibration();
      AppToast.info(Lang.reset);
    }
  }

  String refLabel(String key) {
    switch (key) {
      case 'bank_card':
        return Lang.calibrationRefBankCard;
      case 'id_card':
        return Lang.calibrationRefIdCard;
      case 'coin':
        return Lang.calibrationRefCoin;
      default:
        return key;
    }
  }
}
