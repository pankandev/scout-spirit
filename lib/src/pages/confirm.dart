import 'package:flutter/material.dart';
import 'package:scout_spirit/src/providers/snackbar.dart';
import 'package:scout_spirit/src/services/authentication.dart';
import 'package:scout_spirit/src/themes/theme.dart';

class ConfirmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 36.0),
              child: ConfirmForm())),
    );
  }
}

class ConfirmForm extends StatelessWidget {
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '¡Ya casi estás!',
            style: appTheme.textTheme.headline1,
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
              'Revisa tu correo electrónico por el código para confirmar tu cuenta'),
          SizedBox(
            height: 15.0,
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Este campo es obligatorio';
              }
              return null;
            },
            decoration: InputDecoration(labelText: 'Código de confirmación'),
            controller: _codeController,
          ),
          SizedBox(
            height: 15.0,
          ),
          ElevatedButton(
              onPressed: () => _confirm(context),
              child: Text('Confirmar cuenta'))
        ],
      ),
    );
  }

  Future<void> _confirm(BuildContext context) async {
    String email = ModalRoute.of(context)!.settings.arguments! as String;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    bool confirmed =
        await AuthenticationService().confirm(email, _codeController.text.trim());
    if (!confirmed) {
      SnackBarProvider.showMessage(context, 'Código incorrecto');
    } else {
      Navigator.of(context).pop();
    }
  }
}
