import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/credentials.dart';
import 'package:scout_spirit/src/models/user.dart';

class RegisterFormBloc {
  final emailController = TextEditingController();
  final nicknameController = TextEditingController();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final birthDateController = ValueNotifier<DateTime>(DateTime.now());
  final unitController = ValueNotifier<Unit>(null);

  SignUpCredentials get credentials => SignUpCredentials(
    email: emailController.text,
    nickname: nicknameController.text,
    name: nameController.text,
    lastName: lastNameController.text,
    password: passwordController.text,
    birthDate: birthDateController.value,
    unit: unitController.value
  );
}
