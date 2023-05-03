import 'dart:convert';
import 'dart:typed_data';

import 'package:emotion_app/app/data/models/one_emotion_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/emotions_chart_model.dart';
import '../../../data/models/users_model.dart';
import '../../../mahas/components/chart/pie_chart_component.dart';
import '../../../mahas/mahas_colors.dart';
import '../../../mahas/services/helper.dart';
import '../../../routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  SupabaseClient client = Supabase.instance.client;
  RxList<Users> users = <Users>[].obs;
  RxList<OneemotionModel> listEmotion = <OneemotionModel>[].obs;
  RxList<PieChartItem> pieChartCon = <PieChartItem>[].obs;
  RxList<Map<String, dynamic>> emotionCount = <Map<String, dynamic>>[].obs;
  RxList<EmotionsChartModel> emotions = <EmotionsChartModel>[].obs;
  RxBool loadData = false.obs;

  Uint8List? getImage;

  final box = GetStorage();

  void toProfile() {
    Get.toNamed(Routes.PROFILE)?.then((value) async => await getUser());
  }

  void toEmotionDetail(String emotion, String id) {
    Get.toNamed(Routes.EMOTION_DETAIL,
            parameters: {"emotion": emotion, "id": id})
        ?.then((value) async => await getUser());
  }

  Future<void> onRefresh() async {
    loadData.value = false;
    await getUser();
  }

  Future goToSettingsList() async {
    Get.toNamed(Routes.SETTINGS_LIST)?.then((value) async => await getUser());
  }

  void addOneEmotionOnPressed() {
    Get.toNamed(Routes.ONE_EMOTION_SETUP)
        ?.then((value) async => await getUser());
  }

  Future getUser() async {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    await EasyLoading.show();

    var readUser = await box.read("rememberUser");
    if (readUser != null) {
      List<dynamic> decode = json.decode(readUser);
      List<Users> readDatas = Users.fromDynamicList(decode);
      users.assignAll(readDatas);
    } else {
      try {
        var response = await client.from("users").select().match(
          {
            "user_uid": client.auth.currentUser!.id,
          },
        );
        List<Users> datas = Users.fromDynamicList(response);
        users.assignAll(datas);
        var usersasMap = users.map((users) => users.userstoMap()).toList();
        String jsonString = jsonEncode(usersasMap);
        await box.write('rememberUser', jsonString);
      } on PostgrestException catch (e) {
        Helper.dialogWarning(
          e.toString(),
        );
      } catch (e) {
        Helper.dialogWarning(
          e.toString(),
        );
      }
    }
    getImage = users.first.profilePic != null
        ? stringToImage(users.first.profilePic!)
        : null;
    await getOneEmotion();
    await EasyLoading.dismiss();
    return users;
  }

  Future getOneEmotion() async {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    await EasyLoading.show();

    var readEmotion = await box.read("rememberEmotion");
    if (readEmotion != null) {
      List<dynamic> decode = json.decode(readEmotion);
      List<OneemotionModel> readDatas = OneemotionModel.fromDynamicList(decode);
      listEmotion.assignAll(readDatas);
    } else {
      try {
        var response = await client.from("one_emotion").select().match(
          {
            "user_uid": client.auth.currentUser!.id,
          },
        );
        List<OneemotionModel> datas = OneemotionModel.fromDynamicList(response);
        listEmotion.assignAll(datas);
        var emotionasMap = listEmotion
            .map((listEmotion) => listEmotion.oneEmotiontoMap())
            .toList();
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
    }
    await getEmotionsList();
    await EasyLoading.dismiss();
    return listEmotion;
  }

  Future getEmotionsList() async {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    await EasyLoading.show();

    var readEmotionsList = await box.read("rememberEmotionsList");
    if (readEmotionsList != null) {
      List<dynamic> decode = json.decode(readEmotionsList);
      List<EmotionsChartModel> readDatas =
          EmotionsChartModel.fromJsonList(decode);
      emotions.assignAll(readDatas);
    } else {
      try {
        var response = await client
            .from("emotions_list")
            .select('emotion_title, one_emotion(id, description, image))')
            .match(
          {
            "user_uid": client.auth.currentUser!.id,
          },
        ).order("date_created");

        List<EmotionsChartModel> readDatas =
            EmotionsChartModel.fromJsonList(response);
        emotions.assignAll(readDatas);
      } on PostgrestException catch (e) {
        Helper.dialogWarning(
          e.toString(),
        );
      } catch (e) {
        Helper.dialogWarning(
          e.toString(),
        );
      }
    }

    var emotionsListasMap =
        emotions.map((emotions) => emotions.emotionsListtoMap()).toList();
    String jsonString = jsonEncode(emotionsListasMap);
    await box.write('rememberEmotionsList', jsonString);
    pieChartCon.clear();
    emotionCount.clear();
    for (var e in emotions) {
      bool alreadyCounted = false;
      for (int j = 0; j < emotionCount.length; j++) {
        if (emotionCount[j]['id'] == e.oneEmotion!.id) {
          emotionCount[j]['count']++;
          alreadyCounted = true;
          break;
        }
      }
      if (!alreadyCounted) {
        Map<String, dynamic> countMap = {
          'id': e.oneEmotion!.id,
          'count': 1,
          'title': e.oneEmotion!.description,
          'image': e.oneEmotion!.image
        };
        emotionCount.add(countMap);
      }
    }
    int index = 0;
    for (var e in emotionCount) {
      pieChartCon.add(
        PieChartItem(
          color: MahasColors.grafikColors[index].withOpacity(0.7),
          text: e['title'],
          value: double.parse(e['count'].toString()),
        ),
      );
      index++;
      if (index >= MahasColors.grafikColors.length) {
        index = 0;
      }
    }
    loadData.value = true;
    await EasyLoading.dismiss();
  }

  Uint8List stringToImage(String imageValue) {
    List<int> byte = jsonDecode(imageValue).cast<int>();
    Uint8List ul = Uint8List.fromList(byte);
    return ul;
  }
}
