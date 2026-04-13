import 'dart:ui';
import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
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

    _pageController = PageController(viewportFraction: 0.72);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 340.h,
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

                double scale = lerpDouble(1.0, 0.85, distance)!;

                double hPadding = lerpDouble(
                  AppConstants.paddingOnly,
                  0.w,
                  distance,
                )!;

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
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppConstants.largeRadius),
        boxShadow: [AppConstants.defaultShadow],
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
              Spacing.y(2),
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
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {},
              icon: CustomSvg(path: AppIconsSvg.info2),
            ),
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
