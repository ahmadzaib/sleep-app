import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/models/trait_model.dart';
import 'package:avatar_flow/features/avatar/providers/create_avatar_provider.dart';
import 'package:avatar_flow/widgets/app_loading.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:avatar_flow/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TraitSelectionBottomSheet extends StatefulWidget {
  const TraitSelectionBottomSheet({super.key, required this.provider});

  final CreateAvatarProvider provider;

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
  State<TraitSelectionBottomSheet> createState() =>
      _TraitSelectionBottomSheetState();
}

class _TraitSelectionBottomSheetState extends State<TraitSelectionBottomSheet> {
  @override
  void initState() {
    super.initState();
    // Fetch traits if not already loaded
    if (widget.provider.availableTraits.isEmpty &&
        !widget.provider.isLoadingTraits) {
      widget.provider.fetchAvailableTraits();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final TextEditingController controller = TextEditingController();
    String query = '';

    return StatefulBuilder(
      builder: (context, setModalState) {
        final availableTraits = widget.provider.availableTraits;
        final suggestions = availableTraits
            .where(
              (trait) =>
                  !widget.provider.traits.any((t) => t.name == trait.name) &&
                  trait.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
        final normalizedQuery = query.trim();
        final canAdd =
            normalizedQuery.isNotEmpty &&
            !widget.provider.traits.any(
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
              // Show loading or suggestions
              if (widget.provider.isLoadingTraits)
                const Center(child: AppLoading(size: 40))
              else if (widget.provider.traitsError != null)
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: context.appColors.error,
                        size: 32,
                      ),
                      Spacing.y(1),
                      Text(
                        'Failed to load traits',
                        style: textTheme.bodyMedium?.copyWith(
                          color: context.appColors.error,
                        ),
                      ),
                      Spacing.y(1),
                      TextButton(
                        onPressed: () => widget.provider.fetchAvailableTraits(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              else if (suggestions.isNotEmpty) ...[
                Spacing.y(1.6),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: suggestions
                      .map(
                        (trait) => InkWell(
                          onTap: widget.provider.hasReachedMaxTraits
                              ? null // Disable when max reached
                              : () {
                                  // Add trait immediately and clear search
                                  widget.provider.addTrait(trait);
                                  controller.clear();
                                  setModalState(() {
                                    query = '';
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
                                color: widget.provider.hasReachedMaxTraits
                                    ? context.appColors.lightGrey.withValues(
                                        alpha: 0.5,
                                      )
                                    : context.appColors.lightGrey,
                              ),
                              color: Colors.transparent,
                            ),
                            child: Text(
                              trait.name,
                              style: textTheme.bodySmall?.copyWith(
                                color: widget.provider.hasReachedMaxTraits
                                    ? context.appColors.grey.withValues(
                                        alpha: 0.5,
                                      )
                                    : context.appColors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
              // Show selected traits count
              if (widget.provider.traits.isNotEmpty) ...[
                Spacing.y(1.6),
                Text(
                  '${widget.provider.traits.length}/${CreateAvatarProvider.maxTraits} traits selected',
                  style: textTheme.bodySmall?.copyWith(
                    color: widget.provider.hasReachedMaxTraits
                        ? context.appColors.primary
                        : context.appColors.grey,
                    fontWeight: widget.provider.hasReachedMaxTraits
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
              // Show max reached message
              if (widget.provider.hasReachedMaxTraits) ...[
                Spacing.y(1),
                Text(
                  'Maximum ${CreateAvatarProvider.maxTraits} traits reached',
                  style: textTheme.bodySmall?.copyWith(
                    color: context.appColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              Spacing.y(2),
              // Custom trait button (only when search doesn't match existing AND not at max)
              if (canAdd && !widget.provider.hasReachedMaxTraits)
                CustomButton(
                  text: "Add \"$normalizedQuery\"",
                  onPressed: () {
                    final trait = TraitModel(
                      id: DateTime.now().millisecondsSinceEpoch,
                      name: normalizedQuery,
                    );
                    widget.provider.addTrait(trait);
                    controller.clear();
                    setModalState(() {
                      query = '';
                    });
                  },
                  buttonColor: context.appColors.secondary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                )
              else
                CustomButton(
                  text: "Done",
                  onPressed: () => Navigator.of(context).pop(),
                  buttonColor: context.appColors.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),
            ],
          ),
        );
      },
    );
  }
}
