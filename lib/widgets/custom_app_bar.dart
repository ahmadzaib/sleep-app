import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/widgets/custom_icon_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final String? subtitleText;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool isALigned;

  const CustomAppBar({
    super.key,
    required this.title,
    this.titleWidget,
    this.subtitleText,
    this.actions,
    this.showBackButton = true,
    this.isALigned = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: Padding(
          padding: AppConstants.defaultPaddingHorizental.copyWith(
            bottom: 10.h,
            top: 10.h,
          ),
          child: Row(
            children: [
              showBackButton
                  ? const CustomBackButton()
                  : SizedBox(height: 50.h, width: 24.w),
              Expanded(
                child:
                    titleWidget ??
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                    ),
              ),

              actions != null && actions!.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.only(left: 12.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions!,
                      ),
                    )
                  : isALigned
                  ? SizedBox.shrink()
                  : Spacing.x(30),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 20.h);
}
