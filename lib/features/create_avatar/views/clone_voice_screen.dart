import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/create_avatar/providers/clone_voice_provider.dart';
import 'package:avatar_flow/features/create_avatar/views/agreement_page.dart';
import 'package:avatar_flow/features/create_avatar/views/characteristics_page.dart';
import 'package:avatar_flow/features/create_avatar/views/components/step_indicator.dart';
import 'package:avatar_flow/features/create_avatar/views/record_page.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CloneVoiceScreen extends StatelessWidget {
  const CloneVoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CloneVoiceView();
  }
}

class _CloneVoiceView extends StatelessWidget {
  const _CloneVoiceView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CloneVoiceProvider>();

    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(title: "Clone Voice"),
        body: SafeArea(
          child: Column(
            children: [
              StepIndicator(currentStep: provider.currentStep),
              Spacing.y(1.5),
              Expanded(
                child: PageView(
                  controller: provider.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    AgreementPage(),
                    RecordVoicePage(),
                    CharacterCharacteristicsPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
