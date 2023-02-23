import 'package:emotion_app/app/modules/home/controllers/home_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../mahas/components/inputs/input_text_component.dart';
import '../../../mahas/services/helper.dart';
import '../../../routes/app_pages.dart';

class SignInController extends GetxController {
  RxString version = "1.0.0".obs;
  final InputTextController emailCon =
      InputTextController(type: InputTextType.email);
  final InputTextController passwordCon =
      InputTextController(type: InputTextType.password);

  SupabaseClient client = Supabase.instance.client;
  late List<Map<String, dynamic>> response;

  final HomeController homeC = Get.find();

  Future signInOnTap() async {
    if (!emailCon.isValid) return false;
    if (!passwordCon.isValid) return false;

    if (EasyLoading.isShow) return;
    await EasyLoading.show();

    try {
      await client.auth.signInWithPassword(
          password: passwordCon.value, email: emailCon.value);
    } on PostgrestException catch (e) {
      Helper.dialogWarning(
        e.toString(),
      );
    } catch (e) {
      Helper.dialogWarning(
        e.toString(),
      );
    }

    EasyLoading.dismiss();
    if (client.auth.currentUser!.emailConfirmedAt != null) {
      // await homeC.getUser();
      Get.offNamed(Routes.HOME);
    } else {
      Helper.dialogWarning(
          "We have sent you email verification, please verify your email first!");
    }
  }

  void toRegister() {
    Get.toNamed(Routes.SIGN_UP);
  }
}
