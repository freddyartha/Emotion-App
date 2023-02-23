import 'package:get/get.dart';

import '../controllers/emotion_detail_controller.dart';

class EmotionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmotionDetailController>(
      () => EmotionDetailController(),
    );
  }
}
