import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/executant_list_controller.dart';

class ExecutantListView extends GetView<ExecutantListController> {
  const ExecutantListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExecutantListView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ExecutantListView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
