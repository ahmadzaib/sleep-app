import 'package:avatar_flow/core/controllers/splash_controller.dart';
import 'package:avatar_flow/core/services/preferences.dart';
import 'package:avatar_flow/core/theme/theme_controller.dart';
import 'package:avatar_flow/features/avatar/providers/avatars_provider.dart';
import 'package:avatar_flow/features/avatar/providers/create_avatar_provider.dart';
import 'package:avatar_flow/features/auth/providers/auth_provider.dart';
import 'package:avatar_flow/features/avatar/providers/all_stories_provider.dart';
import 'package:avatar_flow/features/avatar/providers/story_carousel_provider.dart';
import 'package:avatar_flow/features/bottom_nav_bar/views/providers/bottom_navbar_provider.dart';
import 'package:avatar_flow/features/prompt_ai/providers/prompt_ai_provider.dart';
import 'package:avatar_flow/features/milestones/providers/milestones_provider.dart';
import 'package:avatar_flow/features/subscription/providers/subscription_provider.dart';
import 'package:avatar_flow/features/avatar/providers/avatar_share_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class MultiProviderClass {
  final Preferences prefs;

  MultiProviderClass({required this.prefs});

  List<SingleChildWidget> get providersList => [
    ChangeNotifierProvider(create: (_) => ThemeController(prefs)),
    ChangeNotifierProvider(create: (_) => SplashController()),
    ChangeNotifierProvider(create: (_) => BottomNavProvider()),
    ChangeNotifierProvider(create: (_) => AvatarsProvider()),
    ChangeNotifierProvider(create: (_) => CreateAvatarProvider()),
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => StoryProvider()),
    ChangeNotifierProvider(create: (_) => PromptAiProvider()),
    ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
    ChangeNotifierProvider(create: (_) => AvatarShareProvider()),
    ChangeNotifierProvider(create: (_) => StoryCarouselProvider()),
    ChangeNotifierProvider(create: (_) => MilestonesProvider()),
  ];
}
