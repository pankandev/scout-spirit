import 'package:flutter/material.dart';
import 'package:scout_spirit/src/error/app_error.dart';
import 'package:scout_spirit/src/providers/snackbar.dart';
import 'package:scout_spirit/src/services/beneficiaries.dart';
import 'package:scout_spirit/src/themes/theme.dart';

class JoinPage extends StatelessWidget {
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.group,
                    size: 56.0,
                  ),
                  Text(
                    'Unirse a un grupo',
                    style: appTheme.textTheme.headline1,
                  )
                ],
              ),
              JoinGroupForm(codeController: codeController),
            ]),
      )),
    );
  }
}

class JoinGroupForm extends StatefulWidget {
  JoinGroupForm({
    Key? key,
    required this.codeController,
  }) : super(key: key);

  final TextEditingController codeController;

  @override
  _JoinGroupFormState createState() => _JoinGroupFormState();
}

class _JoinGroupFormState extends State<JoinGroupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 24.0),
        child: Flex(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.codeController,
                validator: (value) => value == null || value.isEmpty
                    ? 'Este campo es obligatorio'
                    : null,
                decoration: InputDecoration(labelText: 'Código de grupo'),
              ),
            ),
            TextButton(
                child: Icon(Icons.arrow_right_alt_sharp),
                onPressed: () => _joinGroup(context))
          ],
        ),
      ),
    );
  }

  Future<void> _joinGroup(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await BeneficiariesService().joinGroup(widget.codeController.text);
      } on HttpError catch (e) {
        if (e.statusCode == 403 || e.statusCode == 404) {
          SnackBarProvider.showMessage(context, 'Código Incorrecto');
        } else if (e.statusCode == 400) {
          SnackBarProvider.showMessage(context, 'Ya te has unido a un grupo');
          await Navigator.of(context).pushReplacementNamed('/');
        } else {
          SnackBarProvider.showMessage(context, 'Error desconocido');
        }
      } on AppError {
        SnackBarProvider.showMessage(context, 'Código Incorrecto');
      }
    }
  }
}
