class GeneralException implements Exception {
  final String? code;
  final String? message;
  final String? cause;

  GeneralException({this.code, this.message, this.cause});

  @override
  String toString() {
    return 'GeneralException{message: $message, code: $code, cause: $cause}';
  }
}
