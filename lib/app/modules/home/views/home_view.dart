import 'package:emotion_app/app/mahas/components/mahas_themes.dart';
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
              child: SingleChildScrollView(
                controller: ScrollController(initialScrollOffset: 0),
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
                                      child:
                                          controller.users.first.profilePic !=
                                                  null
                                              ? Image.network(
                                                  controller
                                                      .users.first.profilePic!,
                                                )
                                              : Image.asset(
                                                  "assets/images/no_image.png",
                                                ),
                                    ),
                                  )
                                : SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/images/no_image.png",
                                      ),
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                            overflow: TextOverflow.visible,
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
                            height: 105,
                            width: Get.width,
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller:
                                  ScrollController(initialScrollOffset: 0),
                              radius: const Radius.circular(10),
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  controller: ScrollController(
                                      initialScrollOffset: 0.5),
                                  itemBuilder: (context, index) {
                                    return Obx(
                                      () => controller.listEmotion.isNotEmpty
                                          ? InkWell(
                                              onTap: () =>
                                                  controller.toEmotionDetail(
                                                      controller
                                                          .listEmotion[index]
                                                          .description!,
                                                      controller
                                                          .listEmotion[index]
                                                          .id!
                                                          .toString()),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                width: 80,
                                                height: 100,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      width: 70,
                                                      height: 70,
                                                      child: ClipOval(
                                                        child: Image.memory(
                                                          controller.stringToImage(
                                                              controller
                                                                  .listEmotion[
                                                                      index]
                                                                  .image!),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    FittedBox(
                                                      fit: BoxFit.fitWidth,
                                                      child: Text(
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
                                          : const Center(
                                              child: ShimmerComponent(
                                                count: 1,
                                              ),
                                            ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      thickness: 10,
                                    );
                                  },
                                  itemCount: controller.listEmotion.length),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
