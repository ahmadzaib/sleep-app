// import 'dart:io';
// import 'package:connectivity_plus/connectivity_plus.dart';

// class NetworkUtils {
//   static final Connectivity _connectivity = Connectivity();

//   /// Check if device has internet connectivity
//   static Future<bool> hasInternetConnection() async {
//     try {
//       final connectivityResult = await _connectivity.checkConnectivity();

//       if (connectivityResult == ConnectivityResult.none) {
//         return false;
//       }

//       // Additional check by trying to reach a reliable host
//       final result = await InternetAddress.lookup('google.com');
//       return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//     } catch (e) {
//       return false;
//     }
//   }

//   /// Stream to listen for connectivity changes
//   static Stream<List<ConnectivityResult>> get connectivityStream =>
//       _connectivity.onConnectivityChanged;

//   /// Check if current connection is mobile data
//   static Future<bool> isMobileConnection() async {
//     final connectivityResult = await _connectivity.checkConnectivity();
//     return connectivityResult == ConnectivityResult.mobile;
//   }

//   /// Check if current connection is WiFi
//   static Future<bool> isWiFiConnection() async {
//     final connectivityResult = await _connectivity.checkConnectivity();
//     return connectivityResult == ConnectivityResult.wifi;
//   }
// }
