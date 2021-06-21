import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scout_spirit/src/models/avatar.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/providers/snackbar.dart';
import 'package:scout_spirit/src/services/beneficiaries.dart';
import 'package:scout_spirit/src/utils/datetime.dart';

class AuthenticationService {
  static AuthenticationService _instance = AuthenticationService._internal();

  factory AuthenticationService() {
    return _instance;
  }

  AuthenticationService._internal() {
    updateAuthenticatedUser();
  }

  final BehaviorSubject<User?> _authenticatedUserController =
      BehaviorSubject<User>();
  final BehaviorSubject<CognitoAuthSession?> _sessionController =
      BehaviorSubject<CognitoAuthSession>();
  final BehaviorSubject<Avatar> _avatarController = BehaviorSubject<Avatar>();

  Stream<User?> get userStream => _authenticatedUserController.stream;

  Stream<Avatar> get avatarStream => _avatarController.stream;

  User? get snapAuthenticatedUser => _authenticatedUserController.value;

  String get authenticatedUserId => _authenticatedUserController.value!.id;

  Future<String> getIdentityId() async {
    CognitoAuthSession authSession = await Amplify.Auth.fetchAuthSession(
            options: CognitoSessionOptions(getAWSCredentials: true))
        as CognitoAuthSession;
    return authSession.identityId!;
  }

  Future<void> updateAuthenticatedUser() async {
    AuthUser? user;
    AuthSession authSession = await Amplify.Auth.fetchAuthSession();
    if (authSession.isSignedIn) {
      try {
        user = await Amplify.Auth.getCurrentUser();
      } on SignedOutException {
        user = null;
      }
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

    Beneficiary? beneficiary = await BeneficiariesService().getMyself();
    _authenticatedUserController.sink
        .add(User.fromAuthUser(user, beneficiary, attributes));

    CognitoAuthSession session = await Amplify.Auth.fetchAuthSession(
            options: CognitoSessionOptions(getAWSCredentials: false))
        as CognitoAuthSession;
    _sessionController.sink.add(session);
  }

  Future<bool> register(
      {required String email,
      required String password,
      required String nickname,
      required String name,
      required String lastName,
      required DateTime birthDate,
      required Unit unit}) async {
    CognitoSignUpOptions options = CognitoSignUpOptions(userAttributes: {
      "nickname": nickname,
      "name": name,
      "family_name": lastName,
      "birthdate": dateToString(birthDate),
      "gender": unit.toString().toLowerCase().split('.').last
    });
    SignUpResult result = await Amplify.Auth.signUp(
        username: email, password: password, options: options);
    return result.isSignUpComplete;
  }

  Future<bool> login(
      BuildContext context, String email, String password) async {
    SignInResult result;
    try {
      await Amplify.Auth.signOut();
      result = await Amplify.Auth.signIn(username: email, password: password);
    } on NotAuthorizedException {
      SnackBarProvider.showMessage(context, 'Contraseña incorrecta');
      return false;
    } on UserNotFoundException {
      SnackBarProvider.showMessage(context, 'Correo electrónico no registrado');
      return false;
    } catch (_) {
      SnackBarProvider.showMessage(context, 'Error desconocido');
      return false;
    }
    if (!result.isSignedIn) {
      return false;
    }
    await updateAuthenticatedUser();
    return true;
  }

  Future<bool> confirm(String email, String confirmationCode) async {
    try {
      await Amplify.Auth.confirmSignUp(
          username: email, confirmationCode: confirmationCode);
    } on CodeMismatchException {
      return false;
    }
    return true;
  }

  Future<void> logout() async {
    await Amplify.Auth.signOut();
    _authenticatedUserController.sink.add(null);
    return;
  }

  Future<void> updateNickname() async {}

  void dispose() {
    _sessionController.close();
    _authenticatedUserController.close();
    _avatarController.close();
  }
}
