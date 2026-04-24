import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/views/components/avatar_cards.dart';
import 'package:avatar_flow/widgets/circled_icon_widget.dart';
import 'package:avatar_flow/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SharedAvatarsView extends StatelessWidget {
  const SharedAvatarsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacing.y(2),
        AvatarCards(
          onTap: () {
            HapticFeedback.lightImpact();
            NavigationService.pushNamed(AppRoutes.avatarDetail);
          },
          showRemoveButton: true,
          onRemoveTap: () {
            ConfirmationDialog.show(
              content: CircledIconWidget(
                color: context.appColors.error,
                icon: Icons.warning,
              ),
              context: context,
              title: "Remove Avatar",
              subtitle: "Are you sure, You want to remove this avatar?",
              confirmText: "Remove",
              cancelText: "Cancel",
            );
          },
        ),
      ],
    );
  }
}
