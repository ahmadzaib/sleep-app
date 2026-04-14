import 'package:avatar_flow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Story {
  final String title;
  final String author;
  final String rating;
  final String imageUrl;

  Story({
    required this.title,
    required this.author,
    required this.rating,
    required this.imageUrl,
  });
}

class StoryCards extends StatefulWidget {
  const StoryCards({super.key});

  @override
  State<StoryCards> createState() => _StoryCardsState();
}

class _StoryCardsState extends State<StoryCards> {
  late final PageController _controller;
  double _currentPage = 0.0;

  final List<Story> _stories = [
    Story(
      title: 'History name',
      author: 'Linspector',
      rating: '4.8',
      imageUrl:
          'https://images.unsplash.com/photo-1512820790803-83ca734da794?q=80&w=1000&auto=format&fit=crop',
    ),
    Story(
      title: 'History name',
      author: 'Linspector',
      rating: '4.8',
      imageUrl:
          'https://images.unsplash.com/photo-1532012197267-da84d127e765?q=80&w=1000&auto=format&fit=crop',
    ),
    Story(
      title: 'History name',
      author: 'Linspector',
      rating: '4.8',
      imageUrl:
          'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=1000&auto=format&fit=crop',
    ),
    Story(
      title: 'History name',
      author: 'Linspector',
      rating: '4.8',
      imageUrl:
          'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=1000&auto=format&fit=crop',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.45);
    _controller.addListener(_pageListener);
  }

  void _pageListener() {
    setState(() {
      _currentPage = _controller.page ?? 0.0;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_pageListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320.h,
      child: PageView.builder(
        controller: _controller,
        itemCount: _stories.length,
        padEnds: false,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          // Calculate scale based on distance from current page
          double value = 0.0;
          if (_controller.position.haveDimensions) {
            value = index - _currentPage;
          } else {
            value = index.toDouble();
          }

          // Scale only cards to the right of the current page
          double scale = 1.0;
          if (value > 0) {
            scale = 1.0 - (value * 0.15);
          }
          scale = scale.clamp(0.75, 1.0);

          return Transform.scale(
            scale: scale,
            alignment: Alignment.centerLeft,
            child: _StoryCard(story: _stories[index]),
          );
        },
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: Image.network(
              story.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.grey400,
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          story.title,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.grey200,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: Text(
                story.author,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey300,
                  fontSize: 13.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              story.rating,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.grey300,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(Icons.star, size: 14.r, color: const Color(0xFFFFD700)),
          ],
        ),
      ],
    );
  }
}
