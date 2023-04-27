import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../mahas/mahas_colors.dart';
import '../../../routes/app_pages.dart';

class SplashScreenController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  // RxString route = "".obs;
  final Color color = MahasColors.primary;

  @override
  void onInit() async {
    await checkUser();
    super.onInit();
  }

  Future checkUser() async {
    if (client.auth.currentSession != null) {
      // await HomeController().getUser();
      // print(HomeController().users.first.email);
      Get.offAllNamed(Routes.HOME);
      // route.value = Routes.HOME;
      // return route.value;
    } else {
      // route.value = Routes.SIGN_IN;
      Get.offAllNamed(Routes.SIGN_IN);
      // return route.value;
    }
  }
}
