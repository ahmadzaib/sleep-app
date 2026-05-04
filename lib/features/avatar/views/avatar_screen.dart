import 'package:avatar_flow/core/utils/premium_animation.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/views/components/avatar_appbar.dart';
import 'package:avatar_flow/features/avatar/views/components/avatar_tabs.dart';
import 'package:avatar_flow/features/milestones/views/components/my_avatars_view.dart';
import 'package:avatar_flow/features/avatar/views/shared_avatars_view.dart';
import 'package:avatar_flow/features/avatar/providers/create_avatar_provider.dart';
import 'package:avatar_flow/features/milestones/providers/milestones_provider.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AvatarScreen extends StatefulWidget {
  const AvatarScreen({super.key});

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MilestonesProvider>().fetchMilestones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const HomeAppbar(),
        body: Column(
          children: [
            PremiumAnimation.fadeInDown(
              delay: const Duration(milliseconds: 0),
              duration: const Duration(milliseconds: 400),
              child: Column(children: [Spacing.y(1), const AvatarTabs()]),
            ),
            Expanded(
              child: Consumer<CreateAvatarProvider>(
                builder: (context, provider, child) {
                  return IndexedStack(
                    index: provider.currentIndex,
                    children: const [MyAvatarsView(), SharedAvatarsView()],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
