import 'package:get/get.dart';

class RulerInitRouter {
  static Future<void> goMain() async {
    Get.offNamed('/main');
  }

  static Future<void> goStats() async {
    Get.offNamed('/stats_dash');
  }
}
