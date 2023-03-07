import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import '../../../mahas/components/inputs/input_text_component.dart';
import '../../../mahas/components/mahas_themes.dart';
import '../../../mahas/mahas_colors.dart';
import '../controllers/emotion_detail_setup_controller.dart';

class EmotionDetailSetupView extends GetView<EmotionDetailSetupController> {
  const EmotionDetailSetupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => controller.backOnPressed(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(controller.emotionCon),
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
                  controller: controller.titleCon,
                  required: true,
                  label: "Title",
                  editable: controller.editable.value,
                ),
                InputTextComponent(
                  controller: controller.descCon,
                  required: true,
                  label: "Description",
                  editable: controller.editable.value,
                ),
                Obx(
                  () => controller.selectedId.isEmpty
                      ? Container(
                          height: 60,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: MahasColors.grey.withOpacity(0.3),
                            borderRadius:
                                BorderRadius.circular(MahasThemes.borderRadius),
                          ),
                          child: IconButton(
                            onPressed: () {
                              controller.detailOnPressed();
                            },
                            icon: const Icon(FontAwesomeIcons.circlePlus,
                                color: MahasColors.blue),
                          ),
                        )
                      : Container(
                          width: Get.width,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: MahasColors.grey.withOpacity(0.3),
                            borderRadius:
                                BorderRadius.circular(MahasThemes.borderRadius),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(
                                      parent: NeverScrollableScrollPhysics()),
                                  itemBuilder: (context, index) => SizedBox(
                                    height: 30,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            child: Text(controller
                                                .selectedId[index].name!),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            controller.selectedId.remove(
                                                controller.selectedId[index]);
                                          },
                                          child: const SizedBox(
                                            height: 30,
                                            width: 50,
                                            child: Icon(
                                              Icons.delete_forever,
                                              color: MahasColors.red,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const Divider(height: 0),
                                  itemCount: controller.selectedId.length,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              IconButton(
                                onPressed: () {
                                  controller.detailOnPressed();
                                },
                                icon: const Icon(FontAwesomeIcons.circlePlus,
                                    color: MahasColors.blue),
                              ),
                            ],
                          ),
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GetBuilder<EmotionDetailSetupController>(
                  builder: (c) => Column(
                    children: [
                      c.detailId.value != ""
                          ? c.editable.isFalse
                              ? Container(
                                  width: Get.width,
                                  height: Get.width * 0.8,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: MahasColors.grey.withOpacity(0.3),
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
                                    color: MahasColors.grey.withOpacity(0.3),
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
                                color: MahasColors.grey.withOpacity(0.3),
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
