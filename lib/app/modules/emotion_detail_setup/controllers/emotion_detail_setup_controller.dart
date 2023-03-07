import 'dart:convert';
import 'dart:io';

import 'package:emotion_app/app/data/models/executant_model.dart';
import 'package:emotion_app/app/mahas/components/others/empty_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/notes_model.dart';
import '../../../mahas/components/inputs/input_text_component.dart';
import '../../../mahas/mahas_colors.dart';
import '../../../mahas/services/helper.dart';

class EmotionDetailSetupController extends GetxController {
  final InputTextController titleCon = InputTextController();
  final InputTextController descCon =
      InputTextController(type: InputTextType.paragraf);

  // final oneEmotionC = Get.find<EmotionDetailController>();
  final ImagePicker picker = ImagePicker();
  XFile? image;
  Uint8List? getImage;

  RxList<ExecutantModel> lookUp = <ExecutantModel>[].obs;
  RxList<ExecutantModel> selectedId = <ExecutantModel>[].obs;
  RxList<bool> tileOnTap = <bool>[].obs;

  RxBool editable = true.obs;
  RxInt itemID = 0.obs;
  RxBool isEdit = false.obs;
  RxString detailId = "".obs;
  RxInt qty = 0.obs;

  late String emotionCon;

  SupabaseClient client = Supabase.instance.client;

  @override
  void onInit() {
    String emot = Get.parameters['emotion']!;
    emotionCon = emot;
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
        confirmAction: () => deleteOnPressed(itemID.value),
      );
    }
  }

  Future<bool> backOnPressed() async {
    Helper.dialogQuestionWithAction(
      message: "Are you sure want to go back?",
      confirmAction: () async {
        // await homeC.getNotes();
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
      var dataGet = ExecutantModel.fromDynamicList(resGet);
      lookUp.refresh();
      lookUp.addAll(dataGet);
      for (var e in dataGet) {
        tileOnTap.add(false);
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
    if (tileOnTap.isNotEmpty) {
      tileOnTap.clear();
    }
    if (qty.value > 0) {
      qty.value = 0;
    }
    // if (selectedId.isNotEmpty) {
    //   selectedId.clear();
    // }
    if (lookUp.isNotEmpty) {
      lookUp.clear();
    }
    await getEmotionExecutor();
    await showMaterialModalBottomSheet(
      expand: true,
      isDismissible: false,
      context: Get.context!,
      builder: (context) => WillPopScope(
        onWillPop: () => backOnPressed(),
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
                              return Obx(
                                () => ListTile(
                                  onTap: () {
                                    if (tileOnTap[index] == false) {
                                      tileOnTap[index] = true;

                                      if (selectedId.isNotEmpty) {
                                        for (var e in selectedId) {
                                          if (e.id != lookUp[index].id) {
                                            selectedId.add(lookUp[index]);
                                          }
                                        }
                                      } else if (selectedId.isEmpty) {
                                        selectedId.add(lookUp[index]);
                                      }
                                      // selectedId.add(lookUp[index]);
                                      qty.value++;
                                    } else {
                                      tileOnTap[index] = false;
                                      qty.value--;
                                      selectedId.remove(lookUp[index]);
                                    }
                                  },
                                  selectedTileColor:
                                      MahasColors.blue.withOpacity(0.3),
                                  selectedColor: MahasColors.dark,
                                  selected: tileOnTap[index],
                                  horizontalTitleGap: 10,
                                  leading: lookUp[index].image == ""
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
                      print(selectedId);
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

  Future getData(int id) async {
    if (EasyLoading.isShow) return;
    EasyLoading.show();
    editable.value = false;
    try {
      var resGet = await client.from('notes').select().match(
        {
          "id": id,
        },
      );
      var dataGet = Notes.fromDynamicList(resGet);
      titleCon.value = dataGet.first.title;
      descCon.value = dataGet.first.description;
      itemID.value = dataGet.first.id!;
    } on PostgrestException catch (e) {
      Helper.dialogWarning(e.toString());
    } catch (e) {
      Helper.dialogWarning(e.toString());
    }

    EasyLoading.dismiss();
  }

  Future submitOnPressed(bool edit) async {
    if (!titleCon.isValid) return false;
    if (!descCon.isValid) return false;

    if (EasyLoading.isShow) return false;
    EasyLoading.show();

    if (edit == true) {
      var res = await client.from("notes").update(
        {
          "title": titleCon.value,
          "description": descCon.value,
          "updated_at": DateTime.now().toIso8601String()
        },
      ).match(
        {"id": itemID},
      ).select();
      editable.value = false;
      isEdit.value = false;
      var dataPost = Notes.fromDynamicList(res);
      await getData(dataPost.first.id!);
      EasyLoading.dismiss();
    } else {
      try {
        var res = await client.from('notes').insert(
          {
            "user_uid": client.auth.currentUser!.id,
            "title": titleCon.value,
            "description": descCon.value,
            "created_at": DateTime.now().toIso8601String(),
          },
        ).select();
        editable.value = false;
        var dataPost = Notes.fromDynamicList(res);
        await getData(dataPost.first.id!);
      } on PostgrestException catch (e) {
        Helper.dialogWarning(e.toString());
      } catch (e) {
        Helper.dialogWarning(e.toString());
      }

      EasyLoading.dismiss();
      Helper.dialogSuccess("Created Successfully!");
    }
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
