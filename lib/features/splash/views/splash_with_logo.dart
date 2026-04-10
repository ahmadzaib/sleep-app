import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashWithLogoScreen extends StatefulWidget {
  const SplashWithLogoScreen({super.key});

  @override
  State<SplashWithLogoScreen> createState() => _SplashWithLogoScreenState();
}

class _SplashWithLogoScreenState extends State<SplashWithLogoScreen> {
  @override
  void initState() {
    super.initState();

    if (mounted) {
      Future.delayed(const Duration(seconds: 2), () {
        NavigationService.goNamed(AppRoutes.welcome);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppConstants.defaultGradient(context),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImagesPng.appLogo, width: 114.w),
            Spacing.y(1),
            Text(
              "StoryPals",
              style: textTheme.headlineLarge?.copyWith(fontSize: 33.sp),
            ),
          ],
        ),
      ),
    );
  }
}
