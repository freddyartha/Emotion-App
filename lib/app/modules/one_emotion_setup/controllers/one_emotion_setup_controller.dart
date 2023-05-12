import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:emotion_app/app/data/models/one_emotion_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../mahas/components/inputs/input_text_component.dart';
import '../../../mahas/services/helper.dart';
import '../../home/controllers/home_controller.dart';

class OneEmotionSetupController extends GetxController {
  final InputTextController descCon = InputTextController();

  final ImagePicker picker = ImagePicker();
  XFile? image;
  Uint8List? getImage;

  RxBool editable = true.obs;
  RxInt itemID = 0.obs;
  RxBool isEdit = false.obs;
  RxString detailId = "".obs;
  RxBool imageRequired = false.obs;
  RxBool tapImage = false.obs;

  final box = GetStorage();

  late HomeController homeC;

  SupabaseClient client = Supabase.instance.client;

  @override
  void onInit() async {
    homeC = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
    detailId.value = Get.parameters['id'] ?? '';
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
        message: "Are you sure want to delete \nthis data?",
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
        Get.back(closeOverlays: true);
      },
    );
    return true;
  }

  Future getData(int id) async {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }

    await EasyLoading.show();
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

    await EasyLoading.dismiss();
  }

  Future submitOnPressed(bool edit) async {
    if (!descCon.isValid) return false;
    if (image == null) {
      if (getImage == null) {
        imageRequired.value = true;
        return false;
      }
    }

    if (EasyLoading.isShow) return false;
    EasyLoading.show();

    if (edit == true) {
      dynamic res;
      if (image != null) {
        res = await client.from("one_emotion").update(
          {
            "description": descCon.value,
            "image": await convertImage(image!),
            "updated_at": DateTime.now().toIso8601String()
          },
        ).match(
          {"id": itemID},
        ).select();
      } else {
        res = await client.from("one_emotion").update(
          {
            "description": descCon.value,
            "updated_at": DateTime.now().toIso8601String()
          },
        ).match(
          {"id": itemID},
        ).select();
      }

      editable.value = false;
      isEdit.value = false;
      var dataPost = OneemotionModel.fromDynamicList(res);
      descCon.value = dataPost.first.description;
      getImage = stringToImage(dataPost.first.image!);
      await box.remove('rememberEmotion');
      await homeC.getOneEmotion();

      await EasyLoading.dismiss();
      Helper.dialogSuccess("Updated Successfully!");
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
        descCon.value = dataPost.first.description;
        getImage = stringToImage(dataPost.first.image!);
        await box.remove('rememberEmotion');
        await homeC.getOneEmotion();
      } on PostgrestException catch (e) {
        Helper.dialogWarning(e.toString());
      } catch (e) {
        Helper.dialogWarning(e.toString());
      }

      imageRequired.value = false;
      await EasyLoading.dismiss();
      Helper.dialogSuccess("Created Successfully!");
    }
  }

  void deleteOnPressed(int id) async {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    await EasyLoading.show();

    try {
      var result = await client
          .from("emotionslist_executant")
          .delete()
          .match({"emotionslist_emotion_id": id})
          .then((value) async => await client
              .from("emotions_list")
              .delete()
              .match({"emotion_id": id}))
          .then((value) async =>
              await client.from("one_emotion").delete().match({"id": id}));
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

  Future<void> linkOnPressed() async {
    var url = Uri.parse('https://emojipedia.org/');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
