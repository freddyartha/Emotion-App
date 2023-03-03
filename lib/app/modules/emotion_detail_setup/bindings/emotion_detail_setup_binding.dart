import 'package:get/get.dart';

import '../controllers/emotion_detail_setup_controller.dart';

class EmotionDetailSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmotionDetailSetupController>(
      () => EmotionDetailSetupController(),
    );
  }
}
