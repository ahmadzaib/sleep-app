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

  bool get hasImage => msg.imagePath != null || msg.imageUrl != null;

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

                  if (hasImage) ...[
                    if (msg.text != null) Spacing.y(2),
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

  Widget _buildImage() {
    final double imageHeight = isUser ? 140.h : 220.h;

    if (msg.imageUrl != null) {
      return CustomCachedNetworkImage(
        imageUrl: msg.imageUrl!,
        height: imageHeight,
        width: double.infinity,
        borderRadius: 0,
        cover: BoxFit.cover,
      );
    }

    if (msg.imagePath != null) {
      return Image.file(
        File(msg.imagePath!),
        height: imageHeight,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return const SizedBox();
  }
}
