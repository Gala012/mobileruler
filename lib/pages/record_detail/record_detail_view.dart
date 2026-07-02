import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobilem/components/bottom_sheet_helper.dart';
import 'package:mobilem/components/secondary_page_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/record_detail/record_detail_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/stats_tool_meta.dart';

class RecordDetailView extends GetView<RecordDetailLogic> {
  const RecordDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      appBar: SecondaryAppBar(
        title: Lang.recordDetail,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await showConfirmSheet(message: Lang.confirmDelete);
              if (result == true) await controller.deleteRecord();
            },
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
      body: Obx(() {
        final record = controller.record.value;
        if (record == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.cta));
        }

        final time = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(record.createdAt));
        final rows = <(String, String)>[
          (Lang.recordToolType, Lang.toolTypeLabel(record.toolType)),
          (Lang.recordTime, time),
        ];
        if (record.note.isNotEmpty) {
          rows.add((Lang.note, record.note));
        }

        return ListView(
          padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
          children: [
            DetailHeroCard(
              icon: StatsToolMeta.iconFor(record.toolType),
              iconColor: StatsToolMeta.colorFor(record.toolType),
              toolName: Lang.toolTypeLabel(record.toolType),
              value: record.value.toStringAsFixed(2),
              unit: record.unit,
            ),
            SizedBox(height: ScreenUtil().setHeight(16)),
            InfoRowsCard(rows: rows),
          ],
        );
      }),
    );
  }
}
