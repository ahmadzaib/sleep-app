import 'package:avatar_flow/features/avatar/providers/sample_voices_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'default_voice_tile.dart';
import 'sample_voice_tile.dart';
import 'voice_list_shimmer.dart';

class VoicesList extends StatelessWidget {
  const VoicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SampleVoicesProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const VoiceListShimmer();
        }

        final voices = provider.filteredVoices;

        // Build list with default voice as first item
        final itemCount = voices.isEmpty ? 1 : voices.length + 1;

        return ListView.separated(
          itemCount: itemCount,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            // First item is always the Default voice
            if (index == 0) {
              return const DefaultVoiceTile();
            }
            // Rest are sample voices
            return SampleVoiceTile(voice: voices[index - 1]);
          },
        );
      },
    );
  }
}
