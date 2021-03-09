import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:scout_spirit/amplifyconfiguration.dart';

enum StartupStage {
  AmplifyLoading,
  CheckSession,
  SigningIn,
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
    this.stage = StartupStage.CheckSession;
    try {
      await Amplify.Auth.getCurrentUser();
    } on SignedOutException {
      await Navigator.of(context).pushReplacementNamed('/login');
      return;
    }
    this.stage = StartupStage.SigningIn;
    await Navigator.of(context).pushReplacementNamed('/home');
  }

  _StartupPageState({this.child});

  Future<void> _configureAmplify() async {
    AmplifyAnalyticsPinpoint analyticsPlugin = AmplifyAnalyticsPinpoint();
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyAPI apiPlugin = AmplifyAPI();

    try {
      Amplify.addPlugins([authPlugin, analyticsPlugin, apiPlugin]);
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }
}
