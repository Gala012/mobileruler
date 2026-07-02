import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/secondary_page_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';

class AboutView extends GetView {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      appBar: SecondaryAppBar(title: Lang.aboutTitle),
      body: ListView(
        padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
        children: [
          const AboutBrandCard(),
          SizedBox(height: ScreenUtil().setHeight(16)),
          const HelpSectionCard(
            icon: Icons.apps_rounded,
            title: Lang.aboutFeatures,
            body: Lang.aboutFeaturesBody,
            iconColor: AppColors.cta,
          ),
          const HelpSectionCard(
            icon: Icons.shield_outlined,
            title: Lang.aboutPrivacy,
            body: Lang.aboutPrivacyBody,
          ),
          SizedBox(height: ScreenUtil().setHeight(8)),
          Text(
            Lang.aboutFooter,
            textAlign: TextAlign.center,
            style: AppTypography.label,
          ),
        ],
      ),
    );
  }
}
