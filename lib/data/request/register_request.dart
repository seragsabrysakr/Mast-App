class RegisterRequest {
  final String email;
  final String password;
  final String name;
  final String phone;
  final String fireBaseToken;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.fireBaseToken,
  });
}
