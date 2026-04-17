import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubscriptionHero extends StatelessWidget {
  const SubscriptionHero({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Triangle beam
          Positioned(
            top: 0,
            child: Image.asset(
              AppImagesPng.triangle,
              height: 250.h,
              fit: BoxFit.contain,
            ),
          ),
          // Stars scattered
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              AppImagesPng.stars,
              height: 100.h,
              width: 0.5.sw,
              fit: BoxFit.contain,
            ),
          ),
          // Badge center
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              AppImagesPng.badge,
              height: 120.h,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
