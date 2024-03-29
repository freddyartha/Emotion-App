import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../routes/app_pages.dart';

class MahasInit {
  static Future init() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await Supabase.initialize(
      url: "https://fdaazxiqyzgbckbuyboo.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZkYWF6eGlxeXpnYmNrYnV5Ym9vIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzcwMzk2NDUsImV4cCI6MTk5MjYxNTY0NX0.KYv4__lGBBdxbNo-th99jf-T69pgT39KqreqHoarExY",
    );

    await GetStorage.init();
  }

  static Future checkUser() async {
    SupabaseClient client = Supabase.instance.client;
    RxString route = "".obs;
    if (client.auth.currentSession != null) {
      route.value = Routes.HOME;
      return route.value;
    } else {
      route.value = Routes.SIGN_IN;
      return route.value;
    }
  }
}
