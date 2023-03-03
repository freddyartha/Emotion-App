import 'package:get/get.dart';

import '../controllers/executant_setup_controller.dart';

class ExecutantSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExecutantSetupController>(
      () => ExecutantSetupController(),
    );
  }
}
