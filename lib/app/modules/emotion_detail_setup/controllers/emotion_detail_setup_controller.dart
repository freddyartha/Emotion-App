import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/notes_model.dart';
import '../../../mahas/components/inputs/input_text_component.dart';
import '../../../mahas/services/helper.dart';

class EmotionDetailSetupController extends GetxController {
  final InputTextController titleCon = InputTextController();
  final InputTextController descCon =
      InputTextController(type: InputTextType.paragraf);

  RxBool editable = true.obs;
  RxInt itemID = 0.obs;
  RxBool isEdit = false.obs;

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
}
