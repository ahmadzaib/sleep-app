// import 'package:dio/dio.dart';
// import 'package:avatar_flow/core/constants/keys.dart';
// import 'package:avatar_flow/core/exceptions/app_exceptions.dart';
// import 'package:avatar_flow/core/config/appconfig.dart';

// import 'package:avatar_flow/core/utils/debug_point.dart';

// class DioClient {
//   late Dio _dio;

//   DioClient() {
//     _dio = Dio(
//       BaseOptions(
//         baseUrl: AppConfig.baseUrl,
//         connectTimeout: const Duration(minutes: 1),
//         receiveTimeout: const Duration(minutes: 1),
//         sendTimeout: const Duration(minutes: 1),
//       ),
//     );
//     _setupInterceptors();
//   }
//   Dio get dio => _dio;

//   void _setupInterceptors() {
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: _handleRequest,
//         onResponse: _handleResponse,
//         onError: _handleError,
//       ),
//     );
//   }

//   Future<void> _handleRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     try {
//       DebugPoint.log("-------- 📤 REQUEST --------");
//       DebugPoint.log("URI: ${options.uri}");
//       DebugPoint.log("METHOD: ${options.method}");
//       DebugPoint.log("HEADERS: ${options.headers}");
//       DebugPoint.log("BODY: ${options.data}");
//       String token = getStringAsync(Keys.tokenKey);
//       if (token.isNotEmpty) {
//         options.headers['x-customer-access-token'] = token;
//         DebugPoint.log('Api Request Authorization: $token');
//         DebugPoint.log("----------------------------");
//       }
//       handler.next(options);
//     } catch (e) {
//       DebugPoint.error('Request error $e');
//       handler.reject(
//         DioException(
//           requestOptions: options,
//           error: NetworkException('Failed to make request: ${e.toString()}'),
//         ),
//       );
//     }
//   }

//   void _handleResponse(
//     Response response,
//     ResponseInterceptorHandler handler,
//   ) async {
//     DebugPoint.log("-------- 📥 RESPONSE --------");
//     DebugPoint.log("URI: ${response.requestOptions.uri}");
//     DebugPoint.log("STATUS: ${response.statusCode}");
//     DebugPoint.log("DATA: ${response.data}");
//     DebugPoint.log("-----------------------------");

//     // If we can’t parse, just continue
//     handler.next(response);
//   }

//   Future<void> _handleError(
//     DioException err,
//     ErrorInterceptorHandler handler,
//   ) async {
//     final requestOptions = err.requestOptions;

//     // Log error details for debugging
//     DebugPoint.error("-------- ❌ ERROR --------");
//     DebugPoint.error("URI: ${requestOptions.uri}");
//     DebugPoint.error("STATUS: ${err.response?.statusCode}");
//     DebugPoint.error("ERROR DATA: ${err.response?.data}");
//     DebugPoint.error("---------------------------");

//     // If not 401 → forward the error
//     if (err.response?.statusCode != 401) {
//       handler.next(err);
//       return;
//     }

//     // Prevent refresh loop
//     if (requestOptions.extra["retry"] == true) {
//       // Already retried once → force logout
//       await _clearStorage();
//       handler.reject(err);
//       return;
//     }

//     // Ignore login or refresh endpoints
//     if (requestOptions.path.contains('/auth/login') ||
//         requestOptions.path.contains('/auth/register') ||
//         requestOptions.path.contains('/auth/social-login')) {
//       handler.next(err);
//       return;
//     }

//     DebugPoint.warning("⚠️ Token expired or unauthorized.");

//     // The new API uses Shopify access tokens which have longer lifespans
//     // and different refresh mechanisms. For now, we clear storage and logout.
//     await _clearStorage();
//     handler.reject(err);
//   }

//   Future<void> _clearStorage() async {
//     // await removeKey(Keys.tokenKey);
//     // await removeKey(Keys.userData);
//     // Navigator.of(
//     //   // ignore: use_build_context_synchronously
//     //   navigatorKey.currentState!.context,
//     // ).pushNamedAndRemoveUntil(AppRouteNames.signIn, (route) => false);
//   }
// }
