import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/providers/avatar_provider.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class PromptInputSection extends StatelessWidget {
  const PromptInputSection({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final provider = Provider.of<AvatarProvider>(context, listen: false);

    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadiusGeometry.vertical(
          top: Radius.circular(AppConstants.mediumRadius),
        ),
        boxShadow: [AppConstants.defaultShadow],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40.h,
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                onChanged: (val) => provider.updatePrompt(val),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.smallRadius,
                    ),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.smallRadius,
                    ),
                    borderSide: BorderSide(color: context.appColors.primary),
                  ),
                  fillColor: context.appColors.lightGrey,
                  filled: true,

                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 14.w, right: 8.w),
                    child: Image.asset(
                      AppImagesPng.appLogo,
                      height: 20,
                      width: 28,
                    ),
                  ),

                  hintText: "Describe an image...",
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: context.appColors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Spacing.x(2),

          _buildIconButton(() {}, AppIconsSvg.user2, context),

          Spacing.x(2),
          _buildIconButton(() {}, AppIconsSvg.add, context),
        ],
      ),
    );
  }

  Widget _buildIconButton(
    VoidCallback onTap,
    String svgPath,
    BuildContext context,
  ) {
    return ZoomTapAnimation(
      onTap: onTap,
      child: SizedBox(
        height: 40.h,
        child: CircleAvatar(
          backgroundColor: context.appColors.primary.withValues(alpha: 0.05),
          child: CustomSvg(
            path: svgPath,
            color: context.appColors.primary,
            size: 16,
          ),
        ),
      ),
    );
  }
}
