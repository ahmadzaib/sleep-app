import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastUtils {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get _context => navigatorKey.currentContext;

  static void success(String message) {
    final context = _context;
    if (context == null) return;
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.bottomCenter,
    );
  }

  static void error(String message) {
    final context = _context;
    if (context == null) return;
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.bottomCenter,
    );
  }

  static void warning(String message) {
    final context = _context;
    if (context == null) return;
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.warning,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.bottomCenter,
    );
  }

  static void info(String message) {
    final context = _context;
    if (context == null) return;
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.info,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.bottomCenter,
    );
  }

  static void show(String message) {
    final context = _context;
    if (context == null) return;
    toastification.show(
      context: context,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.bottomCenter,
    );
  }

  static void custom({
    required String title,
    String? description,
    ToastificationType type = ToastificationType.info,
    ToastificationStyle style = ToastificationStyle.flat,
    Duration autoCloseDuration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
    IconData? icon,
    Color? primaryColor,
    Color? backgroundColor,
  }) {
    final context = _context;
    if (context == null) return;
    toastification.show(
      context: context,
      title: Text(title),
      description: description != null ? Text(description) : null,
      type: type,
      style: style,
      autoCloseDuration: autoCloseDuration,
      alignment: alignment,
      icon: icon != null ? Icon(icon) : null,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
    );
  }
}
