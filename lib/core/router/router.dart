import 'package:avatar_flow/features/create_avatar/views/create_avatar_screen.dart';
import 'package:avatar_flow/features/create_avatar/views/avatar_preview_screen.dart';
import 'package:avatar_flow/features/create_avatar/views/clone_voice_screen.dart';
import 'package:avatar_flow/features/auth/providers/auth_provider.dart';
import 'package:avatar_flow/features/auth/views/forgot_password_screen.dart';
import 'package:avatar_flow/features/auth/views/otp_verification_screen.dart';
import 'package:avatar_flow/features/auth/views/sign_in_screen.dart';
import 'package:avatar_flow/features/auth/views/sign_up_screen.dart';
import 'package:avatar_flow/features/prompt_ai/views/prompt_avatar_screen.dart';
import 'package:avatar_flow/features/prompt_ai/views/choose_person_screen.dart';
import 'package:avatar_flow/features/avatar_detail/views/all_stories_screen.dart';
import 'package:avatar_flow/features/avatar_detail/views/avatar_detail_screen.dart';
import 'package:avatar_flow/features/bottom_nav_bar/views/main_screen.dart';
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
      name: AppRoutes.signIn,
      path: AppPaths.signIn,
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      name: AppRoutes.signUp,
      path: AppPaths.signUp,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      name: AppRoutes.forgotPassword,
      path: AppPaths.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      name: AppRoutes.otpVerification,
      path: AppPaths.otpVerification,
      builder: (context, state) {
        final Map<String, dynamic> extra =
            state.extra as Map<String, dynamic>? ?? <String, dynamic>{};
        final String flowName =
            extra['flow'] as String? ?? AuthOtpFlow.signUp.name;
        final AuthOtpFlow flow = flowName == AuthOtpFlow.resetPassword.name
            ? AuthOtpFlow.resetPassword
            : AuthOtpFlow.signUp;

        return OtpVerificationScreen(
          flow: flow,
          destination: extra['destination'] as String? ?? '',
        );
      },
    ),

    GoRoute(
      name: AppRoutes.bottomNavbar,
      path: AppPaths.bottomNavbar,
      builder: (context, state) => const MainScreen(),
    ),

    GoRoute(
      name: AppRoutes.avatarDetail,
      path: AppPaths.avatarDetail,
      builder: (context, state) => const AvatarDetailScreen(),
    ),
    GoRoute(
      name: AppRoutes.allStories,
      path: AppPaths.allStories,
      builder: (context, state) => const AllStoriesScreen(),
    ),
    GoRoute(
      name: AppRoutes.createAvatar,
      path: AppPaths.createAvatar,
      builder: (context, state) {
        final isEdit = state.extra as bool? ?? false;

        return CreateAvatarScreen(isEdit: isEdit);
      },
    ),
    GoRoute(
      name: AppRoutes.avatarPreview,
      path: AppPaths.avatarPreview,
      builder: (context, state) => const AvatarPreviewScreen(),
    ),
    GoRoute(
      name: AppRoutes.promptAvatar,
      path: AppPaths.promptAvatar,
      builder: (context, state) => const PromptAvatarScreen(),
    ),
    GoRoute(
      name: AppRoutes.choosePerson,
      path: AppPaths.choosePerson,
      builder: (context, state) => ChoosePersonScreen(
        sourceImagePath:
            (state.extra as Map<String, dynamic>?)?['imagePath'] as String?,
        sourceImageUrl:
            (state.extra as Map<String, dynamic>?)?['imageUrl'] as String?,
      ),
    ),
    GoRoute(
      name: AppRoutes.cloneVoice,
      path: AppPaths.cloneVoice,
      builder: (context, state) => const CloneVoiceScreen(),
    ),
  ],
);
