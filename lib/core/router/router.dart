import 'package:avatar_flow/features/splash/home/views/home_screen.dart';
import 'package:avatar_flow/features/splash/views/splash_screen.dart';
import 'package:avatar_flow/features/splash/views/splash_with_logo.dart';
import 'package:avatar_flow/features/splash/views/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      name: AppRoutes.splash,
      path: AppPaths.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: AppRoutes.splashWithLogo,
      path: AppPaths.splashWithLogo,
      builder: (context, state) => const SplashWithLogoScreen(),
    ),
    GoRoute(
      name: AppRoutes.welcome,
      path: AppPaths.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      name: AppRoutes.home,
      path: AppPaths.home,
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
