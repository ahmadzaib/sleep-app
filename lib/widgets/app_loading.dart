import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppLoading extends StatelessWidget {
  final Color? color;
  final double size;
  const AppLoading({super.key, this.color, this.size = 50.0});

  @override
  Widget build(BuildContext context) {
    return SpinKitDoubleBounce(
      color: color ?? Theme.of(context).colorScheme.primary,
      size: size,
    );
  }
}
