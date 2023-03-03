import 'package:get/get.dart';

import '../controllers/settings_list_controller.dart';

class SettingsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsListController>(
      () => SettingsListController(),
    );
  }
}
