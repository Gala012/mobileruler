import 'package:get/get.dart';
import 'package:mobilem/db_mobilem/db_mobilem_entity.dart';
import 'package:mobilem/db_mobilem/db_mobilem_helper.dart';

class RecordDetailLogic extends GetxController {
  final record = Rxn<MeasurementRecordEntity>();
  late final int recordId;

  @override
  void onInit() {
    super.onInit();
    recordId = Get.arguments as int;
    _load();
  }

  Future<void> _load() async {
    record.value = await DbMobilemHelper.instance.getRecordById(recordId);
  }

  Future<void> deleteRecord() async {
    await DbMobilemHelper.instance.deleteRecord(recordId);
    Get.back(result: true);
  }
}
