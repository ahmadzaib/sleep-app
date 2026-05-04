import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Individual shimmer tile
class VoiceTileShimmer extends StatefulWidget {
  const VoiceTileShimmer({super.key});

  @override
  State<VoiceTileShimmer> createState() => _VoiceTileShimmerState();
}

class _VoiceTileShimmerState extends State<VoiceTileShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = context.appColors.lightGrey;
    final shimmerColor = context.appColors.grey.withValues(alpha: 0.3);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          // Radio shimmer
          Container(
            width: 22.w,
            height: 22.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: shimmerColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name shimmer
                Container(
                  width: 120.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 8.h),
                // Tags shimmer
                Container(
                  width: 80.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 10.h),
                // Waveform shimmer
                Row(
                  children: List.generate(
                    14,
                    (index) => Container(
                      margin: EdgeInsets.only(right: 3.w),
                      width: 3.w,
                      height: ((index % 4) + 2) * 4.h,
                      decoration: BoxDecoration(
                        color: shimmerColor,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Play button shimmer
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: shimmerColor,
            ),
          ),
        ],
      ),
    );
  }
}
