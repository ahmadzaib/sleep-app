import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/image_picker_helper.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:avatar_flow/features/avatar/providers/avatar_provider.dart';
import 'package:provider/provider.dart';

class PromptAvatarScreen extends StatelessWidget {
  const PromptAvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 18.sp),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Consumer<AvatarProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          height: 200.r,
                          width: 200.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                const Color(0xFFE0C3FC),
                                const Color(0xFF8EC5FC),
                                Colors.white.withValues(alpha: 0.1),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withValues(alpha: 0.2),
                                blurRadius: 50.r,
                                spreadRadius: 10.r,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacing.y(4),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          "Describe an image or add a suggestion from your library.",
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium?.copyWith(
                            color: context.appColors.primary,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      Spacing.y(10), // Push content up
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 30.h),
                    child: Container(
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
