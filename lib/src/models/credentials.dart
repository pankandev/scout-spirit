import 'package:scout_spirit/src/models/user.dart';

class LoginCredentials {
  final String email;
  final String password;

  String toString() {
    return "LoginCredentials(email: '$email', password: '$password')";
  }

  LoginCredentials({this.email, this.password});
}

class SignUpCredentials {
  final String email;
  final String password;
  final String nickname;
  final String name;
  final String lastName;
  final DateTime birthDate;
  final Unit unit;

  String toString() {
    return "SignUpCredentials(email: '$email', password: '$password', nickname: $nickname, name: $name, lastName: $lastName, birthDate: $birthDate, unit: $unit)";
  }

  SignUpCredentials(
      {this.email,
      this.password,
      this.nickname,
      this.name,
      this.lastName,
      this.birthDate,
      this.unit});
}
