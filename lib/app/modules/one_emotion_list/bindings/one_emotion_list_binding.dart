import 'package:get/get.dart';

import '../controllers/one_emotion_list_controller.dart';

class OneEmotionListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OneEmotionListController>(
      () => OneEmotionListController(),
    );
  }
}
