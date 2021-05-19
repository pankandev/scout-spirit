import 'package:flutter/material.dart';
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
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Aquí puedes ver todas las acciones que has realizado en la aplicación',
                    style: TextStyle(fontFamily: 'Ubuntu', color: Colors.white),
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
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 48.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 24.0,
                                            ),
                                            Text(
                                              'Sin registros',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.6,
                                                  fontFamily: 'Ubuntu'),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 12.0),
                                        child: LogCard(log: data[index]),
                                      ))
                            : Center(child: CircularProgressIndicator());
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
