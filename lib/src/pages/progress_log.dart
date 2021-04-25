import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/providers/provider_consumer.dart';
import 'package:scout_spirit/src/services/tasks.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/services/logs.dart';

class ProgressLogDialog extends StatefulWidget {
  @override
  _ProgressLogDialogState createState() => _ProgressLogDialogState();
}

class _ProgressLogDialogState extends State<ProgressLogDialog> {
  final int minCharacters = 32;
  bool loading = false;

  final TextEditingController controller = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Dialog(
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_left),
                          onPressed: () => Navigator.of(context).pop()),
                      Text(
                        'Registrar avance',
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                      'Escribe aquí algo que hayas hecho para avanzar en este objetivo'),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: controller,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      labelText: 'Contenido',
                      alignLabelWithHint: true,
                      errorMaxLines: 2,
                      counter: ProviderConsumer<TextEditingValue>(
                        controller: controller,
                        builder: (controller) {
                          return Text(
                            '${controller.value.text.length} / $minCharacters',
                            style: TextStyle(
                                color:
                                    controller.value.text.length < minCharacters
                                        ? appTheme.errorColor
                                        : appTheme.primaryColor),
                          );
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return "Este campo es obligatorio";
                      }
                      if (value.length < minCharacters) {
                        return "El contenido debe tener al menos $minCharacters carácteres";
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                      onPressed: loading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                Task task = TasksService().snapActiveTask!;
                                try {
                                  await LogsService().postProgressLog(
                                      context, task, controller.text);
                                } catch (e) {
                                  setState(() {
                                    loading = false;
                                  });
                                  return;
                                }
                                Navigator.of(context).pop(true);
                              }
                            },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<
                              Color>((states) => Colors.deepPurple),
                          shape:
                              MaterialStateProperty.resolveWith<OutlinedBorder>(
                                  (states) => RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(24.0)))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 6.0,
                          ),
                          Icon(Icons.save),
                          SizedBox(
                            width: 16.0,
                          ),
                          Text('Subir registro'),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
