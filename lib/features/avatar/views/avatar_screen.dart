import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/views/components/avatar_appbar.dart';
import 'package:avatar_flow/features/avatar/views/components/avatar_tabs.dart';
import 'package:avatar_flow/features/avatar/views/my_avatars_view.dart';
import 'package:avatar_flow/features/avatar/views/shared_avatars_view.dart';
import 'package:avatar_flow/features/avatar/providers/create_avatar_provider.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AvatarScreen extends StatelessWidget {
  const AvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const HomeAppbar(),
        body: Column(
          children: [
            Spacing.y(1),
            const AvatarTabs(),
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
