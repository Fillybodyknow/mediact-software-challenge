class RegisterRequest {
  final String name;
  final String email;
  final String role; // "nurse" หรือ "head_nurse"
  final String password;
  final String verifyPassword;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.role,
    required this.password,
    required this.verifyPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'password': password,
      'verify_password': verifyPassword,
    };
  }
}
