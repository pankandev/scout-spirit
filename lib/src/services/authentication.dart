import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/services/beneficiaries.dart';

class AuthenticationService {
  static AuthenticationService _instance = AuthenticationService._internal();

  factory AuthenticationService() {
    return _instance;
  }

  AuthenticationService._internal() {
    updateAuthenticatedUser();
  }

  final BehaviorSubject<User> _authenticatedUserController =
      BehaviorSubject<User>();
  final BehaviorSubject<CognitoAuthSession> _sessionController =
      BehaviorSubject<CognitoAuthSession>();

  Stream<User> get userStream => _authenticatedUserController.stream;

  User get snapAuthenticatedUser => _authenticatedUserController.value;

  Future<void> updateAuthenticatedUser() async {
    AuthUser user;
    AuthSession authSession = await Amplify.Auth.fetchAuthSession();
    if (authSession.isSignedIn) {
      user = await Amplify.Auth.getCurrentUser();
    } else {
      user = null;
    }

    if (user == null) {
      _authenticatedUserController.sink.add(null);
      _sessionController.sink.add(null);
      return;
    }

    List<AuthUserAttribute> attributes =
        await Amplify.Auth.fetchUserAttributes();

    Beneficiary beneficiary = await BeneficiariesService().getMyself();
    _authenticatedUserController.sink
        .add(User.fromAuthUser(user, beneficiary, attributes));

    CognitoAuthSession session = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: false));
    _sessionController.sink.add(session);
  }

  Future<bool> register(
      {String email,
      String password,
      String nickname,
      String name,
      String lastName,
      DateTime birthDate,
      Unit unit}) async {
    try {
      SignUpOptions options = SignUpOptions(userAttributes: {
        "nickname": nickname,
        "name": name,
        "family_name": lastName,
        "birthdate": "${birthDate.day}-${birthDate.month}-${birthDate.year}",
        "gender": unit.toString().toLowerCase().split('.').last
      });
      SignUpResult result = await Amplify.Auth.signUp(
          username: email, password: password, options: options);
      print(result);
      return true;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      SignInResult result =
          await Amplify.Auth.signIn(username: email, password: password);
      if (!result.isSignedIn) {
        return false;
      }
      await updateAuthenticatedUser();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await Amplify.Auth.signOut();
    _authenticatedUserController.sink.add(null);
    return;
  }

  void dispose() {
    _sessionController.close();
    _authenticatedUserController.close();
  }
}