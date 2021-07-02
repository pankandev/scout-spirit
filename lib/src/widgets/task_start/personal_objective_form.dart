import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/forms/task_start.dart';
import 'package:scout_spirit/src/utils/objectives_icons.dart';
import 'package:scout_spirit/src/widgets/header_back.dart';
import 'package:scout_spirit/src/widgets/objective_card.dart';

class PersonalObjectiveForm extends StatefulWidget {
  final Function()? onBack;

  PersonalObjectiveForm({Key? key, this.onBack}) : super(key: key);

  @override
  _PersonalObjectiveFormState createState() => _PersonalObjectiveFormState();
}

class _PersonalObjectiveFormState extends State<PersonalObjectiveForm> {
  final fieldController = TextEditingController();

  AreaDisplayData get areaData => ObjectivesDisplay.getAreaIconData(
      AuthenticationService().authenticatedUser.unit,
      Provider.of<TaskStartForm>(context).originalObjective!.area);

  @override
  void initState() {
    super.initState();
    Objective? objective =
        Provider.of<TaskStartForm>(context, listen: false).personalObjective;
    fieldController.text = objective != null ? objective.rawObjective : '';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeaderBack(onBack: widget.onBack, label: 'Hazlo tuyo',),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
            child: Column(
              children: [
                StreamBuilder<Objective?>(
                    stream:
                    Provider.of<TaskStartForm>(context).originalObjectiveStream,
                    builder: (ctx, snapshot) {
                      return snapshot.data != null
                          ? ObjectiveCard(objective: snapshot.data!)
                          : Container();
                    }),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Expanded(child: Icon(Icons.arrow_downward, color: Colors.white)),
                    Expanded(child: Icon(Icons.arrow_downward, color: Colors.white)),
                    Expanded(child: Icon(Icons.arrow_downward, color: Colors.white))
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: fieldController,
                              maxLines: 8,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Este campo está vacío";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                TaskStartForm form = Provider.of<TaskStartForm>(
                                    context,
                                    listen: false);
                                form.personalObjective = form.originalObjective!
                                    .copyWith(objective: value);
                              },
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Ubuntu', fontSize: 14.0, height: 1.5),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14.0),
                                      borderSide: BorderSide(
                                          color: Colors.white70, width: 2.0)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14.0),
                                      borderSide: BorderSide(
                                          color: Colors.white70, width: 2.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14.0),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2.0)),
                                  hintText: 'Para trabajar en este objetivo yo...',
                                  hintStyle: TextStyle(
                                      color: Colors.white70, fontFamily: 'Ubuntu')),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
