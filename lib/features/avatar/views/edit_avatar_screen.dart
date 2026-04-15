import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/views/components/voice_note_tile.dart';
import 'package:avatar_flow/features/avatar_detail/views/components/avatar_section.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/custom_app_bar.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:avatar_flow/widgets/custom_textfield.dart';
import 'package:avatar_flow/widgets/confirmation_dialog.dart';
import 'package:avatar_flow/widgets/circled_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:avatar_flow/features/avatar/providers/avatar_provider.dart';
import 'package:provider/provider.dart';

class EditAvatarScreen extends StatefulWidget {
  const EditAvatarScreen({super.key});

  @override
  State<EditAvatarScreen> createState() => _EditAvatarScreenState();
}

class _EditAvatarScreenState extends State<EditAvatarScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(title: "Edit Avatar", isALigned: true),
        body: Consumer<AvatarProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: AppConstants.defaultPaddingHorizental,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacing.y(2),
                    // Avatar Preview
                    Center(
                      child: Container(
                        height: 0.3.sh,
                        width: 1.sw,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(
                            AppConstants.mediumRadius,
                          ),
                          boxShadow: [AppConstants.defaultShadow],
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: ClipPath(
                                  clipper: MyClipper(),
                                  child: Container(
                                    width: 1.sw,
                                    height: 0.16.sh,
                                    color: Colors.yellow.withValues(alpha: .3),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Image.asset(
                                AppImagesPng.dummyImage,
                                height: 0.22.sh,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacing.y(2.5),
                    // Name Field
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(
                          AppConstants.smallRadius,
                        ),
                        boxShadow: [AppConstants.defaultShadow],
                      ),
                      child: CustomTextField(
                        initialValue: provider.avatarName,
                        onChanged: (val) {
                          provider.updateName(val ?? "");
                          return null;
                        },
                        hintText: "Avatars Name",
                        isFilled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        textfieldBorderRadius: AppConstants.smallRadius,
                        prefixIcon: CustomSvg(
                          path: AppIconsSvg.user,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        borderColor: Colors.transparent,
                      ),
                    ),
                    Spacing.y(2.5),

                    Divider(
                      color: colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                    Spacing.y(2.5),

                    Text(
                      "Gender",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacing.y(.5),
                    Text(
                      "Used to personalize stories and characters",
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    Spacing.y(1.5),

                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppConstants.smallRadius,
                        ),
                        color: colorScheme.surface.withValues(alpha: .55),
                      ),
                      child: Row(
                        children: [
                          _buildGenderChip("Male", provider),
                          Spacing.x(2),
                          _buildGenderChip("Female", provider),
                          Spacing.x(2),
                          _buildGenderChip("Other", provider),
                        ],
                      ),
                    ),
                    Spacing.y(3),
                    // Traits section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Avatar's traits",
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Search",
                            style: textTheme.bodyMedium?.copyWith(
                              color: context.appColors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: provider.traits
                          .map((trait) => _buildTraitChip(trait, provider))
                          .toList(),
                    ),
                    Spacing.y(3),
                    // Voice section
                    Text(
                      "Voice",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacing.y(1.5),
                    VoiceNoteTile(
                      title: 'Avatar Voice',
                      audioPath: 'assets/audio/music.mp3',
                      isNetwork: false,
                    ),

                    Spacing.y(4),
                    // Save Button
                    CustomButton(
                      text: "Save",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Spacing.y(1),
                    // Delete Button
                    Center(
                      child: TextButton(
                        onPressed: () {
                          _showDeleteDialog(context);
                        },
                        child: Text(
                          "Delete",
                          style: textTheme.bodyMedium?.copyWith(
                            color: context.appColors.error,
                          ),
                        ),
                      ),
                    ),
                    Spacing.y(4),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGenderChip(String label, AvatarProvider provider) {
    bool isSelected = provider.selectedGender == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => provider.updateGender(label),
        child: AnimatedContainer(
          duration: AppConstants.defaultDuration,
          height: 34.h,
          decoration: BoxDecoration(
            color: !isSelected
                ? Colors.transparent
                : Color(0xFFCDCDCD26).withValues(alpha: .15),
            borderRadius: BorderRadius.circular(AppConstants.smallRadius),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: .7),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTraitChip(String label, AvatarProvider provider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: context.appColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: context.appColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: context.appColors.primary),
          ),
          Spacing.x(1),
          GestureDetector(
            onTap: () => provider.removeTrait(label),
            child: Icon(
              Icons.close,
              size: 14.sp,
              color: context.appColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    ConfirmationDialog.show(
      context: context,
      title: "Delete avatar",
      subtitle:
          "You are about to delete your avatar. This action can't be undone, Are you sure?",
      confirmText: "Cancel",
      cancelText: "Delete",
      content: CircledIconWidget(
        color: context.appColors.error,
        icon: Icons.warning_amber_rounded,
      ),
      onConfirm: () => Navigator.pop(context),
      onCancel: () {
        // Handle delete
        Navigator.pop(context);
      },
    );
  }
}
