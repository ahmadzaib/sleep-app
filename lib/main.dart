import 'package:avatar_flow/core/router/router.dart';
import 'package:avatar_flow/core/services/preferences.dart';
import 'package:avatar_flow/core/services/service_locator.dart';
import 'package:avatar_flow/core/theme/app_colors.dart';
import 'package:avatar_flow/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await Preferences().init();

  // Initialize Supabase with auth persistence
  await Supabase.initialize(
    url: 'https://wyeybswtyqylzagfevtz.supabase.co',
    anonKey: 'sb_publishable_6nGfW4O2rHCuGiS4a4lLsw_uVbrtHCK',
  );

  // Sync auth state with router
  Supabase.instance.client.auth.onAuthStateChange.listen((event) {
    authStateNotifier.value = event.session != null;
  });

  // Initialize ToastUtils with navigator key
  initializeToastUtils();

  ErrorWidget.builder = (details) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: AppColors.whiteColor,
        alignment: Alignment.center,
        child: Text(
          'Error: ${details.exceptionAsString()}',
          style: const TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  };

  // await initialize();
  await initDependencies();

  // Initialize local notifications with enhanced setup
  // if (!kIsWeb) {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   await NotificationService.localNotiInit();
  //   await NotificationService.getDeviceToken();
  // }

  // final isDark = getBoolAsync(Keys.isDarkMode);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp(prefs: prefs));
}
