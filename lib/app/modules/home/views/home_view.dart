import 'package:emotion_app/app/mahas/components/chart/pie_chart_component.dart';
import 'package:emotion_app/app/mahas/components/mahas_themes.dart';
import 'package:emotion_app/app/mahas/components/others/empty_component.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => controller.toProfile(),
                                child: Obx(
                                  () => controller.users.isNotEmpty
                                      ? SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: ClipOval(
                                            child: controller.users.first
                                                        .profilePic !=
                                                    null
                                                ? Image.memory(
                                                    controller.getImage!,
                                                    fit: BoxFit.cover,
                                                  )
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
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () => controller.toProfile(),
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
                              Obx(
                                () => controller.listEmotion.isEmpty
                                    ? Container(
                                        height: 60,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          color: MahasColors.light
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(
                                              MahasThemes.borderRadius),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            controller.addOneEmotionOnPressed();
                                          },
                                          icon: const Icon(
                                              FontAwesomeIcons.circlePlus,
                                              color: MahasColors.blue),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 110,
                                        width: Get.width,
                                        child: Scrollbar(
                                          controller: ScrollController(),
                                          thumbVisibility: true,
                                          radius: const Radius.circular(10),
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Obx(
                                                () => controller.loadData.isTrue
                                                    ? Obx(
                                                        () =>
                                                            controller
                                                                    .listEmotion
                                                                    .isNotEmpty
                                                                ? InkWell(
                                                                    onTap: () => controller.toEmotionDetail(
                                                                        controller
                                                                            .listEmotion[
                                                                                index]
                                                                            .description!,
                                                                        controller
                                                                            .listEmotion[index]
                                                                            .id!
                                                                            .toString()),
                                                                    child:
                                                                        SizedBox(
                                                                      width: 80,
                                                                      height:
                                                                          100,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                75,
                                                                            height:
                                                                                75,
                                                                            child:
                                                                                ClipOval(
                                                                              child: Container(
                                                                                padding: const EdgeInsets.all(5),
                                                                                child: Image.memory(
                                                                                  controller.stringToImage(controller.listEmotion[index].image!),
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          FittedBox(
                                                                            fit:
                                                                                BoxFit.fitWidth,
                                                                            child:
                                                                                Text(
                                                                              controller.listEmotion[index].description!,
                                                                              style: MahasThemes.whiteNormal,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : SizedBox(
                                                                    height: 70,
                                                                    width: Get
                                                                        .width,
                                                                    child:
                                                                        const EmptyComponent(),
                                                                  ),
                                                      )
                                                    : SizedBox(
                                                        height: 100,
                                                        width: Get.width,
                                                        child: const Center(
                                                          child:
                                                              ShimmerComponent(
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
                                            itemCount:
                                                controller.listEmotion.length,
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: Get.width,
                            padding: const EdgeInsets.only(
                                top: 12, left: 10, right: 10),
                            decoration: const BoxDecoration(
                              color: MahasColors.light,
                              // borderRadius: BorderRadius.circular(25),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                topLeft: Radius.circular(25),
                              ),
                            ),
                            child: Obx(
                              () => controller.pieChartCon.isEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Your Emotions in Chart!",
                                          style: MahasThemes.blackH2,
                                        ),
                                        const Expanded(
                                          child: SizedBox(
                                            child: EmptyComponent(),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Your Emotions in Chart!",
                                          style: MahasThemes.blackH2,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Obx(
                                          () => controller.loadData.isTrue
                                              ? SizedBox(
                                                  height: Get.width * 0.50,
                                                  child: PieChartComponent(
                                                    data:
                                                        controller.pieChartCon,
                                                    marginBottom: 0,
                                                  ),
                                                )
                                              : const ShimmerComponent(),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        SizedBox(
                                          width: Get.width,
                                          child: Text(
                                            "Description :",
                                            style: MahasThemes.blackH3,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Expanded(
                                          child: Obx(
                                            () => controller.loadData.isTrue
                                                ? ListView.separated(
                                                    itemBuilder:
                                                        (context, index) =>
                                                            ListTile(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              right: 10),
                                                      horizontalTitleGap: 5,
                                                      leading: ClipOval(
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: Image.memory(
                                                            controller.stringToImage(
                                                                controller.emotionCount[
                                                                        index]
                                                                    ['image']),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      title: Text(
                                                        controller.emotionCount[
                                                            index]['title'],
                                                        style: MahasThemes
                                                            .blackNormal,
                                                      ),
                                                      trailing: Text(
                                                        controller
                                                            .emotionCount[index]
                                                                ['count']
                                                            .toString(),
                                                        style: MahasThemes
                                                            .mutedNormal,
                                                      ),
                                                    ),
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            const Divider(
                                                      height: 0,
                                                    ),
                                                    itemCount: controller
                                                        .emotionCount.length,
                                                  )
                                                : const ShimmerComponent(
                                                    count: 3,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
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
