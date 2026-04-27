import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/views/components/avatar_cards.dart';
import 'package:avatar_flow/features/avatar/views/components/avtar_milestones_tile.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class MyAvatarsView extends StatelessWidget {
  const MyAvatarsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacing.y(2),
        AvatarCards(),
        Spacing.y(2),
        const AvtarMilestonesTile(
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
              NavigationService.pushNamed(
                AppRoutes.createAvatar,
                queryParameters: const {'isEdit': 'false'},
              );
            },
          ),
        ),
      ],
    );
  }
}
