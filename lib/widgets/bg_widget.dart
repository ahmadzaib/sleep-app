import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class BgWidget extends StatelessWidget {
  final Widget child;
  const BgWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppConstants.defaultGradient(context),
      ),
      child: child,
    );
  }
}
