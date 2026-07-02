import 'package:get/get.dart';
import 'package:mobilem/pages/unit_converter/unit_converter_logic.dart';

class UnitConverterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(UnitConverterLogic.new);
  }
}
