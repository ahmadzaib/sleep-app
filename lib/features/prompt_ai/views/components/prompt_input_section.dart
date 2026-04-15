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

  const PromptInputSection({super.key,required this.actions});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PromptAiProvider>(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [AppConstants.defaultShadow],
      ),
      child: Row(
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
                    borderSide: BorderSide(color: context.appColors.primary),
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

         ...actions
        ],
      ),
    );
  }
}