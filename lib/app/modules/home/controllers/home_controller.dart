import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/emotion_model.dart';
import '../../../data/models/users_model.dart';
import '../../../mahas/services/helper.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  RxList<Users> users = <Users>[].obs;
  RxList<EmotionModel> listEmotion = <EmotionModel>[].obs;
  final List<EmotionModel> addEmotion = [
    EmotionModel("assets/images/blessed.png", "Blessed"),
    EmotionModel("assets/images/cool.png", "Cool"),
    EmotionModel("assets/images/happy.png", "Happy"),
    EmotionModel("assets/images/ill.png", "Sick"),
    EmotionModel("assets/images/in_love.png", "In Love"),
    EmotionModel("assets/images/mad.png", "Mad"),
    EmotionModel("assets/images/overwhelmed.png", "Proud"),
    EmotionModel("assets/images/playful.png", "Playful"),
    EmotionModel("assets/images/sad.png", "Sad"),
    EmotionModel("assets/images/shock.png", "Shock"),
  ];

  @override
  void onInit() async {
    await getEmotion();
    super.onInit();
  }

  @override
  void onReady() async {
    await getUser();
    super.onReady();
  }

  Future<void> onRefresh() async {
    await getUser();
  }

  Future getEmotion() async {
    listEmotion.clear();
    listEmotion.assignAll(addEmotion);
  }

  Future signOut() async {
    if (EasyLoading.isShow) return;
    await EasyLoading.show();
    try {
      await client.auth.signOut();
    } on PostgrestException catch (e) {
      EasyLoading.dismiss();
      Helper.dialogWarning(
        e.toString(),
      );
    } catch (e) {
      Helper.dialogWarning(
        e.toString(),
      );
    }
    Get.offAllNamed(Routes.SIGN_IN);
    EasyLoading.dismiss();
  }

  Future getUser() async {
    if (EasyLoading.isShow) return false;
    await EasyLoading.show();

    try {
      var response = await client.from("users").select().match(
        {
          "user_uid": client.auth.currentUser!.id,
        },
      );
      List<Users> datas = Users.fromDynamicList(response);
      users.assignAll(datas);
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
    return users;
  }

  void toEmotionDetail(String emotion) {
    Get.toNamed(Routes.EMOTION_DETAIL, parameters: {"emotion": emotion});
  }
}
