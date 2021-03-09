class LoginCredentials {
  String email;
  String password;

  String toString() {
    return "LoginCredentials(email: '$email', password: '$password')";
  }

  LoginCredentials({this.email, this.password});
}