import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/objective.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/forms/task_start.dart';
import 'package:scout_spirit/src/utils/objectives_icons.dart';
import 'package:scout_spirit/src/widgets/objective_card.dart';
import 'package:scout_spirit/src/themes/theme.dart';

class PersonalObjectiveForm extends StatefulWidget {
  PersonalObjectiveForm({Key key}) : super(key: key);

  @override
  _PersonalObjectiveFormState createState() => _PersonalObjectiveFormState();
}

class _PersonalObjectiveFormState extends State<PersonalObjectiveForm> {
  final fieldController = TextEditingController();

  AreaDisplayData get areaData => ObjectivesDisplay.getAreaIconData(
      AuthenticationService().snapAuthenticatedUser.unit,
      Provider.of<TaskStartForm>(context).originalObjective.area);

  @override
  void initState() {
    super.initState();
    Objective objective = Provider.of<TaskStartForm>(context, listen: false).personalObjective;
    fieldController.text = objective != null ? objective.rawObjective : '';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
        child: Column(
          children: [
            Card(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Objetivo Personal',
                        style: appTheme.textTheme.headline2),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                        '¿Qué objetivo te propones a ti mismo para completar el que seleccionaste según tus intereses?',
                        style: mutedTextTheme),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                        'Puede ser algo bien general, en el siguiente paso definirás qué quieres hacer con más detalle',
                        style: mutedTextTheme),
                    SizedBox(
                      height: 10.0,
                    ),
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: fieldController,
                            maxLines: 8,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Este campo está vacío";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              TaskStartForm form = Provider.of<TaskStartForm>(
                                  context,
                                  listen: false);
                              form.personalObjective = form.originalObjective
                                  .copyWith(objective: value);
                            },
                            decoration: InputDecoration(
                              labelText: 'Objetivo personal',
                              alignLabelWithHint: true,
                              hintText: 'Para realizar este objetivo voy a...',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            if (Provider.of<TaskStartForm>(context).originalObjective != null)
              ObjectiveCard(
                objective:
                    Provider.of<TaskStartForm>(context).originalObjective,
              ),
          ],
        ),
      ),
    );
  }
}
