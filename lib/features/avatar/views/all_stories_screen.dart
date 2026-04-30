import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/theme/app_theme_extension.dart';
import 'package:avatar_flow/features/avatar/providers/all_stories_provider.dart';
import 'package:avatar_flow/features/avatar/views/components/detail_screen_appbar.dart';
import 'package:avatar_flow/features/avatar/views/components/story_grid_tile.dart';
import 'package:avatar_flow/features/avatar/views/components/story_shimmer_tile.dart';
import 'package:avatar_flow/widgets/bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class AllStoriesScreen extends StatefulWidget {
  final int avatarId;

  const AllStoriesScreen({super.key, required this.avatarId});

  @override
  State<AllStoriesScreen> createState() => _AllStoriesScreenState();
}

class _AllStoriesScreenState extends State<AllStoriesScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoryProvider>().loadStories(widget.avatarId);
    });

    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.dispose();
    // Clear stories to prevent showing wrong avatar's stories on next visit
    context.read<StoryProvider>().clearStories();
    super.dispose();
  }

  void _scrollListener() {
    // Pagination can be added here when needed
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 200) {
      // context.read<StoryProvider>().loadMoreStories();
    }
  }

  Future<void> _onRefresh() async {
    await context.read<StoryProvider>().refreshStories();
  }

  @override
  Widget build(BuildContext context) {
    return BgWidget(
      child: Scaffold(
        appBar: AvatarDetailAppbar(
          title: "All Stories",
          subtitleText: "Browse all available stories",
        ),
        backgroundColor: Colors.transparent,
        body: Consumer<StoryProvider>(
          builder: (context, provider, child) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: context.appColors.primary,
              child: MasonryGridView.builder(
                controller: _controller,
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                padding: AppConstants.defaultPaddingHorizental,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: provider.isLoading && provider.stories.isEmpty
                    ? 6 // Show 6 shimmer tiles when initial loading
                    : provider.stories.length + (provider.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  // Show shimmer tiles when loading and no data yet
                  if (provider.isLoading && provider.stories.isEmpty) {
                    final isTall = index % 3 == 0;
                    return StoryShimmerTile(isTall: isTall);
                  }

                  if (index < provider.stories.length) {
                    final story = provider.stories[index];
                    // Alternate between different heights for visual variety
                    final isTall = index % 3 == 0;
                    return StoryGridTile(story: story, isTall: isTall);
                  } else {
                    // Show shimmer tile at the bottom when loading more
                    return provider.isLoading
                        ? const StoryShimmerTile(isTall: false)
                        : const SizedBox();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
