import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthPromptRow extends StatelessWidget {
  const AuthPromptRow({
    super.key,
    required this.message,
    required this.actionText,
    required this.onTap,
  });

  final String message;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          message,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: context.appColors.grey,
            fontSize: 13.sp,
          ),
        ),
        CustomTextButton(
          onPressed: onTap,
          text: actionText,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
          backgroundColor: Colors.transparent,
          textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: context.appColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
