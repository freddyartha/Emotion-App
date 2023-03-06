import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:emotion_app/app/data/models/one_emotion_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../mahas/components/inputs/input_text_component.dart';
import '../../../mahas/services/helper.dart';
import '../../one_emotion_list/controllers/one_emotion_list_controller.dart';

class OneEmotionSetupController extends GetxController {
  final InputTextController descCon = InputTextController();

  final oneEmotionC = Get.find<OneEmotionListController>();
  final ImagePicker picker = ImagePicker();
  XFile? image;
  Uint8List? getImage;

  RxBool editable = true.obs;
  RxInt itemID = 0.obs;
  RxBool isEdit = false.obs;
  RxString detailId = "".obs;
  RxBool imageRequired = false.obs;

  late String emotionCon;

  SupabaseClient client = Supabase.instance.client;

  @override
  void onInit() async {
    detailId.value = Get.parameters['id']!;
    if (detailId.value != "") {
      await getData(int.parse(detailId.value));
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
        await oneEmotionC.getOneEmotionList();
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
      getImage = stringToImage(dataGet.first.image!);
      update();
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
    if (image == null) {
      imageRequired.toggle();
      return false;
    }

    if (EasyLoading.isShow) return false;
    EasyLoading.show();

    if (edit == true) {
      var res = await client.from("one_emotion").update(
        {
          "description": descCon.value,
          "image": await convertImage(image!),
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
            "image": await convertImage(image!),
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

      imageRequired.toggle();
      EasyLoading.dismiss();
      Helper.dialogSuccess("Created Successfully!");
    }
  }

  void deleteOnPressed(int id) async {
    if (EasyLoading.isShow) return;
    EasyLoading.show();
    Get.back(result: true);
    try {
      await client.from("one_emotion").delete().match({"id": id});
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

  Future<void> linkOnPressed() async {
    var url = Uri.parse('https://emojipedia.org/');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
