import 'package:flutter/material.dart';
import 'package:scout_spirit/src/models/beneficiary.dart';
import 'package:scout_spirit/src/providers/confirm_provider.dart';
import 'package:scout_spirit/src/providers/loading_screen.dart';
import 'package:scout_spirit/src/providers/logger.dart';
import 'package:scout_spirit/src/providers/provider_consumer.dart';
import 'package:scout_spirit/src/providers/snackbar.dart';
import 'package:scout_spirit/src/services/tasks.dart';
import 'package:scout_spirit/src/themes/theme.dart';
import 'package:scout_spirit/src/services/logs.dart';
import 'package:scout_spirit/src/widgets/scout_button.dart';

class ProgressLogDialog extends StatefulWidget {
  final TextEditingController controller = TextEditingController();

  @override
  _ProgressLogDialogState createState() => _ProgressLogDialogState();
}

class _ProgressLogDialogState extends State<ProgressLogDialog> {
  final int minCharacters = 32;
  bool loading = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 24.0),
                decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(color: Colors.white, blurRadius: 12.0)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Registrar avance',
                            style: TextStyle(
                                fontSize: 21.0,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.w600),
                          ),
                          Icon(Icons.edit)
                        ],
                      ),
                      SizedBox(
                        height: 32.0,
                      ),
                      Text(
                        'Escribe aquí algo que hayas hecho para avanzar en este objetivo',
                        style: TextStyle(fontFamily: 'Ubuntu'),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        controller: controller,
                        maxLines: 5,
                        readOnly: loading,
                        style: TextStyle(fontFamily: 'Ubuntu'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          labelText: 'Registro de avance',
                          alignLabelWithHint: true,
                          errorMaxLines: 2,
                          counter: ProviderConsumer<TextEditingValue>(
                            controller: controller,
                            builder: (controller) {
                              return Text(
                                '${controller.value.text.length} / $minCharacters',
                                style: TextStyle(
                                    fontFamily: 'UbuntuCondensed',
                                    fontSize: 16.0,
                                    color: controller.value.text.length <
                                            minCharacters
                                        ? appTheme.errorColor
                                        : appTheme.primaryColor),
                              );
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Este campo es obligatorio";
                          }
                          if (value.length < minCharacters) {
                            return "El contenido debe tener al menos $minCharacters carácteres";
                          }
                        },
                      ),
                      SizedBox(
                        height: 32.0,
                      ),
                      ScoutButton(
                        fillColor: appTheme.primaryColor,
                        accentColor: appTheme.accentColor,
                        label: 'Subir registro',
                        icon: Icons.add,
                        labelColor: Colors.white,
                        onPressed: loading
                            ? null
                            : () async {
                                Task? task = TasksService().snapActiveTask;
                                if (task != null &&
                                    (_formKey.currentState?.validate() ??
                                        false)) {
                                  setState(() {
                                    loading = true;
                                  });
                                  try {
                                    LoadingScreenProvider().show(context,
                                        label: "Subiendo registro...");
                                    await LogsService().postProgressLog(
                                        context, task.token!, controller.text);
                                  } catch (e, s) {
                                    setState(() {
                                      loading = false;
                                    });
                                    SnackBarProvider.showMessage(context,
                                        'No se pudo subir el registro',
                                        color: Colors.red);
                                    await LoggerService().error(e, s);
                                  } finally {
                                    LoadingScreenProvider().hide();
                                  }
                                  Navigator.of(context).pop(true);
                                } else {
                                  SnackBarProvider.showMessage(context,
                                      'No se pudo validar el contenido',
                                      color: Colors.red);
                                }
                              },
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      ScoutButton(
                        fillColor: appTheme.errorColor,
                        accentColor: appTheme.errorColor,
                        label: 'Cerrar',
                        icon: Icons.clear,
                        labelColor: Colors.white,
                        onPressed: loading
                            ? null
                            : () async {
                                if (await _onWillPop()) {
                                  Navigator.pop(context);
                                }
                              },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (loading) {
      return false;
    }
    if (controller.text.isEmpty) {
      return true;
    }
    return await ConfirmProvider.askConfirm(context,
        question: 'Quieres descartar este registro?',
        confirmLabel: 'Descartar');
  }
}
