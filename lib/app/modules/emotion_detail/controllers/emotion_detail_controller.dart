import 'package:get/get.dart';

class EmotionDetailController extends GetxController {
  late String emotionCon;
  final count = 0.obs;
  @override
  void onInit() {
    String emot = Get.parameters['emotion']!;
    emotionCon = emot;
    super.onInit();
  }
}
