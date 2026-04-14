import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/theme/app_colors.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/views/components/avatar_appbar.dart';
import 'package:avatar_flow/features/avatar/views/components/avatar_cards.dart';
import 'package:avatar_flow/features/avatar/views/components/avatar_tabs.dart';
import 'package:avatar_flow/features/avatar/views/components/avtar_milestones_tile.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AvatarScreen extends StatelessWidget {
  const AvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: HomeAppbar(),
        body: Column(
          children: [
            Spacing.y(1),
            AvatarTabs(),
            Spacing.y(2),
            AvatarCards(
              onTap: () {
                HapticFeedback.lightImpact();
                NavigationService.pushNamed(AppRoutes.avatarDetail);
              },
            ),
            Spacing.y(2),
            AvtarMilestonesTile(
              title: 'Create 10 avatars',
              totalValue: 10,
              completedValue: 8,
            ),
            Spacing.y(2),
            Padding(
              padding: AppConstants.defaultPaddingHorizental,
              child: CustomButton(
                preffixIconColor: Theme.of(context).colorScheme.onPrimary,
                prefixIcon: AppIconsSvg.edit,
                text: "Create a New Avatar",
                onPressed: () {
                  NavigationService.pushNamed(AppRoutes.createAvatar);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
