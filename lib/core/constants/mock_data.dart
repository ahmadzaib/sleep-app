import 'package:avatar_flow/features/avatar/models/story_model.dart';

String dummyImage =
    "https://thumbs.dreamstime.com/b/beautiful-garden-decorative-wooden-bridge-vector-illustration-spring-flowers-195164545.jpg";

String dummyAvatarUrl =
    "https://images.pexels.com/photos/3373037/pexels-photo-3373037.jpeg";

/// Mock stories using new database structure
final List<Story> mockStories = [
  Story(
    id: 1,
    avatarId: 1,
    title: 'The Adventure Begins',
    description: 'A journey into the unknown',
    content:
        'Once upon a time in a magical land, there was a brave hero who set out on an incredible journey to discover hidden treasures and ancient secrets.',
    images: [
      'https://images.unsplash.com/photo-1512820790803-83ca734da794?q=80&w=1000&auto=format&fit=crop',
    ],
    rating: 4.8,
  ),
  Story(
    id: 2,
    avatarId: 1,
    title: 'Mystery of the Forest',
    description: 'Secrets await in the woods',
    content:
        'Deep within the enchanted forest, secrets waited to be discovered by those brave enough to seek them out and face the challenges ahead.',
    images: [
      'https://images.unsplash.com/photo-1532012197267-da84d127e765?q=80&w=1000&auto=format&fit=crop',
    ],
    rating: 4.5,
  ),
  Story(
    id: 3,
    avatarId: 1,
    title: 'The Lost Treasure',
    description: 'Legends of ancient gold',
    content:
        'Legends spoke of a treasure hidden for centuries, and today our hero was determined to find it no matter what dangers lurked ahead.',
    images: [
      'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=1000&auto=format&fit=crop',
    ],
    rating: 4.9,
  ),
  Story(
    id: 4,
    avatarId: 1,
    title: 'A New Beginning',
    description: 'Every end is a start',
    content:
        'Every ending is just a new beginning. Our hero learned this lesson in the most unexpected way during the journey of a lifetime.',
    images: [
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=1000&auto=format&fit=crop',
    ],
    rating: 4.7,
  ),
];
