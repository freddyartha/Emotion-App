import 'dart:convert';
import 'dart:typed_data';

import 'package:emotion_app/app/data/models/one_emotion_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../mahas/services/helper.dart';
import '../../../routes/app_pages.dart';

class OneEmotionListController extends GetxController {
  SupabaseClient client = Supabase.instance.client;

  RxBool editable = true.obs;
  RxList emotion = List<OneemotionModel>.empty().obs;

  final box = GetStorage();

  @override
  void onInit() async {
    await getOneEmotionList();
    super.onInit();
  }

  void popupMenuButtonOnSelected(String v) async {
    if (v == 'add') {
      Get.toNamed(Routes.ONE_EMOTION_SETUP, parameters: {"id": ""})
          ?.then((value) async => await getOneEmotionList());
    }
  }

  Future<void> onRefresh() async {
    await getOneEmotionList();
  }

  void toOneEmotionDetailSetup(int id) {
    Get.toNamed(Routes.ONE_EMOTION_SETUP, parameters: {"id": id.toString()})
        ?.then((value) async => await getOneEmotionList());
  }

  Future getOneEmotionList() async {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    await EasyLoading.show();
    try {
      var response = await client
          .from("one_emotion")
          .select()
          .eq(
            "user_uid",
            client.auth.currentUser!.id,
          )
          .order("created_at");
      List<OneemotionModel> datas = OneemotionModel.fromDynamicList(response);
      emotion.assignAll(datas);
      await box.remove('rememberEmotion');
      var emotionasMap =
          emotion.map((dataGet) => dataGet.oneEmotiontoMap()).toList();
      String jsonString = jsonEncode(emotionasMap);
      await box.write('rememberEmotion', jsonString);
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
  }

  Uint8List convertImage(String imageValue) {
    List<int> byte = jsonDecode(imageValue).cast<int>();
    Uint8List ul = Uint8List.fromList(byte);
    return ul;
  }
}
