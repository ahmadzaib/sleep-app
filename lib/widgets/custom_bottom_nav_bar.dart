// import 'package:avatar_flow/core/utils/haptic_helper.dart';
// import 'package:avatar_flow/core/constants/app_strings.dart';
// import 'package:avatar_flow/core/extensions/app_localizations_extension.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:avatar_flow/core/constants/app_constants.dart';
// import 'package:avatar_flow/core/constants/app_icons.dart';
// import 'package:avatar_flow/core/theme/app_theme_extension.dart';
// import 'package:avatar_flow/widgets/custom_svg.dart';
// import 'package:avatar_flow/core/router/routes.dart';
// import 'package:go_router/go_router.dart';

// class CustomBottomNavBar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemSelected;

//   const CustomBottomNavBar({
//     super.key,
//     required this.selectedIndex,
//     required this.onItemSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: AppConstants.defaultPaddingHorizental.copyWith(
//         bottom: AppConstants.paddingOnly,
//       ),
//       height: 70.h,
//       child: LiquidGlassLayer(
//         settings: LiquidGlassSettings(
//           blur: 20,
//           thickness: 1.5,
//           glassColor: context.appColors.bubbleGray.withValues(alpha: 0.8),
//           refractiveIndex: 1.1,
//           lightIntensity: 0.4,
//           ambientStrength: 0.5,
//         ),
//         child: LiquidGlass(
//           shape: LiquidRoundedRectangle(borderRadius: 35.r),
//           glassContainsChild: false,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildNavItem(
//                 0,
//                 AppIconsSvg.home,
//                 context.tr(AppStrings.navHome),
//                 context,
//               ),
//               _buildNavItem(
//                 1,
//                 AppIconsSvg.chat,
//                 context.tr(AppStrings.navChat),
//                 context,
//               ),

//               GestureDetector(
//                 onTap: () {
//                   HapticHelper.mediumImpact();
//                   context.pushNamed(AppRouteNames.aiAssistantName);
//                 },
//                 child: Container(
//                   padding: EdgeInsets.all(10.r),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.primary,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.auto_awesome,
//                     color: Colors.white,
//                     size: 24.r,
//                   ),
//                 ),
//               ),
//               _buildNavItem(
//                 2,
//                 AppIconsSvg.bag,
//                 context.tr(AppStrings.navCart),
//                 context,
//               ),
//               _buildNavItem(
//                 3,
//                 AppIconsSvg.user,
//                 context.tr(AppStrings.navProfile),
//                 context,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(
//     int index,
//     String iconOutlined,
//     String label,
//     BuildContext context,
//   ) {
//     bool isSelected = selectedIndex == index;

//     return GestureDetector(
//       onTap: () {
//         HapticHelper.selectionClick();
//         onItemSelected(index);
//       },
//       behavior: HitTestBehavior.opaque,
//       child: AnimatedContainer(
//         duration: AppConstants.defaultDuration,
//         curve: Curves.easeInOut,
//         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//         child: CustomSvg(
//           path: iconOutlined,
//           color: isSelected ? Theme.of(context).colorScheme.primary : null,
//           height: 24.h,
//         ),
//       ),
//     );
//   }
// }
