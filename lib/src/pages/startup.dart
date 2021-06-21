import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';

import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:scout_spirit/amplifyconfiguration.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/objectives.dart';

enum StartupStage {
  AmplifyLoading,
  CheckSession,
  SigningIn,
  PreloadingStaticData
}

class StartupPage extends StatefulWidget {
  @override
  _StartupPageState createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 25.0,
          ),
          Text(this.loadingText)
        ],
      )),
    );
  }

  final Widget? child;

  StartupStage _stage = StartupStage.AmplifyLoading;

  String get loadingText {
    switch (stage) {
      case StartupStage.AmplifyLoading:
        return 'Armando mochila...';
      case StartupStage.PreloadingStaticData:
        return 'Subiendo cosas al bus...';
      case StartupStage.CheckSession:
        return 'Subiendo al bus...';
      case StartupStage.SigningIn:
        return 'Llegando a la zona de campamento';
    }
  }

  StartupStage get stage => _stage;

  set stage(StartupStage newStage) {
    setState(() {
      this._stage = newStage;
    });
  }

  @override
  void initState() {
    super.initState();
    _startup(context);
  }

  void _startup(BuildContext context) async {
    this.stage = StartupStage.AmplifyLoading;
    await _configureAmplify();

    this.stage = StartupStage.PreloadingStaticData;
    await ObjectivesService().preload();

    this.stage = StartupStage.CheckSession;
    AuthenticationService service = AuthenticationService();
    try {
      await service.updateAuthenticatedUser();
    } on HttpError catch (e) {
      if (e.statusCode == 403) {
        await service.logout();
      }
    } on Exception {
    }
    final bool isLoggedIn = service.snapAuthenticatedUser != null;
    if (!isLoggedIn) {
      await Navigator.of(context).pushReplacementNamed('/login');
    } else if (service.snapAuthenticatedUser!.beneficiary == null) {
      this.stage = StartupStage.SigningIn;
      await Navigator.of(context).pushReplacementNamed('/join');
    }else {
      this.stage = StartupStage.SigningIn;
      await Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  _StartupPageState({this.child});

  static bool _isConfigured = false;

  Future<void> _configureAmplify() async {
    AmplifyAnalyticsPinpoint analyticsPlugin = AmplifyAnalyticsPinpoint();
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyStorageS3 storagePlugin = AmplifyStorageS3();

    if (_isConfigured) return;

    try {
      Amplify.addPlugins([authPlugin, analyticsPlugin, storagePlugin]);
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
    _isConfigured = true;
  }

}
