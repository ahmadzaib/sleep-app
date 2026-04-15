import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/features/avatar/views/components/prompt_input_section.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/custom_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:avatar_flow/features/avatar/providers/avatar_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PromptAvatarScreen extends StatelessWidget {
  const PromptAvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BgWidget(
      child: Scaffold(
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: PromptInputSection(),
          ),
        ),
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(title: ""),
        body: Consumer<AvatarProvider>(
          builder: (context, provider, child) {
            return SizedBox(
              width: 1.sw,
              child: Column(
                children: [
                  Lottie.asset(AppImagesPng.ai, animate: true, height: 300),
                  Text(
                    "Describe an image or add\na suggestion from your library.",
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
          },
        ),
      ),
    );
  }
}
