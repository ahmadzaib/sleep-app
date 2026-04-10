// import 'package:avatar_flow/core/constants/app_constants.dart';
// import 'package:avatar_flow/core/constants/app_icons.dart';
// import 'package:avatar_flow/core/utils/spacing.dart';
// import 'package:avatar_flow/widgets/custom_button.dart';
// import 'package:avatar_flow/widgets/custom_svg.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// class NoResultsWidget extends StatelessWidget {
//   final String? iconPath;
//   final String? title;
//   final String? subTitle;
//   final String? buttonText;
//   final VoidCallback? onButtonPressed;

//   const NoResultsWidget({
//     super.key,
//     this.iconPath,
//     this.title,
//     this.subTitle,
//     this.buttonText,
//     this.onButtonPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: AppConstants.defaultAllPadding,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: EdgeInsets.all(24.r),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.secondary,
//                 shape: BoxShape.circle,
//               ),
//               child: CustomSvg(
//                 path: iconPath ?? AppIconsSvg.bag,
//                 height: 40.r,
//                 width: 40.r,
//                 color: Theme.of(context).colorScheme.onSurface,
//               ),
//             ),
//             Spacing.y(24),

//             Text(
//               title ?? "No results found",
//               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: Theme.of(context).colorScheme.onSurface,
//               ),
//             ),
//                         Spacing.y(12),

//             Text(
//               subTitle ?? "Try different keywords or ask AI to help.",
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
//             ),
//             if (onButtonPressed != null) ...[
//                         Spacing.y(40),

//               CustomButton(
//                 text: buttonText ?? "Go Back",
//                 onPressed: onButtonPressed!,
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
