enum AuthErrorType { email, password, repeatPassword, provider, general }

class AuthError implements Exception {
  final String description;
  final AuthErrorType type;

  AuthError({required this.description, required this.type});

  @override
  String toString() => description;
}
