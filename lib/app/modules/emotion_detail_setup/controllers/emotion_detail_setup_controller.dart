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
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/emotions_model.dart';
import '../../../mahas/components/inputs/input_text_component.dart';
import '../../../mahas/mahas_colors.dart';
import '../../../mahas/services/helper.dart';
import '../../emotion_detail/controllers/emotion_detail_controller.dart';

class EmotionDetailSetupController extends GetxController {
  final InputTextController titleCon = InputTextController();
  final InputTextController descCon =
      InputTextController(type: InputTextType.paragraf);

  final listEmotionC = Get.find<EmotionDetailController>();
  final ImagePicker picker = ImagePicker();
  XFile? image;
  Uint8List? getImage;

  RxList<executant.ExecutantModel> lookUp = <executant.ExecutantModel>[].obs;
  RxList selectedId = [].obs;
  RxList<TileonTapModel> tileOnTap = <TileonTapModel>[].obs;
  RxList<EmotionsModel> emotions = <EmotionsModel>[].obs;
  RxList commonItems = [].obs;
  // RxList getExecutant = [].obs;

  RxBool editable = true.obs;

  RxBool isEdit = false.obs;
  RxString detailId = "".obs;
  RxInt qty = 0.obs;

  late String emotionCon;
  late int itemId;
  late int emotionId;
  RxString isAdd = "".obs;

  SupabaseClient client = Supabase.instance.client;

  @override
  void onInit() async {
    emotionCon = Get.parameters['emotion']!;
    var e = Get.parameters['itemId'];
    if (e != null) {
      itemId = int.parse(e);
    }
    emotionId = int.parse(Get.parameters['emotionId']!);
    isAdd.value = Get.parameters['isAdd'] ?? "";
    if (isAdd.value == "") {
      await getData(itemId);
    }

    super.onInit();
  }

  void popupMenuButtonOnSelected(String v) async {
    if (v == 'edit') {
      editable.value = true;
      isEdit.value = true;
    } else if (v == 'delete') {
      Helper.dialogQuestionWithAction(
        message: "Are you sure want to delete this data?",
        textConfirm: "YES",
        textCancel: "NO",
        confirmAction: () => deleteOnPressed(emotionId),
      );
    }
  }

  Future<bool> backOnPressed() async {
    Helper.dialogQuestionWithAction(
      message: "Are you sure want to go back?",
      confirmAction: () async {
        await listEmotionC.getData(emotionId);
        Get.back(closeOverlays: true);
      },
    );
    return true;
  }

  Future<bool> bottomSheetBack() async {
    Helper.dialogQuestionWithAction(
      message: "Are you sure want to go back?",
      confirmAction: () async {
        // await listEmotionC.getData(emotionId);
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
          for (int i = 0; i < selectedId.length; i++) {
            if (e.id == selectedId[i].id) {
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
                        : Obx(
                            () => ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(height: 0),
                              controller: ScrollController(),
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: lookUp.length,
                              itemBuilder: (context, index) {
                                return Obx(
                                  () => ListTile(
                                    onTap: () {
                                      if (tileOnTap[index].data == false) {
                                        print(lookUp[index].id);
                                        tileOnTap[index].data = true;
                                        selectedId.add(lookUp[index]);
                                        qty.value++;
                                      } else {
                                        tileOnTap[index].data = false;
                                        qty.value--;
                                        selectedId.remove(lookUp[index]);
                                      }
                                    },
                                    selectedTileColor:
                                        MahasColors.primary.withOpacity(0.15),
                                    selectedColor: MahasColors.dark,
                                    selected: tileOnTap[index].data!,
                                    horizontalTitleGap: 10,
                                    leading: lookUp[index].image == ""
                                        ? SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: ClipOval(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(5),
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
                                                padding:
                                                    const EdgeInsets.all(5),
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
          .select('*, emotionslist_executant!inner (executant!inner (*))')
          .match(
        {
          "user_uid": client.auth.currentUser!.id,
          "id": itemId.toString(),
        },
      ).order("date_created");
      print(response);
      emotions(EmotionsModel.fromJsonList(response));
      emotions.refresh();
      titleCon.value = emotions.first.emotionTitle!;
      descCon.value = emotions.first.emotionDesc!;
      getImage = emotions.first.images != ""
          ? stringToImage(emotions.first.images!)
          : null;

      selectedId.clear();
      for (var e in emotions.first.emotionslistExecutant!) {
        selectedId.add(e.executant);
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
    EasyLoading.show();

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
        var data = await client.from('emotionslist_executant').select().match(
          {
            "emotionslist_id": itemId,
          },
        );
        print(data);
        if (data != null) {
          for (var e in data) {
            for (int i = 0; i < selectedId.length; i++) {
              selectedId
                  .removeWhere((element) => element.id == e['executant_id']);
              // break;
            }
          }
        }
        print(selectedId);
        if (selectedId.isNotEmpty) {
          for (var e in selectedId) {
            await client.from('emotionslist_executant').insert(
              {
                "emotionslist_id": dataPost.first.id,
                "executant_id": e.id,
              },
            );
          }
        }
        await getData(itemId);
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
            "images": image != null ? await convertImage(image!) : "",
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
    EasyLoading.dismiss();
  }

  void deleteOnPressed(int id) async {
    if (EasyLoading.isShow) return;
    EasyLoading.show();
    Get.back(result: true);
    try {
      await client.from("notes").delete().match({"id": id});
    } on PostgrestException catch (e) {
      Helper.dialogWarning(e.toString());
    } catch (e) {
      Helper.dialogWarning(e.toString());
    }

    EasyLoading.dismiss();
    Get.back(closeOverlays: true);
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
