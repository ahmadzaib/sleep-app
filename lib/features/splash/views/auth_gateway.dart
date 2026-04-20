import 'package:avatar_flow/core/debug/debug_point.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/services/auth_service.dart';
import 'package:avatar_flow/widgets/app_loading.dart';
import 'package:flutter/material.dart';

class AuthGateway extends StatefulWidget {
  const AuthGateway({super.key});

  @override
  State<AuthGateway> createState() => _AuthGatewayState();
}

class _AuthGatewayState extends State<AuthGateway> {
  @override
  void initState() {
    super.initState();
    // Defer navigation until after build phase to avoid setState during build error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleNavigation();
    });
  }

  Future<void> _handleNavigation() async {
    DebugPoint.log('[AUTH_GATEWAY] Starting navigation decision...');

    // Check auth status first
    final isAuthenticated = AuthService.isAuthenticated();
    DebugPoint.log('[AUTH_GATEWAY] isAuthenticated: $isAuthenticated');

    if (isAuthenticated) {
      DebugPoint.log('[AUTH_GATEWAY] → Navigating to home (authenticated)');
      _navigate(AppRoutes.bottomNavbar);
    } else {
      DebugPoint.log(
        '[AUTH_GATEWAY] → Navigating to welcome (not authenticated)',
      );
      _navigate(AppRoutes.welcome);
    }
  }

  void _navigate(String route) {
    if (!mounted) return;
    NavigationService.goNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: AppLoading()));
  }
}
