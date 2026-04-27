import 'dart:io';

import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/providers/create_avatar_provider.dart';
import 'package:avatar_flow/features/avatar/views/components/sample_voices_bottom_sheet.dart';
import 'package:avatar_flow/features/avatar/views/components/trait_selection_bottom_sheet.dart';
import 'package:avatar_flow/features/avatar/views/components/voice_note_bs_tile.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/circled_icon_widget.dart';
import 'package:avatar_flow/widgets/confirmation_dialog.dart';
import 'package:avatar_flow/widgets/custom_app_bar.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:avatar_flow/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AvatarPreviewScreen extends StatelessWidget {
  const AvatarPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BgWidget(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "",

          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacing.x(13),
              Image.asset(AppImagesPng.appLogo, width: 40),
              Spacing.x(2),
              Text('StoryPals', style: textTheme.headlineMedium),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Consumer<CreateAvatarProvider>(
            builder: (context, provider, _) {
              return SingleChildScrollView(
                padding: AppConstants.defaultPaddingHorizental.copyWith(
                  top: 6.h,
                  bottom: 20.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacing.y(1.8),
                    Text(
                      "Let's Finish Creating\nYour Story Hero",
                      style: textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        // height: 1.15,
                      ),
                    ),
                    Spacing.y(.8),
                    Text(
                      "We use age to tailor stories for your child's development stage.",
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.58),
                        height: 1.45,
                      ),
                    ),
                    Spacing.y(2.4),
                    SizedBox(
                      height: 0.35.sh,
                      child: _AvatarPreviewCard(provider: provider),
                    ),
                    Spacing.y(2),
                    _NameField(provider: provider),
                    Spacing.y(3),
                    Divider(
                      color: colorScheme.onSurface.withValues(alpha: 0.08),
                    ),
                    Spacing.y(2),
                    _DetailsCard(provider: provider),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AvatarPreviewCard extends StatelessWidget {
  const _AvatarPreviewCard({required this.provider});

  final CreateAvatarProvider provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.largeRadius),
        boxShadow: [AppConstants.defaultShadow],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ClipPath(
                clipper: _PreviewShapeClipper(),
                child: Container(
                  height: 0.18.sh,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6EED8),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: _buildAvatarImage(provider, context),
          ),
        ],
      ),
    );
  }

  /// Build avatar image from file path or show placeholder
  Widget _buildAvatarImage(
    CreateAvatarProvider provider,
    BuildContext context,
  ) {
    final imagePath = provider.avatarImagePath;

    if (imagePath == null) {
      // No image generated yet - show placeholder with message
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppImagesPng.dummyImage, height: 0.25.sh),
          SizedBox(height: 8.h),
          Text(
            'Generate an image from Prompt AI',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: context.appColors.grey),
          ),
        ],
      );
    }

    // Show generated image
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Image.file(
        File(imagePath),
        height: 0.25.sh,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(AppImagesPng.dummyImage, height: 0.25.sh);
        },
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({required this.provider});

  final CreateAvatarProvider provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        boxShadow: [AppConstants.defaultShadow],
      ),
      child: CustomTextField(
        initialValue: provider.avatarName,
        onChanged: (value) {
          provider.updateName(value ?? "");
          return null;
        },
        hintText: "Avatar's Name",
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
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.provider});

  final CreateAvatarProvider provider;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gender",
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        Spacing.y(.5),
        Text(
          "Used to personalize stories and characters",
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.58),
          ),
        ),
        Spacing.y(1.5),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(AppConstants.smallRadius),
          ),
          child: Row(
            children: [
              _GenderChip(label: "Male", provider: provider),
              Spacing.x(1),
              _GenderChip(label: "Female", provider: provider),
              Spacing.x(1),
              _GenderChip(label: "Other", provider: provider),
            ],
          ),
        ),
        Spacing.y(2),
        Divider(color: colorScheme.onSurface.withValues(alpha: 0.08)),
        Spacing.y(1.2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Avatar's traits",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () {
                TraitSelectionBottomSheet.show(context, provider: provider);
              },
              child: Text(
                "Add +",
                style: textTheme.bodyMedium?.copyWith(
                  color: context.appColors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: provider.traits
              .map((trait) => _TraitChip(label: trait, provider: provider))
              .toList(),
        ),
        Spacing.y(2),
        Divider(color: colorScheme.onSurface.withValues(alpha: 0.08)),
        Spacing.y(1.2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Voice",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () => SampleVoicesBottomSheet.show(context),
              child: Text(
                "Change",
                style: textTheme.bodyMedium?.copyWith(
                  color: context.appColors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        _buildVoiceInfo(context, provider),
        Spacing.y(3),
        CustomButton(
          text: "Save",
          buttonColor: context.appColors.secondaryBlack,
          onPressed: provider.isCreating ? null : () => provider.createAvatar(),
        ),
        Spacing.y(1),
        Center(
          child: TextButton(
            onPressed: () => _showDeleteDialog(context),
            child: Text(
              "Delete",
              style: textTheme.bodyMedium?.copyWith(
                color: context.appColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build voice info tile based on selected source
  Widget _buildVoiceInfo(BuildContext context, CreateAvatarProvider provider) {
    final textTheme = Theme.of(context).textTheme;
    final hasRecorded = provider.hasRecordedVoice;
    final hasSample = provider.hasSampleVoice;
    final voiceName = provider.effectiveVoiceName;

    // Determine icon and subtitle based on source
    IconData icon;
    String subtitle;
    Color color;

    if (hasRecorded) {
      icon = Icons.mic;
      subtitle = 'Your recorded voice';
      color = context.appColors.primary;
    } else if (hasSample) {
      icon = Icons.headphones;
      subtitle = 'Sample voice';
      color = context.appColors.secondary;
    } else {
      icon = Icons.volume_up;
      subtitle = 'Default AI voice';
      color = context.appColors.grey;
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voiceName,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: context.appColors.grey,
                  ),
                ),
              ],
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
          "You are about to delete your avatar. This action can't be undone, are you sure?",
      confirmText: "Cancel",
      cancelText: "Delete",
      content: CircledIconWidget(
        color: context.appColors.error,
        icon: Icons.warning_amber_rounded,
      ),
      onConfirm: () => Navigator.pop(context),
      onCancel: () => Navigator.pop(context),
    );
  }
}

class _GenderChip extends StatelessWidget {
  const _GenderChip({required this.label, required this.provider});

  final String label;
  final CreateAvatarProvider provider;

  @override
  Widget build(BuildContext context) {
    final isSelected = provider.selectedGender == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => provider.updateGender(label),
        child: AnimatedContainer(
          duration: AppConstants.defaultDuration,
          height: 38.h,
          decoration: BoxDecoration(
            color: isSelected
                ? context.appColors.primary.withValues(alpha: 0.16)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppConstants.smallRadius),
          ),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? context.appColors.primary
                    : Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: .5),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TraitChip extends StatelessWidget {
  const _TraitChip({required this.label, required this.provider});

  final String label;
  final CreateAvatarProvider provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: context.appColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: context.appColors.primary.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.appColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 6.w),
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
}

class _PreviewShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width * 0.07, size.height * 0.50);
    path.quadraticBezierTo(
      size.width * 0.017,
      size.height * 0.526,
      0,
      size.height * 0.596,
    );
    path.quadraticBezierTo(
      size.width * -0.0005,
      size.height * 0.658,
      size.width * -0.002,
      size.height * 0.843,
    );
    path.quadraticBezierTo(
      size.width * -0.0116,
      size.height * 1.013,
      size.width * 0.10,
      size.height * 1.003,
    );
    path.quadraticBezierTo(
      size.width * 0.299,
      size.height * 1.0008,
      size.width * 0.898,
      size.height * 0.993,
    );
    path.quadraticBezierTo(
      size.width * 1.005,
      size.height * 1.018,
      size.width * 1.002,
      size.height * 0.816,
    );
    path.quadraticBezierTo(
      size.width * 1.001,
      size.height * 0.652,
      size.width * 0.998,
      size.height * 0.16,
    );
    path.quadraticBezierTo(
      size.width * 1.005,
      size.height * -0.0057,
      size.width * 0.894,
      size.height * -0.005,
    );
    path.quadraticBezierTo(
      size.width * 0.688,
      size.height * 0.121,
      size.width * 0.07,
      size.height * 0.50,
    );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
