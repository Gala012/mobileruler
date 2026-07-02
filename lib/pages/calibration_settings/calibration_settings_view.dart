import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobilem/components/common_widgets.dart';
import 'package:mobilem/components/secondary_page_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/calibration_settings/calibration_settings_logic.dart';
import 'package:mobilem/services/app_data_service.dart';
import 'package:mobilem/utils/app_colors.dart';

class CalibrationSettingsView extends GetView<CalibrationSettingsLogic> {
  const CalibrationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.find<AppDataService>();

    return Scaffold(
      backgroundColor: AppColors.pageBg,
      appBar: SecondaryAppBar(title: Lang.calibrationSettingsTitle),
      body: Obx(() {
        final settings = data.settings.value;
        final manual = settings.isManuallyCalibrated;
        final effective = data.pixelsPerMm();
        final rows = <(String, String)>[
          (Lang.calibrationSource, manual ? Lang.calibrationSourceManual : Lang.calibrationSourceAuto),
          (Lang.calibrationFactor, effective.toStringAsFixed(4)),
        ];
        if (manual) {
          rows.add((Lang.calibrationRefType, controller.refLabel(settings.calibrationRefType)));
          rows.add((
            Lang.calibrationTime,
            settings.calibratedAt == null
                ? '-'
                : DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(settings.calibratedAt!)),
          ));
        }

        return ListView(
          padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
          children: [
            InfoRowsCard(rows: rows),
            SizedBox(height: ScreenUtil().setHeight(20)),
            PrimaryButton(
              label: Lang.calibrationRecalibrate,
              icon: Icons.tune_rounded,
              height: 44,
              onPressed: controller.goRecalibrate,
            ),
            if (manual) ...[
              SizedBox(height: ScreenUtil().setHeight(10)),
              SecondaryButton(
                label: Lang.calibrationReset,
                icon: Icons.restart_alt_rounded,
                height: 44,
                onPressed: controller.resetCalibration,
              ),
            ],
          ],
        );
      }),
    );
  }
}
