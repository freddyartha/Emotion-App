import 'package:get/get.dart';

import '../controllers/one_emotion_setup_controller.dart';

class OneEmotionSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OneEmotionSetupController>(
      () => OneEmotionSetupController(),
    );
  }
}
