import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:get/get.dart';

import 'app/mahas/components/mahas_themes.dart';
import 'app/mahas/services/mahas_init.dart';
import 'app/routes/app_pages.dart';

void main() async {
  await MahasInit.init();

  runApp(
    GetMaterialApp(
      title: "EMOTION APP",
      debugShowCheckedModeBanner: false,
      initialRoute: await MahasInit.checkUser(),
      getPages: AppPages.routes,
      theme: MahasThemes.light,
      builder: EasyLoading.init(),
    ),
  );

  FlutterNativeSplash.remove();
}
