import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:avatar_flow/widgets/custom_textfield.dart';
import 'package:avatar_flow/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateAvatarScreen extends StatelessWidget {
  const CreateAvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BgWidget(
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          height: 0.09.sh,
          child: Padding(
            padding: AppConstants.defaultAllPadding,
            child: Center(
              child: CustomButton(
                prefixIcon: AppIconsSvg.magic,
                preffixIconColor: Theme.of(context).colorScheme.onPrimary,
                text: "Need Inspiration?",
                onPressed: () {},
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(
          title: "Create a new avatar",
          isALigned: true,
        ),
        body: Padding(
          padding: AppConstants.defaultPaddingHorizental,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Spacing.y(4),
                // Big card
                Container(
                  height: .35.sh,
                  width: double.infinity,

                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(
                      AppConstants.mediumRadius,
                    ),
                    boxShadow: [AppConstants.defaultShadow],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppImagesPng.add, height: 50),
                      Spacing.y(1.5),
                      Text(
                        "Create New\nAvatar",
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium?.copyWith(
                          color: context.appColors.primary,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacing.y(3),
                // TextField
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [AppConstants.defaultShadow],
                  ),
                  child: CustomTextField(
                    hintText: "Avatars 's Name",
                    isFilled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    textfieldBorderRadius: 12.r,
                    prefixIcon: CustomSvg(
                      path: AppIconsSvg.user,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    borderColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
