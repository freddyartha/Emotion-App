import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/models/emotions_model.dart';
import '../../../mahas/components/mahas_themes.dart';
import '../../../mahas/components/others/empty_component.dart';
import '../../../mahas/services/mahas_format.dart';
import '../controllers/emotion_detail_controller.dart';

class EmotionDetailView extends GetView<EmotionDetailController> {
  const EmotionDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.emotionCon,
          style: MahasThemes.whiteH2,
        ),
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
                    PopupMenuItem(
                      value: 'add',
                      child: Text('Add New ${controller.emotionCon} Emotion'),
                    ),
                  );

                  return r;
                },
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.onRefresh(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: controller.getEmotions(1),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: EmptyComponent(),
                );
              } else {
                return Obx(
                  () => ListView.separated(
                    itemCount: controller.emotions.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 0,
                    ),
                    itemBuilder: (context, index) {
                      EmotionsModel emotions = controller.emotions[index];
                      return ListTile(
                        onTap: () =>
                            controller.toEmotionDetailSetup(emotions.id!),
                        horizontalTitleGap: 5,
                        leading: const Icon(Icons.notes_rounded),
                        title: Text(emotions.emotionTitle!),
                        trailing: Text(
                            MahasFormat.displayDate(emotions.dateCreated!)),
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
