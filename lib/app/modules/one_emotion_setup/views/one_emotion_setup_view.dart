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
                Text(
                  "Emotion Image",
                  style: MahasThemes.mutedNormal,
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
                  builder: (c) => Column(
                    children: [
                      c.detailId.value != ""
                          ? c.editable.isFalse
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
                                      ? const Center(
                                          child: SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: CircularProgressIndicator(
                                              color: MahasColors.primary,
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
                                      ? const Center(
                                          child: SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: CircularProgressIndicator(
                                              color: MahasColors.primary,
                                            ),
                                          ),
                                        )
                                      : c.getImage != null && c.image == null
                                          ? Image.memory(c.getImage!)
                                          : c.getImage != null &&
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
                              child: c.image == null
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
                                  : Image.file(
                                      File(c.image!.path),
                                    ),
                            ),
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
