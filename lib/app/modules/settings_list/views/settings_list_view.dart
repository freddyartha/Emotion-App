import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/settings_list_controller.dart';

class SettingsListView extends GetView<SettingsListController> {
  const SettingsListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemBuilder: (context, i) => ListTile(
          horizontalTitleGap: 5,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          title: Text(controller.menus[i].title),
          leading: Icon(
            controller.menus[i].icon,
          ),
          onTap: controller.menus[i].onTab,
        ),
        itemCount: controller.menus.length,
        separatorBuilder: (context, index) {
          return const Divider(
            height: 0,
          );
        },
      ),
    );
  }
}
