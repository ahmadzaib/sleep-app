import 'package:avatar_flow/core/constants/app_constants.dart';
import 'package:avatar_flow/core/utils/spacing.dart';
import 'package:avatar_flow/features/avatar/models/story_model.dart';
import 'package:avatar_flow/widgets/custom_cache_netword_imge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoryGridTile extends StatelessWidget {
  final Story story;
  final bool isTall;

  const StoryGridTile({super.key, required this.story, this.isTall = false});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        CustomCachedNetworkImage(
          imageUrl: story.imageUrl,
          height: isTall ? 220.h : 140.h,
          width: double.infinity,
          cover: BoxFit.cover,
          borderRadius: AppConstants.mediumRadius,
        ),

        Container(
          padding: AppConstants.defaultAllPadding - EdgeInsets.all(6),
          margin: AppConstants.defaultAllPadding - EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.smallRadius),
            color: Theme.of(
              context,
            ).colorScheme.onPrimary.withValues(alpha: .4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                story.title,
                style: textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              Spacing.y(.5),

              // Author
              Row(
                children: [
                  Text(
                    story.author,
                    style: textTheme.bodySmall!.copyWith(fontSize: 12.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Icon(Icons.star, color: Colors.amber, size: 16.w),
                  Spacing.x(1),
                  Text(
                    story.rating,
                    style: textTheme.bodySmall!.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
