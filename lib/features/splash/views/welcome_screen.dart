import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10 * 0.01.sh,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: CustomSvg(
                      path: AppIconsSvg.info,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Image.asset(AppImagesPng.appLogo, width: 64.w),
                  Spacing.y(2),
                  Text(
                    "Let's Start Your Child's Bedtime Adventure",
                    style: textTheme.displayLarge?.copyWith(
                      fontSize: 42.sp,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacing.y(2),
                  Text(
                    "Explore interactive bedtime\nstories tailored for your child",
                    style: textTheme.headlineSmall?.copyWith(fontSize: 18.sp),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Spacer(),

              SizedBox(
                height: 52 * 0.01.sh,
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentGeometry.topCenter,
                      child: Image.asset(
                        AppImagesPng.welcomeImage,
                        width: 270.w,
                      ),
                    ),

                    Stack(
                      children: [
                        Align(
                          alignment: AlignmentGeometry.bottomCenter,
                          child: Image.asset(AppImagesPng.bottomClipPath),
                        ),

                        Padding(
                          padding: AppConstants.defaultAllPadding.copyWith(
                            bottom: 3 * 0.01.sh,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,

                            children: [
                              CustomButton(
                                text: "Login",
                                onPressed: () {
                                  NavigationService.goNamed(AppRoutes.signIn);
                                },
                              ),
                              Spacing.y(2),
                              CustomButton(
                                text: "Sign Up",
                                onPressed: () {
                                  NavigationService.goNamed(AppRoutes.signUp);
                                },
                                isOutlineButton: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
