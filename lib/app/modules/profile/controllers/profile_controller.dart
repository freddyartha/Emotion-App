import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:emotion_app/app/mahas/services/mahas_format.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/users_model.dart';
import '../../../mahas/components/inputs/input_datetime_component.dart';
import '../../../mahas/components/inputs/input_radio_component.dart';
import '../../../mahas/components/inputs/input_text_component.dart';
import '../../../mahas/services/helper.dart';
import '../../home/controllers/home_controller.dart';

class ProfileController extends GetxController {
  final InputTextController nameCon = InputTextController();
  final InputTextController addressCon =
      InputTextController(type: InputTextType.paragraf);
  final InputRadioController sexCon = InputRadioController(
    items: [
      RadioButtonItem(text: "Male", value: "m"),
      RadioButtonItem(text: "Female", value: "f"),
    ],
  );
  final InputDatetimeController birthDayCon = InputDatetimeController();
  final InputTextController emailCon =
      InputTextController(type: InputTextType.email);

  final ImagePicker picker = ImagePicker();
  XFile? image;
  Uint8List? getImage;

  RxBool editable = true.obs;
  RxBool tapImage = false.obs;
  RxInt itemID = 0.obs;

  SupabaseClient client = Supabase.instance.client;

  late HomeController homeC;

  final box = GetStorage();

  @override
  void onInit() async {
    homeC = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
    await getData();
    super.onInit();
  }

  void popupMenuButtonOnSelected(String v) async {
    if (v == 'edit') {
      editable.value = true;
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

  Future getData() async {
    if (EasyLoading.isShow) return;
    EasyLoading.show();
    editable.value = false;
    try {
      var resGet = await client.from('users').select().match(
        {
          "user_uid": client.auth.currentUser!.id,
        },
      );
      var dataGet = Users.fromDynamicList(resGet);
      nameCon.value = dataGet.first.name;
      addressCon.value = dataGet.first.address;
      sexCon.value = dataGet.first.sex;
      birthDayCon.value = dataGet.first.birthDate;
      emailCon.value = dataGet.first.email;
      getImage = dataGet.first.profilePic != null
          ? stringToImage(dataGet.first.profilePic!)
          : null;
      update();
      itemID.value = dataGet.first.id!;
    } on PostgrestException catch (e) {
      Helper.dialogWarning(e.toString());
    } catch (e) {
      Helper.dialogWarning(e.toString());
    }

    EasyLoading.dismiss();
  }

  Future submitOnPressed() async {
    if (!nameCon.isValid) return false;
    if (!addressCon.isValid) return false;
    if (!birthDayCon.isValid) return false;
    if (!emailCon.isValid) return false;

    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }

    await EasyLoading.show();

    var res = await client.from("users").update(
      {
        "name": nameCon.value,
        "address": addressCon.value,
        "sex": sexCon.value ?? "",
        "birth_date": MahasFormat.dateToString(birthDayCon.value),
        "email": emailCon.value,
        "profile_pic": image != null ? await convertImage(image!) : getImage,
      },
    ).match(
      {"id": itemID},
    ).select();
    editable.value = false;
    var dataPost = Users.fromDynamicList(res);
    await box.remove('rememberUser');
    var usersasMap = dataPost.map((dataPost) => dataPost.userstoMap()).toList();
    String jsonString = jsonEncode(usersasMap);
    await box.write('rememberUser', jsonString);
    nameCon.value = dataPost.first.name;
    addressCon.value = dataPost.first.address;
    sexCon.value = dataPost.first.sex;
    birthDayCon.value = dataPost.first.birthDate;
    emailCon.value = dataPost.first.email;
    getImage = dataPost.first.profilePic != null
        ? stringToImage(dataPost.first.profilePic!)
        : null;
    update();
    await EasyLoading.dismiss();
    Helper.dialogSuccess("Updated Successfully!");
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
