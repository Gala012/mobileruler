import 'package:get/get.dart';
import 'package:mobilem/pages/distance/distance_logic.dart';

class DistanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(DistanceLogic.new);
  }
}
