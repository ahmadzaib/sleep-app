import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/constants/mock_data.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/models/story_model.dart';
import 'package:avatar_flow/widgets/custom_cache_netword_imge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoryCards extends StatelessWidget {
  const StoryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.3.sh,
      child: CarouselView.weighted(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Colors.transparent,
        flexWeights: [10, 9, 8],
        children: mockStories.map((e) => _StoryCard(story: e)).toList(),
      ),
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
              story.rating,
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
