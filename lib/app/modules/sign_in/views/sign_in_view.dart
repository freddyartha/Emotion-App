import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../mahas/components/inputs/input_text_component.dart';
import '../../../mahas/components/mahas_themes.dart';
import '../../../mahas/mahas_colors.dart';
import '../controllers/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MahasColors.primary,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: Container(),
                ),
                const SizedBox(
                  width: 150,
                  child: Icon(
                    Icons.person_pin,
                    size: 100,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(5)),
                Text(
                  "EMOTION APP",
                  style: MahasThemes.blackH1,
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Text(
                  "Sign In",
                  style: MahasThemes.whiteH2,
                ),
                Column(
                  children: [
                    InputTextComponent(
                      controller: controller.emailCon,
                      required: true,
                      label: "Email",
                    ),
                    InputTextComponent(
                      controller: controller.passwordCon,
                      required: true,
                      label: "Password",
                    ),
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                SizedBox(
                  width: Get.width,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      controller.signInOnTap();
                    },
                    icon: const Icon(Icons.login_outlined),
                    label: const Text("SIGN IN"),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    controller.toRegister();
                  },
                  child: SizedBox(
                    height: 30,
                    width: Get.width,
                    child: Center(
                      child: Text(
                        "Sign Up Here",
                        style: MahasThemes.linkNormal,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                Obx(
                  () => Text(controller.version.value),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
