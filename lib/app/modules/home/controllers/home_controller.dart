import 'dart:convert';
import 'dart:typed_data';

import 'package:emotion_app/app/data/models/one_emotion_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/users_model.dart';
import '../../../mahas/services/helper.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  RxList<Users> users = <Users>[].obs;
  RxList<OneemotionModel> listEmotion = <OneemotionModel>[].obs;
  RxBool loadData = false.obs;
  Uint8List? getImage;

  // @override
  // void onInit() async {
  //   // await getUser();
  //   await getOneEmotion();
  //   super.onInit();
  // }

  @override
  void onReady() async {
    loadData.value = false;
    await getUser();
    await getOneEmotion();
    super.onReady();
  }

  Future<void> onRefresh() async {
    loadData.value = false;
    await getUser();
    await getOneEmotion();
  }

  Future goToSettingsList() async {
    Get.toNamed(Routes.SETTINGS_LIST);
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
      getImage = stringToImage(users.first.profilePic!);
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

  Future getOneEmotion() async {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    await EasyLoading.show();

    try {
      var response = await client.from("one_emotion").select().match(
        {
          "user_uid": client.auth.currentUser!.id,
        },
      );
      List<OneemotionModel> datas = OneemotionModel.fromDynamicList(response);
      listEmotion.assignAll(datas);
      loadData.toggle();
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

  void toEmotionDetail(String emotion, String id) {
    Get.toNamed(Routes.EMOTION_DETAIL_SETUP,
        parameters: {"emotion": emotion, "id": id});
  }

  Uint8List stringToImage(String imageValue) {
    List<int> byte = jsonDecode(imageValue).cast<int>();
    Uint8List ul = Uint8List.fromList(byte);
    return ul;
  }
}
