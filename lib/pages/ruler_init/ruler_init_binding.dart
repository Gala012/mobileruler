import 'package:get/get.dart';

import 'ruler_init_logic.dart';

class RulerInitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      RulerInitLogic(),
      permanent: true,
    );
  }
}
