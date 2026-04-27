import 'dart:io';

import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/prompt_ai/models/chat_model.dart';
import 'package:avatar_flow/widgets/custom_cache_netword_imge.dart';
import 'package:avatar_flow/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.isUser,
    required this.msg,
    this.onUseAsAvatar,
  });

  final bool isUser;
  final ChatMessage msg;
  final VoidCallback? onUseAsAvatar;

  bool get hasImage => msg.hasImage;

  bool get isImageOnly => hasImage && msg.text == null;

  @override
  Widget build(BuildContext context) {
    final Alignment alignment = isUser
        ? Alignment.centerRight
        : Alignment.centerLeft; // 👈 non-user always centered

    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Align(
        alignment: alignment,
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 6.h),
              padding: EdgeInsets.all(10.w),
              width: isImageOnly ? 0.85.sw : null,
              constraints: BoxConstraints(
                maxWidth: isImageOnly
                    ? isUser
                          ? 0.4.sw
                          : 0.9.sw
                    : 0.75.sw,
              ),

              decoration: BoxDecoration(
                color: isUser
                    ? context.appColors.primary
                    : context.appColors.lightGrey,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (msg.text != null)
                    Text(
                      msg.text!,
                      textAlign: isUser ? TextAlign.start : TextAlign.start,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: isUser
                            ? Theme.of(context).colorScheme.onPrimary
                            : null,
                      ),
                    ),

                  // Show style chip
                  if (msg.style != null) ...[
                    if (msg.text != null) Spacing.y(1),
                    _buildChip(context, icon: Icons.style, label: msg.style!),
                  ],

                  // Show actual image
                  if (hasImage) ...[
                    if (msg.text != null || msg.style != null) Spacing.y(2),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppConstants.smallRadius,
                      ),
                      child: _buildImage(),
                    ),
                  ],
                ],
              ),
            ),

            /// ✅ BUTTON ONLY FOR USER IMAGES
            if (!isUser && hasImage) ...[
              Spacing.y(1),
              CustomTextButton(
                text: "Use as Avatar",
                borderRadius: 100,
                onPressed: onUseAsAvatar,
              ),
              Spacing.y(1),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageChip(
    BuildContext context, {
    required ImageProvider image,
    required String label,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isUser
            ? Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.2)
            : context.appColors.grey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 12.r, backgroundImage: image),
          Spacing.x(1),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: isUser
                  ? Theme.of(context).colorScheme.onPrimary
                  : context.appColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final double imageHeight = isUser ? 140.h : 220.h;
    final double imageWidth = isUser ? 0.6.sw : double.infinity;

    if (msg.imageUrl != null) {
      return CustomCachedNetworkImage(
        imageUrl: msg.imageUrl!,
        height: imageHeight,
        width: imageWidth,
        borderRadius: 0,
        cover: BoxFit.cover,
      );
    }

    if (msg.imagePath != null) {
      // Asset image (from person grid) or File image (from picker)
      final image = msg.isAssetImage
          ? Image.asset(
              msg.imagePath!,
              height: imageHeight,
              width: imageWidth,
              fit: BoxFit.cover,
            )
          : Image.file(
              File(msg.imagePath!),
              height: imageHeight,
              width: imageWidth,
              fit: BoxFit.cover,
            );
      return image;
    }

    return const SizedBox();
  }

  Widget _buildChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isUser
            ? Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.2)
            : context.appColors.grey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isUser
                ? Theme.of(context).colorScheme.onPrimary
                : context.appColors.grey,
          ),
          Spacing.x(1),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: isUser
                  ? Theme.of(context).colorScheme.onPrimary
                  : context.appColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
