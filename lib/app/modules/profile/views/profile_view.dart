import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../mahas/components/inputs/input_datetime_component.dart';
import '../../../mahas/components/inputs/input_radio_component.dart';
import '../../../mahas/components/inputs/input_text_component.dart';
import '../../../mahas/components/mahas_themes.dart';
import '../../../mahas/mahas_colors.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.backOnPressed(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          actions: [
            Obx(
              () => Visibility(
                visible: controller.editable.isFalse ? true : false,
                child: PopupMenuButton(
                  icon: const Icon(
                    Icons.more_horiz_rounded,
                    size: 25,
                  ),
                  onSelected: (value) =>
                      controller.popupMenuButtonOnSelected(value),
                  itemBuilder: (BuildContext context) {
                    List<PopupMenuItem<String>> r = [];
                    r.add(
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                    );

                    return r;
                  },
                ),
              ),
            ),
          ],
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
                Text(
                  "Profile Picture",
                  style: MahasThemes.mutedNormal,
                ),
                const SizedBox(
                  height: 10,
                ),
                GetBuilder<ProfileController>(
                  builder: (c) => Column(
                    children: [
                      c.editable.isFalse
                          ? Container(
                              width: Get.width,
                              height: Get.width * 0.8,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: MahasColors.grey.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(
                                    MahasThemes.borderRadius),
                              ),
                              child: c.getImage == null
                                  ? Center(
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                              "assets/images/no_image_no_caption.png",
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Image.memory(c.getImage!),
                            )
                          : Container(
                              width: Get.width,
                              height: Get.width * 0.8,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: MahasColors.grey.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(
                                    MahasThemes.borderRadius),
                              ),
                              child: c.getImage == null && c.image == null
                                  // ? const Center(
                                  //     child: SizedBox(
                                  //       width: 30,
                                  //       height: 30,
                                  //       child: CircularProgressIndicator(
                                  //         color: MahasColors.primary,
                                  //       ),
                                  //     ),
                                  //   )
                                  ? Center(
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                              "assets/images/no_image_no_caption.png",
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : c.getImage != null && c.image == null
                                      ? Image.memory(c.getImage!)
                                      : c.getImage != null && c.image != null
                                          ? Image.file(
                                              File(c.image!.path),
                                            )
                                          : c.getImage == null &&
                                                  c.image != null
                                              ? Image.file(
                                                  File(c.image!.path),
                                                )
                                              : Center(
                                                  child: Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration:
                                                        const BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                          "assets/images/no_image_no_caption.png",
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                            ),
                      // : Container(
                      //     width: Get.width,
                      //     height: Get.width * 0.8,
                      //     padding: const EdgeInsets.all(10),
                      //     decoration: BoxDecoration(
                      //       color: MahasColors.grey.withOpacity(0.15),
                      //       borderRadius: BorderRadius.circular(
                      //           MahasThemes.borderRadius),
                      //     ),
                      //     child: c.image == null
                      //         ? Center(
                      //             child: Container(
                      //               height: 100,
                      //               width: 100,
                      //               decoration: const BoxDecoration(
                      //                 image: DecorationImage(
                      //                   image: AssetImage(
                      //                     "assets/images/no_image_no_caption.png",
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           )
                      //         : Image.file(
                      //             File(c.image!.path),
                      //           ),
                      //   ),
                      c.editable.isTrue
                          ? Column(
                              children: [
                                SizedBox(
                                  width: Get.width,
                                  height: 35,
                                  child: TextButton(
                                    onPressed: () {
                                      c.clearImage();
                                    },
                                    child: Text(
                                      "Clear image",
                                      style: MahasThemes.linkNormal,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width,
                                  height: 35,
                                  child: TextButton(
                                    onPressed: () {
                                      c.fromGallery();
                                    },
                                    child: Text(
                                      "From Gallery",
                                      style: MahasThemes.linkNormal,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width,
                                  height: 35,
                                  child: TextButton(
                                    onPressed: () {
                                      c.fromCamera();
                                    },
                                    child: Text(
                                      "From Camera",
                                      style: MahasThemes.linkNormal,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  () => Visibility(
                    visible: controller.editable.value,
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
      ),
    );
  }
}
