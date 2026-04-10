import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/constants/keys.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/widgets/custom_cache_netword_imge.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});
  @override
  Size get preferredSize => Size.fromHeight(90.h);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return PreferredSize(
      preferredSize: preferredSize,
      child: Align(
        alignment: AlignmentGeometry.bottomCenter,
        child: Padding(
          padding: AppConstants.defaultPaddingHorizental,
          child: SizedBox(
            height: 70.h,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Avatars",
                        style: textTheme.headlineSmall?.copyWith(
                          fontSize: 23.sp,
                        ),
                      ),
                      Text(
                        "Manage and create unique avatars for your stories.",
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                          color: context.appColors.secondaryBlack.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Spacing.x(4),
                CustomSvg(path: AppIconsSvg.shield),
                Spacing.x(2),
                CustomCachedNetworkImage(
                  imageUrl: Keys.placeHolderImage,
                  height: 44.h,
                  width: 44.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
