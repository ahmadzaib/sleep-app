import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';

class CustomShimmer extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const CustomShimmer({super.key, required this.child, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return Shimmer.fromColors(
      baseColor: context.appColors.lightGrey,
      highlightColor: context.appColors.bubbleGray,
      child: child,
    );
  }
}
