import 'package:avatar_flow/core/constants/app_icons.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/providers/create_avatar_provider.dart';
import 'package:avatar_flow/widgets/app_loading.dart';
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
  void initState() {
    super.initState();
    // Fetch traits from Supabase when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateAvatarProvider>().fetchAvailableTraits();
    });
  }

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
      child: Consumer<CreateAvatarProvider>(
        builder: (context, provider, _) {
          final selectedTraits = provider.traits;
          final query = _query.trim().toLowerCase();

          final availableTraits = provider.availableTraits;
          final suggestions = availableTraits
              .where(
                (t) =>
                    !selectedTraits.any((st) => st.name == t.name) &&
                    (query.isEmpty || t.name.toLowerCase().contains(query)),
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
                              trait.name,
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

              // Show loading while fetching traits
              if (provider.isLoadingTraits)
                const Center(child: AppLoading(size: 40))
              else if (provider.traitsError != null)
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
                        onPressed: () => provider.fetchAvailableTraits(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              else
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
                                    trait.name,
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
                onPressed: () async {
                  final provider = context.read<CreateAvatarProvider>();

                  // Show loading dialog while removing background
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const _CreatingAvatarDialog(),
                  );

                  // Prepare avatar (remove background)
                  final success = await provider.prepareAvatarForPreview();

                  // Close loading dialog
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }

                  // Navigate to preview if successful
                  if (success) {
                    NavigationService.pushNamed(AppRoutes.avatarPreview);
                  }
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

/// Loading dialog shown while removing background and preparing avatar
class _CreatingAvatarDialog extends StatelessWidget {
  const _CreatingAvatarDialog();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 48.w,
              height: 48.h,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ),
            Spacing.y(3),
            Text(
              'Creating your avatar...',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Spacing.y(1),
            Text(
              'Removing background',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
