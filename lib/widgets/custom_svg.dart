import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';

class CustomSvg extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;
  final Color? color;

  const CustomSvg({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? context.appColors.iconColor;

    return SvgPicture.asset(
      path,
      height: height,
      width: width,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(iconColor, BlendMode.srcIn),
      fit: BoxFit.contain,
    );
  }
}
