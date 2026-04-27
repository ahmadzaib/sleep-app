import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';

class ConfirmationDialog extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final String? confirmText;
  final String? cancelText;
  final Widget? content;
  final Future<void> Function()? onConfirm;
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
    Future<void> Function()? onConfirm,
    VoidCallback? onCancel,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ConfirmationDialog(
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
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  bool isLoading = false;

  Future<void> _handleConfirm() async {
    if (widget.onConfirm == null) {
      NavigationService.pop();
      return;
    }

    setState(() => isLoading = true);

    try {
      await widget.onConfirm!();

      if (mounted) {
        NavigationService.pop(); // close dialog after success
      }
    } catch (e) {
      // Optional: handle error (show snackbar etc.)
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: context.appColors.error,
            blurRadius: 0,
            offset: const Offset(0, -3),
          ),
        ],
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.largeRadius),
        ),
      ),
      padding: AppConstants.defaultAllPadding.copyWith(top: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacing.y(4),

          if (widget.content != null) ...[widget.content!, Spacing.y(2)],

          // Title
          Text(
            widget.title ?? "Are you sure?",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          Spacing.y(1),

          // Subtitle
          Text(
            widget.subtitle ?? 'Once submitted, this action cannot be undone.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: context.appColors.grey),
          ),

          Spacing.y(3),

          Column(
            children: [
              // Confirm Button
              CustomButton(
                isLoading: isLoading,
                text: widget.confirmText ?? 'Submit',
                onPressed: _handleConfirm,
              ),

              Spacing.y(2),

              // Cancel Button
              CustomButton(
                isOutlineButton: true,
                textColor: context.appColors.error,
                text: widget.cancelText ?? 'Go Back',
                onPressed:
                    widget.onCancel ??
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
