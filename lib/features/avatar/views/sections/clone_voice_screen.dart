import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/auth/services/auth_service.dart';
import 'package:avatar_flow/features/avatar/providers/create_avatar_provider.dart';
import 'package:avatar_flow/features/avatar/views/sections/agreement_page.dart';
import 'package:avatar_flow/features/avatar/views/sections/characteristics_page.dart';
import 'package:avatar_flow/features/avatar/views/components/step_indicator.dart';
import 'package:avatar_flow/features/avatar/views/components/record_page.dart';
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
  bool _hasCheckedAgreement = false;

  @override
  void initState() {
    super.initState();
    _checkUserAgreement();
  }

  Future<void> _checkUserAgreement() async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) {
      setState(() => _hasCheckedAgreement = true);
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('voice_agreement_accepted')
          .eq('id', userId)
          .single();

      final hasAccepted = response['voice_agreement_accepted'] == true;

      if (hasAccepted && mounted) {
        // Skip agreement page - jump to record page
        final provider = context.read<CreateAvatarProvider>();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          provider.voicePageController.jumpToPage(1);
        });
      }
    } catch (e) {
      debugPrint('[CloneVoiceScreen] Error checking agreement: $e');
    } finally {
      if (mounted) {
        setState(() => _hasCheckedAgreement = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateAvatarProvider>();

    if (!_hasCheckedAgreement) {
      return const BgWidget(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: "Clone Voice",
          onBackBtnPress: () {
            if (provider.currentVoiceStep > 0) {
              provider.previousVoiceStep();
              return;
            }
            NavigationService.pop();
            return;
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              StepIndicator(currentStep: provider.currentVoiceStep),
              Spacing.y(1.5),
              Expanded(
                child: PageView(
                  controller: provider.voicePageController,
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
