import 'package:avatar_flow/core/constants/error_constants.dart';
import 'package:dio/dio.dart';

class ErrorUtils {
  /// Extract error message from DioException response
  /// Handles various API error response formats:
  /// - {"error": "message"}
  /// - {"message": "message"}
  /// - {"detail": "message"}
  /// - "string error"
  static String extractErrorMessage(DioException exception) {
    if (exception.response == null) {
      return _getErrorMessageFromType(exception.type);
    }

    final responseData = exception.response?.data;

    if (responseData is Map) {
      // Try to extract error message from various possible fields
      final errorMessage =
          responseData["error"] ??
          responseData["message"] ??
          responseData["detail"] ??
          responseData["errors"];

      if (errorMessage is String) {
        return errorMessage;
      } else if (errorMessage is Map) {
        // Handle nested error objects
        return errorMessage.values.first?.toString() ??
            ErrorConstants.generalError;
      } else if (errorMessage is List && errorMessage.isNotEmpty) {
        // Handle array of errors
        return errorMessage.first?.toString() ?? ErrorConstants.generalError;
      }
    } else if (responseData is String) {
      return responseData;
    }

    return ErrorConstants.generalError;
  }

  /// Get error message based on DioException type
  static String _getErrorMessageFromType(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return "Connection timeout. Please check your internet connection.";
      case DioExceptionType.connectionError:
        return "No internet connection. Please check your network.";
      case DioExceptionType.badResponse:
        return "Server error. Please try again later.";
      case DioExceptionType.cancel:
        return "Request was cancelled.";
      default:
        return ErrorConstants.generalError;
    }
  }
}
