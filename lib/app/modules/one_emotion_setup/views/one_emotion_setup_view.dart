import 'dart:io';

import 'package:emotion_app/app/mahas/components/mahas_themes.dart';
import 'package:emotion_app/app/mahas/mahas_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../mahas/components/inputs/input_text_component.dart';
import '../controllers/one_emotion_setup_controller.dart';

class OneEmotionSetupView extends GetView<OneEmotionSetupController> {
  const OneEmotionSetupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.backOnPressed(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Emotion'),
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
                    r.add(
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
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
                  controller: controller.descCon,
                  required: true,
                  label: "Emotion Name",
                  editable: controller.editable.value,
                ),
                Row(
                  children: [
                    Text(
                      "Emotion Image",
                      style: MahasThemes.mutedNormal,
                    ),
                    Text(
                      "*",
                      style:
                          MahasThemes.blackNormal.copyWith(color: Colors.red),
                    ),
                  ],
                ),
                Visibility(
                  visible: controller.imageRequired.value,
                  child: const Text(
                    "    The field is required",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: MahasColors.red,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GetBuilder<OneEmotionSetupController>(
                  builder: (c) => Stack(
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
                          : InkWell(
                              onTap: () {
                                c.tapImage.toggle();
                                c.update();
                              },
                              child: Container(
                                width: Get.width,
                                height: Get.width * 0.8,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: MahasColors.grey.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(
                                      MahasThemes.borderRadius),
                                ),
                                child: c.getImage == null && c.image == null
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
                            ),
                      //image action button
                      c.editable.isTrue && c.tapImage.isTrue
                          ? InkWell(
                              onTap: () {
                                c.tapImage.toggle();
                                c.update();
                              },
                              child: Container(
                                width: Get.width,
                                height: Get.width * 0.8,
                                decoration: BoxDecoration(
                                  color: MahasColors.dark.withOpacity(0.70),
                                  borderRadius: BorderRadius.circular(
                                      MahasThemes.borderRadius),
                                ),
                                child: SizedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 25),
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          color: MahasColors.light
                                              .withOpacity(0.55),
                                          borderRadius: BorderRadius.circular(
                                            MahasThemes.borderRadius,
                                          ),
                                        ),
                                        height: 45,
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
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 25),
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          color: MahasColors.light
                                              .withOpacity(0.55),
                                          borderRadius: BorderRadius.circular(
                                            MahasThemes.borderRadius,
                                          ),
                                        ),
                                        height: 45,
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
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 25),
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          color: MahasColors.light
                                              .withOpacity(0.55),
                                          borderRadius: BorderRadius.circular(
                                            MahasThemes.borderRadius,
                                          ),
                                        ),
                                        height: 45,
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
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: Get.width,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      "It is recommended to download your Emotion Image from",
                      style: MahasThemes.mutedNormal,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  width: Get.width,
                  height: 35,
                  child: TextButton(
                    onPressed: () => controller.linkOnPressed(),
                    child: Text(
                      "https://emojipedia.org/",
                      style: MahasThemes.linkNormal,
                      textAlign: TextAlign.center,
                    ),
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
                          controller.isEdit.value == true
                              ? controller.submitOnPressed(true)
                              : controller.submitOnPressed(false);
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
