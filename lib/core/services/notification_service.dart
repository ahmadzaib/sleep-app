// import 'dart:convert' show jsonEncode;
// import 'dart:io' show Platform;
// import 'dart:typed_data';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:nb_utils/nb_utils.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin =
//       FlutterLocalNotificationsPlugin();

//   // Add static flag to prevent multiple initializations
//   static bool _isInitialized = false;
//   static bool _isListenersSet = false;

//   String? fCMToken;

//   // Enhanced device token retrieval
//   static Future<String?> getDeviceToken({int maxRetries = 3}) async {
//     try {
//       NotificationSettings settings = await FirebaseMessaging.instance
//           .requestPermission(
//             alert: true,
//             badge: true,
//             sound: true,
//             criticalAlert: true,
//           );

//       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//         log('User granted permission');

//         String? token = await FirebaseMessaging.instance.getToken();
//         log("FCM Device token : $token");
//         await setValue("fcm_token", token);
//         return token;
//       } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
//         log('User denied permission');
//         return null;
//       } else {
//         log('Permission not determined or restricted');
//         return null;
//       }
//     } catch (e) {
//       log("Failed to get device token: $e");
//       if (maxRetries > 0) {
//         log("Retrying after 10 seconds...");
//         await Future.delayed(const Duration(seconds: 10));
//         return getDeviceToken(maxRetries: maxRetries - 1);
//       } else {
//         return null;
//       }
//     }
//   }

//   static Future initNotifications() async {
//     // Prevent multiple initializations
//     if (_isInitialized) {
//       log('NotificationService already initialized, skipping...');
//       return;
//     }

//     _isInitialized = true;
//     log('Initializing NotificationService...');

//     await getDeviceToken();

//     // Initialize local notifications first
//     await localNotiInit();

//     // Set up Firebase messaging listeners only once
//     if (!_isListenersSet) {
//       await _setupFirebaseListeners();
//       _isListenersSet = true;
//     }
//   }

//   static Future<void> _setupFirebaseListeners() async {
//     log('Setting up Firebase messaging listeners...');

//     // Get initial message if the application has been opened from a terminated state
//     final RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();

//     // Check notification data
//     if (initialMessage != null) {
//       debugPrint('getInitialMessage() -> data: ${initialMessage.data}');
//       onNotificationClick(openRoute: true, message: initialMessage);
//     }

//     // Listen for when user presses a notification message displayed via FCM
//     // Note: A Stream event will be sent if the app has opened from a background state (not terminated)
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       debugPrint('onMessageOpenedApp() -> data: ${message.data}');
//       onNotificationClick(openRoute: true, message: message);
//     });

//     // Listen for incoming push notifications when app is in foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       debugPrint('onMessage() -> data: ${message.data}');
//       onNotificationClick(message: message);
//     });

//     log('Firebase messaging listeners set up successfully');
//   }

//   // Add method to reset initialization (useful for testing or if needed)
//   static void resetInitialization() {
//     _isInitialized = false;
//     _isListenersSet = false;
//     log('NotificationService initialization reset');
//   }

//   // Handle notification click. E.g: open a route..
//   static Future<void> onNotificationClick({
//     bool openRoute = false,
//     RemoteMessage? message,
//   }) async {
//     // Vars
//     // Map<String, dynamic>? payload = message?.data;
//     // String type = payload!['type'] ?? '';

//     // if (type == "audio_call" || type == "video_call") {
//     //   final String callerId = payload['caller_id']?.toString() ?? '';
//     //   final String callerName = payload['caller_name']?.toString() ?? 'Unknown';
//     //   final String callerAvatar = payload['caller_avatar']?.toString() ?? '';

//     //   if (callerId.isNotEmpty) {
//     //     // Add check to prevent multiple navigation to call screen
//     //     if (navigatorKey.currentState != null) {
//     //       // Check if call screen is already on top
//     //       final currentRoute =
//     //           ModalRoute.of(navigatorKey.currentContext!)?.settings.name;
//     //       if (currentRoute != '/call_screen') {
//     //         // navigatorKey.currentState!.push(
//     //         //   MaterialPageRoute(
//     //         //     settings: const RouteSettings(name: '/call_screen'),
//     //         //     builder:
//     //         //         (context) => CallScreen(
//     //         //           callType: type,
//     //         //           userName: callerName,
//     //         //           userImageUrl: callerAvatar,
//     //         //           userId: callerId,
//     //         //         ),
//     //         //   ),
//     //         // );
//     //       } else {
//     //         debugPrint('Call screen already open, ignoring duplicate call');
//     //       }
//     //     }
//     //   } else {
//     //     debugPrint('Error: Missing caller_id in notification data');
//     //   }
//     //   return;
//     // }

//     // Non-call notifications fall back to notifications tab (if provided)
//     showSimpleNotification(
//       title: message!.notification!.title ?? "",
//       body: message.notification!.body ?? "",
//       payload: jsonEncode(message.data),
//     );
//   }

//   // Enhanced local notification initialization
//   static Future localNotiInit() async {
//     // Android settings with proper channel configuration
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/launcher_icon');

//     // iOS settings with call category
//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//           requestAlertPermission: true,
//           requestBadgePermission: true,
//           requestSoundPermission: true,
//           requestCriticalPermission: true,
//         );

//     // Common initialization settings
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//           android: initializationSettingsAndroid,
//           iOS: initializationSettingsDarwin,
//         );

//     // Platform-specific permission handling
//     if (Platform.isAndroid) {
//       // Create notification channels for Android
//       await _createNotificationChannels();

//       // Request notification permission for Android
//       await _flutterLocalNotificationPlugin
//           .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin
//           >()
//           ?.requestNotificationsPermission();
//     } else if (Platform.isIOS) {
//       // Setup iOS notification categories
//       await _setupIOSNotificationCategories();

//       // Request notification permission for iOS
//       final bool? permissionGranted = await _flutterLocalNotificationPlugin
//           .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin
//           >()
//           ?.requestPermissions(
//             alert: true,
//             badge: true,
//             sound: true,
//             critical: true,
//           );

//       if (!(permissionGranted ?? false)) {
//         return;
//       }
//     }

//     // Initialize notifications with the settings
//     await _flutterLocalNotificationPlugin.initialize(initializationSettings);
//   }

//   // Create Android notification channels
//   static Future<void> _createNotificationChannels() async {
//     final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//         _flutterLocalNotificationPlugin
//             .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin
//             >();

//     if (androidImplementation != null) {
//       // Call notification channel
//       AndroidNotificationChannel callChannel = AndroidNotificationChannel(
//         'incoming_calls',
//         'Incoming Calls',
//         description: 'Notifications for incoming calls',
//         importance: Importance.max,
//         playSound: true,
//         // sound: RawResourceAndroidNotificationSound('call_ringtone'),
//         enableVibration: true,
//         vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
//         showBadge: true,
//       );

//       // Regular notification channel
//       const AndroidNotificationChannel generalChannel =
//           AndroidNotificationChannel(
//             'general_notifications',
//             'General Notifications',
//             description: 'General app notifications',
//             importance: Importance.high,
//             playSound: true,
//             enableVibration: true,
//           );

//       await androidImplementation.createNotificationChannel(callChannel);
//       await androidImplementation.createNotificationChannel(generalChannel);
//     }
//   }

//   // Setup iOS notification categories
//   static Future<void> _setupIOSNotificationCategories() async {
//     final IOSFlutterLocalNotificationsPlugin? iosImplementation =
//         _flutterLocalNotificationPlugin
//             .resolvePlatformSpecificImplementation<
//               IOSFlutterLocalNotificationsPlugin
//             >();

//     if (iosImplementation != null) {
//       await iosImplementation.initialize(DarwinInitializationSettings());

//       // Define call notification category with actions
//       DarwinNotificationCategory callCategory = DarwinNotificationCategory(
//         'call_category',
//         actions: <DarwinNotificationAction>[
//           DarwinNotificationAction.plain(
//             'accept_call',
//             'Accept',
//             options: <DarwinNotificationActionOption>{
//               DarwinNotificationActionOption.foreground,
//             },
//           ),
//           DarwinNotificationAction.plain(
//             'decline_call',
//             'Decline',
//             options: <DarwinNotificationActionOption>{
//               DarwinNotificationActionOption.destructive,
//             },
//           ),
//         ],
//         options: <DarwinNotificationCategoryOption>{
//           DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
//         },
//       );

//       await iosImplementation.initialize(
//         DarwinInitializationSettings(notificationCategories: [callCategory]),
//       );
//     }
//   }

//   // Method to manually cancel call notification
//   static Future<void> cancelCallNotification() async {
//     await _flutterLocalNotificationPlugin.cancel(0);
//   }

//   // Enhanced simple notification
//   static Future showSimpleNotification({
//     required String title,
//     required String body,
//     required String payload,
//   }) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//           'general_notifications',
//           'General Notifications',
//           channelDescription: 'General app notifications',
//           importance: Importance.high,
//           priority: Priority.high,
//           ticker: 'ticker',
//           playSound: true,
//           enableVibration: true,
//         );

//     const DarwinNotificationDetails iOSNotificationDetails =
//         DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         );

//     NotificationDetails notificationDetails = const NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: iOSNotificationDetails,
//     );

//     await _flutterLocalNotificationPlugin.show(
//       0,
//       title,
//       body,
//       notificationDetails,
//       payload: payload,
//     );
//   }
// }
