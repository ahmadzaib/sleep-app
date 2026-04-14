import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_tooltip/super_tooltip.dart'
    show
        SuperTooltipController,
        SuperTooltip,
        ArrowConfiguration,
        BarrierConfiguration,
        TooltipStyle;

class CustomToolTip extends StatelessWidget {
  final String text;
  final Widget child;
  final VoidCallback? onClose; // 👈 add this
  const CustomToolTip({
    super.key,
    required SuperTooltipController tooltipController,
    required this.text,
    required this.child,
    this.onClose,
  }) : _tooltipController = tooltipController;

  final SuperTooltipController _tooltipController;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SuperTooltip(
      arrowConfig: ArrowConfiguration(length: 0, tipDistance: 20.h),
      barrierConfig: BarrierConfiguration(color: Colors.transparent),
      style: TooltipStyle(
        boxShadows: [AppConstants.defaultShadow],
        borderColor: Colors.transparent,
        borderRadius: AppConstants.smallRadius,
      ),

      controller: _tooltipController,
      content: Container(
        padding: EdgeInsets.all(4),
        width: 0.6.sw,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(AppImagesPng.award, height: 35),
            Spacing.x(2),
            Expanded(
              child: Text(
                text,
                style: textTheme.bodySmall!.copyWith(fontSize: 14.sp),
              ),
            ),
            IconButton(
              style: IconButton.styleFrom(
                alignment: Alignment.topRight,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                _tooltipController.hideTooltip();
                onClose?.call();
              },
              icon: CustomSvg(path: AppIconsSvg.cross),
            ),
          ],
        ),
      ),
      child: child,
    );
  }
}
