import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/providers/create_avatar_provider.dart';
import 'package:avatar_flow/features/avatar/providers/sample_voices_provider.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'sample_voices/widgets/bottom_sheet_handle.dart';
import 'sample_voices/widgets/category_chips.dart';
import 'sample_voices/widgets/title_widget.dart';
import 'sample_voices/widgets/voices_list.dart';

class SampleVoicesBottomSheet extends StatelessWidget {
  const SampleVoicesBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    final createAvatarProvider = context.read<CreateAvatarProvider>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.extraLargeRadius),
        ),
      ),
      builder: (_) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: createAvatarProvider),
          ChangeNotifierProvider(create: (_) => SampleVoicesProvider()),
        ],
        child: const SampleVoicesBottomSheet(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppConstants.paddingOnly,
        right: AppConstants.paddingOnly,
        top: AppConstants.paddingOnly.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: SizedBox(
        height: 0.78.sh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BottomSheetHandle(),
            Spacing.y(1.6),
            const TitleWidget(),
            Spacing.y(2),
            const CategoryChips(),
            Spacing.y(2),
            const Expanded(child: VoicesList()),
            Spacing.y(1),
            CustomButton(
              buttonColor: context.appColors.primary.withValues(alpha: .2),
              textColor: context.appColors.primary,
              text: "Clone your voice instead",
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to voice clone/record screen
                context.read<CreateAvatarProvider>().useDefaultVoice();
              },
            ),
            Spacing.y(1),
            CustomButton(
              text: "Save Selection",
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
