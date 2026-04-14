import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/image_picker_helper.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/custom_app_bar.dart';
import 'package:avatar_flow/widgets/custom_icon_button.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:avatar_flow/features/avatar/providers/avatar_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PromptAvatarScreen extends StatelessWidget {
  const PromptAvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(title: ""),
        body: Consumer<AvatarProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                Lottie.asset(AppImagesPng.ai, animate: true, height: 300),
                Text(
                  "Describe an image or add\na suggestion from your library.",
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium?.copyWith(
                    color: context.appColors.primary,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                    fontSize: 16.sp,
                  ),
                ),
                Spacer(),
                Container(
                  margin: AppConstants.defaultAllPadding,
                  height: 60.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [AppConstants.defaultShadow],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 24.r,
                        width: 24.r,
                        decoration: BoxDecoration(
                          color: context.appColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.blur_on,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                      Spacing.x(3),
                      Expanded(
                        child: TextField(
                          onChanged: (val) => provider.updatePrompt(val),
                          decoration: InputDecoration(
                            hintText: "Describe an image...",
                            hintStyle: textTheme.bodyMedium?.copyWith(
                              color: context.appColors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Link to camera or gallery
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: context.appColors.primary.withValues(
                              alpha: 0.05,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: CustomSvg(
                            path: AppIconsSvg.user,
                            color: context.appColors.primary,
                            size: 16,
                          ),
                        ),
                      ),
                      Spacing.x(2),
                      GestureDetector(
                        onTap: () {
                          ImagePickerHelper.pickFromCamera();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: context.appColors.primary.withValues(
                              alpha: 0.05,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            color: context.appColors.primary,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
