import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/views/avatar_screen.dart';
import 'package:avatar_flow/features/bottom_nav_bar/views/providers/bottom_navbar_provider.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BottomNavProvider>(context);

    final List<Widget> screens = [
      Container(color: Colors.red),
      AvatarScreen(),
      Container(color: Colors.blue),
      Container(color: Colors.green),
    ];

    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            /// 👇 PageView with animation
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                provider.changeIndex(index);
              },
              children: screens,
            ),

            /// 👇 Floating Navbar
            Positioned(
              left: AppConstants.paddingOnly,
              right: AppConstants.paddingOnly,
              bottom: AppConstants.paddingOnly,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(100.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _navItem(AppIconsSvg.home, "Home", 0),
                    _navItem(AppIconsSvg.user, "Avatar", 1),
                    _navItem(AppIconsSvg.speech, "Speak", 2),
                    _navItem(AppIconsSvg.search, "Search", 3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(String icon, String label, int index) {
    final provider = Provider.of<BottomNavProvider>(context);
    final isSelected = provider.currentIndex == index;
    final textTheme = Theme.of(context).textTheme;

    return ZoomTapAnimation(
      onTap: () {
        provider.changeIndex(index);

        /// 👇 Animate to page
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 7.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: .2)
              : Colors.transparent,
        ),
        child: Column(
          children: [
            CustomSvg(
              size: 18,
              path: icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
            Spacing.y(.3),

            Text(
              label,
              style: textTheme.bodySmall!.copyWith(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
