import 'dart:io';
import 'dart:typed_data';

import 'package:emotion_app/app/data/models/one_emotion_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../mahas/components/inputs/input_text_component.dart';
import '../../../mahas/services/helper.dart';

class OneEmotionSetupController extends GetxController {
  final InputTextController descCon = InputTextController();

  final ImagePicker picker = ImagePicker();
  XFile? image;

  RxBool editable = true.obs;
  RxInt itemID = 0.obs;
  RxBool isEdit = false.obs;
  RxString detailId = "".obs;

  late String emotionCon;

  SupabaseClient client = Supabase.instance.client;

  @override
  void onInit() {
    detailId.value = Get.parameters['id']!;
    if (detailId.value != "") {
      getData(int.parse(detailId.value));
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

  Future getData(int id) async {
    if (EasyLoading.isShow) return;
    EasyLoading.show();
    editable.value = false;
    try {
      var resGet = await client.from('one_emotion').select().match(
        {
          "id": id,
        },
      );
      var dataGet = OneemotionModel.fromDynamicList(resGet);
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
    if (!descCon.isValid) return false;

    if (EasyLoading.isShow) return false;
    EasyLoading.show();

    if (edit == true) {
      var res = await client.from("one_emotion").update(
        {
          "description": descCon.value,
          "image": image != null ? await convertImage(image!) : "",
          "updated_at": DateTime.now().toIso8601String()
        },
      ).match(
        {"id": itemID},
      ).select();
      editable.value = false;
      isEdit.value = false;
      var dataPost = OneemotionModel.fromDynamicList(res);
      await getData(dataPost.first.id!);
      EasyLoading.dismiss();
    } else {
      try {
        var res = await client.from('one_emotion').insert(
          {
            "user_uid": client.auth.currentUser!.id,
            "description": descCon.value,
            "image": image != null ? await convertImage(image!) : "",
            "created_at": DateTime.now().toIso8601String(),
          },
        ).select();
        editable.value = false;
        var dataPost = OneemotionModel.fromDynamicList(res);
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
  }

  Future<Uint8List> convertImage(XFile imageData) async {
    final path = imageData.path;
    Uint8List bytes = await File(path).readAsBytes();
    return bytes;
  }
}
