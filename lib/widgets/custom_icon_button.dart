// import 'package:avatar_flow/core/utils/haptic_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:avatar_flow/core/constants/app_constants.dart';
// import 'package:avatar_flow/core/constants/app_icons.dart';
// import 'package:avatar_flow/core/router/navigation_service.dart'
//     show NavigationService;
// import 'package:avatar_flow/core/theme/app_theme_extension.dart';
// import 'package:avatar_flow/widgets/custom_svg.dart';

// class CustomBackButton extends StatelessWidget {
//   final VoidCallback? onPressed;
//   final Color? bgColor;
//   final Color? iconColor;
//   final double? size;
//   final double? iconSize;

//   const CustomBackButton({
//     super.key,
//     this.onPressed,
//     this.bgColor,
//     this.iconColor,
//     this.size,
//     this.iconSize,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CustomIconButton(
//       iconPath: AppIconsSvg.arrowBack,
//       onPressed: onPressed ?? () => NavigationService.pop(),
//       bgColor: bgColor,
//       iconColor: iconColor,
//       size: size,
//       iconSize: iconSize,
//     );
//   }
// }

// class CustomIconButton extends StatelessWidget {
//   final bool isOulined;
//   final Color? bgColor;
//   final Color? iconColor;
//   final String? iconPath;
//   final IconData? iconData;
//   final VoidCallback? onPressed;
//   final double? size;
//   final double? iconSize;

//   const CustomIconButton({
//     super.key,
//     this.iconPath,
//     this.iconData,
//     this.onPressed,
//     this.bgColor,
//     this.iconColor,
//     this.isOulined = false,
//     this.size,
//     this.iconSize,
//   }) : assert(iconPath != null || iconData != null);

//   @override
//   Widget build(BuildContext context) {
//     final double buttonSize = size ?? AppConstants.defaultIconButtonSize;
//     return IconButton(
//       onPressed: () {
//         HapticHelper.lightImpact();
//         onPressed?.call();
//       },
//       padding: EdgeInsets.zero,
//       constraints: BoxConstraints(minHeight: buttonSize, minWidth: buttonSize),
//       icon: Container(
//         padding: EdgeInsets.all(1.r),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: context.appColors.lightGrey.withValues(alpha: 0.5),
//             width: 0.5.r,
//           ),
//         ),
//         child: CircleAvatar(
//           radius: buttonSize / 2,
//           backgroundColor:
//               isOulined
//                   ? Theme.of(context).colorScheme.secondary
//                   : (bgColor ?? Theme.of(context).colorScheme.secondary),
//           child:
//               isOulined
//                   ? CircleAvatar(
//                     radius: (buttonSize / 2) - 1.r,
//                     backgroundColor:
//                         bgColor ?? Theme.of(context).colorScheme.surface,
//                     child: _buildIcon(context),
//                   )
//                   : _buildIcon(context),
//         ),
//       ),
//     );
//   }

//   Widget _buildIcon(BuildContext context) {
//     if (iconData != null) {
//       return Center(
//         child: Icon(
//           iconData,
//           size: iconSize ?? AppConstants.defaultIconSize,
//           color: iconColor ?? Theme.of(context).colorScheme.onSurface,
//         ),
//       );
//     }
//     return Center(
//       child: CustomSvg(
//         path: iconPath!,
//         height: iconSize ?? AppConstants.defaultIconSize,
//         color: iconColor,
//       ),
//     );
//   }
// }
