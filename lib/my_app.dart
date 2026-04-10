import 'package:avatar_flow/core/services/multiprovider_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:avatar_flow/core/config/appconfig.dart';
import 'package:avatar_flow/core/router/router.dart' as router;
import 'package:avatar_flow/core/theme/app_theme.dart';
import 'package:avatar_flow/core/theme/theme_controller.dart';
import 'package:avatar_flow/core/controllers/splash_controller.dart';
import 'package:avatar_flow/core/services/preferences.dart';
// import 'package:avatar_flow/core/localization/app_locale_provider.dart'; // if using

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.prefs});

  final Preferences prefs;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: MultiProviderClass(prefs: prefs).providersList,

      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return Consumer<ThemeController>(
            builder: (context, themeController, _) {
              return SafeArea(
                top: false,
                child: MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: AppConfig.appName,
                  routerConfig: router.router,

                  /// 🌗 Theme
                  themeMode: themeController.currentTheme,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,

                  /// 🌍 Localization (uncomment if needed)
                  // locale: context.watch<AppLocaleProvider>().locale,
                  // supportedLocales: AppLocalizations.supportedLocales,
                  // localizationsDelegates: AppLocalizations.localizationsDelegates,

                  /// 👇 Dismiss keyboard on tap
                  builder: (context, child) {
                    return GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: child,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
