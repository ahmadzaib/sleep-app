class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic data;

  AppException(this.message, {this.code, this.data});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException(super.message, {super.code, super.data});
}

class UnauthorizedException extends AppException {
  UnauthorizedException(super.message, {super.code, super.data});
}

class ValidationException extends AppException {
  ValidationException(super.message, {super.code, super.data});
}

class ServerException extends AppException {
  ServerException(super.message, {super.code, super.data});
}

class CacheException extends AppException {
  CacheException(super.message, {super.code, super.data});
}
