import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class StoryShimmerTile extends StatelessWidget {
  final bool isTall;

  const StoryShimmerTile({super.key, this.isTall = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.lightGrey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer Image
            Shimmer.fromColors(
              baseColor: context.appColors.lightGrey.withValues(alpha: 0.3),
              highlightColor: context.appColors.lightGrey.withValues(
                alpha: 0.1,
              ),
              child: Container(
                height: isTall ? 220.h : 140.h,
                width: double.infinity,
                color: context.appColors.lightGrey,
              ),
            ),

            // Shimmer Content
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title shimmer
                  Shimmer.fromColors(
                    baseColor: context.appColors.lightGrey.withValues(
                      alpha: 0.3,
                    ),
                    highlightColor: context.appColors.lightGrey.withValues(
                      alpha: 0.1,
                    ),
                    child: Container(
                      height: 16.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.appColors.lightGrey,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Author shimmer
                  Shimmer.fromColors(
                    baseColor: context.appColors.lightGrey.withOpacity(0.3),
                    highlightColor: context.appColors.lightGrey.withOpacity(
                      0.1,
                    ),
                    child: Container(
                      height: 12.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: context.appColors.lightGrey,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Rating row shimmer
                  Row(
                    children: [
                      Shimmer.fromColors(
                        baseColor: context.appColors.lightGrey.withOpacity(0.3),
                        highlightColor: context.appColors.lightGrey.withOpacity(
                          0.1,
                        ),
                        child: Container(
                          height: 16.w,
                          width: 16.w,
                          decoration: BoxDecoration(
                            color: context.appColors.lightGrey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Shimmer.fromColors(
                        baseColor: context.appColors.lightGrey.withOpacity(0.3),
                        highlightColor: context.appColors.lightGrey.withOpacity(
                          0.1,
                        ),
                        child: Container(
                          height: 12.h,
                          width: 30.w,
                          decoration: BoxDecoration(
                            color: context.appColors.lightGrey,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Shimmer.fromColors(
                        baseColor: context.appColors.lightGrey.withOpacity(0.3),
                        highlightColor: context.appColors.lightGrey.withOpacity(
                          0.1,
                        ),
                        child: Container(
                          height: 14.w,
                          width: 14.w,
                          decoration: BoxDecoration(
                            color: context.appColors.lightGrey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Shimmer.fromColors(
                        baseColor: context.appColors.lightGrey.withOpacity(0.3),
                        highlightColor: context.appColors.lightGrey.withOpacity(
                          0.1,
                        ),
                        child: Container(
                          height: 12.h,
                          width: 25.w,
                          decoration: BoxDecoration(
                            color: context.appColors.lightGrey,
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
        ),
      ),
    );
  }
}
