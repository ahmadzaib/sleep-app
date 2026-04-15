import 'dart:io';
import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/prompt_ai/providers/prompt_ai_provider.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/custom_app_bar.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'components/prompt_input_section.dart';

class PromptAvatarScreen extends StatefulWidget {
  const PromptAvatarScreen({super.key});

  @override
  State<PromptAvatarScreen> createState() => _PromptAvatarScreenState();
}

class _PromptAvatarScreenState extends State<PromptAvatarScreen> {
  final _tooltipController = SuperTooltipController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(title: "AI Chat"),

        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: PromptInputSection(
              actions: [
                SuperTooltip(
                  // arrowConfig: ArrowConfiguration(length: 0, tipDistance: 20.h),
                  barrierConfig: BarrierConfiguration(
                    color: Colors.transparent,
                  ),
                  style: TooltipStyle(
                    boxShadows: [AppConstants.defaultShadow],
                    borderColor: Colors.transparent,
                    borderRadius: AppConstants.smallRadius,
                  ),

                  controller: _tooltipController,
                  content: Container(
                    padding: EdgeInsets.all(4),
                    width: 0.6.sw,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(AppImagesPng.award, height: 35),
                        Spacing.x(2),
                        Expanded(
                          child: Text(
                            "adsd",
                            style: textTheme.bodySmall!.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        IconButton(
                          style: IconButton.styleFrom(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            _tooltipController.hideTooltip();
                          },
                          icon: CustomSvg(path: AppIconsSvg.cross),
                        ),
                      ],
                    ),
                  ),
                  child: _iconButton(
                    icon: AppIconsSvg.add,
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _tooltipController.showTooltip();
                      });
                    },
                    context: context,
                  ),
                ),

                Spacing.x(2),
                _iconButton(
                  icon: AppIconsSvg.send,
                  onTap: () {},
                  context: context,
                ),
              ],
            ),
          ),
        ),

        body: Consumer<PromptAiProvider>(
          builder: (context, provider, child) {
            final messages = provider.messages;

            // EMPTY STATE (your first screen)
            if (messages.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(AppImagesPng.ai, height: 250),
                    SizedBox(height: 20.h),
                    Text(
                      "Describe an image or add\nsomething from your library.",
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium?.copyWith(
                        color: context.appColors.primary,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              );
            }

            // CHAT UI
            return ListView.builder(
              padding: EdgeInsets.all(12.w),
              itemCount: messages.length + (provider.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == messages.length && provider.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("AI is thinking..."),
                    ),
                  );
                }

                final msg = messages[index];
                final isUser = msg.isUser;

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 6.h),
                    padding: EdgeInsets.all(10.w),
                    constraints: BoxConstraints(maxWidth: 0.75.sw),
                    decoration: BoxDecoration(
                      color: isUser
                          ? context.appColors.primary
                          : context.appColors.lightGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (msg.text != null)
                          Text(
                            msg.text!,
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.black,
                            ),
                          ),
                        if (msg.imagePath != null) ...[
                          SizedBox(height: 8.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(msg.imagePath!),
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _iconButton({
    required String icon,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return ZoomTapAnimation(
      onTap: onTap,
      child: SizedBox(
        height: 40.h,
        child: CircleAvatar(
          radius: 18,
          backgroundColor: context.appColors.primary.withValues(alpha: 0.2),
          child: CustomSvg(
            path: icon,
            color: context.appColors.primary,
            size: 16,
          ),
        ),
      ),
    );
  }
}
