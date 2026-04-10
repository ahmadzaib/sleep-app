import 'dart:convert';

import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;
  ApiService(this._dio);

  Future<Response<dynamic>> get(
    String apiPath, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        apiPath,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response<dynamic>> post({
    required String apiPath,
    dynamic apiData,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Function(int, int)? onReceiveProgress,
    Function(int, int)? onSendProgress,
    bool isJsonData = false,
  }) async {
    try {
      // dynamic requestData;
      // if (apiData != null) {
      //   if (apiData is FormData) {
      //     // If already FormData, use it directly
      //     requestData = apiData;
      //   } else if (isJsonData) {
      //     // For JSON data (like the initialize upload payload)
      //     requestData = apiData;
      //   } else if (apiData is Map<String, dynamic> && apiData.isNotEmpty) {
      //     // For FormData (default behavior)
      //     requestData = FormData.fromMap(apiData);
      //   }
      // }
      dynamic requestData;

      // Handle different data types
      if (apiData != null) {
        if (apiData is FormData) {
          // If already FormData, use it directly (for file uploads)
          requestData = apiData;
        } else {
          // For JSON data, encode it
          requestData = jsonEncode(apiData);
        }
      }

      final response = await _dio.post(
        apiPath,
        data: requestData,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response<dynamic>> put(
    String apiPath, {
    dynamic apiData,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(
        apiPath,
        data: apiData,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response<dynamic>> delete(
    String apiPath, {
    dynamic apiData,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        apiPath,
        data: apiData,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response<dynamic>> patch(
    String apiPath, {
    dynamic apiData,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.patch(
        apiPath,
        data: apiData,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<void> download(
    String apiPath,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    void Function(int, int)? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      await _dio.download(
        apiPath,
        savePath,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } on DioException {
      rethrow;
    }
  }
}
