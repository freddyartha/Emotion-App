import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../mahas/components/inputs/input_datetime_component.dart';
import '../../../mahas/components/inputs/input_radio_component.dart';
import '../../../mahas/components/inputs/input_text_component.dart';
import '../../../mahas/services/helper.dart';
import '../../../mahas/services/mahas_format.dart';

class SignUpController extends GetxController {
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
  final InputTextController passCon =
      InputTextController(type: InputTextType.password);
  final InputTextController passConfirmCon =
      InputTextController(type: InputTextType.password);

  SupabaseClient client = Supabase.instance.client;
  late List<Map<String, dynamic>> response;

  RxBool visible = true.obs;
  RxBool editable = true.obs;

  Future submitOnPressed() async {
    if (!nameCon.isValid) return false;
    if (!addressCon.isValid) return false;
    if (!birthDayCon.isValid) return false;
    if (!emailCon.isValid) return false;
    if (!passCon.isValid) return false;
    if (!passConfirmCon.isValid) return false;
    if (passCon.value != passConfirmCon.value) {
      Helper.dialogWarning("Password confirmation doesn't match Password");
      EasyLoading.dismiss();
      return false;
    }

    if (EasyLoading.isShow) return false;
    EasyLoading.show();

    try {
      await client.auth
          .signUp(
        password: passConfirmCon.value,
        email: emailCon.value,
      )
          .then(
        (value) async {
          try {
            response = await client.from('users').insert(
              {
                "user_uid": value.user!.id,
                "name": nameCon.value,
                "address": addressCon.value,
                "sex": sexCon.value ?? "",
                "birth_date": MahasFormat.dateToString(birthDayCon.value),
                "email": emailCon.value,
                "created_at": DateTime.now().toIso8601String(),
                "profile_pic": "",
              },
            ).select();
            Helper.dialogSuccess(
                "Register Success!\n We have sent you email verification. Please check your email");
            editable.value = false;
            visible.value = false;
            Map<String, dynamic> data = response.first;
            nameCon.value = data["name"];
            addressCon.value = data["address"];
            sexCon.value = data["sex"];
            birthDayCon.value =
                MahasFormat.stringToDateTime(data["birth_date"]);
            emailCon.value = data["email"];
          } catch (e) {
            Helper.dialogWarning(e.toString());
          }
        },
      );
    } catch (e) {
      Helper.dialogWarning(e.toString());
    }

    EasyLoading.dismiss();
  }
}
