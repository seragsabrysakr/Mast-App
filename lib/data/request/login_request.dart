class LoginRequest {
  final String email;
  final String password;
  final String fireBaseToken;

  LoginRequest({
    required this.email,
    required this.password,
    required this.fireBaseToken,
  });
}
