import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/views/components/avatar_appbar.dart';
import 'package:avatar_flow/features/avatar/views/components/avatar_cards.dart';
import 'package:avatar_flow/features/avatar/views/components/avatar_tabs.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:flutter/material.dart';

class AvatarScreen extends StatelessWidget {
  const AvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: HomeAppbar(),
        body: Column(children: [Spacing.y(2), AvatarTabs(), AvatarCards()]),
      ),
    );
  }
}
