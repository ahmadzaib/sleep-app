import 'package:avatar_flow/core/constants/app_icons.dart';
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
