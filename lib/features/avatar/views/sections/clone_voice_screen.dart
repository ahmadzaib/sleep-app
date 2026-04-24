import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/providers/clone_voice_provider.dart';
import 'package:avatar_flow/features/avatar/views/sections/agreement_page.dart';
import 'package:avatar_flow/features/avatar/views/sections/characteristics_page.dart';
import 'package:avatar_flow/features/avatar/views/components/step_indicator.dart';
import 'package:avatar_flow/features/avatar/views/components/record_page.dart';
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
        appBar: CustomAppBar(
          title: "Clone Voice",
          onBackBtnPress: () {
            if (provider.currentStep > 0) {
              provider.previousStep();
              return;
            }
            NavigationService.pop();
            return;
          },
        ),
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
