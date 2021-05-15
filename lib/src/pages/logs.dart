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
                  flex: 10,
                  child: FutureBuilder<List<Log>>(
                      future: logs,
                      builder: (context, snapshot) {
                        List<Log>? data = snapshot.data;
                        return data != null
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (ctx, index) => Padding(
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
