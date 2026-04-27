import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/utils/debug_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/widgets/custom_icon_button.dart';

class AvatarDetailAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String? subtitleText;
  final List<Widget>? actions;
  final bool showBackButton;
  final Widget? widgetWithTitle;

  const AvatarDetailAppbar({
    super.key,
    required this.title,
    this.subtitleText,
    this.actions,
    this.showBackButton = true,
    this.widgetWithTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: Padding(
          padding: AppConstants.defaultPaddingHorizental.copyWith(
            // bottom: 10.h,
            top: 10.h,
            right: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (showBackButton)
                    CustomBackButton(
                      onPressed: () {
                        NavigationService.pop();
                        DebugPoint.log("BACK PRESSED");
                      },
                    ),
                  Padding(
                    padding: AppConstants.defaultPaddingHorizental,
                    child: Row(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(fontSize: 20.sp),
                        ),
                        if (widgetWithTitle != null) widgetWithTitle!,
                      ],
                    ),
                  ),
                  Spacer(),

                  if (actions != null && actions!.isNotEmpty)
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 12.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [...actions!],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              if (subtitleText != null) ...[
                Padding(
                  padding: AppConstants.defaultPaddingHorizental,
                  child: Text(
                    subtitleText!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: .6),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 20.h);
}
