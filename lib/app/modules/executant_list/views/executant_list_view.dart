import 'package:emotion_app/app/data/models/executant_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import '../../../mahas/components/mahas_themes.dart';
import '../../../mahas/components/others/empty_component.dart';
import '../controllers/executant_list_controller.dart';

class ExecutantListView extends GetView<ExecutantListController> {
  const ExecutantListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Emotion Executor",
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
                    child: Text('Add an Executor'),
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
            future: controller.getExecutantList(),
            builder: (context, snapshot) {
              return Obx(
                () => controller.executant.isEmpty
                    ? Center(
                        child: EmptyComponent(
                          onPressed: () => controller.getExecutantList(),
                        ),
                      )
                    : ListView.separated(
                        itemCount: controller.executant.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 0,
                        ),
                        itemBuilder: (context, index) {
                          ExecutantModel executant =
                              controller.executant[index];
                          return ListTile(
                            onTap: () => controller
                                .toExecutantDetailSetup(executant.id!),
                            horizontalTitleGap: 5,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            leading: executant.image == null
                                ? const SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: ClipOval(
                                      child: Icon(
                                        FontAwesomeIcons.faceSmile,
                                        size: 40,
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: ClipOval(
                                      child: Image.memory(
                                        controller
                                            .convertImage(executant.image!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            title: Text(executant.name!),
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
