import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/secondary_page_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';
import 'package:mobilem/utils/tool_icons.dart';

class HelpView extends GetView {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      appBar: SecondaryAppBar(title: Lang.helpTitle),
      body: ListView(
        padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
        children: [
          Text(Lang.helpSectionTipsBody, style: AppTypography.caption),
          SizedBox(height: ScreenUtil().setHeight(16)),
          const HelpSectionCard(
            icon: ToolIcons.ruler,
            title: Lang.helpSectionRuler,
            body: Lang.helpSectionRulerBody,
            iconColor: AppColors.cta,
          ),
          const HelpSectionCard(
            icon: ToolIcons.protractor,
            title: Lang.helpSectionProtractor,
            body: Lang.helpSectionProtractorBody,
          ),
          const HelpSectionCard(
            icon: ToolIcons.distance,
            title: Lang.helpSectionDistance,
            body: Lang.helpSectionDistanceBody,
          ),
          const HelpSectionCard(
            icon: ToolIcons.area,
            title: Lang.helpSectionArea,
            body: Lang.helpSectionAreaBody,
          ),
          const HelpSectionCard(
            icon: ToolIcons.level,
            title: Lang.helpSectionSensor,
            body: Lang.helpSectionSensorBody,
          ),
          const HelpSectionCard(
            icon: Icons.lightbulb_outline_rounded,
            title: Lang.helpSectionTips,
            body: Lang.helpSectionTipsBody,
            iconColor: AppColors.cta,
          ),
        ],
      ),
    );
  }
}
