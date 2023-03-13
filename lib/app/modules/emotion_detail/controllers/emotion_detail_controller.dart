import 'dart:convert';

import 'package:emotion_app/app/data/models/emotions_model.dart';
import 'package:emotion_app/app/routes/app_pages.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../mahas/components/inputs/input_text_component.dart';
import '../../../mahas/services/helper.dart';

class EmotionDetailController extends GetxController {
  final InputTextController titleCon = InputTextController();
  final InputTextController descCon =
      InputTextController(type: InputTextType.paragraf);

  RxBool editable = true.obs;
  RxInt itemID = 0.obs;
  RxBool isEdit = false.obs;
  RxList emotions = List<EmotionsModel>.empty().obs;

  late String emotionCon;
  late int emotionId;

  SupabaseClient client = Supabase.instance.client;

  @override
  void onInit() async {
    emotionCon = Get.parameters['emotion']!;
    emotionId = int.parse(Get.parameters['id']!);
    super.onInit();
  }

  void popupMenuButtonOnSelected(String v) async {
    if (v == 'add') {
      Get.toNamed(Routes.EMOTION_DETAIL_SETUP, parameters: {
        "emotion": emotionCon,
        "emotionId": emotionId.toString(),
        "isAdd": "yes"
      });
    }
  }

  Future<void> onRefresh() async {
    await getData(emotionId);
  }

  void toEmotionDetailSetup(int id) {
    Get.toNamed(Routes.EMOTION_DETAIL_SETUP, parameters: {
      "emotion": emotionCon,
      "itemId": id.toString(),
      "emotionId": emotionId.toString()
    });
  }

  Future getData(int emotionId) async {
    if (EasyLoading.isShow) return false;
    await EasyLoading.show();
    try {
      var response = await client
          .from("emotions_list")
          .select(
              '*, one_emotion(description), emotionslist_executant!inner (executant!inner (name))')
          .match(
        {
          "user_uid": client.auth.currentUser!.id,
          "emotion_id": emotionId.toString(),
        },
      ).order("date_created");

      List<EmotionsModel> datas = EmotionsModel.fromJsonList(response);
      emotions(datas);
      emotions.refresh();
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

  Uint8List stringToImage(String imageValue) {
    List<int> byte = jsonDecode(imageValue).cast<int>();
    Uint8List ul = Uint8List.fromList(byte);
    return ul;
  }
}
