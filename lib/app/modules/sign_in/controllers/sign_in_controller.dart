import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../mahas/components/inputs/input_text_component.dart';
import '../../../mahas/services/helper.dart';
import '../../../routes/app_pages.dart';

class SignInController extends GetxController {
  RxString version = "".obs;
  final RxBool isRemember = false.obs;

  final InputTextController emailCon =
      InputTextController(type: InputTextType.email);
  final InputTextController passwordCon =
      InputTextController(type: InputTextType.password);

  SupabaseClient client = Supabase.instance.client;
  late List<Map<String, dynamic>> response;
  final box = GetStorage();

  @override
  void onInit() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
    var read = await box.read("rememberme");
    if (read != null) {
      emailCon.value = read["email"];
      passwordCon.value = read["pass"];
      isRemember.value = true;
    }
    super.onInit();
  }

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
      if (box.read('rememberme') != null) {
        box.remove('rememberme');
      }
      if (isRemember.isTrue) {
        box.write(
            'rememberme', {'email': emailCon.value, 'pass': passwordCon.value});
      }
      Get.offAllNamed(Routes.HOME);
    } else {
      Helper.dialogWarning(
          "We have sent you email verification, please verify your email first!");
    }
  }

  void toRegister() {
    Get.toNamed(Routes.SIGN_UP);
  }
}
