import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvatarCards extends StatelessWidget {
  const AvatarCards({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(height: 100.h, width: 200.w, color: Colors.red);
      },
    );
  }
}
