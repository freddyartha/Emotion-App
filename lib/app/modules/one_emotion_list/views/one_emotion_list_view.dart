import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import '../../../data/models/one_emotion_model.dart';
import '../../../mahas/components/mahas_themes.dart';
import '../../../mahas/components/others/empty_component.dart';
import '../controllers/one_emotion_list_controller.dart';

class OneEmotionListView extends GetView<OneEmotionListController> {
  const OneEmotionListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Emotion",
          style: MahasThemes.whiteH2,
        ),
        centerTitle: true,
        actions: [
          Visibility(
            visible: true,
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
                    value: 'add',
                    child: Text('Add an Emotion'),
                  ),
                );

                return r;
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.onRefresh(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: controller.getOneEmotionList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: EmptyComponent(),
                );
              } else {
                return Obx(
                  () => ListView.separated(
                    itemCount: controller.emotion.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 0,
                    ),
                    itemBuilder: (context, index) {
                      OneemotionModel emotion = controller.emotion[index];
                      return ListTile(
                        onTap: () =>
                            controller.toOneEmotionDetailSetup(emotion.id!),
                        horizontalTitleGap: 10,
                        leading: emotion.image == null
                            ? const Icon(FontAwesomeIcons.faceSmile)
                            : SizedBox(
                                width: 50,
                                height: 50,
                                child: ClipOval(
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Image.memory(
                                      controller.convertImage(emotion.image!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                        title: Text(emotion.description!),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
