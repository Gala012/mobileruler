import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class RulerInitPayload {
  static Future<Map<String, dynamic>> build() async {
    final DeviceInfoPlugin info = DeviceInfoPlugin();
    PackageInfo package = await PackageInfo.fromPlatform();
    final String tz = await FlutterTimezone.getLocalTimezone();
    var locale = Platform.localeName;

    var packageName = package.packageName;
    var version = package.version;
    var build = package.buildNumber;
    var appName = package.appName;

    var model = "";
    var vendor = "";
    var brand = "";
    var extraA = "";
    var extraB = "";
    var extraC = "";
    var extraD = "";
    var extraE = "";
    var extraF = "";

    var platform = "";
    var isRealDevice = false;

    if (GetPlatform.isAndroid) {
      platform = "android";
      var androidInfo = await info.androidInfo;
      brand = androidInfo.brand;
      model = androidInfo.model;
      vendor = androidInfo.id;
      isRealDevice = androidInfo.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      platform = "ios";
      var iosInfo = await info.iosInfo;
      brand = iosInfo.name;
      model = iosInfo.model;
      vendor = iosInfo.identifierForVendor ?? "";
      isRealDevice = iosInfo.isPhysicalDevice;
    }
    return {
      'vpikd': extraF,
      'rIRY': appName,
      'XZnQai': build,
      'muHjWbw': packageName,
      'jhyalwb': extraC,
      'jRJsWTKl': model,
      'PqwLOIYh': tz,
      'EwtRyHM': brand,
      'kbhqVHKd': vendor,
      'njxqaz': locale,
      'segRb': platform,
      'LWcAMqBH': isRealDevice,
      'jolmauq': extraA,
      'pyuamwsx': extraB,
      'xlvbeat': extraD,
      'NemXzBLE': version,
      'nixjlwu': extraE,
    };
  }
}
