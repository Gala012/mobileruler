import 'package:get/get.dart';
import 'package:mobilem/pages/stats/stats_logic.dart';

class StatsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(StatsLogic.new);
  }
}
