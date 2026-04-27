import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/prompt_ai/providers/prompt_ai_provider.dart';
import 'package:avatar_flow/features/prompt_ai/views/components/chat_bubble_widget.dart';
import 'package:avatar_flow/widgets/app_loading.dart';
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
        appBar: const CustomAppBar(title: ""),

        bottomNavigationBar: _buildInput(),

        body: Consumer<PromptAiProvider>(
          builder: (context, provider, child) {
            final messages = provider.messages;

            // EMPTY STATE (your first screen)
            if (messages.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    Lottie.asset(AppImagesPng.ai, height: 250.h),
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
                  return Padding(
                    padding: EdgeInsets.all(12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          AppLoading(size: 25),
                          Spacing.x(2),
                          Text("AI is thinking..."),
                        ],
                      ),
                    ),
                  );
                }

                final msg = messages[index];
                final isUser = msg.isUser;

                return ChatBubble(
                  isUser: isUser,
                  msg: msg,
                  onUseAsAvatar:
                      (!isUser &&
                          (msg.imagePath != null || msg.imageUrl != null))
                      ? () {
                          NavigationService.pushNamed(
                            AppRoutes.choosePerson,
                            extra: <String, dynamic>{
                              'imagePath': msg.imagePath,
                              'imageUrl': msg.imageUrl,
                            },
                          );
                        }
                      : null,
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

  Widget _columnInfo(
    String imagePath,
    String text,
    TextTheme textTheme,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: isSelected ? 28.r : 26.r,
            backgroundColor: isSelected
                ? context.appColors.primary
                : context.appColors.primary.withValues(alpha: .3),
            backgroundImage: AssetImage(imagePath),
            child: isSelected
                ? Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
          Spacing.y(.5),
          Text(
            text,
            style: textTheme.bodySmall!.copyWith(
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              color: isSelected ? context.appColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowInfo(
    VoidCallback onTap,
    String title,
    String svgPath,
    TextTheme textTheme,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
        child: Row(
          children: [
            Text(
              title,
              style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w600),
            ),
            Spacer(),
            CustomSvg(path: svgPath, color: context.appColors.grey, size: 18),
          ],
        ),
      ),
    );
  }

  _buildInput() {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: PromptInputSection(
          actions: [
            _iconButton(
              icon: AppIconsSvg.user2,
              onTap: () {
                NavigationService.pushNamed(AppRoutes.choosePerson);
              },
              context: context,
            ),
            Spacing.x(2),

            SuperTooltip(
              arrowConfig: ArrowConfiguration(
                length: 20.h,
                tipDistance: 14.h,
                baseWidth: 18.w,
              ),
              barrierConfig: BarrierConfiguration(color: Colors.transparent),
              positionConfig: PositionConfiguration(
                preferredDirection: TooltipDirection.up,
                // verticalOffset: -30.h,
              ),
              style: TooltipStyle(
                boxShadows: [AppConstants.defaultShadow],
                borderColor: Colors.transparent,
                borderRadius: AppConstants.mediumRadius,
              ),

              controller: _tooltipController,
              content: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                width: 0.55.sw,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Choose style", style: textTheme.bodyMedium),
                    Spacing.y(2),
                    Consumer<PromptAiProvider>(
                      builder: (context, provider, _) {
                        final styles = PromptAiProvider.styleOptions;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: styles.map((style) {
                            final isSelected =
                                provider.selectedStyle == style['name'];
                            return _columnInfo(
                              style['image']!,
                              style['name']!,
                              textTheme,
                              isSelected,
                              () => provider.setSelectedStyle(
                                isSelected ? null : style['name'],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    Spacing.y(1.5),
                    Text(
                      'Create an image based on a photo of pets, nature or food.',
                      style: textTheme.bodySmall,
                    ),
                    Spacing.y(1.5),
                    _rowInfo(
                      () async {
                        final provider = context.read<PromptAiProvider>();
                        await _tooltipController.hideTooltip();
                        await provider.pickImageFromGallery();
                      },
                      "Choose Photo",
                      AppIconsSvg.gallery,
                      textTheme,
                    ),
                    _rowInfo(
                      () async {
                        final provider = context.read<PromptAiProvider>();
                        await _tooltipController.hideTooltip();
                        await provider.pickImageFromCamera();
                      },
                      "Take Photo",
                      AppIconsSvg.camera,
                      textTheme,
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
              onTap: () {
                context.read<PromptAiProvider>().sendMessage();
              },
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}
