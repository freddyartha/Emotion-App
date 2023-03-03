import 'dart:io';

import 'package:emotion_app/app/mahas/components/mahas_themes.dart';
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
          title: const Text('Add an Emotion'),
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
                const SizedBox(
                  height: 10,
                ),
                GetBuilder<OneEmotionSetupController>(
                  builder: (c) => Row(
                    children: [
                      Column(
                        children: [
                          c.image == null
                              ? Text(
                                  "No Image Yet",
                                  style: MahasThemes.mutedNormal,
                                )
                              : SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: ClipOval(
                                    child: Image.file(
                                      File(c.image!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                          TextButton(
                            onPressed: () {
                              c.clearImage();
                            },
                            child: Text(
                              "Clear image",
                              style: MahasThemes.linkNormal,
                            ),
                          ),
                        ],
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                c.fromGallery();
                              },
                              child: Text(
                                "From Gallery",
                                style: MahasThemes.linkNormal,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                c.fromCamera();
                              },
                              child: Text(
                                "From Camera",
                                style: MahasThemes.linkNormal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
