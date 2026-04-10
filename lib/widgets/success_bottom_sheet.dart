import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessBottomSheet extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget icon;
  final String buttonText;
  final VoidCallback onPressed;

  const SuccessBottomSheet({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.extraLargeRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacing.y(10),
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            child: icon,
          ),
                  Spacing.y(24),

          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
                 Spacing.y(8),

          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: context.appColors.grey,
            ),
          ),
                    Spacing.y(32),

          CustomButton(text: buttonText, onPressed: onPressed),
          Spacing.y(24),
          
        ],
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String subTitle,
    required Widget icon,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => SuccessBottomSheet(
            title: title,
            subTitle: subTitle,
            icon: icon,
            buttonText: buttonText,
            onPressed: onPressed,
          ),
    );
  }
}
