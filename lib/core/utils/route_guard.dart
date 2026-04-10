// import 'package:flutter/material.dart';
// import 'package:avatar_flow/core/services/auth_service.dart';
// import 'package:avatar_flow/core/router/navigation_service.dart';
// import 'package:avatar_flow/core/router/routes.dart';

// class RouteGuard {
//   /// Check if user is authenticated and redirect to sign-in if not
//   static Future<bool> requireAuth(BuildContext context) async {
//     final isAuthenticated = await AuthService.isAuthenticated();

//     if (!isAuthenticated) {
//       NavigationService.goNamed(AppRouteNames.signInName);
//       return false;
//     }

//     return true;
//   }

//   /// Check if user is authenticated and redirect to home if they are
//   /// Useful for auth screens (sign-in, sign-up) to prevent authenticated users from accessing them
//   static Future<bool> requireGuest(BuildContext context) async {
//     final isAuthenticated = await AuthService.isAuthenticated();

//     if (isAuthenticated) {
//       NavigationService.goNamed(AppRouteNames.homeName);
//       return false;
//     }

//     return true;
//   }
// }
