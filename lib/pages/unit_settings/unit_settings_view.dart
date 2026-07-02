import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/secondary_page_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/unit_settings/unit_settings_logic.dart';
import 'package:mobilem/utils/app_colors.dart';

class UnitSettingsView extends GetView<UnitSettingsLogic> {
  const UnitSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      appBar: SecondaryAppBar(title: Lang.unitSettingsTitle),
      body: Obx(() {
        return ListView(
          padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
          children: [
            OptionGroupCard(
              title: Lang.unitLength,
              options: [(Lang.unitCm, 'cm'), (Lang.unitInch, 'inch')],
              selected: controller.lengthUnit.value,
              onSelect: controller.setLengthUnit,
            ),
            SizedBox(height: ScreenUtil().setHeight(24)),
            OptionGroupCard(
              title: Lang.unitArea,
              options: [(Lang.unitCm2, 'cm2'), (Lang.unitInch2, 'inch2')],
              selected: controller.areaUnit.value,
              onSelect: controller.setAreaUnit,
            ),
          ],
        );
      }),
    );
  }
}
