import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/executant_model.dart';
import '../../../data/models/menu_item_model.dart';
import '../../../mahas/services/helper.dart';
import '../../../routes/app_pages.dart';

class SettingsListController extends GetxController {
  final List<MenuItemModel> menus = [];
  SupabaseClient client = Supabase.instance.client;
  final box = GetStorage();

  void cSignOut() async {
    Helper.dialogQuestionWithAction(
        confirmAction: () async => await signOut(),
        message: "Are you sure want to Sign Out?");
  }

  Future signOut() async {
    if (EasyLoading.isShow) return;
    await EasyLoading.show();
    try {
      await client.auth.signOut();
    } on PostgrestException catch (e) {
      EasyLoading.dismiss();
      Helper.dialogWarning(
        e.toString(),
      );
    } catch (e) {
      Helper.dialogWarning(
        e.toString(),
      );
    }
    Get.offAllNamed(Routes.SIGN_IN);
    EasyLoading.dismiss();
  }

  void cExecutantList() {
    Get.toNamed(Routes.EXECUTANT_LIST);
  }

  void cOneEmotionList() {
    Get.toNamed(Routes.ONE_EMOTION_LIST);
  }

  void cProfile() {
    Get.toNamed(Routes.PROFILE);
  }

  void cDeleteAccount() {
    Helper.dialogQuestionWithAction(
      message: "Are you sure want to delete \nyour account?",
      textConfirm: "YES",
      textCancel: "NO",
      confirmAction: () async =>
          await deleteOnPressed(client.auth.currentUser!.id),
    );
  }

  Future<void> deleteOnPressed(String id) async {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    await EasyLoading.show();

    try {
      var res = await client.from("executant").select().match(
        {"user_uid": id},
      );
      var dataGet = ExecutantModel.fromDynamicList(res);
      try {
        for (var e in dataGet) {
          await client
              .from("emotionslist_executant")
              .delete()
              .match({"executant_id": e.id});
        }
      } on PostgrestException catch (e) {
        Helper.dialogWarning(e.toString());
      } catch (e) {
        Helper.dialogWarning(e.toString());
      }
      await EasyLoading.dismiss();

      await client
          .from("emotions_list")
          .delete()
          .match({"user_uid": id})
          .then((value) async =>
              await client.from("executant").delete().match({"user_uid": id}))
          .then((value) async =>
              await client.from("one_emotion").delete().match({"user_uid": id}))
          .then((value) async =>
              await client.from("users").delete().match({"user_uid": id}))
          .then((value) async {
            await client.auth.admin.deleteUser(id);
            box.erase();
          })
          .then(
            (value) async => await EasyLoading.dismiss(),
          )
          .then((value) => Get.offAllNamed(Routes.SIGN_IN));
    } on PostgrestException catch (e) {
      Helper.dialogWarning(e.toString());
    } catch (e) {
      Helper.dialogWarning(e.toString());
    }
    await EasyLoading.dismiss();
  }

  void cForgotPassword() async {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    await EasyLoading.show();
    await client.auth.resetPasswordForEmail(
      client.auth.currentUser!.email!,
    );
    await EasyLoading.dismiss();
    Helper.dialogSuccess(
        "We already sent a link to your email!\nplease check your email inbox/spam");
  }

  @override
  void onInit() {
    menus.add(MenuItemModel(
        'Who Made Your Emotion', FontAwesomeIcons.peopleGroup, cExecutantList));
    menus.add(
        MenuItemModel('Emotion', FontAwesomeIcons.faceSmile, cOneEmotionList));
    menus.add(MenuItemModel(
        'Edit Profile', FontAwesomeIcons.userAstronaut, cProfile));
    // menus.add(MenuItemModel(
    //     'Delete Account', FontAwesomeIcons.userXmark, cDeleteAccount));
    // menus.add(MenuItemModel(
    //     'Forgot Password', FontAwesomeIcons.lockOpen, cForgotPassword));
    menus.add(
        MenuItemModel('Sign Out', FontAwesomeIcons.rightFromBracket, cSignOut));

    super.onInit();
  }
}
