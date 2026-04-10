import 'package:avatar_flow/core/router/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  NavigationService._();

  static BuildContext? get context =>   rootNavigatorKey.currentContext;

  static void pushNamed(
    String name, {
    Object? extra,
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
  }) {
    if (context != null) {
      context!.pushNamed(
        name,
        extra: extra,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
      );
    }
  }

  static void push(String location, {Object? extra}) {
    if (context != null) {
      context!.push(location, extra: extra);
    }
  }

  static void go(String location, {Object? extra}) {
    if (context != null) {
      context!.go(location, extra: extra);
    }
  }

  static void goNamed(
    String name, {
    Object? extra,
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
  }) {
    if (context != null) {
      context!.goNamed(
        name,
        extra: extra,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
      );
    }
  }

  static void replace(String location, {Object? extra}) {
    if (context != null) {
      context!.replace(location, extra: extra);
    }
  }

  static void pop<T extends Object?>([T? result]) {
    if (context != null && context!.canPop()) {
      context!.pop(result);
    }
  }
}
