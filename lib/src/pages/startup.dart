import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:scout_spirit/amplifyconfiguration.dart';
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

  final Widget child;

  StartupStage _stage;

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
    return 'Cargando...';
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
    final bool isLoggedIn = await _checkIfLoggedIn();
    if (!isLoggedIn) {
      await Navigator.of(context).pushReplacementNamed('/login');
    } else {
      this.stage = StartupStage.SigningIn;
      await Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  _StartupPageState({this.child});

  static bool _isConfigured = false;

  Future<void> _configureAmplify() async {
    AmplifyAnalyticsPinpoint analyticsPlugin = AmplifyAnalyticsPinpoint();
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyAPI apiPlugin = AmplifyAPI();

    if (_isConfigured) return;

    try {
      Amplify.addPlugins([authPlugin, analyticsPlugin, apiPlugin]);
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
    _isConfigured = true;
  }

  Future<bool> _checkIfLoggedIn() async {
    AuthSession session = await Amplify.Auth.fetchAuthSession();
    return session.isSignedIn;
  }
}
