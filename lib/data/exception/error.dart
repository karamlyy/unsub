class HttpException implements Exception {
  final ErrorMessage error;

  HttpException({required this.error});
}

class ErrorMessage {
  final String message;
  final int? code;

  ErrorMessage({required this.message, this.code = -1});

  @override
  String toString() {
    return "ERROR: $message, CODE: $code";
  }
}
