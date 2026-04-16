import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/create_avatar/providers/clone_voice_provider.dart';
import 'package:avatar_flow/widgets/custom_button.dart';
import 'package:avatar_flow/widgets/custom_svg.dart';
import 'package:avatar_flow/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CharacterCharacteristicsPage extends StatefulWidget {
  const CharacterCharacteristicsPage({super.key});

  @override
  State<CharacterCharacteristicsPage> createState() =>
      _CharacterCharacteristicsPageState();
}

class _CharacterCharacteristicsPageState
    extends State<CharacterCharacteristicsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      child: Consumer<CloneVoiceProvider>(
        builder: (context, provider, _) {
          final selectedTraits = provider.traits;
          final query = _query.trim().toLowerCase();

          final suggestions = CloneVoiceProvider.traitSuggestions
              .where(
                (t) =>
                    !selectedTraits.contains(t) &&
                    (query.isEmpty || t.toLowerCase().contains(query)),
              )
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Character Characteristics',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacing.y(2.0),
              if (selectedTraits.isNotEmpty) ...[
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: selectedTraits.map((trait) {
                    return InkWell(
                      onTap: () => provider.toggleTrait(trait),
                      borderRadius: BorderRadius.circular(100.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999.r),

                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              trait,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacing.x(2),
                            Icon(
                              Icons.close_rounded,
                              size: 16.sp,
                              color: context.appColors.primary,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Spacing.y(2.0),
              ],
              CustomTextField(
                controller: _searchController,
                hintText: 'Search',
                prefixIcon: CustomSvg(path: AppIconsSvg.search, size: 20),
                onChanged: (val) {
                  setState(() {
                    _query = val ?? '';
                  });
                  return null;
                },
              ),
              Spacing.y(2),
              Text('All', style: textTheme.headlineMedium),
              Spacing.y(2),

              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: suggestions.isNotEmpty
                    ? suggestions
                          .map(
                            (trait) => InkWell(
                              onTap: () => provider.toggleTrait(trait),
                              borderRadius: BorderRadius.circular(999.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999.r),
                                  border: Border.all(
                                    color: context.appColors.lightGrey,
                                  ),
                                ),
                                child: Text(
                                  trait,
                                  style: textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList()
                    : [
                        Text(
                          'No traits found',
                          style: textTheme.bodySmall?.copyWith(),
                        ),
                      ],
              ),
              const Spacer(),
              CustomButton(
                text: 'Next',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Character characteristics saved'),
                    ),
                  );
                },
              ),
              Spacing.y(1.5),
            ],
          );
        },
      ),
    );
  }
}
