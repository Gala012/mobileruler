import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/app_root/app_root_binding.dart';
import 'package:mobilem/pages/app_root/app_root_view.dart';
import 'package:mobilem/pages/about/about_binding.dart';
import 'package:mobilem/pages/about/about_view.dart';
import 'package:mobilem/pages/area/area_binding.dart';
import 'package:mobilem/pages/area/area_view.dart';
import 'package:mobilem/pages/outdoor_area/outdoor_area_binding.dart';
import 'package:mobilem/pages/outdoor_area/outdoor_area_view.dart';
import 'package:mobilem/pages/calibration/calibration_binding.dart';
import 'package:mobilem/pages/calibration/calibration_view.dart';
import 'package:mobilem/pages/calibration_settings/calibration_settings_binding.dart';
import 'package:mobilem/pages/calibration_settings/calibration_settings_view.dart';
import 'package:mobilem/pages/compass/compass_binding.dart';
import 'package:mobilem/pages/compass/compass_view.dart';
import 'package:mobilem/pages/distance/distance_binding.dart';
import 'package:mobilem/pages/distance/distance_view.dart';
import 'package:mobilem/pages/flashlight/flashlight_binding.dart';
import 'package:mobilem/pages/flashlight/flashlight_view.dart';
import 'package:mobilem/pages/help/help_binding.dart';
import 'package:mobilem/pages/help/help_view.dart';
import 'package:mobilem/pages/level/level_binding.dart';
import 'package:mobilem/pages/level/level_view.dart';
import 'package:mobilem/pages/protractor/protractor_binding.dart';
import 'package:mobilem/pages/protractor/protractor_view.dart';
import 'package:mobilem/pages/record_detail/record_detail_binding.dart';
import 'package:mobilem/pages/record_detail/record_detail_view.dart';
import 'package:mobilem/pages/ruler/ruler_binding.dart';
import 'package:mobilem/pages/ruler/ruler_view.dart';
import 'package:mobilem/pages/divider_ruler/divider_ruler_binding.dart';
import 'package:mobilem/pages/divider_ruler/divider_ruler_view.dart';
import 'package:mobilem/pages/ruler_init/ruler_init_binding.dart';
import 'package:mobilem/pages/ruler_init/ruler_init_view.dart';
import 'package:mobilem/pages/scale_ruler/scale_ruler_binding.dart';
import 'package:mobilem/pages/scale_ruler/scale_ruler_view.dart';
import 'package:mobilem/pages/stats/stats_dash.dart';
import 'package:mobilem/pages/tape_ruler/tape_ruler_binding.dart';
import 'package:mobilem/pages/tape_ruler/tape_ruler_view.dart';
import 'package:mobilem/pages/unit_converter/unit_converter_binding.dart';
import 'package:mobilem/pages/unit_converter/unit_converter_view.dart';
import 'package:mobilem/pages/stats/stats_binding.dart';
import 'package:mobilem/pages/stats/stats_view.dart';
import 'package:mobilem/pages/unit_settings/unit_settings_binding.dart';
import 'package:mobilem/pages/unit_settings/unit_settings_view.dart';
import 'package:mobilem/services/app_data_service.dart';
import 'package:mobilem/utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await Get.putAsync<AppDataService>(() => AppDataService().init(), permanent: true);
  runApp(const MobilemApp());
}

class MobilemApp extends StatelessWidget {
  const MobilemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, __) {
        return GetMaterialApp(
          title: Lang.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          initialRoute: '/',
          getPages: Ruler,
        );
      },
    );
  }
}
List<GetPage<dynamic>> Ruler = [
  GetPage(name: '/', page: () => const RulerInitView(), binding: RulerInitBinding()),
  GetPage(name: '/main', page: () => const AppRootView(), binding: AppRootBinding()),
  GetPage(name: '/ruler', page: () => const RulerView(), binding: RulerBinding()),
  GetPage(name: '/calibration', page: () => const CalibrationView(), binding: CalibrationBinding()),
  GetPage(name: '/protractor', page: () => const ProtractorView(), binding: ProtractorBinding()),
  GetPage(name: '/distance', page: () => const DistanceView(), binding: DistanceBinding()),
  GetPage(name: '/area', page: () => const AreaView(), binding: AreaBinding()),
  GetPage(name: '/outdoor_area', page: () => const OutdoorAreaView(), binding: OutdoorAreaBinding()),
  GetPage(name: '/level', page: () => const LevelView(), binding: LevelBinding()),
  GetPage(name: '/flashlight', page: () => const FlashlightView(), binding: FlashlightBinding()),
  GetPage(name: '/compass', page: () => const CompassView(), binding: CompassBinding()),
  GetPage(name: '/unit_converter', page: () => const UnitConverterView(), binding: UnitConverterBinding()),
  GetPage(name: '/tape_ruler', page: () => const TapeRulerView(), binding: TapeRulerBinding()),
  GetPage(name: '/scale_ruler', page: () => const ScaleRulerView(), binding: ScaleRulerBinding()),
  GetPage(name: '/divider_ruler', page: () => const DividerRulerView(), binding: DividerRulerBinding()),
  GetPage(name: '/record_detail', page: () => const RecordDetailView(), binding: RecordDetailBinding()),
  GetPage(name: '/stats', page: () => const StatsView(), binding: StatsBinding()),
  GetPage(name: '/stats_dash', page: () => const StatsDash()),
  GetPage(
    name: '/calibration_settings',
    page: () => const CalibrationSettingsView(),
    binding: CalibrationSettingsBinding(),
  ),
  GetPage(name: '/unit_settings', page: () => const UnitSettingsView(), binding: UnitSettingsBinding()),
  GetPage(name: '/help', page: () => const HelpView(), binding: HelpBinding()),
  GetPage(name: '/about', page: () => const AboutView(), binding: AboutBinding()),
];