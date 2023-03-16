import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/menu_item_model.dart';
import '../../../mahas/services/helper.dart';
import '../../../routes/app_pages.dart';

class SettingsListController extends GetxController {
  final List<MenuItemModel> menus = [];
  SupabaseClient client = Supabase.instance.client;

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

  @override
  void onInit() {
    menus.add(MenuItemModel('Add Who Made Your Emotion',
        FontAwesomeIcons.peopleGroup, cExecutantList));
    menus.add(MenuItemModel(
        'Add an Emotion', FontAwesomeIcons.faceSmile, cOneEmotionList));
    menus.add(MenuItemModel(
        'Edit Profile', FontAwesomeIcons.userAstronaut, cProfile));
    menus.add(
        MenuItemModel('Sign Out', FontAwesomeIcons.rightFromBracket, cSignOut));
    super.onInit();
  }
}
