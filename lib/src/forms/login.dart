

import 'package:rxdart/rxdart.dart';
import 'package:scout_spirit/src/models/credentials.dart';
import 'package:scout_spirit/src/validators/email.dart';
import 'package:scout_spirit/src/validators/password.dart';

class LoginFormBloc {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  Stream<String> get emailStream => _emailController.stream.transform(validateEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validatePassword);

  Stream<bool> get formValidStream => Rx.combineLatest2(emailStream, passwordStream, (email, password) => true);

  String get email => _emailController.value;
  String get password => _passwordController.value;
  LoginCredentials get credentials => LoginCredentials(
    email: email,
    password: password
  );

  LoginFormBloc() {
    changeEmail('');
    changePassword('');
  }

  void dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}