import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../mahas/components/mahas_themes.dart';
import '../controllers/emotion_detail_controller.dart';

class EmotionDetailView extends GetView<EmotionDetailController> {
  const EmotionDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.emotionCon,
          style: MahasThemes.whiteH2,
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EmotionDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
