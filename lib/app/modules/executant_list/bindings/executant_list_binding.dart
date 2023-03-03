import 'package:get/get.dart';

import '../controllers/executant_list_controller.dart';

class ExecutantListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExecutantListController>(
      () => ExecutantListController(),
    );
  }
}
