// import 'package:avatar_flow/core/constants/app_constants.dart';
// import 'package:avatar_flow/core/theme/app_theme_extension.dart';
// import 'package:avatar_flow/core/utils/haptic_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CustomSocialButton extends StatelessWidget {
//   final String text;
//   final String imagePath;
//   final VoidCallback onPressed;
//   final Color? color;

//   const CustomSocialButton({
//     super.key,
//     required this.text,
//     required this.imagePath,
//     required this.onPressed,
//     this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return MaterialButton(
//       minWidth: double.infinity,
//       padding: EdgeInsets.symmetric(vertical: 14.h),
//       shape: RoundedRectangleBorder(
//         side: BorderSide(color: context.appColors.lightGrey),
//         borderRadius: BorderRadius.circular(AppConstants.largeRadius),
//       ),
//       elevation: 0,
//       color: Theme.of(context).colorScheme.surface,
//       onPressed: () {
//         HapticHelper.mediumImpact();
//         onPressed();
//       },
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(imagePath, height: 22.r, width: 22.r, color: color),
//           12.width,
//           Text(
//             text,
//             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//               fontWeight: FontWeight.w600,
//               fontSize: 14.sp,
//               color: Theme.of(context).colorScheme.onSurface,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
