import 'dart:io';

import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/prompt_ai/providers/prompt_ai_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';

class PromptInputSection extends StatelessWidget {
  final List<Widget> actions;

  const PromptInputSection({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PromptAiProvider>(context);
    final textTheme = Theme.of(context).textTheme;
    final selectedImage = provider.selectedImage;
    final selectedStyle = provider.selectedStyle;
    final hasImage = provider.hasSelectedImage;
    final isAsset = provider.isAssetImage;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [AppConstants.defaultShadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Selected image/style row
          if (hasImage || (selectedStyle != null && selectedStyle.isNotEmpty))
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Wrap(
                spacing: 8.w,
                children: [
                  // Selected image (person or picked)
                  if (hasImage)
                    _buildImageChip(
                      context,
                      image: isAsset
                          ? AssetImage(selectedImage as String)
                          : FileImage(selectedImage as File),
                      label: isAsset ? "Person" : "Image",
                      onClear: () => provider.clearSelectedImage(),
                    ),
                  // Selected style
                  if (selectedStyle != null && selectedStyle.isNotEmpty)
                    _buildChip(
                      context,
                      icon: Icons.style,
                      label: selectedStyle,
                      onClear: () => provider.setSelectedStyle(null),
                    ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40.h,
                  child: TextField(
                    controller: provider.promptController,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (val) => provider.updatePrompt(val),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.smallRadius,
                        ),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.smallRadius,
                        ),
                        borderSide: BorderSide(
                          color: context.appColors.primary,
                        ),
                      ),
                      fillColor: context.appColors.lightGrey,
                      filled: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 14.w, right: 8.w),
                        child: Image.asset(
                          AppImagesPng.appLogo,
                          height: 20,
                          width: 28,
                        ),
                      ),
                      hintText: "Describe an image...",
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: context.appColors.grey,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Spacing.x(2),
              ...actions,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageChip(
    BuildContext context, {
    required ImageProvider image,
    required String label,
    required VoidCallback onClear,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: context.appColors.lightGrey,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 14.r, backgroundImage: image),
          Spacing.x(1),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(color: context.appColors.grey),
          ),
          Spacing.x(1),
          GestureDetector(
            onTap: onClear,
            child: Icon(Icons.close, size: 16, color: context.appColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onClear,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: context.appColors.lightGrey,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: context.appColors.grey),
          Spacing.x(1),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(color: context.appColors.grey),
          ),
          Spacing.x(1),
          GestureDetector(
            onTap: onClear,
            child: Icon(Icons.close, size: 16, color: context.appColors.grey),
          ),
        ],
      ),
    );
  }
}
