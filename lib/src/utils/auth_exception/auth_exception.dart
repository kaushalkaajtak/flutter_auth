class AuthException {
  final String message;
  final String? code;

  AuthException({required this.message, this.code});
}
