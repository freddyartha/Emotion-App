import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/executant_model.dart';
import '../../../mahas/services/helper.dart';
import '../../../routes/app_pages.dart';

class ExecutantListController extends GetxController {
  SupabaseClient client = Supabase.instance.client;

  RxBool editable = true.obs;
  RxList executant = List<ExecutantModel>.empty().obs;

  @override
  void onInit() async {
    await getExecutantList();
    super.onInit();
  }

  void popupMenuButtonOnSelected(String v) async {
    if (v == 'add') {
      Get.toNamed(Routes.EXECUTANT_SETUP, parameters: {"id": ""})
          ?.then((value) async => await getExecutantList());
    }
  }

  Future<void> onRefresh() async {
    await getExecutantList();
  }

  void toExecutantDetailSetup(int id) {
    Get.toNamed(Routes.EXECUTANT_SETUP, parameters: {"id": id.toString()})
        ?.then((value) async => await getExecutantList());
  }

  Future getExecutantList() async {
    if (EasyLoading.isShow) return false;
    await EasyLoading.show();
    try {
      var response = await client
          .from("executant")
          .select()
          .eq(
            "user_uid",
            client.auth.currentUser!.id,
          )
          .order("created_at");
      List<ExecutantModel> datas = ExecutantModel.fromDynamicList(response);
      executant.assignAll(datas);
      executant.refresh();
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

  Uint8List convertImage(String imageValue) {
    List<int> byte = jsonDecode(imageValue).cast<int>();
    Uint8List ul = Uint8List.fromList(byte);
    return ul;
  }
}
