class SignInDTO {
  final String email;
  final String password;

  SignInDTO({required this.email, required this.password});

  Map<String, String> toForm() {
    return {
      'email': email,
      'password': password,
    };
  }
}
