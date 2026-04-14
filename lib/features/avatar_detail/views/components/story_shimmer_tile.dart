import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class StoryShimmerTile extends StatelessWidget {
  final bool isTall;

  const StoryShimmerTile({super.key, this.isTall = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        // Image placeholder with shimmer
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
          child: Shimmer.fromColors(
            baseColor: Colors.white.withValues(alpha: 0.3),
            highlightColor: Colors.white.withValues(alpha: 0.3),
            child: Container(
              height: isTall ? 220.h : 140.h,
              width: double.infinity,
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
        ),

        // Glassmorphism text container shimmer at bottom
        Container(
          padding: EdgeInsets.all(10.w),
          margin: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.smallRadius),
            color: Colors.white.withValues(alpha: 0.15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title shimmer
              Shimmer.fromColors(
                baseColor: Colors.white.withValues(alpha: 0.4),
                highlightColor: Colors.white.withValues(alpha: 0.2),
                child: Container(
                  height: 14.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),

              SizedBox(height: 6.h),

              // Author and rating row shimmer
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Author shimmer
                  Shimmer.fromColors(
                    baseColor: Colors.white.withValues(alpha: 0.35),
                    highlightColor: Colors.white.withValues(alpha: 0.15),
                    child: Container(
                      height: 12.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  // Star icon shimmer
                  Shimmer.fromColors(
                    baseColor: Colors.white.withValues(alpha: 0.35),
                    highlightColor: Colors.white.withValues(alpha: 0.15),
                    child: Container(
                      height: 12.w,
                      width: 12.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  SizedBox(width: 4.w),

                  // Rating shimmer
                  Shimmer.fromColors(
                    baseColor: Colors.white.withValues(alpha: 0.35),
                    highlightColor: Colors.white.withValues(alpha: 0.15),
                    child: Container(
                      height: 12.h,
                      width: 25.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
