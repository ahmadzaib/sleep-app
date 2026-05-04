import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/auth/models/user_model.dart';
import 'package:avatar_flow/features/avatar/providers/avatar_share_provider.dart';
import 'package:avatar_flow/widgets/app_loading.dart';
import 'package:avatar_flow/widgets/custom_cache_netword_imge.dart';
import 'package:avatar_flow/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ShareAvatarBottomSheet extends StatefulWidget {
  final int avatarId;
  const ShareAvatarBottomSheet({super.key, required this.avatarId});

  static Future<void> show(BuildContext context, int avatarId) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShareAvatarBottomSheet(avatarId: avatarId),
    );
  }

  @override
  State<ShareAvatarBottomSheet> createState() => _ShareAvatarBottomSheetState();
}

class _ShareAvatarBottomSheetState extends State<ShareAvatarBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AvatarShareProvider>().fetchSuggestions();
      context.read<AvatarShareProvider>().clearSearchResults();
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

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.all(20.r),
      child: Consumer<AvatarShareProvider>(
        builder: (context, provider, child) {
          final showSuggestions = _searchController.text.isEmpty;
          final List<UserModel> displayUsers = showSuggestions
              ? provider.suggestedUsers
              : provider.searchResults;

          return Column(
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: context.appColors.lightGrey,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Spacing.y(2),
              Text(
                'Share Avatar',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 16.sp,
                ),
              ),
              Spacing.y(2),
              CustomTextField(
                controller: _searchController,
                hintText: 'Search by name or email',
                prefixIcon: Icon(
                  Icons.search,
                  size: 20.r,
                  color: context.appColors.grey,
                ),
                onChanged: (val) {
                  provider.searchUsers(val ?? '');
                  return null;
                },
              ),
              Spacing.y(2),
              Expanded(
                child: provider.isSearching
                    ? const Center(child: AppLoading(size: 40))
                    : displayUsers.isEmpty
                    ? Center(
                        child: Text(
                          _searchController.text.isEmpty
                              ? 'Enter a name to search'
                              : 'No users found',
                          style: textTheme.bodySmall?.copyWith(
                            color: context.appColors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: displayUsers.length,
                        itemBuilder: (context, index) {
                          final user = displayUsers[index];
                          final isAlreadyShared = provider.recipients.any(
                            (u) => u.id == user.id,
                          );

                          return _buildUserTile(
                            context,
                            user: user,
                            isAlreadyShared: isAlreadyShared,
                            onShare: () async {
                              await provider.shareAvatar(
                                widget.avatarId,
                                user.id,
                              );
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserTile(
    BuildContext context, {
    required UserModel user,
    required bool isAlreadyShared,
    required VoidCallback onShare,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          CustomCachedNetworkImage(
            imageUrl: user.avatarUrl,
            height: 36.r,
            width: 36.r,
            borderRadius: 36.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? 'Anonymous',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  user.email,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    color: context.appColors.grey,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: isAlreadyShared ? null : onShare,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              isAlreadyShared ? 'Shared' : 'Share',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isAlreadyShared
                    ? context.appColors.grey
                    : context.appColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
