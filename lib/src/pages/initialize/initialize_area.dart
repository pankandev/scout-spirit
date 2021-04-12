import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/models/user.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/services/objectives.dart';
import 'package:scout_spirit/src/services/tasks.dart';
import 'package:scout_spirit/src/utils/development_area.dart';
import 'package:scout_spirit/src/utils/development_stage.dart';
import 'package:scout_spirit/src/utils/objectives_icons.dart';
import 'package:scout_spirit/src/forms/initialize.dart';

class InitializeAreaPage extends StatefulWidget {
  final InitializeFormBloc form;
  final DevelopmentArea area;

  const InitializeAreaPage({Key? key, required this.form, required this.area})
      : super(key: key);

  @override
  _InitializeAreaPageState createState() => _InitializeAreaPageState();
}

class _InitializeAreaPageState extends State<InitializeAreaPage> {
  late final Future<List<Task>> tasks;

  @override
  void initState() {
    super.initState();
    User user = AuthenticationService().snapAuthenticatedUser!;
    tasks = TasksService().getUserTasksByArea(user, user.stage, widget.area);
  }

  @override
  Widget build(BuildContext context) {
    List<Line> lines = ObjectivesService().getAllLinesByArea(widget.area);
    User user = AuthenticationService().snapAuthenticatedUser!;
    AreaDisplayData displayData =
        ObjectivesDisplay.getUserAreaIconData(user, widget.area);
    DevelopmentStage stage = user.stage;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Row(children: [
                Icon(Icons.check, color: Colors.white),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  "Guardar",
                  style: TextStyle(color: Colors.white),
                )
              ]))
        ],
        elevation: 0,
        backgroundColor: displayData.colorScheme.primary,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(displayData.icon),
            SizedBox(
              width: 16.0,
            ),
            Text(displayData.name),
          ],
        ),
      ),
      body: FutureBuilder<List<Task>>(
        future: tasks,
        builder: (context, tasksSnapshot) {
          return !tasksSnapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(displayData.color),
                  ),
                )
              : StreamBuilder<Map<DevelopmentArea, List<Objective>>>(
                  stream: widget.form.selectedObjectivesStream,
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemCount: lines.length,
                      itemBuilder: (context, index) {
                        List<Objective> objectives = lines[index]
                            .objectives[stage]!
                            .where((objective) =>
                                tasksSnapshot.data!.indexWhere((task) =>
                                    task.originalObjective == objective) ==
                                -1)
                            .toList();
                        int? selectedObjectives = snapshot.data?[widget.area]
                            ?.where((e) => e.line - 1 == index)
                            .length;
                        return Column(
                          children: [
                                ListTile(
                                  title: Text(
                                    lines[index].name,
                                    style: TextStyle(color: displayData.color),
                                  ),
                                  subtitle: Text(
                                      "$selectedObjectives de ${objectives.length} objetivos seleccionados",
                                      style: TextStyle(
                                          color: Color.lerp(Colors.white,
                                              displayData.color, 0.7))),
                                )
                              ] +
                              objectives.map<ListTile>((objective) {
                                return ListTile(
                                  leading: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 4.0),
                                    child: Icon(
                                      displayData.icon,
                                      size: 28.0,
                                      color: widget.form
                                                  .findObjective(objective) !=
                                              -1
                                          ? displayData.color
                                          : Colors.grey[400],
                                    ),
                                  ),
                                  title: Text(
                                    objective.authorizedObjective,
                                    style: TextStyle(fontSize: 14.0),
                                    textAlign: TextAlign.justify,
                                  ),
                                  onTap: () =>
                                      widget.form.toggleObjective(objective),
                                );
                              }).toList(),
                        );
                      },
                    );
                  });
        },
      ),
    );
  }
}
