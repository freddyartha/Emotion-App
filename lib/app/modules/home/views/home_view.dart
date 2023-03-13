import 'package:emotion_app/app/mahas/components/mahas_themes.dart';
import 'package:emotion_app/app/mahas/components/others/empty_component.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../mahas/components/others/shimmer_component.dart';
import '../../../mahas/mahas_colors.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MahasColors.primary,
      height: Get.height,
      child: SafeArea(
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () => controller.onRefresh(),
            child: Container(
              color: MahasColors.primary,
              height: Get.height,
              child: FutureBuilder(
                future: controller.getUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: MahasColors.primary,
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Obx(
                                  () => controller.users.isNotEmpty
                                      ? SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: ClipOval(
                                            child: controller.users.first
                                                        .profilePic !=
                                                    null
                                                ? Image.memory(
                                                    controller.getImage!)
                                                : Image.asset(
                                                    "assets/images/no_image.png",
                                                  ),
                                          ),
                                        )
                                      : SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: ClipOval(
                                            child: Image.asset(
                                              "assets/images/no_image.png",
                                            ),
                                          ),
                                        ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Welcome!",
                                          style: MahasThemes.whiteNormal,
                                        ),
                                        Obx(
                                          () => controller.users.isNotEmpty
                                              ? Text(
                                                  controller.users.first.name!,
                                                  style: MahasThemes.whiteH2,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  maxLines: 2,
                                                )
                                              : const ShimmerComponent(
                                                  count: 1,
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    controller.goToSettingsList();
                                  },
                                  child: const SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Icon(
                                      Icons.settings_outlined,
                                      color: MahasColors.light,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "What's your feeling today?",
                                  style: MahasThemes.whiteH2,
                                  overflow: TextOverflow.visible,
                                  maxLines: 2,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 110,
                                  width: Get.width,
                                  child: Scrollbar(
                                    controller: ScrollController(),
                                    thumbVisibility: true,
                                    radius: const Radius.circular(10),
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Obx(
                                          () => controller.loadData.isTrue
                                              ? Obx(
                                                  () =>
                                                      controller.listEmotion
                                                              .isNotEmpty
                                                          ? InkWell(
                                                              onTap: () => controller.toEmotionDetail(
                                                                  controller
                                                                      .listEmotion[
                                                                          index]
                                                                      .description!,
                                                                  controller
                                                                      .listEmotion[
                                                                          index]
                                                                      .id!
                                                                      .toString()),
                                                              child: SizedBox(
                                                                width: 80,
                                                                height: 100,
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 75,
                                                                      height:
                                                                          75,
                                                                      child:
                                                                          ClipOval(
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              const EdgeInsets.all(5),
                                                                          child:
                                                                              Image.memory(
                                                                            controller.stringToImage(controller.listEmotion[index].image!),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    FittedBox(
                                                                      fit: BoxFit
                                                                          .fitWidth,
                                                                      child:
                                                                          Text(
                                                                        controller
                                                                            .listEmotion[index]
                                                                            .description!,
                                                                        style: MahasThemes
                                                                            .whiteNormal,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox(
                                                              height: 70,
                                                              width: Get.width,
                                                              child:
                                                                  const EmptyComponent(),
                                                            ),
                                                )
                                              : SizedBox(
                                                  height: 100,
                                                  width: Get.width,
                                                  child: const Center(
                                                    child: ShimmerComponent(
                                                      count: 3,
                                                    ),
                                                  ),
                                                ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const Divider(
                                          thickness: 0,
                                        );
                                      },
                                      itemCount: controller.listEmotion.length,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: Get.height,
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: MahasColors.light,
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
