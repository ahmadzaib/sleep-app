import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/auth/services/auth_service.dart';
import 'package:avatar_flow/features/avatar/providers/create_avatar_provider.dart';
import 'package:avatar_flow/features/avatar/views/sections/agreement_page.dart';
import 'package:avatar_flow/features/avatar/views/sections/characteristics_page.dart';
import 'package:avatar_flow/features/avatar/views/components/step_indicator.dart';
import 'package:avatar_flow/features/avatar/views/components/record_page.dart';
import 'package:avatar_flow/widgets/app_loading.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CloneVoiceScreen extends StatelessWidget {
  const CloneVoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CloneVoiceView();
  }
}

class _CloneVoiceView extends StatefulWidget {
  const _CloneVoiceView();

  @override
  State<_CloneVoiceView> createState() => _CloneVoiceViewState();
}

class _CloneVoiceViewState extends State<_CloneVoiceView> {
  bool _isLoading = true;
  bool _hasAcceptedAgreement = false;

  @override
  void initState() {
    super.initState();
    _checkUserAgreement();
  }

  Future<void> _checkUserAgreement() async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) {
      setState(() {
        _isLoading = false;
        _hasAcceptedAgreement = false;
      });
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('voice_agreement_accepted')
          .eq('id', userId)
          .single();

      final hasAccepted = response['voice_agreement_accepted'] == true;

      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasAcceptedAgreement = hasAccepted;
        });

        // If already accepted, set provider to step 0 (which is now Record page in our 2-page view)
        if (hasAccepted) {
          final provider = context.read<CreateAvatarProvider>();
          // Reset to step 0 since we're showing only 2 pages (Record, Character)
          provider.currentVoiceStep = 0;
        }
      }
    } catch (e) {
      debugPrint('[CloneVoiceScreen] Error checking agreement: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasAcceptedAgreement = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateAvatarProvider>();

    if (_isLoading) {
      return const BgWidget(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: AppLoading()),
        ),
      );
    }

    final pages = _hasAcceptedAgreement
        ? const [RecordVoicePage(), CharacterCharacteristicsPage()]
        : const [
            AgreementPage(),
            RecordVoicePage(),
            CharacterCharacteristicsPage(),
          ];

    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: "Clone Voice",
          onBackBtnPress: () {
            // If showing 2 pages and on first page (Record), or on Agreement page, pop screen
            if (provider.currentVoiceStep == 0) {
              NavigationService.pop();
              return;
            }
            // Otherwise go to previous step
            provider.previousVoiceStep();
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              StepIndicator(
                currentStep: provider.currentVoiceStep,
                totalSteps: pages.length,
                labels: _hasAcceptedAgreement
                    ? const ['Record', 'Character']
                    : const ['Agreement', 'Record', 'Character'],
              ),
              Spacing.y(1.5),
              Expanded(
                child: PageView(
                  controller: provider.voicePageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: pages,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
