import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../mahas/components/inputs/input_datetime_component.dart';
import '../../../mahas/components/inputs/input_radio_component.dart';
import '../../../mahas/components/inputs/input_text_component.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(
          () => ListView(
            children: [
              InputTextComponent(
                controller: controller.nameCon,
                required: true,
                label: "Name",
                editable: controller.editable.value,
              ),
              InputTextComponent(
                controller: controller.addressCon,
                required: true,
                label: "Address",
                editable: controller.editable.value,
              ),
              InputRadioComponent(
                controller: controller.sexCon,
                label: "Sex",
                editable: controller.editable.value,
              ),
              InputDatetimeComponent(
                controller: controller.birthDayCon,
                label: "Date of Birth",
                required: true,
                editable: controller.editable.value,
              ),
              InputTextComponent(
                controller: controller.emailCon,
                required: true,
                label: "Email Address",
                editable: controller.editable.value,
              ),
              Obx(
                () => Visibility(
                  visible: controller.visible.value,
                  child: Column(
                    children: [
                      InputTextComponent(
                        controller: controller.passCon,
                        required: true,
                        label: "Password",
                        editable: controller.editable.value,
                      ),
                      InputTextComponent(
                        controller: controller.passConfirmCon,
                        required: true,
                        label: "Confirm Password",
                        editable: controller.editable.value,
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.visible.value,
                  child: SizedBox(
                    width: Get.width,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.submitOnPressed();
                      },
                      child: const Text(
                        "Submit",
                        textAlign: TextAlign.center,
                      ),
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
}
