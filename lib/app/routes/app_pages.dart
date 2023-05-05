import 'package:get/get.dart';

import '../modules/emotion_detail/bindings/emotion_detail_binding.dart';
import '../modules/emotion_detail/views/emotion_detail_view.dart';
import '../modules/emotion_detail_setup/bindings/emotion_detail_setup_binding.dart';
import '../modules/emotion_detail_setup/views/emotion_detail_setup_view.dart';
import '../modules/executant_list/bindings/executant_list_binding.dart';
import '../modules/executant_list/views/executant_list_view.dart';
import '../modules/executant_setup/bindings/executant_setup_binding.dart';
import '../modules/executant_setup/views/executant_setup_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/one_emotion_list/bindings/one_emotion_list_binding.dart';
import '../modules/one_emotion_list/views/one_emotion_list_view.dart';
import '../modules/one_emotion_setup/bindings/one_emotion_setup_binding.dart';
import '../modules/one_emotion_setup/views/one_emotion_setup_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/settings_list/bindings/settings_list_binding.dart';
import '../modules/settings_list/views/settings_list_view.dart';
import '../modules/sign_in/bindings/sign_in_binding.dart';
import '../modules/sign_in/views/sign_in_view.dart';
import '../modules/sign_up/bindings/sign_up_binding.dart';
import '../modules/sign_up/views/sign_up_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_IN,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.EMOTION_DETAIL,
      page: () => const EmotionDetailView(),
      binding: EmotionDetailBinding(),
    ),
    GetPage(
      name: _Paths.EMOTION_DETAIL_SETUP,
      page: () => const EmotionDetailSetupView(),
      binding: EmotionDetailSetupBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS_LIST,
      page: () => const SettingsListView(),
      binding: SettingsListBinding(),
    ),
    GetPage(
      name: _Paths.EXECUTANT_LIST,
      page: () => const ExecutantListView(),
      binding: ExecutantListBinding(),
    ),
    GetPage(
      name: _Paths.EXECUTANT_SETUP,
      page: () => const ExecutantSetupView(),
      binding: ExecutantSetupBinding(),
    ),
    GetPage(
      name: _Paths.ONE_EMOTION_LIST,
      page: () => const OneEmotionListView(),
      binding: OneEmotionListBinding(),
    ),
    GetPage(
      name: _Paths.ONE_EMOTION_SETUP,
      page: () => const OneEmotionSetupView(),
      binding: OneEmotionSetupBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
