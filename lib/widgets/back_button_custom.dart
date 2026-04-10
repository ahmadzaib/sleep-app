import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';

class BackButtonCustom extends StatelessWidget {
  const BackButtonCustom({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.pop(context);
          },
      child: Container(
        width: 35.sp,
        height: 35.sp,
        padding: EdgeInsets.all(6.sp),
        margin: EdgeInsets.only(right: 10.w),
        decoration: BoxDecoration(
          border: Border.all(color: context.appColors.secondaryBlack),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: SvgPicture.asset(
          "",
          // AssetsConstants.arrowBack,
          colorFilter: ColorFilter.mode(
            context.appColors.secondaryBlack,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
