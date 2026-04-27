import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/prompt_ai/providers/prompt_ai_provider.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:avatar_flow/widgets/custom_app_bar.dart';
import 'package:avatar_flow/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChoosePersonScreen extends StatefulWidget {
  const ChoosePersonScreen({
    super.key,
    this.sourceImagePath,
    this.sourceImageUrl,
  });

  final String? sourceImagePath;
  final String? sourceImageUrl;

  @override
  State<ChoosePersonScreen> createState() => _ChoosePersonScreenState();
}

class _ChoosePersonScreenState extends State<ChoosePersonScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final selectedImage = context.read<PromptAiProvider>().selectedImage;
    if (selectedImage is String) {
      final existingIndex = PromptAiProvider.peopleOptions.indexOf(
        selectedImage,
      );
      if (existingIndex >= 0) {
        _selectedIndex = existingIndex;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = context.watch<PromptAiProvider>();
    final imageOptions = PromptAiProvider.peopleOptions;

    return BgWidget(
      child: Scaffold(
        appBar: CustomAppBar(title: ""),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeroPreview(context),
              Expanded(
                child: Container(
                  padding: AppConstants.defaultPaddingHorizental,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppConstants.extraLargeRadius),
                    ),
                  ),
                  child: Column(
                    children: [
                      Spacing.y(3),
                      Text(
                        "Choose a person",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                        ),
                      ),
                      Spacing.y(1),
                      Text(
                        "The person or appearance you select will be the\nstarting point for your new image.",
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(
                          color: context.appColors.grey,
                          height: 1.4,
                        ),
                      ),
                      Spacing.y(2),
                      CustomTextButton(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        text: "Done",
                        textStyle: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(
                              color: context.appColors.primary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                        onPressed: () {
                          provider.setSelectedPerson(
                            imageOptions[_selectedIndex],
                          );
                          NavigationService.pop();
                        },
                        borderRadius: 100,
                      ),
                      Spacing.y(2.4),
                      Expanded(
                        child: GridView.builder(
                          itemCount: imageOptions.length,
                          padding: EdgeInsets.all(10),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 18.w,
                                mainAxisSpacing: 18.h,
                                childAspectRatio: 1,
                              ),
                          itemBuilder: (context, index) {
                            final isSelected = index == _selectedIndex;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              },
                              child: AnimatedContainer(
                                duration: AppConstants.defaultDuration,
                                padding: EdgeInsets.all(isSelected ? 3.w : 0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? context.appColors.primary
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    imageOptions[index],
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroPreview(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 0.34.sh,
      child: Center(
        child: CircleAvatar(
          backgroundColor: colorScheme.surface.withValues(alpha: .3),
          radius: 80.r,
          child: Center(
            child: CircleAvatar(
              backgroundColor: colorScheme.surface.withValues(alpha: .3),
              radius: 66.r,
              child: Center(
                child: Image.asset(AppImagesPng.shield, height: 60.h),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
