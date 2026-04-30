import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/models/story_model.dart';
import 'package:avatar_flow/features/avatar/providers/story_carousel_provider.dart';
import 'package:avatar_flow/widgets/custom_cache_netword_imge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class StoryCards extends StatefulWidget {
  final int avatarId;

  const StoryCards({super.key, required this.avatarId});

  @override
  State<StoryCards> createState() => _StoryCardsState();
}

class _StoryCardsState extends State<StoryCards> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoryCarouselProvider>().loadStories(widget.avatarId);
    });
  }

  @override
  void dispose() {
    context.read<StoryCarouselProvider>().clearStories();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryCarouselProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return SizedBox(
            height: 0.3.sh,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.error != null || provider.stories.isEmpty) {
          return SizedBox(
            height: 0.3.sh,
            child: Center(
              child: Text(
                provider.stories.isEmpty
                    ? 'No stories yet'
                    : 'Error: ${provider.error}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        }

        return SizedBox(
          height: 0.3.sh,
          child: CarouselView.weighted(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            backgroundColor: Colors.transparent,
            flexWeights: const [10, 9, 8],
            children: provider.stories
                .map((e) => _StoryCard(story: e))
                .toList(),
          ),
        );
      },
    );
  }
}

class _StoryCard extends StatelessWidget {
  final Story story;

  const _StoryCard({required this.story});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomCachedNetworkImage(
            imageUrl: story.imageUrl,
            borderRadius: AppConstants.mediumRadius,
            height: null,
            width: null,
          ),
        ),
        Spacing.y(1),
        Text(
          story.title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 16.sp),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Spacing.y(.5),

        Row(
          children: [
            Expanded(
              child: Text(
                story.author,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: .6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              story.ratingString,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: .6),
              ),
            ),
            Spacing.x(1),
            Icon(Icons.star, size: 14.r, color: const Color(0xFFFFD700)),
          ],
        ),
      ],
    );
  }
}
