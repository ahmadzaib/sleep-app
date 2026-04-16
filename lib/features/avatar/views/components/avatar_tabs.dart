import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/create_avatar/providers/create_avatar_provider.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AvatarTabs extends StatelessWidget {
  const AvatarTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final List<Map<String, dynamic>> avatarData = [
      {'title': 'My Avatar', 'icon': AppIconsSvg.user, "index": 0},
      {'title': 'Shared Avatars', 'icon': AppIconsSvg.twoUsers, "index": 1},
    ];
    return Consumer<CreateAvatarProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: AppConstants.defaultPaddingHorizental,
          child: Row(
            children: [
              ...avatarData.map(
                (data) => ZoomTapAnimation(
                  onTap: () {
                    provider.changeIndex(data['index']!);
                  },
                  child: AnimatedContainer(
                    margin: EdgeInsets.only(right: 8.w),
                    duration: AppConstants.defaultDuration,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.r),
                      color: data['index'] == provider.currentIndex
                          ? context.appColors.secondary
                          : context.appColors.secondary.withValues(alpha: 0.07),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      children: [
                        CustomSvg(
                          path: data['icon']!,
                          color: data["index"] == provider.currentIndex
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                        Spacing.x(2),
                        Text(
                          data['title']!,
                          style: textTheme.bodyMedium!.copyWith(
                            fontSize: 13.sp,
                            color: data["index"] == provider.currentIndex
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
