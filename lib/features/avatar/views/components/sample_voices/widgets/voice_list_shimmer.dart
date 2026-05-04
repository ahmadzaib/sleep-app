import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'voice_tile_shimmer.dart';

/// Shimmer loading effect for voice list
class VoiceListShimmer extends StatelessWidget {
  const VoiceListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 5,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) => const VoiceTileShimmer(),
    );
  }
}
