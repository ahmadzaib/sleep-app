// import 'package:avatar_flow/core/constants/app_constants.dart';
// import 'package:avatar_flow/core/constants/app_images.dart';
// import 'package:avatar_flow/core/theme/app_theme_extension.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class AvatarCards extends StatefulWidget {
//   const AvatarCards({super.key});

//   @override
//   State<AvatarCards> createState() => _AvatarCardsState();
// }

// class _AvatarCardsState extends State<AvatarCards> {
//   late PageController _pageController;
//   double _currentPage = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     // viewportFraction < 1.0 allows the side cards to be visible
//     _pageController = PageController(viewportFraction: 0.7);
//     _pageController.addListener(() {
//       setState(() {
//         _currentPage = _pageController.page!;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return SizedBox(
//       height: 330.h, // Adjusted height for the design
//       child: PageView.builder(
//         padEnds: false,
//         controller: _pageController,
//         itemCount: 10,
//         physics: const BouncingScrollPhysics(),
//         itemBuilder: (context, index) {
//           // Calculate scale based on distance from current page
//           double relativePosition = index - _currentPage;
//           double scale = (1 - (relativePosition.abs() * 0.15)).clamp(0.8, 1.0);

//           return Transform.scale(scale: scale, child: _buildCard(index, theme));
//         },
//       ),
//     );
//   }

//   Widget _buildCard(int index, ThemeData theme) {
//     return Container(
//       margin: EdgeInsets.only(
//         left: index == _currentPage ? AppConstants.paddingOnly : 0,
//       ),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surface.withValues(alpha: .5),
//         borderRadius: BorderRadius.circular(
//           index == _currentPage
//               ? AppConstants.largeRadius
//               : AppConstants.extraLargeRadius,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Info Icon Top Right
//           Align(
//             alignment: Alignment.topRight,
//             child: Padding(
//               padding: EdgeInsets.all(12.w),
//               child: Icon(
//                 Icons.info_outline,
//                 color: Colors.deepPurple,
//                 size: 20.sp,
//               ),
//             ),
//           ),
//           // Character Image Placeholder
//           Expanded(child: Center(child: Image.asset(AppImagesPng.dummyImage))),
//           // Text Details
//           Padding(
//             padding: EdgeInsets.only(bottom: 20.h),
//             child: Column(
//               children: [
//                 Text(
//                   "Lilian",
//                   style: TextStyle(
//                     fontSize: 22.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   "Linspector",
//                   style: TextStyle(fontSize: 16.sp, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
// }

import 'dart:ui';

import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvatarCards extends StatefulWidget {
  const AvatarCards({super.key});

  @override
  State<AvatarCards> createState() => _AvatarCardsState();
}

class _AvatarCardsState extends State<AvatarCards> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // ✅ viewportFraction thoda bada kiya taake cards properly visible hon
    _pageController = PageController(viewportFraction: 0.72);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 320.h,
      child: ClipRRect(
        child: PageView.builder(
          controller: _pageController,
          itemCount: 10,
          padEnds: false,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                double page = 0;
                if (_pageController.hasClients &&
                    _pageController.page != null) {
                  page = _pageController.page!;
                }

                double distance = (page - index).abs().clamp(0.0, 1.0);

                // ✅ Smooth scale: active = 1.0, inactive = 0.88
                double scale = lerpDouble(1.0, 0.85, distance)!;

                // ✅ Horizontal padding bhi animate hogi — yeh lag wali feeling remove karta hai
                double hPadding = lerpDouble(
                  AppConstants.paddingOnly,
                  0.w,
                  distance,
                )!;

                // ✅ Opacity bhi smooth hogi

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPadding),
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.centerLeft,
                    child: _buildCard(index, theme),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(int index, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppConstants.largeRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: AppConstants.defaultAllPadding,
              child: Image.asset(AppImagesPng.cardVector),
            ),
          ),
          Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.deepPurple,
                    size: 20.sp,
                  ),
                ),
              ),
              Expanded(
                child: Center(child: Image.asset(AppImagesPng.dummyImage)),
              ),
              Spacing.y(1),

              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Column(
                  children: [
                    Text(
                      "Lilian",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontSize: 18.sp,
                      ),
                    ),
                    Spacing.y(.5),
                    Text(
                      "Linspector",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: .5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
