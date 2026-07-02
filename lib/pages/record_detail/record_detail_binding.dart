import 'package:get/get.dart';
import 'package:mobilem/pages/record_detail/record_detail_logic.dart';

class RecordDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(RecordDetailLogic.new);
  }
}
