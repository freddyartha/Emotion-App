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
          PopupMenuButton(
            icon: const Icon(
              Icons.more_horiz_rounded,
              size: 25,
            ),
            onSelected: (value) => controller.popupMenuButtonOnSelected(value),
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
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.onRefresh(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: controller.getData(controller.emotionId),
            builder: (context, snapshot) {
              return Obx(
                () => controller.emotions.isEmpty
                    ? Center(
                        child: EmptyComponent(
                          onPressed: () => controller.onRefresh(),
                        ),
                      )
                    : ListView.separated(
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
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            leading: emotions.images != null
                                ? SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: ClipOval(
                                      child: Image.memory(
                                        controller
                                            .stringToImage(emotions.images!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.notes_rounded,
                                    size: 35,
                                  ),
                            title: Text(emotions.emotionTitle!),
                            trailing: Text(
                              MahasFormat.displayDate(emotions.dateCreated!),
                            ),
                          );
                        },
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
