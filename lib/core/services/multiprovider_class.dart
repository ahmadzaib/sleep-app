import 'package:avatar_flow/core/controllers/splash_controller.dart';
import 'package:avatar_flow/core/services/preferences.dart';
import 'package:avatar_flow/core/theme/theme_controller.dart';
import 'package:avatar_flow/features/avatar/providers/avatar_provider.dart';
import 'package:avatar_flow/features/avatar_detail/providers/all_stories_provider.dart';
import 'package:avatar_flow/features/bottom_nav_bar/views/providers/bottom_navbar_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class MultiProviderClass {
  final Preferences prefs;

  MultiProviderClass({required this.prefs});

  List<SingleChildWidget> get providersList => [
    ChangeNotifierProvider(create: (_) => ThemeController(prefs)),
    ChangeNotifierProvider(create: (_) => SplashController()),
    ChangeNotifierProvider(create: (_) => BottomNavProvider()),
    ChangeNotifierProvider(create: (_) => AvatarProvider()),
    ChangeNotifierProvider(create: (_) => StoryProvider()),
  ];
}
