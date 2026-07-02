import 'package:get/get.dart';
import 'package:mobilem/services/app_data_service.dart';

class GuideLogic extends GetxController {
  var _finishing = false;

  bool get isFinishing => _finishing;

  Future<void> markFinished() async {
    if (_finishing) return;
    _finishing = true;
    await Get.find<AppDataService>().markGuideSeen();
  }
}
