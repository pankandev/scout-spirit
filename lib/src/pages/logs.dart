import 'package:flutter/material.dart';
import 'package:scout_spirit/src/themes/constants.dart';
import 'package:scout_spirit/src/widgets/background.dart';
import 'package:scout_spirit/src/widgets/log_card.dart';
import 'package:scout_spirit/src/models/log.dart';
import 'package:scout_spirit/src/services/logs.dart';
import 'package:scout_spirit/src/widgets/header_back.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({Key? key}) : super(key: key);

  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  late final Future<List<Log>> logs;

  @override
  void initState() {
    super.initState();
    logs = LogsService().getMyLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          SafeArea(
            child: Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  child: HeaderBack(
                    onBack: () => Navigator.pop(context),
                    label: 'Registros',
                  ),
                ),
                Expanded(
                    child: Container(
                      padding: Paddings.container,
                      child: Text(
                        'Aquí puedes ver todas las acciones que has realizado en la aplicación',
                        style: TextStyles.light,
                      ),
                    )),
                Expanded(
                  flex: 10,
                  child: FutureBuilder<List<Log>>(
                      future: logs,
                      builder: (context, snapshot) {
                        List<Log>? data = snapshot.data;
                        return data != null
                            ? ListView.builder(
                            shrinkWrap: true,
                            padding: Paddings.containerFluid,
                            physics: BouncingScrollPhysics(),
                            itemCount: data.length > 0 ? data.length : 1,
                            itemBuilder: (ctx, index) => data.length == 0
                                ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 24.0, horizontal: 16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '(。_。)',
                                    style: TextStyles.giant,
                                  ),
                                  VSpacings.medium,
                                  Text(
                                    'Sin registros',
                                    textAlign: TextAlign.center,
                                    style: TextStyles.giant,
                                  ),
                                ],
                              ),
                            )
                                : Padding(
                              padding: Paddings.listItem,
                              child: LogCard(log: data[index]),
                            ))
                            : Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    Colors.white)));
                      }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
