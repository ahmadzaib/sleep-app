import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Text(
        "Choose Your Hero's Voice!",
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 18.sp,
        ),
      ),
    );
  }
}
