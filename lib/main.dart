import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:scout_spirit/src/pages/main.dart';
import 'package:scout_spirit/src/pages/authentication.dart';
import 'package:scout_spirit/src/pages/signup.dart';
import 'package:scout_spirit/src/pages/startup.dart';
import 'package:scout_spirit/src/pages/confirm.dart';
import 'package:scout_spirit/src/pages/explore.dart';
import 'package:scout_spirit/src/pages/join.dart';
import 'package:scout_spirit/src/pages/initialize.dart';
import 'package:scout_spirit/src/pages/tasks/task-start-form.dart';
import 'package:scout_spirit/src/pages/tasks/task-view.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/utils/development_area.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('rewards');
  runApp(ScoutSpiritApp());
}

class ScoutSpiritApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scout Spirit App',
      initialRoute: '/',
      theme: appTheme,
      routes: {
        '/': (_) => StartupPage(),
        '/login': (_) => AuthenticationPage(),
        '/join': (_) => JoinPage(),
        '/signup': (_) => SignUpPage(),
        '/confirm': (_) => ConfirmPage(),
        '/initialize': (_) => InitializePage(),
        '/home': (_) => MainPage(),
        '/explore': (_) => ExplorePage(),
        '/tasks/start': (context) =>
            TaskStartFormPage(area: ModalRoute.of(context)!.settings.arguments! as DevelopmentArea),
        '/tasks/view': (context) => TaskViewPage()
      },
    );
  }
}
