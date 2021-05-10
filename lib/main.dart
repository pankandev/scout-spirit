import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:scout_spirit/src/forms/initialize.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/rewards/reward.dart';
import 'package:scout_spirit/src/models/world.dart';
import 'package:scout_spirit/src/pages/binnacle.dart';
import 'package:scout_spirit/src/pages/main.dart';
import 'package:scout_spirit/src/pages/authentication.dart';
import 'package:scout_spirit/src/pages/signup.dart';
import 'package:scout_spirit/src/pages/startup.dart';
import 'package:scout_spirit/src/pages/confirm.dart';
import 'package:scout_spirit/src/pages/explore.dart';
import 'package:scout_spirit/src/pages/join.dart';
import 'package:scout_spirit/src/pages/profile.dart';
import 'package:scout_spirit/src/widgets/reward_view.dart';
import 'package:scout_spirit/src/pages/initialize/initialize.dart';
import 'package:scout_spirit/src/pages/initialize/initialize_area.dart';
import 'package:scout_spirit/src/pages/tasks/task-start-form.dart';
import 'package:scout_spirit/src/pages/tasks/task-view.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/utils/development_area.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<String>('rewards');
  Hive.registerAdapter(WorldAdapter());
  Hive.registerAdapter(ZoneAdapter());
  Hive.registerAdapter(NodeAdapter());
  Hive.registerAdapter(ZoneObjectAdapter());
  Hive.registerAdapter(Vector3Adapter());
  Hive.registerAdapter(QuaternionAdapter());
  await Hive.openBox<World>('world');
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
        '/initialize/area': (context) {
          Map arguments = (ModalRoute.of(context)!.settings.arguments as Map);
          InitializeFormBloc form = arguments['form'];
          DevelopmentArea area = arguments['area'];
          return InitializeAreaPage(form: form, area: area);
        },
        '/home': (_) => MainPage(),
        '/profile': (_) => ProfilePage(),
        '/binnacle': (_) => BinnaclePage(),
        '/explore': (_) => ExplorePage(),
        '/rewards/claim': (context) => RewardsPage(
            rewards:
                ModalRoute.of(context)!.settings.arguments! as List<Reward>),
        '/tasks/start': (context) => TaskStartFormPage(
            area:
                ModalRoute.of(context)!.settings.arguments! as DevelopmentArea),
        '/tasks/view': (context) {
          Task task = ModalRoute.of(context)!.settings.arguments! as Task;
          return TaskViewPage(task: task);
        },
        '/tasks/active': (context) => TaskViewPage()
      },
    );
  }
}
