import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/executant_setup_controller.dart';

class ExecutantSetupView extends GetView<ExecutantSetupController> {
  const ExecutantSetupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExecutantSetupView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ExecutantSetupView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
