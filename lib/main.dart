import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:scout_spirit/src/forms/initialize.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/inventory.dart';
import 'package:scout_spirit/src/models/rewards/reward.dart';
import 'package:scout_spirit/src/models/world.dart';
import 'package:scout_spirit/src/pages/binnacle.dart';
import 'package:scout_spirit/src/pages/main.dart';
import 'package:scout_spirit/src/pages/authentication.dart';
import 'package:scout_spirit/src/pages/signup.dart';
import 'package:scout_spirit/src/pages/startup.dart';
import 'package:scout_spirit/src/pages/confirm.dart';
import 'package:scout_spirit/src/pages/logs.dart';
import 'package:scout_spirit/src/pages/stats.dart';
import 'package:scout_spirit/src/pages/explore.dart';
import 'package:scout_spirit/src/pages/join.dart';
import 'package:scout_spirit/src/pages/profile.dart';
import 'package:scout_spirit/src/services/rest_api.dart';
import 'package:scout_spirit/src/widgets/reward_view.dart';
import 'package:scout_spirit/src/pages/initialize/initialize.dart';
import 'package:scout_spirit/src/pages/initialize/initialize_area.dart';
import 'package:scout_spirit/src/pages/tasks/task-start-form.dart';
import 'package:scout_spirit/src/pages/tasks/task-view.dart';
import 'package:scout_spirit/src/widgets/active_task_view.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/utils/development_area.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

SentryEvent beforeSend(SentryEvent event, {dynamic hint}) {
  // Don't send personal data
  event = event.copyWith(user: null);
  return event;
}

void main() async {
  Hive.registerAdapter(WorldAdapter());
  Hive.registerAdapter(ZoneAdapter());
  Hive.registerAdapter(NodeAdapter());
  Hive.registerAdapter(ZoneObjectAdapter());
  Hive.registerAdapter(Vector3Adapter());
  Hive.registerAdapter(QuaternionAdapter());
  Hive.registerAdapter(ItemQuantityAdapter());
  Hive.registerAdapter(InventoryAdapter());

  await Hive.initFlutter();
  await Hive.openBox<String>('rewards');
  await Hive.openBox<World>('world');
  await Hive.openBox<Inventory>('inventory');
  await RestApiService.updateEmulatorCheck();

  await SentryFlutter.init(
    (options) {
      options.environment = kReleaseMode ? 'production' : 'testing';
      options.beforeSend = beforeSend;
      options.dsn =
          'https://a2522c41e4e34b73a21d91886dbbd6be@o578448.ingest.sentry.io/5825665';
    },
    appRunner: () => runApp(ScoutSpiritApp()),
  );
}

class ScoutSpiritApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1280, 720),
      builder: () => MaterialApp(
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
            '/tasks/start': (context) => TaskStartFormPage(),
            '/tasks/view': (context) {
              Task task = ModalRoute.of(context)!.settings.arguments! as Task;
              return TaskViewPage(
                  objectiveKey: task.originalObjective, readonly: true);
            },
            '/tasks/active': (context) => ActiveTaskView(),
            '/logs': (context) => LogsPage(),
            '/stats': (context) => StatsPage()
          },
        )
    );
  }
}
