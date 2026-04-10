import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';

class ConfirmationDialog extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? confirmText;
  final String? cancelText;
  final Widget? content;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    this.title,
    this.subtitle,
    this.confirmText,
    this.cancelText,
    this.content,
    this.onConfirm,
    this.onCancel,
  });

  static void show({
    required BuildContext context,
    String? title,
    String? subtitle,
    String? confirmText,
    String? cancelText,
    Widget? content,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => ConfirmationDialog(
            title: title,
            subtitle: subtitle,
            confirmText: confirmText,
            cancelText: cancelText,
            content: content,
            onConfirm: onConfirm,
            onCancel: onCancel,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstants.largeRadius),
          topRight: Radius.circular(AppConstants.largeRadius),
        ),
      ),
      padding: AppConstants.defaultAllPadding.copyWith(top: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const BottomsheetHandle(),
          Spacing.y(10),
          // Title
          Text(
            title ?? "Are you sure?",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          Spacing.y(6),

          if (content != null) ...[content!, SizedBox(height: 16.h)],

          // Subtitle
          Text(
            subtitle ?? 'Once submitted, this action cannot be undone.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: context.appColors.grey),
          ),

                    Spacing.y(24),


          // Action Buttons
          Column(
            children: [
              // Confirm Button
              CustomButton(
                text: confirmText ?? 'Submit',
                onPressed:
                    onConfirm ??
                    () {
                      NavigationService.pop();
                    },
              ),

              SizedBox(height: 16.h),

              // Cancel Button
              CustomButton(
                isOutlineButton: true,
                textColor: Theme.of(context).colorScheme.onSurface,
                buttonColor: Theme.of(context).colorScheme.onSurface,
                text: cancelText ?? 'Go Back',
                onPressed:
                    onCancel ??
                    () {
                      NavigationService.pop();
                    },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ],
      ),
    );
  }
}
