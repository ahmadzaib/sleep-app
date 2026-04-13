import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';

import 'package:avatar_flow/core/router/navigation_service.dart'
    show NavigationService;

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CustomBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed ?? () => NavigationService.pop(),
      icon: CustomSvg(path: AppIconsSvg.arrowBack),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String svgPath;
  final Color? backgroundColor;
  final Color? iconColor;

  const CustomIconButton({
    super.key,
    this.onPressed,
    required this.svgPath,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor:
            backgroundColor ?? context.appColors.primary.withValues(alpha: .15),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed ?? () => NavigationService.pop(),
      icon: CustomSvg(
        path: svgPath,
        color: iconColor ?? context.appColors.primary,
      ),
    );
  }
}
