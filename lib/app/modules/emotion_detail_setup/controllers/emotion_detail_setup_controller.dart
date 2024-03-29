import 'dart:convert';
import 'dart:io';

import 'package:emotion_app/app/data/models/executant_model.dart' as executant;
import 'package:emotion_app/app/mahas/components/others/empty_component.dart';
import 'package:emotion_app/app/mahas/services/mahas_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/emotions_model.dart';
import '../../../mahas/components/inputs/input_text_component.dart';
import '../../../mahas/mahas_colors.dart';
import '../../../mahas/services/helper.dart';
import '../../home/controllers/home_controller.dart';

class EmotionDetailSetupController extends GetxController {
  final InputTextController titleCon = InputTextController();
  final InputTextController descCon =
      InputTextController(type: InputTextType.paragraf);

  final ImagePicker picker = ImagePicker();
  XFile? image;
  Uint8List? getImage;

  RxList<executant.ExecutantModel> lookUp = <executant.ExecutantModel>[].obs;
  RxList selectedId = [].obs;
  RxList<TileonTapModel> tileOnTap = <TileonTapModel>[].obs;
  RxList<EmotionsModel> emotions = <EmotionsModel>[].obs;
  RxList commonItems = [].obs;
  RxBool editable = true.obs;
  RxBool isEdit = false.obs;
  RxInt qty = 0.obs;
  RxInt itemId = 0.obs;
  RxString isAdd = "".obs;
  RxBool tapImage = false.obs;

  late String emotionCon;
  late int emotionId;

  SupabaseClient client = Supabase.instance.client;

  late HomeController homeC;

  final box = GetStorage();

  @override
  void onInit() async {
    homeC = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
    emotionCon = Get.parameters['emotion']!;
    var e = Get.parameters['itemId'];
    if (e != null) {
      itemId.value = int.parse(e);
    }
    emotionId = int.parse(Get.parameters['emotionId']!);
    isAdd.value = Get.parameters['isAdd'] ?? "";
    if (isAdd.value == "") {
      await getData(itemId.value);
    }

    super.onInit();
  }

  void popupMenuButtonOnSelected(String v) async {
    if (v == 'edit') {
      editable.value = true;
      isEdit.value = true;
    } else if (v == 'delete') {
      Helper.dialogQuestionWithAction(
        message: "Are you sure want to delete \nthis data?",
        textConfirm: "YES",
        textCancel: "NO",
        confirmAction: () async => await deleteOnPressed(itemId.value),
      );
    }
  }

  Future<bool> backOnPressed() async {
    Helper.dialogQuestionWithAction(
      message: "Are you sure want to go back?",
      confirmAction: () async {
        Get.back(closeOverlays: true);
      },
    );
    return true;
  }

  Future<bool> bottomSheetBack() async {
    Helper.dialogQuestionWithAction(
      message: "Are you sure want to go back?",
      confirmAction: () async {
        Get.back(closeOverlays: true);
      },
    );
    return true;
  }

  Future getEmotionExecutor() async {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    EasyLoading.show();
    try {
      var resGet = await client.from('executant').select().match(
        {
          "user_uid": client.auth.currentUser!.id,
        },
      );
      lookUp.refresh();
      lookUp.addAll(executant.ExecutantModel.fromDynamicList(resGet));
      for (var e in lookUp) {
        tileOnTap.add(TileonTapModel(e.id, false));
      }
      if (tileOnTap.isNotEmpty) {
        for (var e in tileOnTap) {
          for (var s in selectedId) {
            if (e.id == s.id) {
              e.data = true;
              qty++;
            }
          }
        }
      }
    } on PostgrestException catch (e) {
      Helper.dialogWarning(e.toString());
    } catch (e) {
      Helper.dialogWarning(e.toString());
    }

    EasyLoading.dismiss();
  }

  void detailOnPressed() async {
    FocusScope.of(Get.context!).unfocus();
    if (qty.value < 0) {
      qty.value = 0;
    }
    if (lookUp.isEmpty) {
      await getEmotionExecutor();
    }

    await showMaterialModalBottomSheet(
      expand: true,
      isDismissible: false,
      context: Get.context!,
      builder: (context) => WillPopScope(
        onWillPop: () => bottomSheetBack(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Emotion Executor"),
            centerTitle: true,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => await getEmotionExecutor(),
                  child: Obx(
                    () => lookUp.isEmpty
                        ? EmptyComponent(
                            onPressed: () async => await getEmotionExecutor(),
                          )
                        : ListView.separated(
                            separatorBuilder: (context, index) =>
                                const Divider(height: 0),
                            controller: ScrollController(),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: lookUp.length,
                            itemBuilder: (context, index) {
                              return GetBuilder<EmotionDetailSetupController>(
                                builder: (c) => ListTile(
                                  onTap: () {
                                    if (tileOnTap[index].data == false) {
                                      tileOnTap[index].data = true;
                                      selectedId.add(lookUp[index]);
                                      qty.value++;
                                    } else {
                                      tileOnTap[index].data = false;
                                      qty.value--;
                                      selectedId.remove(lookUp[index]);
                                    }
                                    update();
                                  },
                                  selectedTileColor:
                                      MahasColors.primary.withOpacity(0.15),
                                  selectedColor: MahasColors.dark,
                                  selected: tileOnTap[index].data!,
                                  horizontalTitleGap: 5,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  leading: lookUp[index].image == null
                                      ? SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: ClipOval(
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              child: const Icon(
                                                FontAwesomeIcons.faceSmile,
                                                color: MahasColors.dark,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: ClipOval(
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              child: Image.memory(
                                                stringToImage(
                                                    lookUp[index].image!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                  title: Text(lookUp[index].name!),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: lookUp.isEmpty ? false : true,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Obx(
                      () => qty.value > 0
                          ? Text("Add (${qty.value})")
                          : qty.value <= 0
                              ? const Text("Add")
                              : const Text("Add"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getData(int itemId) async {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    await EasyLoading.show();
    try {
      var response = await client
          .from("emotions_list")
          .select('*, emotionslist_executant!left (executant!left (*))')
          .match(
        {
          "user_uid": client.auth.currentUser!.id,
          "id": itemId.toString(),
        },
      ).order("date_created");
      await box.remove('rememberEmotionsList');
      await homeC.getEmotionsList("All");
      emotions(EmotionsModel.fromJsonList(response));
      emotions.refresh();
      titleCon.value = emotions.first.emotionTitle!;
      descCon.value = emotions.first.emotionDesc!;
      if (emotions.first.images != null) {
        getImage = stringToImage(emotions.first.images!);
      }
      selectedId.clear();
      if (emotions.first.emotionslistExecutant!.isNotEmpty) {
        for (var e in emotions.first.emotionslistExecutant!) {
          selectedId.add(e.executant);
        }
      }
      editable.value = false;
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

  Future submitOnPressed(bool edit) async {
    if (!titleCon.isValid) return false;
    if (!descCon.isValid) return false;

    if (EasyLoading.isShow) return false;
    await EasyLoading.show();

    if (edit == true) {
      try {
        var res = await client.from("emotions_list").update(
          {
            "emotion_id": emotionId,
            "emotion_title": titleCon.value,
            "emotion_desc": descCon.value,
            "images": image != null ? await convertImage(image!) : getImage,
            "updated_at": DateTime.now().toIso8601String()
          },
        ).match(
          {"id": itemId},
        ).select();
        var dataPost = EmotionsModel.fromJsonList(res);
        if (selectedId.isNotEmpty) {
          await client
              .from('emotionslist_executant')
              .delete()
              .match({'emotionslist_id': dataPost.first.id});
          for (var e in selectedId) {
            await client.from('emotionslist_executant').insert(
              {
                "emotionslist_id": dataPost.first.id,
                "emotionslist_emotion_id": emotionId,
                "executant_id": e.id,
              },
            );
          }
        } else {
          await client
              .from('emotionslist_executant')
              .delete()
              .match({'emotionslist_id': dataPost.first.id});
        }
        await getData(itemId.value);
        editable.value = false;
        isEdit.value = false;
        Helper.dialogSuccess("Updated Successfully!");
      } on PostgrestException catch (e) {
        Helper.dialogWarning(e.toString());
      } catch (e) {
        Helper.dialogWarning(e.toString());
      }
    } else {
      try {
        var res = await client.from('emotions_list').insert(
          {
            "user_uid": client.auth.currentUser!.id,
            "emotion_id": emotionId,
            "emotion_title": titleCon.value,
            "emotion_desc": descCon.value,
            "images": image != null ? await convertImage(image!) : null,
            "date_created": DateTime.now().toIso8601String(),
            "time_created": MahasFormat.timeToString(TimeOfDay.now()),
          },
        ).select();
        var dataPost = EmotionsModel.fromJsonList(res);
        if (selectedId.isNotEmpty) {
          for (var e in selectedId) {
            await client.from('emotionslist_executant').insert(
              {
                "emotionslist_id": dataPost.first.id,
                "emotionslist_emotion_id": emotionId,
                "executant_id": e.id,
              },
            );
          }
        }
        await getData(dataPost.first.id!);
        editable.value = false;
        Helper.dialogSuccess("Created Successfully!");
      } on PostgrestException catch (e) {
        Helper.dialogWarning(e.toString());
      } catch (e) {
        Helper.dialogWarning(e.toString());
      }
    }
    await EasyLoading.dismiss();
  }

  Future<void> deleteOnPressed(int id) async {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    await EasyLoading.show();
    try {
      var result = await client
          .from("emotionslist_executant")
          .delete()
          .match({"emotionslist_id": id}).then((value) async =>
              await client.from("emotions_list").delete().match({"id": id}));
      await EasyLoading.dismiss();
      if (result == null) {
        Get.back(
          closeOverlays: true,
          result: true,
        );
      }
    } on PostgrestException catch (e) {
      Helper.dialogWarning(e.toString());
    } catch (e) {
      Helper.dialogWarning(e.toString());
    }
    await EasyLoading.dismiss();
  }

  void fromGallery() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    update();
  }

  void fromCamera() async {
    image = await picker.pickImage(source: ImageSource.camera);
    update();
  }

  void clearImage() {
    if (image != null) {
      image = null;
      if (getImage != null) {
        getImage = null;
      }
    } else if (getImage != null) {
      getImage = null;
      if (image != null) {
        image = null;
      }
    }
    update();
  }

  Future<Uint8List> convertImage(XFile imageData) async {
    final path = imageData.path;
    Uint8List bytes = await File(path).readAsBytes();
    return bytes;
  }

  Uint8List stringToImage(String imageValue) {
    List<int> byte = jsonDecode(imageValue).cast<int>();
    Uint8List ul = Uint8List.fromList(byte);
    return ul;
  }
}

class TileonTapModel {
  int? id;
  bool? data;

  TileonTapModel(this.id, this.data);
}
