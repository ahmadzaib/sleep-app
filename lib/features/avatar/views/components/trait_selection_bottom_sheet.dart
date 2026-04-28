import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/models/trait_model.dart';
import 'package:avatar_flow/features/avatar/providers/create_avatar_provider.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:avatar_flow/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TraitSelectionBottomSheet extends StatelessWidget {
  const TraitSelectionBottomSheet({super.key, required this.provider});

  final CreateAvatarProvider provider;

  static final List<TraitModel> traitSuggestions = [
    TraitModel(id: 1, name: 'Adventurous'),
    TraitModel(id: 2, name: 'Brave'),
    TraitModel(id: 3, name: 'Bold'),
    TraitModel(id: 4, name: 'Calm'),
    TraitModel(id: 5, name: 'Charismatic'),
    TraitModel(id: 6, name: 'Cheerful'),
    TraitModel(id: 7, name: 'Curious'),
    TraitModel(id: 8, name: 'Creative'),
    TraitModel(id: 9, name: 'Fearless'),
    TraitModel(id: 10, name: 'Friendly'),
    TraitModel(id: 11, name: 'Kind'),
    TraitModel(id: 12, name: 'Loyal'),
    TraitModel(id: 13, name: 'Playful'),
    TraitModel(id: 14, name: 'Smart'),
    TraitModel(id: 15, name: 'Wise'),
  ];

  static Future<void> show(
    BuildContext context, {
    required CreateAvatarProvider provider,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.extraLargeRadius),
        ),
      ),
      builder: (_) => TraitSelectionBottomSheet(provider: provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final TextEditingController controller = TextEditingController();
    String query = '';

    return StatefulBuilder(
      builder: (context, setModalState) {
        final suggestions = traitSuggestions
            .where(
              (trait) =>
                  !provider.traits.any((t) => t.name == trait.name) &&
                  trait.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
        final normalizedQuery = query.trim();
        final canAdd =
            normalizedQuery.isNotEmpty &&
            !provider.traits.any(
              (trait) =>
                  trait.name.toLowerCase() == normalizedQuery.toLowerCase(),
            );

        return Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 18.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: context.appColors.lightGrey,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
              Spacing.y(1.8),
              Center(
                child: Text(
                  "Trait selection",
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Spacing.y(1.6),
              CustomTextField(
                controller: controller,
                hintText: "Search by trait",
                fillColor: Theme.of(context).colorScheme.surface,
                borderColor: context.appColors.lightGrey.withValues(alpha: 0.8),
                textfieldBorderRadius: AppConstants.mediumRadius,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
                prefixIcon: CustomSvg(
                  path: AppIconsSvg.search,
                  color: context.appColors.grey,
                  size: 20,
                ),
                onChanged: (value) {
                  setModalState(() {
                    query = value ?? '';
                  });
                  return null;
                },
              ),
              if (suggestions.isNotEmpty) ...[
                Spacing.y(1.6),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: suggestions
                      .map(
                        (trait) => InkWell(
                          onTap: () {
                            controller.text = trait.name;
                            controller.selection = TextSelection.collapsed(
                              offset: controller.text.length,
                            );
                            setModalState(() {
                              query = trait.name;
                            });
                          },
                          borderRadius: BorderRadius.circular(999.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999.r),
                              border: Border.all(
                                color: context.appColors.lightGrey,
                              ),
                              color: Colors.transparent,
                            ),
                            child: Text(
                              trait.name,
                              style: textTheme.bodySmall?.copyWith(
                                color: context.appColors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
              Spacing.y(2),
              CustomButton(
                text: "Add Trait",
                onPressed: canAdd
                    ? () {
                        final trait = TraitModel(
                          id: DateTime.now().millisecondsSinceEpoch,
                          name: normalizedQuery,
                        );
                        provider.addTrait(trait);
                        Navigator.of(context).pop();
                      }
                    : null,
                isDisabled: !canAdd,
                buttonColor: context.appColors.secondary,
                textColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ],
          ),
        );
      },
    );
  }
}
